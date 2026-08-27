/**
 * `GET /_health` — SASID Application Health Standard v1.
 *
 * The point of this file is the `components` array, not the top-level status.
 * Relay turns every entry into its own tracked component with its own history
 * and its own alert, so a dependency that is not enumerated here is a
 * dependency nobody is watching.
 *
 * This module is the I/O half. Every wire shape, every status decision and
 * every timestamp coercion lives in `contract.ts`, which imports nothing and
 * is what the schema regression test drives.
 *
 * Two rules this endpoint keeps:
 *   - it never reads the 16 MB snapshot file, only `stat`s it;
 *   - it never runs the product-stats aggregate, so stats latency cannot
 *     change readiness.
 */

import * as fs from 'fs/promises';
import * as path from 'path';
import axios from 'axios';
import { RequestHandler } from 'express';
import { ScrapedData } from '../../types/models';
import { BroadcastDiagnostics } from '../../services/broadcast-checker';
import { dataDirectory, readScrapeJournal } from '../../services/scrape-journal';
import {
  HealthComponent,
  HealthReport,
  UPSTREAM_ORIGIN,
  assembleHealthReport,
  broadcastComponent,
  contentFreshnessComponent,
  contentSnapshotComponent,
  contentStoreComponent,
  httpStatusFor,
  scraperComponent,
  statsExportComponent,
  upstreamComponent,
} from './contract';

/** The container's scrape cadence, mirrored from `docker-entrypoint.sh`. */
const SCRAPE_INTERVAL_SECONDS = 2 * 60 * 60;

export interface HealthSource {
  getData(): ScrapedData | null;
  getDataHash(): string;
  getBroadcastDiagnostics(): BroadcastDiagnostics;
}

interface UpstreamSnapshot {
  probedAt?: string;
  latencyMs?: number;
  httpStatus?: number;
  reachable?: boolean;
  lastSuccessAt?: string;
  lastFailureAt?: string;
}

/**
 * The upstream verdict is cached and refreshed on its own slow loop rather
 * than probed per request: an unauthenticated endpoint must not let a client
 * turn one HTTP call into an outbound request to somebody else's site.
 */
let upstream: UpstreamSnapshot = {};

async function probeUpstream(): Promise<void> {
  const startedAt = Date.now();
  try {
    const response = await axios.head(UPSTREAM_ORIGIN, {
      timeout: 8000,
      maxRedirects: 3,
      validateStatus: () => true,
      headers: { 'User-Agent': 'arrahmah-health/1.0 (+https://arrahmah.sasid.me)' },
    });
    const at = new Date().toISOString();
    // 405/501 means the origin refuses HEAD, not that it is unwell — it
    // answered, which is the whole question this probe asks.
    const ok = response.status < 400 || response.status === 405 || response.status === 501;
    upstream = {
      probedAt: at,
      latencyMs: Date.now() - startedAt,
      httpStatus: ok && response.status >= 400 ? 200 : response.status,
      reachable: true,
      lastSuccessAt: ok ? at : upstream.lastSuccessAt,
      lastFailureAt: ok ? upstream.lastFailureAt : at,
    };
  } catch {
    const at = new Date().toISOString();
    upstream = {
      probedAt: at,
      latencyMs: Date.now() - startedAt,
      reachable: false,
      lastSuccessAt: upstream.lastSuccessAt,
      lastFailureAt: at,
    };
  }
}

export function startUpstreamCanaryLoop(intervalMs = 5 * 60_000): NodeJS.Timeout {
  void probeUpstream();
  const timer = setInterval(() => void probeUpstream(), intervalMs);
  timer.unref();
  return timer;
}

/** Local filesystem calls are fast, but readiness must still be bounded. */
async function withTimeout<T>(work: Promise<T>, ms: number, fallback: T): Promise<T> {
  let timer: NodeJS.Timeout | undefined;
  const guard = new Promise<T>((resolve) => {
    timer = setTimeout(() => resolve(fallback), ms);
  });
  try {
    return await Promise.race([work, guard]);
  } finally {
    if (timer) clearTimeout(timer);
  }
}

interface StoreFacts {
  directoryPresent: boolean;
  writable: boolean;
  snapshotBytes?: number;
  snapshotModifiedAt?: Date;
}

async function inspectStore(): Promise<StoreFacts> {
  const directory = dataDirectory();
  let directoryPresent = false;
  let writable = false;

  try {
    const stats = await fs.stat(directory);
    directoryPresent = stats.isDirectory();
  } catch {
    return { directoryPresent: false, writable: false };
  }

  try {
    // W_OK is a permission question, not a write: the check stays read-only.
    await fs.access(directory, fs.constants.W_OK);
    writable = true;
  } catch {
    writable = false;
  }

  try {
    const snapshot = await fs.stat(path.join(directory, 'scraped_data.json'));
    return {
      directoryPresent,
      writable,
      snapshotBytes: snapshot.size,
      snapshotModifiedAt: snapshot.mtime,
    };
  } catch {
    return { directoryPresent, writable };
  }
}

function statsExportConfigured(): boolean {
  const token = process.env.PRODUCT_STATS_TOKEN;
  return typeof token === 'string' && token.trim().length >= 24;
}

export async function buildHealthReport(source: HealthSource): Promise<HealthReport> {
  const startedAt = Date.now();
  const observedAt = new Date(startedAt).toISOString();

  const data = source.getData();
  const appData = data?.appData;
  const hash = source.getDataHash();

  const [store, journal] = await Promise.all([
    withTimeout(inspectStore(), 1500, { directoryPresent: false, writable: false }),
    withTimeout(readScrapeJournal(), 1500, null),
  ]);

  const ioLatency = Date.now() - startedAt;
  const now = Date.now();

  const snapshot = contentSnapshotComponent({
    observedAt,
    latencyMs: Date.now() - startedAt,
    loaded: data !== null && appData !== undefined,
    lastUpdate: data?.runMetadata?.lastUpdate,
    duaCategories: appData?.duaCategories?.length,
    courses: appData?.courses?.length,
    courseGroups: appData?.otherCourseGroups?.length,
    drawerItems: appData?.drawerItems?.length,
    broadcastItems: appData?.broadcastItems?.length,
    hashPrefix: hash ? hash.slice(0, 12) : undefined,
  });

  const freshness = contentFreshnessComponent({
    observedAt,
    latencyMs: ioLatency,
    servedAt: data?.runMetadata?.lastUpdate,
    diskModifiedAt: store.snapshotModifiedAt,
    now,
  });

  const storeComponent = contentStoreComponent({
    observedAt,
    latencyMs: ioLatency,
    directoryPresent: store.directoryPresent,
    writable: store.writable,
    snapshotBytes: store.snapshotBytes,
    snapshotModifiedAt: store.snapshotModifiedAt,
  });

  // With no journal yet — the first deploy that ships one — the snapshot's own
  // timestamp is still real evidence that a scrape completed, so say so and
  // label where the evidence came from rather than reporting nothing.
  const scraper = scraperComponent({
    observedAt,
    latencyMs: ioLatency,
    source: journal ? 'journal' : data ? 'snapshot' : 'none',
    lastRunStartedAt: journal?.lastRunStartedAt,
    lastRunFinishedAt: journal?.lastRunFinishedAt,
    lastRunOk: journal?.lastRunOk,
    lastRunDurationMs: journal?.lastRunDurationMs,
    lastSuccessAt: journal?.lastSuccessAt ?? data?.runMetadata?.lastUpdate,
    lastFailureAt: journal?.lastFailureAt,
    consecutiveFailures: journal?.consecutiveFailures,
    intervalSeconds: SCRAPE_INTERVAL_SECONDS,
    now,
  });

  const site = upstreamComponent({
    observedAt,
    probedAt: upstream.probedAt,
    latencyMs: upstream.latencyMs,
    httpStatus: upstream.httpStatus,
    reachable: upstream.reachable,
    lastSuccessAt: upstream.lastSuccessAt,
    lastFailureAt: upstream.lastFailureAt,
    now,
  });

  const diagnostics = source.getBroadcastDiagnostics();
  const broadcast = broadcastComponent({
    observedAt,
    configured: diagnostics.destinations > 0,
    destinations: diagnostics.destinations,
    platformsLive: diagnostics.platformsLive,
    lastCheckAt: diagnostics.lastCheckAt,
    lastSuccessAt: diagnostics.lastSuccessAt,
    lastFailureAt: diagnostics.lastFailureAt,
    lastCheckErrors: diagnostics.lastCheckErrors,
    now,
  });

  const stats = statsExportComponent({ observedAt, configured: statsExportConfigured() });

  const components: HealthComponent[] = [
    snapshot,
    freshness,
    storeComponent,
    scraper,
    site,
    broadcast,
    stats,
  ];

  return assembleHealthReport({
    components,
    observedAt,
    uptimeSeconds: Math.floor(process.uptime()),
    responseTimeMs: Date.now() - startedAt,
    environment: process.env.NODE_ENV === 'production' ? 'production' : 'development',
    commit: process.env.RELEASE_SHA,
    releasedAt: process.env.RELEASE_AT,
  });
}

export function createHealthHandler(source: HealthSource): RequestHandler {
  return (_req, res) => {
    void buildHealthReport(source)
      .then((report) => {
        res
          .status(httpStatusFor(report.status))
          .set({
            'Content-Type': 'application/vnd.sasid.health+json; version=1',
            'Cache-Control': 'no-store, max-age=0',
          })
          .json(report);
      })
      .catch((error) => {
        // A health endpoint that 500s tells an operator nothing. Answer the
        // contract with `unknown`, which the transport table maps to 503.
        console.error('[health] Failed to assemble report:', error);
        const observedAt = new Date().toISOString();
        res
          .status(503)
          .set({
            'Content-Type': 'application/vnd.sasid.health+json; version=1',
            'Cache-Control': 'no-store, max-age=0',
          })
          .json({
            ...assembleHealthReport({
              components: [
                {
                  id: 'health-report',
                  name: 'Health report',
                  type: 'internal',
                  status: 'unknown',
                  required: true,
                  observedAt,
                  message: 'The application could not assemble a trustworthy health report',
                },
              ],
              observedAt,
              uptimeSeconds: Math.floor(process.uptime()),
              responseTimeMs: 0,
              environment:
                process.env.NODE_ENV === 'production' ? 'production' : 'development',
              commit: process.env.RELEASE_SHA,
              releasedAt: process.env.RELEASE_AT,
            }),
          });
      });
  };
}
