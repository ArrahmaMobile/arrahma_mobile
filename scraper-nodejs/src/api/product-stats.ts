import { timingSafeEqual } from 'crypto';
import { RequestHandler } from 'express';
import {
  DrawerItem,
  DuaCategory,
  QuranCourse,
  ScrapedData,
} from '../types/models';

type MetricCategory = 'users' | 'engagement' | 'content' | 'growth' | 'revenue';
type MetricSemantic =
  | 'total-users'
  | 'new-users'
  | 'active-users'
  | 'online-users'
  | 'core-action'
  | 'conversion'
  | 'revenue'
  | 'custom';
type MetricStatus = 'available' | 'suppressed' | 'unavailable' | 'not-applicable';
type MetricPeriod = 'instant' | '24h' | '7d' | '30d' | 'all-time';

export interface ProductMetric {
  id: string;
  name: string;
  description?: string;
  category: MetricCategory;
  semantic: MetricSemantic;
  status: MetricStatus;
  value?: number;
  unit: 'count' | 'percent' | 'currency-minor' | 'seconds';
  period: MetricPeriod;
  aggregation: 'gauge' | 'cumulative';
}

export interface ProductStatsReport {
  schemaVersion: '1.0';
  observedAt: string;
  applicationId: 'arrahmah';
  metrics: ProductMetric[];
}

export interface BroadcastStatus {
  isYoutubeLive: boolean;
  isFacebookLive: boolean;
  isMixlrLive: boolean;
}

export interface ProductStatsSource {
  getData(): ScrapedData | null;
  getBroadcastStatus(): BroadcastStatus;
}

interface DuaInventory {
  categories: number;
  duas: number;
}

interface DrawerInventory {
  collections: number;
  lessons: number;
}

function metric(
  base: Omit<ProductMetric, 'status' | 'value'>,
  value: number | undefined,
): ProductMetric {
  return value === undefined
    ? { ...base, status: 'unavailable' }
    : { ...base, status: 'available', value };
}

function countDuas(categories: DuaCategory[]): DuaInventory {
  return categories.reduce<DuaInventory>(
    (total, category) => {
      const nested = countDuas(category.categories ?? []);
      return {
        categories: total.categories + 1 + nested.categories,
        duas: total.duas + (category.duas?.length ?? 0) + nested.duas,
      };
    },
    { categories: 0, duas: 0 },
  );
}

function countDrawerContent(items: DrawerItem[]): DrawerInventory {
  return items.reduce<DrawerInventory>(
    (total, item) => {
      const nested = countDrawerContent(item.children ?? []);
      const lessons = (item.content?.surahs ?? []).reduce(
        (sum, surah) => sum + (surah.lessons?.length ?? 0),
        0,
      );
      return {
        collections: total.collections + (item.content ? 1 : 0) + nested.collections,
        lessons: total.lessons + lessons + nested.lessons,
      };
    },
    { collections: 0, lessons: 0 },
  );
}

function catalogCourses(data: ScrapedData): QuranCourse[] {
  return [
    ...(data.appData.courses ?? []),
    ...(data.appData.otherCourseGroups ?? []).flatMap((group) => group.courses ?? []),
  ];
}

function contentAgeSeconds(data: ScrapedData, now: number): number | undefined {
  const lastUpdate = Date.parse(data.runMetadata?.lastUpdate ?? '');
  const ageMs = now - lastUpdate;
  return Number.isFinite(lastUpdate) && ageMs >= 0
    ? Math.floor(ageMs / 1_000)
    : undefined;
}

function unavailableUserMetric(
  id: string,
  name: string,
  semantic: Extract<MetricSemantic, 'total-users' | 'new-users' | 'active-users' | 'online-users'>,
  period: MetricPeriod,
): ProductMetric {
  return {
    id,
    name,
    description:
      'Unavailable: this content API does not receive durable application identity or interaction events.',
    category:
      semantic === 'new-users'
        ? 'growth'
        : semantic === 'active-users' || semantic === 'online-users'
          ? 'engagement'
          : 'users',
    semantic,
    status: 'unavailable',
    unit: 'count',
    period,
    aggregation: period === 'all-time' ? 'cumulative' : 'gauge',
  };
}

export function buildArrahmahProductStats(
  data: ScrapedData | null,
  broadcasts: BroadcastStatus,
  now = Date.now(),
): ProductStatsReport {
  const duaInventory = data ? countDuas(data.appData.duaCategories ?? []) : undefined;
  const drawerInventory = data ? countDrawerContent(data.appData.drawerItems ?? []) : undefined;
  const liveBroadcastFlags = [
    broadcasts.isYoutubeLive,
    broadcasts.isFacebookLive,
    broadcasts.isMixlrLive,
  ].filter(Boolean).length;

  const metrics: ProductMetric[] = [
    unavailableUserMetric('users-total', 'Total users', 'total-users', 'all-time'),
    unavailableUserMetric('users-new', 'New users', 'new-users', '24h'),
    unavailableUserMetric('users-active', 'Active users', 'active-users', '24h'),
    unavailableUserMetric('users-online', 'Users online', 'online-users', 'instant'),
    metric(
      {
        id: 'content-age',
        name: 'Content snapshot age',
        description: 'Seconds since the loaded scraper snapshot was produced.',
        category: 'content',
        semantic: 'custom',
        unit: 'seconds',
        period: 'instant',
        aggregation: 'gauge',
      },
      data ? contentAgeSeconds(data, now) : undefined,
    ),
    metric(
      {
        id: 'duas-published',
        name: 'Duas published',
        description: 'Dua records in the current loaded content snapshot, including nested categories.',
        category: 'content',
        semantic: 'core-action',
        unit: 'count',
        period: 'instant',
        aggregation: 'gauge',
      },
      duaInventory?.duas,
    ),
    metric(
      {
        id: 'dua-categories-published',
        name: 'Dua categories',
        description: 'Dua categories in the current loaded snapshot, including nested categories.',
        category: 'content',
        semantic: 'custom',
        unit: 'count',
        period: 'instant',
        aggregation: 'gauge',
      },
      duaInventory?.categories,
    ),
    metric(
      {
        id: 'courses-published',
        name: 'Courses published',
        description: 'Course entries across the primary catalog and grouped course collections.',
        category: 'content',
        semantic: 'core-action',
        unit: 'count',
        period: 'instant',
        aggregation: 'gauge',
      },
      data ? catalogCourses(data).length : undefined,
    ),
    metric(
      {
        id: 'lesson-records-published',
        name: 'Lesson records',
        description: 'Lesson records nested in the current navigation content collections.',
        category: 'content',
        semantic: 'core-action',
        unit: 'count',
        period: 'instant',
        aggregation: 'gauge',
      },
      drawerInventory?.lessons,
    ),
    metric(
      {
        id: 'content-collections-published',
        name: 'Content collections',
        description: 'Navigation entries with structured course content in the current snapshot.',
        category: 'content',
        semantic: 'custom',
        unit: 'count',
        period: 'instant',
        aggregation: 'gauge',
      },
      drawerInventory?.collections,
    ),
    metric(
      {
        id: 'broadcast-destinations',
        name: 'Broadcast destinations',
        description: 'Configured broadcast destinations in the current content snapshot.',
        category: 'content',
        semantic: 'custom',
        unit: 'count',
        period: 'instant',
        aggregation: 'gauge',
      },
      data ? data.appData.broadcastItems?.length ?? 0 : undefined,
    ),
    metric(
      {
        id: 'broadcast-platforms-live',
        name: 'Broadcast platforms flagged live',
        description: 'Best-effort live flags currently held by the YouTube, Facebook, and Mixlr checker.',
        category: 'engagement',
        semantic: 'custom',
        unit: 'count',
        period: 'instant',
        aggregation: 'gauge',
      },
      liveBroadcastFlags,
    ),
  ];

  return {
    schemaVersion: '1.0',
    observedAt: new Date(now).toISOString(),
    applicationId: 'arrahmah',
    metrics,
  };
}

export function validProductStatsBearer(
  authorization: string | undefined,
  configuredToken: string | undefined,
): boolean {
  const expected = configuredToken?.trim() ?? '';
  if (expected.length < 24 || !authorization?.startsWith('Bearer ')) return false;
  const supplied = authorization.slice('Bearer '.length).trim();
  const left = Buffer.from(supplied);
  const right = Buffer.from(expected);
  return left.length === right.length && timingSafeEqual(left, right);
}

export function createProductStatsHandler(source: ProductStatsSource): RequestHandler {
  return (req, res) => {
    const token = process.env.PRODUCT_STATS_TOKEN;
    if (!token || token.trim().length < 24) {
      res.status(503).json({ error: 'product_stats_unavailable' });
      return;
    }
    if (!validProductStatsBearer(req.get('authorization'), token)) {
      res.set('WWW-Authenticate', 'Bearer').status(401).json({ error: 'unauthorized' });
      return;
    }

    const report = buildArrahmahProductStats(
      source.getData(),
      source.getBroadcastStatus(),
    );
    res
      .status(200)
      .set({
        'Content-Type': 'application/vnd.sasid.product-stats+json; version=1',
        'Cache-Control': 'no-store, max-age=0',
      })
      .json(report);
  };
}
