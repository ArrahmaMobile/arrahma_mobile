/**
 * Standalone scraper process - runs independently from API server
 * This ensures scraper runs aren't interrupted by API server restarts/deployments
 */

import { ArrahmahScraper } from './index';
import * as http from 'http';

class StandaloneScraper {
  private scraper: ArrahmahScraper;
  private isRunning: boolean = false;
  private readonly apiPort: number;
  private readonly reloadApiKey: string;

  constructor() {
    this.scraper = new ArrahmahScraper();
    this.apiPort = parseInt(process.env.PORT || '8888', 10);
    this.reloadApiKey = process.env.RELOAD_API_KEY || '';
  }

  /**
   * Notify API server to reload data
   */
  private async notifyApiServer(): Promise<void> {
    return new Promise((resolve) => {
      const postData = JSON.stringify({});

      const options = {
        hostname: 'localhost',
        port: this.apiPort,
        path: '/api/internal/reload-data',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(postData),
          'x-api-key': this.reloadApiKey,
        },
      };

      const req = http.request(options, (res) => {
        let data = '';

        res.on('data', (chunk) => {
          data += chunk;
        });

        res.on('end', () => {
          if (res.statusCode === 200) {
            console.log('✅ API server notified successfully');
            resolve();
          } else {
            console.warn(`⚠️  API server notification returned status ${res.statusCode}: ${data}`);
            resolve(); // Don't fail the scraper run if notification fails
          }
        });
      });

      req.on('error', (error) => {
        console.error('❌ Failed to notify API server:', error.message);
        resolve(); // Don't fail the scraper run if notification fails
      });

      req.write(postData);
      req.end();
    });
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

      // Notify API server to reload data
      console.log('📡 Notifying API server to reload data...');
      await this.notifyApiServer();
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
