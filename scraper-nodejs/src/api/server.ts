/**
 * Express API server for Arrahmah data
 * Replicates the functionality of the existing Dart API
 * Integrated with automatic scraping every 2 hours
 */

import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import crypto from 'crypto';
import * as fs from 'fs/promises';
import * as path from 'path';
import { ScrapedData } from '../types/models';
import { ScraperScheduler } from '../services/scraper-scheduler';
import { BroadcastChecker } from '../services/broadcast-checker';

interface BroadcastStatus {
  isYoutubeLive: boolean;
  isFacebookLive: boolean;
  isMixlrLive: boolean;
}

interface ServerStatus {
  status: 'Available' | 'Maintenance' | 'Unavailable';
  isDataStale: boolean;
  broadcastStatus: BroadcastStatus;
  lastScrapedOn: string;
  lastScrapeAttemptOn: string;
  lastDataHash: string | null;
  lastDataChangeOn: string | null; // When the hash actually changed
}

interface HashMetadata {
  hash: string;
  lastChanged: string;
}

class ArrahmahAPIServer {
  private app: express.Application;
  private cachedData: ScrapedData | null = null;
  private dataHash: string = '';
  private lastDataChangeTimestamp: string | null = null;
  private lastUpdateAttempt: string = new Date().toISOString();
  private readonly dataPath: string;
  private readonly hashMetadataPath: string;
  private readonly port: number;
  private scheduler: ScraperScheduler;
  private broadcastChecker: BroadcastChecker;
  private broadcastCheckInterval: NodeJS.Timeout | null = null;

  constructor(port: number = 8888) {
    this.app = express();
    this.port = port;
    this.dataPath = path.join(__dirname, '../../data/scraped_data.json');
    this.hashMetadataPath = path.join(__dirname, '../../data/hash_metadata.json');
    this.scheduler = new ScraperScheduler({
      runOnStart: false, // Don't run on start to avoid conflicts
      maxRetries: 3,
      retryDelay: 60000,
      onScraperStart: () => {
        // Update last attempt timestamp when scraper starts
        this.lastUpdateAttempt = new Date().toISOString();
      },
    });
    this.broadcastChecker = new BroadcastChecker();
    this.setupMiddleware();
    this.setupRoutes();
  }

  /**
   * Setup middleware
   */
  private setupMiddleware(): void {
    // CORS - allow all origins like the original API
    this.app.use(cors({
      origin: '*',
      exposedHeaders: ['ETag'],
    }));

    // JSON parsing
    this.app.use(express.json());

    // Request logging
    this.app.use((req: Request, _res: Response, next: NextFunction) => {
      console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
      next();
    });
  }

  /**
   * Setup routes
   */
  private setupRoutes(): void {
    const router = express.Router();

    // Status endpoint
    router.get('/status', this.getStatus.bind(this));

    // Data endpoint
    router.get('/data/:version?', this.getData.bind(this));

    // Scraper status endpoint
    router.get('/scraper-status', this.getScraperStatus.bind(this));

    // Manual scraper trigger endpoint (for admin use)
    router.post('/trigger-scrape', this.triggerScrape.bind(this));

    // Mount router at /api
    this.app.use('/api', router);

    // Health check endpoint with detailed diagnostics
    this.app.get('/health', async (_req: Request, res: Response) => {
      const health = {
        status: 'ok',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        memory: {
          used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
          total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024),
          unit: 'MB',
        },
        dataAvailable: this.cachedData !== null,
        dataHash: this.dataHash ? this.dataHash.substring(0, 12) + '...' : null,
        lastUpdate: this.cachedData?.runMetadata?.lastUpdate || null,
        scheduler: this.scheduler.getStatus(),
      };
      res.json(health);
    });

    // 404 handler
    this.app.use((_req: Request, res: Response) => {
      res.status(404).json({ error: 'Not found' });
    });
  }

  /**
   * Load hash metadata from file
   */
  private async loadHashMetadata(): Promise<HashMetadata | null> {
    try {
      const fileContent = await fs.readFile(this.hashMetadataPath, 'utf-8');
      return JSON.parse(fileContent);
    } catch (error) {
      // File doesn't exist yet, return null
      return null;
    }
  }

  /**
   * Save hash metadata to file
   */
  private async saveHashMetadata(metadata: HashMetadata): Promise<void> {
    try {
      await fs.writeFile(this.hashMetadataPath, JSON.stringify(metadata, null, 2), 'utf-8');
    } catch (error) {
      console.error('Error saving hash metadata:', error);
    }
  }

  /**
   * Load scraped data from file
   */
  private async loadData(): Promise<void> {
    try {
      // Check if file exists
      try {
        await fs.access(this.dataPath);
      } catch {
        console.warn(`Data file not found at ${this.dataPath}`);
        // File doesn't exist - this is OK on first run
        this.cachedData = null;
        this.dataHash = '';
        this.lastDataChangeTimestamp = null;
        return;
      }

      // Read file content
      const fileContent = await fs.readFile(this.dataPath, 'utf-8');

      // Validate file is not empty
      if (!fileContent || fileContent.trim().length === 0) {
        console.warn('Data file is empty');
        this.cachedData = null;
        this.dataHash = '';
        this.lastDataChangeTimestamp = null;
        return;
      }

      // Parse JSON with validation
      let parsedData: ScrapedData;
      try {
        parsedData = JSON.parse(fileContent);
      } catch (parseError) {
        console.error('Failed to parse JSON data:', parseError);
        console.warn('Data file may be corrupted or incomplete');
        // Don't throw - keep using old cached data if available
        return;
      }

      // Validate structure
      if (!parsedData || !parsedData.appData) {
        console.warn('Invalid data structure - missing appData');
        return;
      }

      // Data is valid - update cache
      this.cachedData = parsedData;

      // Calculate hash of the data
      const dataString = JSON.stringify(this.cachedData.appData);
      const newHash = crypto.createHash('md5').update(dataString).digest('hex');

      // Load previous hash metadata
      const previousMetadata = await this.loadHashMetadata();

      // Check if hash has changed
      if (!previousMetadata || previousMetadata.hash !== newHash) {
        // Hash changed - update timestamp
        const now = new Date().toISOString();
        this.lastDataChangeTimestamp = now;

        // Save new hash metadata
        await this.saveHashMetadata({
          hash: newHash,
          lastChanged: now,
        });

        console.log(`✓ Data hash changed! New hash: ${newHash.substring(0, 12)}..., Changed at: ${now}`);
      } else {
        // Hash unchanged - use existing timestamp
        this.lastDataChangeTimestamp = previousMetadata.lastChanged;
      }

      this.dataHash = newHash;
      console.log(`✓ Data loaded successfully. Hash: ${this.dataHash.substring(0, 12)}..., Last changed: ${this.lastDataChangeTimestamp}`);
    } catch (error) {
      console.error('Unexpected error loading data:', error);
      // Don't throw - allow server to continue with cached data
    }
  }

  /**
   * GET /api/status
   * Returns server status and checks if data is stale
   */
  private async getStatus(req: Request, res: Response): Promise<void> {
    try {
      const dataHashParam = req.query.dataHash as string | undefined;

      // Reload data to get latest
      await this.loadData();

      // Determine server status
      let serverStatus: 'Available' | 'Maintenance' | 'Unavailable' = 'Available';
      if (!this.cachedData) {
        serverStatus = 'Maintenance'; // No data available yet
      }

      // Get current broadcast status from broadcast checker
      const broadcastStatus: BroadcastStatus = this.broadcastChecker.getCurrentStatus();

      const statusResponse: ServerStatus = {
        status: serverStatus,
        isDataStale: dataHashParam !== undefined && this.dataHash !== dataHashParam,
        broadcastStatus,
        lastScrapedOn: this.cachedData?.runMetadata?.lastUpdate || this.lastUpdateAttempt,
        lastScrapeAttemptOn: this.lastUpdateAttempt,
        lastDataHash: this.dataHash || null,
        lastDataChangeOn: this.lastDataChangeTimestamp,
      };

      console.log(`[status] dataHash=${dataHashParam}, isStale=${statusResponse.isDataStale}, status=${serverStatus}`);
      res.json(statusResponse);
    } catch (error) {
      console.error('Error in getStatus:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  /**
   * GET /api/data/:version?
   * Returns scraped data with ETag support
   */
  private async getData(req: Request, res: Response): Promise<void> {
    try {
      // Reload data to get latest
      await this.loadData();

      // Check if data is available
      if (!this.cachedData || !this.cachedData.appData) {
        console.warn('[data] No data available yet - server in maintenance mode');
        res.status(503).json({
          error: 'Service temporarily unavailable',
          message: 'Data is being loaded. Please try again in a few moments.',
        });
        return;
      }

      // Check If-None-Match header for ETag
      const ifNoneMatch = req.headers['if-none-match'];

      if (ifNoneMatch && ifNoneMatch === this.dataHash) {
        console.log(`[data] 304 Not Modified - Hash matches: ${this.dataHash.substring(0, 12)}...`);
        res.status(304).setHeader('ETag', this.dataHash).send();
        return;
      }

      // Check API version from query parameter or header
      const versionParam = req.query['api-version'] || req.headers['accept-version'];
      const version = versionParam ? parseInt(versionParam.toString(), 10) : null;

      // Return just the appData part (unwrapped), matching the existing API structure
      const responseData = this.cachedData.appData;

      console.log(`[data] Sending data - Version: ${version || 'latest'}, Hash: ${this.dataHash.substring(0, 12)}...`);

      res.setHeader('ETag', this.dataHash);
      res.json(responseData);
    } catch (error) {
      console.error('Error in getData:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  /**
   * GET /api/scraper-status
   * Returns the current status of the scraper scheduler
   */
  private async getScraperStatus(_req: Request, res: Response): Promise<void> {
    try {
      const status = this.scheduler.getStatus();
      res.json({
        ...status,
        statusSummary: this.scheduler.getStatusSummary(),
      });
    } catch (error) {
      console.error('Error in getScraperStatus:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  /**
   * POST /api/trigger-scrape
   * Manually trigger a scraper run
   */
  private async triggerScrape(_req: Request, res: Response): Promise<void> {
    try {
      // Trigger the scraper asynchronously
      this.scheduler.triggerManualRun().catch(err => {
        console.error('Error in manual scraper run:', err);
      });

      res.json({
        message: 'Scraper run triggered successfully',
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Error in triggerScrape:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  /**
   * Start periodic broadcast status checking
   */
  private async startBroadcastChecking(): Promise<void> {
    // Initialize broadcast checker
    await this.broadcastChecker.init();

    // Perform initial check
    await this.broadcastChecker.checkLiveStatus(this.cachedData);

    // Start periodic checking every 30 seconds (like the Dart implementation)
    this.broadcastCheckInterval = setInterval(async () => {
      try {
        await this.broadcastChecker.checkLiveStatus(this.cachedData);
      } catch (error) {
        console.error('Error in broadcast status check:', error);
      }
    }, 10 * 60 * 1000); // 10 minutes

    console.log('🔴 Broadcast status checking started (every 30 seconds)');
  }

  /**
   * Start the server
   */
  public async start(): Promise<void> {
    try {
      // Load data initially (don't fail if data doesn't exist)
      await this.loadData();

      // Warn if no data is available
      if (!this.cachedData) {
        console.warn('\n⚠️  No data available on startup. Server will be in maintenance mode until first scrape completes.\n');
      }

      // Start broadcast status checking
      await this.startBroadcastChecking();

      // Start the scheduler
      await this.scheduler.start();

      this.app.listen(this.port, () => {
        console.log(`\n${'='.repeat(60)}`);
        console.log(`🚀 Arrahmah API Server Started`);
        console.log(`${'='.repeat(60)}`);
        console.log(`📊 Data endpoint: http://localhost:${this.port}/api/data`);
        console.log(`📡 Status endpoint: http://localhost:${this.port}/api/status`);
        console.log(`🔧 Scraper status: http://localhost:${this.port}/api/scraper-status`);
        console.log(`⚡ Trigger scrape: POST http://localhost:${this.port}/api/trigger-scrape`);
        console.log(`❤️  Health check: http://localhost:${this.port}/health`);
        console.log(`${'='.repeat(60)}`);
        console.log(`🕐 Automatic scraping: Every 2 hours`);
        console.log(`🔄 Auto-retry on failure: Yes (3 attempts)`);
        console.log(`${'='.repeat(60)}\n`);
      });
    } catch (error) {
      console.error('Failed to start server:', error);
      process.exit(1);
    }
  }

  /**
   * Stop the server and scheduler
   */
  public stop(): void {
    this.scheduler.stop();
    if (this.broadcastCheckInterval) {
      clearInterval(this.broadcastCheckInterval);
      this.broadcastCheckInterval = null;
    }
    console.log('🛑 Server stopped');
  }
}

// Start server if run directly
if (require.main === module) {
  const port = parseInt(process.env.PORT || '8888', 10);
  const server = new ArrahmahAPIServer(port);
  server.start();
}

export { ArrahmahAPIServer };
