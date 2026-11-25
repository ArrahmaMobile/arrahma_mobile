/**
 * A durable record of what the scraper actually did.
 *
 * Before this existed a scrape could fail on every cycle for a day and nothing
 * outside the container logs would know: the API kept serving the last good
 * snapshot and `/health` kept answering `"status":"ok"`. The journal is the
 * evidence `/_health` needs to say "the ingest job is broken" while the served
 * content is still fine.
 *
 * It lives on the mounted data volume, so it survives container replacement,
 * and it is written atomically because the scraper and the API read and write
 * the same directory.
 */

import * as fs from 'fs/promises';
import * as path from 'path';

export interface ScrapeJournal {
  lastRunStartedAt: string;
  lastRunFinishedAt: string | null;
  lastRunOk: boolean;
  lastRunDurationMs: number;
  lastSuccessAt: string | null;
  lastFailureAt: string | null;
  consecutiveFailures: number;
}

/**
 * `/app/data`, resolved from this module rather than from `process.cwd()`.
 * The API server and the standalone scraper are started with different working
 * directories in some paths; resolving from `__dirname` keeps both pointed at
 * the same volume.
 */
export function dataDirectory(): string {
  return path.resolve(__dirname, '../../data');
}

export function journalPath(): string {
  return path.join(dataDirectory(), 'scraper_run.json');
}

export async function readScrapeJournal(): Promise<ScrapeJournal | null> {
  try {
    const raw = await fs.readFile(journalPath(), 'utf-8');
    const parsed = JSON.parse(raw) as Partial<ScrapeJournal>;
    const startedAt = parsed?.lastRunStartedAt ?? parsed?.lastRunFinishedAt;
    if (typeof startedAt !== 'string') return null;
    return {
      lastRunStartedAt: startedAt,
      lastRunFinishedAt: parsed.lastRunFinishedAt ?? null,
      lastRunOk: parsed.lastRunOk === true,
      lastRunDurationMs: Number(parsed.lastRunDurationMs) || 0,
      lastSuccessAt: parsed.lastSuccessAt ?? null,
      lastFailureAt: parsed.lastFailureAt ?? null,
      consecutiveFailures: Number(parsed.consecutiveFailures) || 0,
    };
  } catch {
    return null;
  }
}

/**
 * Records the outcome of one run, carrying the previous `lastSuccessAt`
 * forward across failures so a broken cycle never erases the evidence of when
 * content was last genuinely refreshed.
 *
 * Never throws: bookkeeping must not be able to fail a scrape.
 */
export async function recordScrapeRun(
  outcome: { startedAt: Date; finishedAt: Date; ok: boolean },
): Promise<void> {
  try {
    const previous = await readScrapeJournal();
    const finished = outcome.finishedAt.toISOString();

    const journal: ScrapeJournal = {
      lastRunStartedAt: outcome.startedAt.toISOString(),
      lastRunFinishedAt: finished,
      lastRunOk: outcome.ok,
      lastRunDurationMs: Math.max(
        0,
        outcome.finishedAt.getTime() - outcome.startedAt.getTime(),
      ),
      lastSuccessAt: outcome.ok ? finished : (previous?.lastSuccessAt ?? null),
      lastFailureAt: outcome.ok ? (previous?.lastFailureAt ?? null) : finished,
      consecutiveFailures: outcome.ok ? 0 : (previous?.consecutiveFailures ?? 0) + 1,
    };

    await writeJournal(journal);
  } catch (error) {
    console.error(
      '[journal] Failed to record scrape run:',
      error instanceof Error ? error.message : error,
    );
  }
}

/** Record the start before scraping so a process abort still leaves evidence. */
export async function recordScrapeStart(startedAt: Date): Promise<void> {
  try {
    const previous = await readScrapeJournal();
    await writeJournal({
      lastRunFinishedAt: null,
      lastRunOk: false,
      lastRunDurationMs: 0,
      lastSuccessAt: null,
      lastFailureAt: null,
      consecutiveFailures: 0,
      ...previous,
      lastRunStartedAt: startedAt.toISOString(),
    });
  } catch (error) {
    console.error('[journal] Failed to record scrape start:', error);
  }
}

async function writeJournal(journal: ScrapeJournal): Promise<void> {
  const target = journalPath();
  const temp = `${target}.tmp`;
  await fs.mkdir(dataDirectory(), { recursive: true });
  await fs.writeFile(temp, JSON.stringify(journal, null, 2), 'utf-8');
  await fs.rename(temp, target);
}
