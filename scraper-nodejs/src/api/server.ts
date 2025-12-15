/**
 * Express API server for Arrahmah data
 * Replicates the functionality of the existing Dart API
 */

import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import crypto from 'crypto';
import * as fs from 'fs/promises';
import * as path from 'path';
import { ScrapedData } from '../types/models';

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
}

class ArrahmahAPIServer {
  private app: express.Application;
  private cachedData: ScrapedData | null = null;
  private dataHash: string = '';
  private lastUpdateAttempt: string = new Date().toISOString();
  private readonly dataPath: string;
  private readonly port: number;

  constructor(port: number = 8888) {
    this.app = express();
    this.port = port;
    this.dataPath = path.join(__dirname, '../../data/scraped_data.json');
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

    // Mount router at /api
    this.app.use('/api', router);

    // Health check endpoint
    this.app.get('/health', (_req: Request, res: Response) => {
      res.json({ status: 'ok' });
    });

    // 404 handler
    this.app.use((_req: Request, res: Response) => {
      res.status(404).json({ error: 'Not found' });
    });
  }

  /**
   * Load scraped data from file
   */
  private async loadData(): Promise<void> {
    try {
      const fileContent = await fs.readFile(this.dataPath, 'utf-8');
      this.cachedData = JSON.parse(fileContent);

      // Calculate hash of the data
      const dataString = JSON.stringify(this.cachedData?.data);
      this.dataHash = crypto.createHash('md5').update(dataString).digest('hex');

      console.log(`Data loaded successfully. Hash: ${this.dataHash}`);
    } catch (error) {
      console.error('Error loading data:', error);
      throw error;
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

      // For now, broadcast status is always false
      // In the future, this could check actual broadcast platforms
      const broadcastStatus: BroadcastStatus = {
        isYoutubeLive: false,
        isFacebookLive: false,
        isMixlrLive: false,
      };

      const statusResponse: ServerStatus = {
        status: 'Available',
        isDataStale: dataHashParam !== undefined && this.dataHash !== dataHashParam,
        broadcastStatus,
        lastScrapedOn: this.cachedData?.metadata.timestamp || new Date().toISOString(),
        lastScrapeAttemptOn: this.lastUpdateAttempt,
        lastDataHash: this.dataHash,
      };

      console.log(`[status] dataHash=${dataHashParam}, isStale=${statusResponse.isDataStale}`);
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

      // Check If-None-Match header for ETag
      const ifNoneMatch = req.headers['if-none-match'];

      if (ifNoneMatch && ifNoneMatch === this.dataHash) {
        console.log(`[data] 304 Not Modified - Hash matches: ${this.dataHash}`);
        res.status(304).setHeader('ETag', this.dataHash).send();
        return;
      }

      // Check API version from query parameter or header
      const versionParam = req.query['api-version'] || req.headers['accept-version'];
      const version = versionParam ? parseInt(versionParam.toString(), 10) : null;

      // For now, we only support the new format (no v1 legacy support needed)
      // If version 1 is requested, we could transform the data, but for now just return the new format
      const responseData = this.cachedData;

      console.log(`[data] Sending data - Version: ${version || 'latest'}, Hash: ${this.dataHash}`);

      res.setHeader('ETag', this.dataHash);
      res.json(responseData);
    } catch (error) {
      console.error('Error in getData:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  /**
   * Start the server
   */
  public async start(): Promise<void> {
    try {
      // Load data initially
      await this.loadData();

      this.app.listen(this.port, () => {
        console.log(`🚀 Arrahmah API server running on port ${this.port}`);
        console.log(`📊 Data endpoint: http://localhost:${this.port}/api/data`);
        console.log(`📡 Status endpoint: http://localhost:${this.port}/api/status`);
      });
    } catch (error) {
      console.error('Failed to start server:', error);
      process.exit(1);
    }
  }
}

// Start server if run directly
if (require.main === module) {
  const port = parseInt(process.env.PORT || '8888', 10);
  const server = new ArrahmahAPIServer(port);
  server.start();
}

export { ArrahmahAPIServer };
