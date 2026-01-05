/**
 * Scraper scheduler service
 * Automatically runs the scraper every 2 hours and keeps data fresh
 */

import * as cron from 'node-cron';
import { ArrahmahScraper } from '../index';

export interface SchedulerConfig {
  /** Cron expression for schedule (default: every 2 hours) */
  cronExpression?: string;
  /** Run scraper immediately on start */
  runOnStart?: boolean;
  /** Maximum retry attempts on failure */
  maxRetries?: number;
  /** Delay between retries in ms */
  retryDelay?: number;
  /** Callback fired when scraper starts */
  onScraperStart?: () => void;
  /** Callback fired when scraper completes successfully */
  onScraperSuccess?: () => void;
  /** Callback fired when scraper fails */
  onScraperFailure?: (error: Error) => void;
}

export interface ScraperStatus {
  isRunning: boolean;
  lastRunTime: Date | null;
  lastSuccessTime: Date | null;
  lastError: Error | null;
  successCount: number;
  failureCount: number;
  nextScheduledRun: Date | null;
}

export class ScraperScheduler {
  private scraper: ArrahmahScraper;
  private task: cron.ScheduledTask | null = null;
  private status: ScraperStatus = {
    isRunning: false,
    lastRunTime: null,
    lastSuccessTime: null,
    lastError: null,
    successCount: 0,
    failureCount: 0,
    nextScheduledRun: null,
  };

  private readonly cronExpression: string;
  private readonly runOnStart: boolean;
  private readonly maxRetries: number;
  private readonly retryDelay: number;
  private readonly onScraperStart?: () => void;
  private readonly onScraperSuccess?: () => void;
  private readonly onScraperFailure?: (error: Error) => void;

  constructor(scraperConfig: SchedulerConfig = {}) {
    this.scraper = new ArrahmahScraper();
    this.cronExpression = scraperConfig.cronExpression || '0 */2 * * *'; // Every 2 hours
    this.runOnStart = scraperConfig.runOnStart ?? true;
    this.maxRetries = scraperConfig.maxRetries ?? 3;
    this.retryDelay = scraperConfig.retryDelay ?? 60000; // 1 minute
    this.onScraperStart = scraperConfig.onScraperStart;
    this.onScraperSuccess = scraperConfig.onScraperSuccess;
    this.onScraperFailure = scraperConfig.onScraperFailure;
  }

  /**
   * Start the scheduler
   */
  async start(): Promise<void> {
    console.log('🕐 Starting scraper scheduler...');
    console.log(`📅 Schedule: ${this.cronExpression} (every 2 hours)`);
    console.log(`🚀 Run on start: ${this.runOnStart}`);
    console.log(`🔄 Max retries: ${this.maxRetries}\n`);

    // Run immediately if configured
    if (this.runOnStart) {
      await this.runScraper();
    }

    // Schedule recurring task
    this.task = cron.schedule(this.cronExpression, async () => {
      await this.runScraper();
    });

    this.updateNextScheduledRun();
    console.log(`⏰ Next scheduled run: ${this.status.nextScheduledRun?.toLocaleString()}\n`);
  }

  /**
   * Stop the scheduler
   */
  stop(): void {
    if (this.task) {
      this.task.stop();
      this.task = null;
      console.log('🛑 Scraper scheduler stopped');
    }
  }

  /**
   * Run the scraper with retry logic
   */
  private async runScraper(): Promise<void> {
    if (this.status.isRunning) {
      console.log('⏭️  Scraper already running, skipping this scheduled run');
      return;
    }

    this.status.isRunning = true;
    this.status.lastRunTime = new Date();
    this.updateNextScheduledRun();

    // Fire onScraperStart callback
    if (this.onScraperStart) {
      this.onScraperStart();
    }

    let attempt = 0;
    let success = false;

    while (attempt < this.maxRetries && !success) {
      attempt++;

      try {
        console.log(`\n${'='.repeat(60)}`);
        console.log(`🔄 Scraper run started (Attempt ${attempt}/${this.maxRetries})`);
        console.log(`⏰ Time: ${new Date().toLocaleString()}`);
        console.log(`${'='.repeat(60)}\n`);

        const startTime = Date.now();
        const appData = await this.scraper.scrape();
        await this.scraper.saveToFile(appData);
        const duration = ((Date.now() - startTime) / 1000).toFixed(2);

        this.status.lastSuccessTime = new Date();
        this.status.lastError = null;
        this.status.successCount++;
        success = true;

        // Fire onScraperSuccess callback
        if (this.onScraperSuccess) {
          this.onScraperSuccess();
        }

        console.log(`\n${'='.repeat(60)}`);
        console.log(`✅ Scraper run completed successfully`);
        console.log(`⏱️  Duration: ${duration}s`);
        console.log(`📊 Total successful runs: ${this.status.successCount}`);
        console.log(`⏰ Next run: ${this.status.nextScheduledRun?.toLocaleString()}`);
        console.log(`${'='.repeat(60)}\n`);

      } catch (error) {
        const err = error as Error;
        this.status.lastError = err;
        this.status.failureCount++;

        // Fire onScraperFailure callback
        if (this.onScraperFailure) {
          this.onScraperFailure(err);
        }

        console.error(`\n${'='.repeat(60)}`);
        console.error(`❌ Scraper run failed (Attempt ${attempt}/${this.maxRetries})`);
        console.error(`📛 Error: ${err.message}`);
        console.error(`${'='.repeat(60)}\n`);

        if (attempt < this.maxRetries) {
          console.log(`⏳ Retrying in ${this.retryDelay / 1000} seconds...\n`);
          await this.delay(this.retryDelay);
        } else {
          console.error(`💥 All retry attempts exhausted. Will try again at next scheduled time.`);
          console.error(`⏰ Next scheduled run: ${this.status.nextScheduledRun?.toLocaleString()}\n`);
        }
      }
    }

    this.status.isRunning = false;
  }

  /**
   * Manually trigger a scraper run
   */
  async triggerManualRun(): Promise<void> {
    console.log('🎯 Manual scraper run triggered\n');
    await this.runScraper();
  }

  /**
   * Get current scheduler status
   */
  getStatus(): ScraperStatus {
    return { ...this.status };
  }

  /**
   * Update the next scheduled run time
   */
  private updateNextScheduledRun(): void {
    // Calculate next run based on cron expression
    // For "0 */2 * * *" (every 2 hours), calculate the next occurrence
    const now = new Date();
    const nextRun = new Date(now);

    // Round up to the next 2-hour mark
    const hours = now.getHours();
    const nextHour = Math.ceil((hours + 1) / 2) * 2;

    if (nextHour >= 24) {
      nextRun.setDate(nextRun.getDate() + 1);
      nextRun.setHours(0, 0, 0, 0);
    } else {
      nextRun.setHours(nextHour, 0, 0, 0);
    }

    this.status.nextScheduledRun = nextRun;
  }

  /**
   * Delay helper
   */
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  /**
   * Get human-readable status summary
   */
  getStatusSummary(): string {
    const status = this.getStatus();
    return `
Scraper Scheduler Status
${'='.repeat(60)}
Running: ${status.isRunning ? 'Yes ⚙️' : 'No 💤'}
Last Run: ${status.lastRunTime?.toLocaleString() || 'Never'}
Last Success: ${status.lastSuccessTime?.toLocaleString() || 'Never'}
Next Scheduled: ${status.nextScheduledRun?.toLocaleString() || 'Not scheduled'}
Success Count: ${status.successCount} ✅
Failure Count: ${status.failureCount} ❌
Last Error: ${status.lastError?.message || 'None'}
${'='.repeat(60)}
    `.trim();
  }
}
