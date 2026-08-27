/**
 * `/_health` against the real published SASID Health v1 JSON Schema.
 *
 * Eyeballing the shape is not enough. Relay compiles this exact schema with
 * Ajv and discards the whole report — not the offending field — when anything
 * fails, so a single unnormalised timestamp reads as a total outage while
 * every component inside it is green. Another application in this fleet is
 * down for exactly that reason right now: it shipped
 * `"lastSuccessAt": "2026-08-27 11:55:57.814"`, a database timestamp with no
 * `T` and no offset, and `format: "date-time"` rejected it.
 *
 * So the values fed in here are the awkward ones: naive timestamps, `Date`
 * objects, numeric strings, `null`, and absent evidence. `contract.ts` imports
 * nothing, which is what lets this run with no filesystem and no network.
 */

const assert = require('node:assert/strict');
const test = require('node:test');
const { readFileSync } = require('node:fs');
const { join } = require('node:path');

const Ajv2020Module = require('ajv/dist/2020.js');
const ajvFormatsModule = require('ajv-formats');

const Ajv2020 = Ajv2020Module.default ?? Ajv2020Module;
const addFormats = ajvFormatsModule.default ?? ajvFormatsModule;

const {
  assembleHealthReport,
  aggregateStatus,
  broadcastComponent,
  contentFreshnessComponent,
  contentSnapshotComponent,
  contentStoreComponent,
  httpStatusFor,
  scraperComponent,
  statsExportComponent,
  toRfc3339,
  upstreamComponent,
  SNAPSHOT_STALE_AFTER_SECONDS,
  RELOAD_LAG_SECONDS,
} = require('../dist/api/health/contract.js');

const schema = JSON.parse(
  readFileSync(join(__dirname, 'fixtures', 'sasid-health.v1.schema.json'), 'utf8'),
);

const ajv = new Ajv2020({ allErrors: true, strict: false });
addFormats(ajv);
const validate = ajv.compile(schema);

/** The exact shape that took another fleet application off the dashboard. */
const NAIVE_TIMESTAMP = '2026-08-27 11:55:57.814';

const NOW = Date.parse('2026-08-27T12:00:00.000Z');
const OBSERVED_AT = new Date(NOW).toISOString();

function assertValid(report) {
  if (!validate(report)) {
    assert.fail(
      `report failed SASID Health v1 validation:\n${JSON.stringify(validate.errors, null, 2)}`,
    );
  }
}

function healthyComponents(overrides = {}) {
  return [
    contentSnapshotComponent({
      observedAt: OBSERVED_AT,
      latencyMs: 1,
      loaded: true,
      lastUpdate: '2026-08-27T11:27:05.336Z',
      duaCategories: 27,
      courses: 6,
      courseGroups: 3,
      drawerItems: 8,
      broadcastItems: 4,
      hashPrefix: '42daac03668f',
      ...overrides.snapshot,
    }),
    contentFreshnessComponent({
      observedAt: OBSERVED_AT,
      latencyMs: 1,
      servedAt: '2026-08-27T11:27:05.336Z',
      diskModifiedAt: new Date('2026-08-27T11:27:05.336Z'),
      now: NOW,
      ...overrides.freshness,
    }),
    contentStoreComponent({
      observedAt: OBSERVED_AT,
      latencyMs: 1,
      directoryPresent: true,
      writable: true,
      snapshotBytes: 15_902_898,
      snapshotModifiedAt: new Date('2026-08-27T11:27:05.336Z'),
      ...overrides.store,
    }),
    scraperComponent({
      observedAt: OBSERVED_AT,
      latencyMs: 1,
      source: 'journal',
      lastRunStartedAt: '2026-08-27T11:20:00.000Z',
      lastRunFinishedAt: '2026-08-27T11:27:05.336Z',
      lastRunOk: true,
      lastRunDurationMs: 425_336,
      lastSuccessAt: '2026-08-27T11:27:05.336Z',
      lastFailureAt: null,
      consecutiveFailures: 0,
      intervalSeconds: 7200,
      now: NOW,
      ...overrides.scraper,
    }),
    upstreamComponent({
      observedAt: OBSERVED_AT,
      probedAt: '2026-08-27T11:58:00.000Z',
      latencyMs: 633,
      httpStatus: 200,
      reachable: true,
      lastSuccessAt: '2026-08-27T11:58:00.000Z',
      now: NOW,
      ...overrides.upstream,
    }),
    broadcastComponent({
      observedAt: OBSERVED_AT,
      configured: true,
      destinations: 3,
      platformsLive: 0,
      lastCheckAt: '2026-08-27T11:55:00.000Z',
      lastSuccessAt: '2026-08-27T11:55:00.000Z',
      lastFailureAt: null,
      lastCheckErrors: 0,
      now: NOW,
      ...overrides.broadcast,
    }),
    statsExportComponent({ observedAt: OBSERVED_AT, configured: true, ...overrides.stats }),
  ];
}

function report(components, extra = {}) {
  return assembleHealthReport({
    components,
    observedAt: OBSERVED_AT,
    uptimeSeconds: 1_961_430,
    responseTimeMs: 3,
    environment: 'production',
    commit: 'a1b2c3d4e5f6',
    releasedAt: '2026-08-27T09:00:00.000Z',
    ...extra,
  });
}

test('a healthy report validates against the published schema', () => {
  const assembled = report(healthyComponents());
  assertValid(assembled);
  assert.equal(assembled.status, 'operational');
  assert.equal(assembled.application.id, 'arrahmah');
  assert.equal(assembled.schemaVersion, '1.0');
  assert.equal(httpStatusFor(assembled.status), 200);
  assert.equal(assembled.links.stats, 'https://arrahmah.sasid.me/_stats');
});

test('every component declares the fields the standard requires', () => {
  for (const component of healthyComponents()) {
    for (const field of ['id', 'name', 'type', 'status', 'required', 'observedAt', 'message']) {
      assert.ok(
        component[field] !== undefined,
        `component ${component.id} is missing ${field}`,
      );
    }
    assert.match(component.id, /^[a-z][a-z0-9-]{1,63}$/);
  }
});

test('naive timestamps from disk and drivers are normalised to RFC 3339 UTC', () => {
  assert.equal(toRfc3339(NAIVE_TIMESTAMP), '2026-08-27T11:55:57.814Z');
  assert.equal(toRfc3339(new Date(NOW)), OBSERVED_AT);
  assert.equal(toRfc3339(NOW), OBSERVED_AT);
  assert.equal(toRfc3339(null), undefined);
  assert.equal(toRfc3339('not a timestamp'), undefined);

  // The whole report, with every instant supplied in the broken form.
  const assembled = report(
    healthyComponents({
      snapshot: { lastUpdate: NAIVE_TIMESTAMP },
      freshness: { servedAt: NAIVE_TIMESTAMP, diskModifiedAt: NAIVE_TIMESTAMP },
      store: { snapshotModifiedAt: NAIVE_TIMESTAMP },
      scraper: {
        lastRunStartedAt: NAIVE_TIMESTAMP,
        lastRunFinishedAt: NAIVE_TIMESTAMP,
        lastSuccessAt: NAIVE_TIMESTAMP,
      },
      upstream: { probedAt: NAIVE_TIMESTAMP, lastSuccessAt: NAIVE_TIMESTAMP },
      broadcast: { lastCheckAt: NAIVE_TIMESTAMP, lastSuccessAt: NAIVE_TIMESTAMP },
    }),
    { releasedAt: NAIVE_TIMESTAMP },
  );

  assertValid(assembled);
  assert.equal(assembled.application.deployment.latest.at, '2026-08-27T11:55:57.814Z');
});

test('a missing snapshot is a required outage and answers 503', () => {
  const components = healthyComponents({
    snapshot: {
      loaded: false,
      lastUpdate: null,
      duaCategories: undefined,
      courses: undefined,
      courseGroups: undefined,
      drawerItems: undefined,
      broadcastItems: undefined,
      hashPrefix: undefined,
    },
    freshness: { servedAt: null },
    scraper: { source: 'none', lastSuccessAt: null },
  });

  const assembled = report(components);
  assertValid(assembled);
  assert.equal(assembled.status, 'outage');
  assert.equal(httpStatusFor(assembled.status), 503);

  const snapshot = components.find((c) => c.id === 'content-snapshot');
  assert.equal(snapshot.required, true);
  assert.equal(snapshot.details.dataAvailable, false);
});

test('stale content degrades without taking the application down', () => {
  const stale = '2026-08-26T00:00:00.000Z'; // 36h before NOW
  const assembled = report(
    healthyComponents({
      freshness: { servedAt: stale, diskModifiedAt: new Date(stale) },
      scraper: { lastSuccessAt: stale, lastRunFinishedAt: stale },
    }),
  );

  assertValid(assembled);
  assert.equal(assembled.status, 'degraded');
  assert.equal(httpStatusFor(assembled.status), 200);

  const freshness = assembled.components.find((c) => c.id === 'content-freshness');
  assert.equal(freshness.status, 'degraded');
  assert.equal(freshness.details.isDataStale, true);
  assert.equal(freshness.details.staleThresholdSeconds, SNAPSHOT_STALE_AFTER_SECONDS);
});

test('freshness does not flap inside one healthy scrape cycle', () => {
  // Three hours old: past the two-hour cadence, nowhere near unusable.
  const component = contentFreshnessComponent({
    observedAt: OBSERVED_AT,
    latencyMs: 1,
    servedAt: '2026-08-27T09:00:00.000Z',
    diskModifiedAt: new Date('2026-08-27T09:00:00.000Z'),
    now: NOW,
  });
  assert.equal(component.status, 'operational');
  assert.equal(component.details.isDataStale, false);
});

test('a newer snapshot stuck on disk is reported as a reload lag', () => {
  const component = contentFreshnessComponent({
    observedAt: OBSERVED_AT,
    latencyMs: 1,
    servedAt: '2026-08-27T09:00:00.000Z',
    diskModifiedAt: new Date('2026-08-27T11:50:00.000Z'),
    now: NOW,
  });
  assert.equal(component.status, 'degraded');
  assert.ok(component.details.reloadLagSeconds > RELOAD_LAG_SECONDS);
  assert.match(component.message, /on disk/);
});

test('a failing scrape degrades the application while content still serves', () => {
  const assembled = report(
    healthyComponents({
      scraper: { lastRunOk: false, consecutiveFailures: 3, lastFailureAt: '2026-08-27T11:40:00.000Z' },
    }),
  );

  assertValid(assembled);
  assert.equal(assembled.status, 'degraded');
  const scraper = assembled.components.find((c) => c.id === 'scraper');
  assert.equal(scraper.required, false);
  assert.equal(scraper.status, 'degraded');
  assert.equal(scraper.lastFailureAt, '2026-08-27T11:40:00.000Z');
});

test('an unwritable data volume is a required outage', () => {
  const component = contentStoreComponent({
    observedAt: OBSERVED_AT,
    latencyMs: 1,
    directoryPresent: true,
    writable: false,
    snapshotBytes: 15_902_898,
    snapshotModifiedAt: new Date(NOW),
  });
  assert.equal(component.status, 'outage');
  assert.equal(component.required, true);
  assert.equal(aggregateStatus([component]), 'outage');
});

test('unconfigured optional integrations report maintenance, not permanent degradation', () => {
  const components = healthyComponents({
    broadcast: { configured: false, destinations: 0, lastCheckAt: null, lastSuccessAt: null },
    stats: { configured: false },
  });
  const assembled = report(components);

  assertValid(assembled);
  assert.equal(assembled.status, 'operational');

  const broadcast = assembled.components.find((c) => c.id === 'broadcast-status');
  assert.equal(broadcast.status, 'maintenance');
  assert.equal(broadcast.details.configured, false);

  const stats = assembled.components.find((c) => c.id === 'stats-export');
  assert.equal(stats.status, 'maintenance');
  assert.equal(stats.details.configured, false);
});

test('a configured-and-failing integration still degrades', () => {
  const component = broadcastComponent({
    observedAt: OBSERVED_AT,
    configured: true,
    destinations: 3,
    platformsLive: 0,
    lastCheckAt: '2026-08-27T11:55:00.000Z',
    lastFailureAt: '2026-08-27T11:55:00.000Z',
    lastCheckErrors: 2,
    now: NOW,
  });
  assert.equal(component.status, 'degraded');
  assert.equal(component.details.configured, true);
  assert.equal(aggregateStatus([component]), 'degraded');
});

test('an unreachable upstream degrades the application rather than breaking it', () => {
  const assembled = report(
    healthyComponents({
      upstream: {
        reachable: false,
        httpStatus: undefined,
        lastFailureAt: '2026-08-27T11:58:00.000Z',
      },
    }),
  );

  assertValid(assembled);
  assert.equal(assembled.status, 'degraded');
  assert.equal(httpStatusFor(assembled.status), 200);
  const site = assembled.components.find((c) => c.id === 'upstream-site');
  assert.equal(site.status, 'outage');
  assert.equal(site.required, false);
});

test('an optional component that has not been observed does not raise an alert', () => {
  const assembled = report(
    healthyComponents({ upstream: { probedAt: undefined, reachable: undefined, httpStatus: undefined } }),
  );
  assertValid(assembled);
  assert.equal(assembled.status, 'operational');
  assert.equal(
    assembled.components.find((c) => c.id === 'upstream-site').status,
    'unknown',
  );
});

test('the report carries no secrets', () => {
  process.env.PRODUCT_STATS_TOKEN = 'super-secret-token-value-abcdefgh';
  const serialised = JSON.stringify(report(healthyComponents()));
  delete process.env.PRODUCT_STATS_TOKEN;

  for (const forbidden of ['super-secret-token-value', 'PRODUCT_STATS_TOKEN', 'RELOAD_API_KEY', '/app/data']) {
    assert.equal(
      serialised.includes(forbidden),
      false,
      `report leaked ${forbidden}`,
    );
  }
});

test('an unparseable commit is omitted rather than emitted invalid', () => {
  const assembled = report(healthyComponents(), { commit: 'not-a-sha', releasedAt: null });
  assertValid(assembled);
  assert.equal(assembled.application.commit, undefined);
  assert.equal(assembled.application.deployment, undefined);
});
