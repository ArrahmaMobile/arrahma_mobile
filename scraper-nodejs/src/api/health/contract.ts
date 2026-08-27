/**
 * The wire shape of `GET /_health` — SASID Application Health Standard v1.
 *
 * Deliberately import-free and pure. Everything here can be exercised by the
 * schema regression test without a filesystem, a network socket or a running
 * scraper, which is the only way to prove the assembled payload validates
 * before it reaches production.
 *
 * Relay compiles the published JSON Schema with Ajv and treats a validation
 * failure as a hard outage for the whole application rather than a warning on
 * one field. The schema is `additionalProperties: false` throughout and every
 * timestamp carries `format: "date-time"`, so a single unnormalised value — a
 * raw filesystem or database timestamp such as `2026-08-27 11:55:57.814`,
 * missing both the `T` and the offset — takes the application off the
 * dashboard entirely. That is why every instant in this file goes through
 * `toRfc3339()` instead of being formatted at each call site.
 */

export type HealthStatus =
  | 'operational'
  | 'degraded'
  | 'outage'
  | 'maintenance'
  | 'unknown';

export interface HealthComponent {
  id: string;
  name: string;
  description?: string;
  type: string;
  status: HealthStatus;
  required: boolean;
  observedAt: string;
  latencyMs?: number;
  message?: string;
  lastSuccessAt?: string;
  lastFailureAt?: string;
  details?: Record<string, string | number | boolean | null>;
}

export interface HealthReport {
  schemaVersion: '1.0';
  observedAt: string;
  application: {
    id: 'arrahmah';
    name: string;
    description: string;
    environment: string;
    owner: string;
    kind: 'application';
    homepage: string;
    repository: string;
    release?: string;
    commit?: string;
    region?: string;
    tags?: string[];
    technologies?: Array<{
      name: string;
      category: string;
      sources: string[];
      confidence: string;
      evidence?: string;
    }>;
    deployment?: {
      latest?: {
        at: string;
        sources: string[];
        confidence: string;
        evidence?: string;
      };
    };
  };
  status: HealthStatus;
  summary: string;
  uptimeSeconds: number;
  responseTimeMs: number;
  components: HealthComponent[];
  /** `dashboard`, `runbook`, `support` and `stats` are the only legal keys in v1. */
  links?: {
    dashboard?: string;
    runbook?: string;
    support?: string;
    stats?: string;
  };
}

export const PUBLIC_ORIGIN = 'https://arrahmah.sasid.me';
export const UPSTREAM_ORIGIN = 'https://arrahmah.org';

const COMMIT_PATTERN = /^[a-fA-F0-9]{7,64}$/;

/**
 * The scraper runs every two hours. Twelve hours is six consecutive missed
 * cycles: a bound that a healthy day never approaches and that a broken ingest
 * pipeline crosses unambiguously. Choosing something nearer the cadence would
 * flap on a slow scrape and train everyone to ignore the signal.
 */
export const SNAPSHOT_STALE_AFTER_SECONDS = 12 * 60 * 60;

/** Same reasoning for the job itself: six missed runs, not one slow one. */
export const SCRAPER_STALE_AFTER_SECONDS = 12 * 60 * 60;

/**
 * The scraper writes the snapshot to disk and then POSTs the API to reload it.
 * If that POST is lost the API keeps serving an older snapshot while the disk
 * holds a newer one — a failure the previous bespoke endpoints could not see
 * at all. Half an hour is far longer than the write-then-notify gap.
 */
export const RELOAD_LAG_SECONDS = 30 * 60;

/** The broadcast checker polls every ten minutes; 45 minutes is four misses. */
export const BROADCAST_STALE_AFTER_SECONDS = 45 * 60;

/** The upstream canary loop runs every five minutes; beyond 20 it is not evidence. */
export const UPSTREAM_PROBE_MAX_AGE_SECONDS = 20 * 60;

/** A snapshot smaller than this is a truncated or half-written file, not content. */
export const MIN_SNAPSHOT_BYTES = 4096;

/**
 * A filesystem `stat` returns a `Date`, `JSON.parse` returns whatever the
 * writer put there, and both eventually reach a field the schema validates as
 * `date-time`. Coerce once, here, and return `undefined` rather than a guess
 * for anything unparseable: those fields are optional, and omitting an unknown
 * instant is honest where inventing one is not.
 */
export function toRfc3339(value: unknown): string | undefined {
  if (value === null || value === undefined) return undefined;

  if (value instanceof Date) {
    return Number.isNaN(value.getTime()) ? undefined : value.toISOString();
  }

  if (typeof value === 'number') {
    const fromEpoch = new Date(value);
    return Number.isNaN(fromEpoch.getTime()) ? undefined : fromEpoch.toISOString();
  }

  if (typeof value !== 'string') return undefined;

  const raw = value.trim();
  if (raw.length === 0) return undefined;

  // `YYYY-MM-DD HH:MM:SS[.fff]` with no zone: the shape every database driver
  // and log formatter emits, and the shape that fails RFC 3339. Every instant
  // this application records is UTC, so the missing offset is `Z`.
  const naive = /^(\d{4}-\d{2}-\d{2})[ tT](\d{2}:\d{2}:\d{2}(?:\.\d+)?)$/.exec(raw);
  const candidate = naive ? `${naive[1]}T${naive[2]}Z` : raw;

  const parsed = new Date(candidate);
  return Number.isNaN(parsed.getTime()) ? undefined : parsed.toISOString();
}

/** Whole non-negative seconds between two instants, or `undefined` if either is unusable. */
export function ageSeconds(instant: unknown, now: number): number | undefined {
  const normalised = toRfc3339(instant);
  if (!normalised) return undefined;
  const elapsed = now - Date.parse(normalised);
  return elapsed >= 0 ? Math.floor(elapsed / 1000) : 0;
}

function nonNegativeInt(value: unknown): number | undefined {
  const parsed = Number(value);
  return Number.isFinite(parsed) && parsed >= 0 ? Math.floor(parsed) : undefined;
}

/** Omit optional instants entirely rather than emit `undefined` keys. */
function at(key: 'lastSuccessAt' | 'lastFailureAt', value: unknown): Record<string, string> {
  const normalised = toRfc3339(value);
  return normalised ? { [key]: normalised } : {};
}

// ---------------------------------------------------------------------------
// Components
// ---------------------------------------------------------------------------

export interface SnapshotObservation {
  observedAt: string;
  latencyMs: number;
  /** The bespoke `/health` field this replaces: is a parsed snapshot in memory? */
  loaded: boolean;
  /** `runMetadata.lastUpdate` of the snapshot actually being served. */
  lastUpdate: unknown;
  duaCategories?: number;
  courses?: number;
  courseGroups?: number;
  drawerItems?: number;
  broadcastItems?: number;
  /** First 12 hex characters of the content hash. Not a secret; it is an ETag. */
  hashPrefix?: string;
}

/**
 * The served snapshot is the product: every mobile client reads `/api/data`
 * from it, and without one that route answers 503. Required, and an outage
 * when absent — this is the component that carries the old `dataAvailable`
 * probe forward.
 */
export function contentSnapshotComponent(input: SnapshotObservation): HealthComponent {
  const empty =
    (input.duaCategories ?? 0) === 0 &&
    (input.courses ?? 0) === 0 &&
    (input.drawerItems ?? 0) === 0;

  const status: HealthStatus = !input.loaded
    ? 'outage'
    : empty
      ? 'degraded'
      : 'operational';

  const message = !input.loaded
    ? 'No scraped content snapshot is loaded; content routes answer 503'
    : empty
      ? 'A snapshot is loaded but carries no duas, courses or lesson collections'
      : 'Content snapshot loaded and served';

  const details: Record<string, string | number | boolean | null> = {
    dataAvailable: input.loaded,
  };
  if (input.duaCategories !== undefined) details.duaCategories = input.duaCategories;
  if (input.courses !== undefined) details.courses = input.courses;
  if (input.courseGroups !== undefined) details.courseGroups = input.courseGroups;
  if (input.drawerItems !== undefined) details.contentCollections = input.drawerItems;
  if (input.broadcastItems !== undefined) details.broadcastDestinations = input.broadcastItems;
  if (input.hashPrefix) details.contentHash = input.hashPrefix;

  return {
    id: 'content-snapshot',
    name: 'Content snapshot',
    description: 'The scraped Arrahmah content snapshot held in memory and served to the apps.',
    type: 'dataset',
    required: true,
    status,
    observedAt: input.observedAt,
    latencyMs: input.latencyMs,
    message,
    ...at('lastSuccessAt', input.loaded ? input.lastUpdate : undefined),
    details,
  };
}

export interface FreshnessObservation {
  observedAt: string;
  latencyMs: number;
  /** `runMetadata.lastUpdate` of the in-memory snapshot. */
  servedAt: unknown;
  /** mtime of the snapshot file on disk, which the scraper writes before notifying. */
  diskModifiedAt: unknown;
  now: number;
}

/**
 * Freshness of what is actually being served, plus the reload-lag check.
 *
 * Optional on purpose. Stale content is a real loss — it is the signal the
 * bespoke `/api/status` probe was reaching for — but the apps keep working
 * from the snapshot they have, so this degrades the application rather than
 * declaring it down. It never escalates to outage: there is no age at which
 * refusing to serve the content would help anyone.
 */
export function contentFreshnessComponent(input: FreshnessObservation): HealthComponent {
  const served = ageSeconds(input.servedAt, input.now);
  const disk = ageSeconds(input.diskModifiedAt, input.now);
  const reloadLag =
    served !== undefined && disk !== undefined && served > disk ? served - disk : 0;

  let status: HealthStatus;
  let message: string;

  if (served === undefined) {
    status = 'unknown';
    message = 'No snapshot timestamp is available to age';
  } else if (served > SNAPSHOT_STALE_AFTER_SECONDS) {
    status = 'degraded';
    message = `Served content snapshot is ${Math.floor(served / 3600)}h old (stale beyond ${SNAPSHOT_STALE_AFTER_SECONDS / 3600}h)`;
  } else if (reloadLag > RELOAD_LAG_SECONDS) {
    status = 'degraded';
    message = `A newer snapshot has been on disk for ${Math.floor(reloadLag / 60)}m without being loaded`;
  } else {
    status = 'operational';
    message = `Served content snapshot is ${Math.floor(served / 60)}m old`;
  }

  const details: Record<string, string | number | boolean | null> = {
    staleThresholdSeconds: SNAPSHOT_STALE_AFTER_SECONDS,
    isDataStale: served !== undefined && served > SNAPSHOT_STALE_AFTER_SECONDS,
  };
  if (served !== undefined) details.servedAgeSeconds = served;
  if (disk !== undefined) details.diskAgeSeconds = disk;
  if (reloadLag > 0) details.reloadLagSeconds = reloadLag;

  return {
    id: 'content-freshness',
    name: 'Content freshness',
    description: 'Age of the served snapshot, and whether a newer one is waiting unloaded on disk.',
    type: 'dataset',
    required: false,
    status,
    observedAt: input.observedAt,
    latencyMs: input.latencyMs,
    message,
    ...at('lastSuccessAt', input.servedAt),
    details,
  };
}

export interface StorageObservation {
  observedAt: string;
  latencyMs: number;
  directoryPresent: boolean;
  writable: boolean;
  snapshotBytes?: number;
  snapshotModifiedAt?: unknown;
}

/**
 * The mounted `/app/data` volume. Required: an unwritable or missing volume
 * means no further ingest can land, and it is the failure that leaves the API
 * looking perfectly healthy while quietly freezing forever.
 */
export function contentStoreComponent(input: StorageObservation): HealthComponent {
  const bytes = nonNegativeInt(input.snapshotBytes);

  let status: HealthStatus;
  let message: string;

  if (!input.directoryPresent) {
    status = 'outage';
    message = 'Content data volume is not present';
  } else if (!input.writable) {
    status = 'outage';
    message = 'Content data volume is not writable; no further scrape can be stored';
  } else if (bytes === undefined) {
    status = 'degraded';
    message = 'Content data volume is writable but holds no snapshot file';
  } else if (bytes < MIN_SNAPSHOT_BYTES) {
    status = 'degraded';
    message = 'Snapshot file on disk is too small to be a complete snapshot';
  } else {
    status = 'operational';
    message = 'Content data volume is readable, writable and holds a snapshot';
  }

  const details: Record<string, string | number | boolean | null> = {
    writable: input.writable,
    present: input.directoryPresent,
  };
  if (bytes !== undefined) details.snapshotBytes = bytes;

  return {
    id: 'content-store',
    name: 'Content data volume',
    description: 'The mounted volume holding the scraped snapshot and scraper bookkeeping.',
    type: 'storage',
    required: true,
    status,
    observedAt: input.observedAt,
    latencyMs: input.latencyMs,
    message,
    ...at('lastSuccessAt', status === 'operational' ? input.snapshotModifiedAt : undefined),
    details,
  };
}

export interface ScraperObservation {
  observedAt: string;
  latencyMs: number;
  /** Where the evidence came from: the run journal, or the snapshot as a fallback. */
  source: 'journal' | 'snapshot' | 'none';
  lastRunStartedAt?: unknown;
  lastRunFinishedAt?: unknown;
  lastRunOk?: boolean;
  lastRunDurationMs?: unknown;
  lastSuccessAt?: unknown;
  lastFailureAt?: unknown;
  consecutiveFailures?: number;
  intervalSeconds: number;
  now: number;
}

/**
 * The ingest job itself, which the bespoke endpoints never reported on: a
 * scrape could fail every cycle for a day and `/health` would still answer
 * `"status":"ok"`. Optional, because a dead scraper freezes content rather
 * than breaking the API — but it degrades the application, so it is visible.
 */
export function scraperComponent(input: ScraperObservation): HealthComponent {
  const successAge = ageSeconds(input.lastSuccessAt, input.now);
  const failures = nonNegativeInt(input.consecutiveFailures) ?? 0;

  let status: HealthStatus;
  let message: string;

  if (input.source === 'none' || successAge === undefined) {
    status = 'unknown';
    message = 'No scrape run has been recorded yet';
  } else if (successAge > SCRAPER_STALE_AFTER_SECONDS) {
    status = 'degraded';
    message = `Last successful scrape was ${Math.floor(successAge / 3600)}h ago (expected every ${Math.round(input.intervalSeconds / 3600)}h)`;
  } else if (input.lastRunOk === false) {
    status = 'degraded';
    message =
      failures > 1
        ? `Last ${failures} scrape attempts failed; the previous snapshot is still being served`
        : 'The last scrape attempt failed; the previous snapshot is still being served';
  } else {
    status = 'operational';
    message = `Last successful scrape was ${Math.floor(successAge / 60)}m ago`;
  }

  const details: Record<string, string | number | boolean | null> = {
    evidence: input.source,
    intervalSeconds: input.intervalSeconds,
    staleThresholdSeconds: SCRAPER_STALE_AFTER_SECONDS,
    consecutiveFailures: failures,
  };
  if (input.lastRunOk !== undefined) details.lastRunOk = input.lastRunOk;
  const duration = nonNegativeInt(input.lastRunDurationMs);
  if (duration !== undefined) details.lastRunDurationMs = duration;
  const startedAge = ageSeconds(input.lastRunStartedAt, input.now);
  if (startedAge !== undefined) details.lastRunAgeSeconds = startedAge;
  if (successAge !== undefined) details.lastSuccessAgeSeconds = successAge;

  return {
    id: 'scraper',
    name: 'Content scraper',
    description: 'The scheduled ingest job that refreshes the snapshot from arrahmah.org.',
    type: 'worker',
    required: false,
    status,
    observedAt: input.observedAt,
    latencyMs: input.latencyMs,
    message,
    ...at('lastSuccessAt', input.lastSuccessAt),
    ...at('lastFailureAt', input.lastFailureAt ?? (input.lastRunOk === false ? input.lastRunFinishedAt : undefined)),
    details,
  };
}

export interface UpstreamObservation {
  observedAt: string;
  /** `undefined` while the canary loop has not produced a verdict yet. */
  probedAt?: unknown;
  latencyMs?: number;
  httpStatus?: number;
  reachable?: boolean;
  lastSuccessAt?: unknown;
  lastFailureAt?: unknown;
  now: number;
}

/**
 * arrahmah.org, the only source this API mirrors. Optional: when it is down
 * the apps keep reading the cached snapshot, so this degrades the application
 * instead of taking it out — but it is the root cause of every future
 * staleness alert, so it belongs in the report rather than in a log line.
 */
export function upstreamComponent(input: UpstreamObservation): HealthComponent {
  const probeAge = ageSeconds(input.probedAt, input.now);

  let status: HealthStatus;
  let message: string;

  if (probeAge === undefined || probeAge > UPSTREAM_PROBE_MAX_AGE_SECONDS) {
    status = 'unknown';
    message = 'No recent reachability probe for the upstream site';
  } else if (input.reachable === false) {
    status = 'outage';
    message = 'Upstream site is unreachable; the cached snapshot is still being served';
  } else if (input.httpStatus !== undefined && input.httpStatus >= 400) {
    status = 'degraded';
    message = `Upstream site answered HTTP ${input.httpStatus}; the next scrape may produce no content`;
  } else {
    status = 'operational';
    message = 'Upstream site is reachable';
  }

  const details: Record<string, string | number | boolean | null> = {
    origin: UPSTREAM_ORIGIN,
  };
  if (input.httpStatus !== undefined) details.httpStatus = input.httpStatus;
  if (probeAge !== undefined) details.probeAgeSeconds = probeAge;

  return {
    id: 'upstream-site',
    name: 'Upstream arrahmah.org',
    description: 'The public site this API scrapes; the sole source of every content snapshot.',
    type: 'external',
    required: false,
    status,
    observedAt: input.observedAt,
    ...(input.latencyMs !== undefined ? { latencyMs: input.latencyMs } : {}),
    message,
    ...at('lastSuccessAt', input.lastSuccessAt),
    ...at('lastFailureAt', input.lastFailureAt),
    details,
  };
}

export interface BroadcastObservation {
  observedAt: string;
  /** False when the snapshot publishes no broadcast destinations to watch. */
  configured: boolean;
  destinations: number;
  platformsLive: number;
  lastCheckAt?: unknown;
  lastSuccessAt?: unknown;
  lastFailureAt?: unknown;
  lastCheckErrors?: number;
  now: number;
}

/**
 * The YouTube/Facebook/Mixlr live-status checker.
 *
 * When the snapshot publishes no broadcast destinations there is nothing to
 * check and nothing wrong: that reports `maintenance` with
 * `details.configured: false`, not a permanent `degraded`. A known, deliberate
 * state is not an alert. A destination that *is* configured and whose checks
 * are failing or gone quiet does degrade — that is a real regression.
 */
export function broadcastComponent(input: BroadcastObservation): HealthComponent {
  const checkAge = ageSeconds(input.lastCheckAt, input.now);
  const errors = nonNegativeInt(input.lastCheckErrors) ?? 0;

  let status: HealthStatus;
  let message: string;

  if (!input.configured) {
    status = 'maintenance';
    message = 'No broadcast destinations are published in the current snapshot; nothing to watch';
  } else if (checkAge === undefined) {
    status = 'unknown';
    message = 'The broadcast checker has not completed a cycle yet';
  } else if (checkAge > BROADCAST_STALE_AFTER_SECONDS) {
    status = 'degraded';
    message = `Broadcast status has not been refreshed for ${Math.floor(checkAge / 60)}m`;
  } else if (errors > 0) {
    status = 'degraded';
    message = `${errors} broadcast platform check${errors === 1 ? '' : 's'} failed on the last cycle`;
  } else {
    status = 'operational';
    message =
      input.platformsLive > 0
        ? `Broadcast status current; ${input.platformsLive} platform${input.platformsLive === 1 ? '' : 's'} live`
        : 'Broadcast status current; no platform is live';
  }

  return {
    id: 'broadcast-status',
    name: 'Broadcast live status',
    description: 'Best-effort live checks against the broadcast destinations in the snapshot.',
    type: 'external',
    required: false,
    status,
    observedAt: input.observedAt,
    message,
    ...at('lastSuccessAt', input.lastSuccessAt),
    ...at('lastFailureAt', input.lastFailureAt),
    details: {
      configured: input.configured,
      destinations: input.destinations,
      platformsLive: input.platformsLive,
      ...(checkAge !== undefined ? { lastCheckAgeSeconds: checkAge } : {}),
      failedChecks: errors,
    },
  };
}

export interface StatsExportObservation {
  observedAt: string;
  configured: boolean;
}

/**
 * `/_stats` is how Relay draws this application's public metrics. Optional,
 * and `maintenance` rather than `degraded` when the token is simply not set —
 * an intentionally unconfigured integration is a known state, not an alert.
 * Nothing here queries the aggregate; readiness must never depend on it.
 */
export function statsExportComponent(input: StatsExportObservation): HealthComponent {
  return {
    id: 'stats-export',
    name: 'Product stats export',
    description: 'Token-protected /_stats endpoint that Relay reads for public product metrics.',
    type: 'telemetry',
    required: false,
    status: input.configured ? 'operational' : 'maintenance',
    observedAt: input.observedAt,
    message: input.configured
      ? 'Product stats export is configured'
      : 'Product stats export is intentionally unconfigured; readiness is unaffected',
    details: { configured: input.configured },
  };
}

// ---------------------------------------------------------------------------
// Aggregation
// ---------------------------------------------------------------------------

/**
 * Standard precedence, with one addition the standard leaves to the
 * application: a *required* component whose state cannot be established makes
 * the application `unknown`, while an optional one does not. An optional
 * `unknown` — an upstream canary that has not run yet — is not evidence of a
 * problem, and treating it as one would page on startup.
 */
export function aggregateStatus(components: HealthComponent[]): HealthStatus {
  if (components.some((c) => c.required && c.status === 'outage')) return 'outage';
  if (components.some((c) => c.required && c.status === 'unknown')) return 'unknown';
  if (components.some((c) => c.status === 'outage' || c.status === 'degraded')) {
    return 'degraded';
  }
  return 'operational';
}

export function summarise(components: HealthComponent[]): string {
  const down = components.filter((c) => c.status === 'outage');
  if (down.some((c) => c.required)) {
    const names = down.filter((c) => c.required).map((c) => c.name).join(', ');
    return `${names} unavailable; content routes cannot serve.`;
  }
  const degraded = components.filter(
    (c) => c.status === 'degraded' || c.status === 'outage',
  );
  if (degraded.length > 0) {
    return `${degraded.map((c) => c.name).join(', ')} degraded; cached content is still being served.`;
  }
  const unknown = components.filter((c) => c.status === 'unknown');
  if (unknown.length > 0) {
    return `All required systems operational; ${unknown.map((c) => c.name).join(', ')} not yet observed.`;
  }
  return 'All systems operational.';
}

/** The transport table from the standard. */
export function httpStatusFor(status: HealthStatus): number {
  return status === 'outage' || status === 'unknown' ? 503 : 200;
}

export interface ReportInput {
  components: HealthComponent[];
  observedAt: string;
  uptimeSeconds: number;
  responseTimeMs: number;
  environment: string;
  commit?: string;
  releasedAt?: unknown;
}

/** Assembles the wire report from already-collected components. Pure. */
export function assembleHealthReport(input: ReportInput): HealthReport {
  const commit =
    input.commit && COMMIT_PATTERN.test(input.commit) ? input.commit : undefined;
  const releasedAt = toRfc3339(input.releasedAt);

  return {
    schemaVersion: '1.0',
    observedAt: input.observedAt,
    application: {
      // Relay's durable id for this application. It must match
      // `config/apps.json` exactly or the report is filed against nothing.
      id: 'arrahmah',
      name: 'Arrahmah',
      description: 'Arrahmah Islamic Institute content, prayer, and broadcast API.',
      environment: input.environment,
      owner: 'SASID',
      kind: 'application',
      homepage: PUBLIC_ORIGIN,
      repository: 'https://github.com/ArrahmaMobile/arrahma_mobile',
      region: 'EU',
      tags: ['api', 'data', 'scraper'],
      ...(commit ? { commit, release: `arrahmah-api:${commit}` } : {}),
      technologies: [
        { name: 'TypeScript', category: 'language', sources: ['configured'], confidence: 'declared' },
        { name: 'Node.js', category: 'runtime', sources: ['configured'], confidence: 'declared' },
        { name: 'Express', category: 'framework', sources: ['configured'], confidence: 'declared' },
        { name: 'Docker', category: 'hosting', sources: ['configured'], confidence: 'declared' },
      ],
      ...(releasedAt
        ? {
            deployment: {
              latest: {
                at: releasedAt,
                sources: ['vps'],
                confidence: 'high',
                evidence: 'Release timestamp stamped into the container environment at deploy time.',
              },
            },
          }
        : {}),
    },
    status: aggregateStatus(input.components),
    summary: summarise(input.components),
    uptimeSeconds: input.uptimeSeconds,
    responseTimeMs: input.responseTimeMs,
    components: input.components,
    links: {
      dashboard: 'https://health.sasid.ai',
      // Reserved by the standard for the canonical Product Stats v1 endpoint.
      stats: `${PUBLIC_ORIGIN}/_stats`,
    },
  };
}
