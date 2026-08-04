const assert = require('node:assert/strict');
const test = require('node:test');
const express = require('express');
const {
  buildArrahmahProductStats,
  createProductStatsHandler,
  validProductStatsBearer,
} = require('../dist/api/product-stats.js');

function fixture() {
  return {
    runMetadata: {
      lastUpdate: '2026-08-04T11:59:00.000Z',
      updateFrequency: 7_200_000,
    },
    appData: {
      logoUrl: '',
      quickLinks: [],
      banners: [],
      broadcastItems: [{}, {}, {}, {}],
      socialMediaItems: [],
      aboutUsMarkdown: '',
      courses: [{ title: 'Primary', imageUrl: '', buttons: [], sections: [] }],
      otherCourseGroups: [{
        title: 'Languages',
        imageUrl: '',
        courses: [{ title: 'Grouped', imageUrl: '', buttons: [], sections: [] }],
      }],
      drawerItems: [{
        title: 'Tafseer',
        children: [{
          title: 'Series',
          content: {
            id: 'series',
            title: 'Series',
            surahs: [{
              name: 'One',
              arabicName: null,
              description: null,
              groups: [],
              lessons: [{}, {}, {}],
            }],
          },
        }],
      }],
      duaCategories: [{
        title: 'Morning',
        duas: [{ id: 1 }, { id: 2 }],
        categories: [{ title: 'Travel', duas: [{ id: 3 }] }],
      }],
    },
  };
}

test('reports current content, freshness, and broadcast evidence', () => {
  const report = buildArrahmahProductStats(
    fixture(),
    { isYoutubeLive: true, isFacebookLive: false, isMixlrLive: true },
    Date.parse('2026-08-04T12:00:00.000Z'),
  );

  assert.equal(report.schemaVersion, '1.0');
  assert.equal(report.applicationId, 'arrahmah');
  assert.equal(report.observedAt, '2026-08-04T12:00:00.000Z');
  assert.equal(report.metrics.length, 12);

  const value = (id) => report.metrics.find((metric) => metric.id === id)?.value;
  assert.equal(value('content-age'), 60);
  assert.equal(value('duas-published'), 3);
  assert.equal(value('dua-categories-published'), 2);
  assert.equal(value('courses-published'), 2);
  assert.equal(value('lesson-records-published'), 3);
  assert.equal(value('content-collections-published'), 1);
  assert.equal(value('broadcast-destinations'), 4);
  assert.equal(value('broadcast-platforms-live'), 2);

  for (const id of ['users-total', 'users-new', 'users-active', 'users-online']) {
    const metric = report.metrics.find((candidate) => candidate.id === id);
    assert.equal(metric?.status, 'unavailable');
    assert.equal(metric?.value, undefined);
  }
});

test('does not turn missing or invalid content into zero inventory', () => {
  const missing = buildArrahmahProductStats(
    null,
    { isYoutubeLive: false, isFacebookLive: false, isMixlrLive: false },
    0,
  );
  for (const id of [
    'content-age',
    'duas-published',
    'dua-categories-published',
    'courses-published',
    'lesson-records-published',
    'content-collections-published',
    'broadcast-destinations',
  ]) {
    assert.equal(missing.metrics.find((metric) => metric.id === id)?.status, 'unavailable');
  }
  assert.equal(
    missing.metrics.find((metric) => metric.id === 'broadcast-platforms-live')?.value,
    0,
  );

  const invalid = fixture();
  invalid.runMetadata.lastUpdate = 'not-a-date';
  assert.equal(
    buildArrahmahProductStats(
      invalid,
      { isYoutubeLive: false, isFacebookLive: false, isMixlrLive: false },
      0,
    ).metrics.find((metric) => metric.id === 'content-age')?.status,
    'unavailable',
  );
});

test('uses a strong exact bearer token comparison', () => {
  const token = 'arrahmah-product-stats-test-token';
  assert.equal(validProductStatsBearer(`Bearer ${token}`, token), true);
  assert.equal(validProductStatsBearer('Bearer wrong-token', token), false);
  assert.equal(validProductStatsBearer(`Bearer ${token}`, 'short'), false);
  assert.equal(validProductStatsBearer(undefined, token), false);
});

test('protects the HTTP endpoint and returns the versioned contract', async () => {
  const previousToken = process.env.PRODUCT_STATS_TOKEN;
  const token = 'arrahmah-product-stats-http-token';
  const app = express();
  app.get('/_stats', createProductStatsHandler({
    getData: fixture,
    getBroadcastStatus: () => ({
      isYoutubeLive: false,
      isFacebookLive: false,
      isMixlrLive: false,
    }),
  }));
  const server = await new Promise((resolve) => {
    const listening = app.listen(0, '127.0.0.1', () => resolve(listening));
  });
  const address = server.address();
  assert.ok(address && typeof address !== 'string');
  const url = `http://127.0.0.1:${address.port}/_stats`;

  try {
    delete process.env.PRODUCT_STATS_TOKEN;
    const unconfigured = await fetch(url);
    assert.equal(unconfigured.status, 503);
    assert.deepEqual(await unconfigured.json(), { error: 'product_stats_unavailable' });

    process.env.PRODUCT_STATS_TOKEN = token;
    const unauthorized = await fetch(url, {
      headers: { authorization: 'Bearer wrong' },
    });
    assert.equal(unauthorized.status, 401);
    assert.equal(unauthorized.headers.get('www-authenticate'), 'Bearer');

    const authorized = await fetch(url, {
      headers: { authorization: `Bearer ${token}` },
    });
    assert.equal(authorized.status, 200);
    const contentType = authorized.headers.get('content-type') ?? '';
    assert.match(contentType, /^application\/vnd\.sasid\.product-stats\+json;/);
    assert.match(contentType, /\bversion=1\b/);
    assert.equal(authorized.headers.get('cache-control'), 'no-store, max-age=0');
    assert.equal((await authorized.json()).applicationId, 'arrahmah');
  } finally {
    await new Promise((resolve, reject) => server.close((error) => error ? reject(error) : resolve()));
    if (previousToken === undefined) delete process.env.PRODUCT_STATS_TOKEN;
    else process.env.PRODUCT_STATS_TOKEN = previousToken;
  }
});
