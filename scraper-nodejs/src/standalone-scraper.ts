/**
 * Standalone scraper process - runs independently from API server
 * This ensures scraper runs aren't interrupted by API server restarts/deployments
 */

import { ArrahmahScraper } from './index';

class StandaloneScraper {
  private scraper: ArrahmahScraper;
  private isRunning: boolean = false;

  constructor() {
    this.scraper = new ArrahmahScraper();
  }

  /**
   * Run scraper with fresh HTTP cache
   */
  async run(): Promise<void> {
    if (this.isRunning) {
      console.log('⏭️  Scraper already running, skipping this run');
      return;
    }

    this.isRunning = true;

    try {
      console.log('\n' + '='.repeat(60));
      console.log('🔄 Standalone Scraper Run Started');
      console.log(`⏰ Time: ${new Date().toLocaleString()}`);
      console.log('='.repeat(60) + '\n');

      const startTime = Date.now();

      // Create fresh scraper instance to clear HTTP cache
      this.scraper = new ArrahmahScraper();

      const appData = await this.scraper.scrape();
      await this.scraper.saveToFile(appData);

      const duration = ((Date.now() - startTime) / 1000).toFixed(2);

      console.log('\n' + '='.repeat(60));
      console.log('✅ Scraper Run Completed Successfully');
      console.log(`⏱️  Duration: ${duration}s`);
      console.log('='.repeat(60) + '\n');
    } catch (error) {
      console.error('\n' + '='.repeat(60));
      console.error('❌ Scraper Run Failed');
      console.error('Error:', error);
      console.error('='.repeat(60) + '\n');
      throw error;
    } finally {
      this.isRunning = false;
    }
  }
}

// Run if executed directly
if (require.main === module) {
  const scraper = new StandaloneScraper();
  scraper.run()
    .then(() => {
      console.log('✓ Scraper completed successfully');
      process.exit(0);
    })
    .catch((error) => {
      console.error('✗ Scraper failed:', error);
      process.exit(1);
    });
}

export { StandaloneScraper };
