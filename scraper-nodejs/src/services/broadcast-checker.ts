/**
 * Broadcast Status Checker
 * Checks live status for YouTube, Facebook, and Mixlr broadcasts
 * Based on the original Dart BroadcastService implementation
 */

import * as fs from 'fs/promises';
import * as path from 'path';
import axios from 'axios';
import { ScrapedData, BroadcastItem, BroadcastType } from '../types/models';

interface BroadcastStatus {
  isYoutubeLive: boolean;
  isFacebookLive: boolean;
  isMixlrLive: boolean;
}

interface BroadcastChannels {
  youtubeChannelId: string | null;
  facebookChannelId: string | null;
  mixlrChannelId: string | null;
}

interface LastVideoIds {
  youtube: string | null;
  facebook: string | null;
  mixlr: string | null;
}

/**
 * What `/_health` needs to tell "no broadcast is live" apart from "the checker
 * stopped working". Without this the two look identical from outside, which is
 * how an optional integration rots unnoticed.
 */
export interface BroadcastDiagnostics {
  /** Broadcast destinations published in the current snapshot. Zero means nothing to check. */
  destinations: number;
  platformsLive: number;
  lastCheckAt: string | null;
  lastSuccessAt: string | null;
  lastFailureAt: string | null;
  /** Unexpected failures on the most recent cycle. Facebook's routine blocking is excluded. */
  lastCheckErrors: number;
}

export class BroadcastChecker {
  private readonly lastVideoIdsPath: string;
  private lastVideoIds: LastVideoIds = {
    youtube: null,
    facebook: null,
    mixlr: null,
  };
  private currentStatus: BroadcastStatus = {
    isYoutubeLive: false,
    isFacebookLive: false,
    isMixlrLive: false,
  };
  private destinations = 0;
  private lastCheckAt: string | null = null;
  private lastSuccessAt: string | null = null;
  private lastFailureAt: string | null = null;
  private lastCheckErrors = 0;
  private cycleErrors = 0;

  constructor() {
    this.lastVideoIdsPath = path.join(__dirname, '../../data/lastVideoIds.json');
  }

  /**
   * Counts a check that failed for a reason worth reporting. Facebook answering
   * 400 to an unauthenticated scrape is its normal behaviour, not a regression,
   * and counting it would make this component permanently degraded — a state
   * everyone learns to ignore.
   */
  private noteCheckFailure(): void {
    this.cycleErrors += 1;
  }

  /**
   * Initialize the broadcast checker
   */
  async init(): Promise<void> {
    try {
      // Load last video IDs from file
      const fileContent = await fs.readFile(this.lastVideoIdsPath, 'utf-8');
      this.lastVideoIds = JSON.parse(fileContent);
      console.log('✓ Loaded last video IDs from file');
    } catch (error) {
      // File doesn't exist or is invalid - use defaults
      console.log('ℹ No previous video IDs found, starting fresh');
      await this.saveLastVideoIds();
    }
  }

  /**
   * Save last video IDs to file
   */
  private async saveLastVideoIds(): Promise<void> {
    try {
      await fs.writeFile(
        this.lastVideoIdsPath,
        JSON.stringify(this.lastVideoIds, null, 2),
        'utf-8'
      );
    } catch (error) {
      console.error('Error saving last video IDs:', error);
    }
  }

  /**
   * Extract channel IDs from broadcast items
   */
  private extractChannelIds(broadcastItems: BroadcastItem[]): BroadcastChannels {
    const channels: BroadcastChannels = {
      youtubeChannelId: null,
      facebookChannelId: null,
      mixlrChannelId: null,
    };

    for (const item of broadcastItems) {
      const url = item.item.data;

      if (item.type === BroadcastType.YouTube) {
        // Extract YouTube channel ID from URL
        // Formats: youtube.com/channel/CHANNEL_ID or youtube.com/c/USERNAME or youtube.com/@username
        const channelMatch = url.match(/youtube\.com\/channel\/([^/?]+)/);
        const cMatch = url.match(/youtube\.com\/c\/([^/?]+)/);
        const atMatch = url.match(/youtube\.com\/@([^/?]+)/);

        if (channelMatch) {
          channels.youtubeChannelId = channelMatch[1];
        } else if (cMatch) {
          // Use /c/ format directly
          channels.youtubeChannelId = 'c/' + cMatch[1];
        } else if (atMatch) {
          channels.youtubeChannelId = '@' + atMatch[1];
        }
      } else if (item.type === BroadcastType.Facebook) {
        // Extract Facebook page ID/username from URL
        // Formats: facebook.com/PAGE_NAME or facebook.com/pages/PAGE_NAME/PAGE_ID
        const pageMatch = url.match(/facebook\.com\/([^/?]+)/);
        if (pageMatch) {
          channels.facebookChannelId = pageMatch[1];
        }
      } else if (item.type === BroadcastType.Mixlr) {
        // Extract Mixlr username from URL
        // Formats: mixlr.com/USERNAME or USERNAME.mixlr.com
        const mixlrMatch = url.match(/mixlr\.com\/([^/?]+)/);
        const subdomainMatch = url.match(/([^/]+)\.mixlr\.com/);

        if (mixlrMatch) {
          channels.mixlrChannelId = mixlrMatch[1];
        } else if (subdomainMatch) {
          // Use subdomain as username (only use the first one found)
          if (!channels.mixlrChannelId) {
            channels.mixlrChannelId = subdomainMatch[1];
          }
        }
      }
    }

    return channels;
  }

  /**
   * Check YouTube live status from HTML
   * Uses the same approach as the Dart implementation
   */
  private async checkYoutubeLive(channelId: string | null): Promise<string | null> {
    if (!channelId) return null;

    try {
      // Build URL based on channel ID format
      let url: string;
      if (channelId.startsWith('c/')) {
        url = `https://www.youtube.com/${channelId}`;
      } else if (channelId.startsWith('@')) {
        url = `https://www.youtube.com/${channelId}`;
      } else {
        url = `https://www.youtube.com/channel/${channelId}`;
      }

      const response = await axios.get(url, {
        timeout: 10000,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      });

      if (!response.data) return null;

      // Look for live thumbnail pattern in HTML
      // YouTube uses hqdefault_live.jpg for live streams
      const liveMatch = response.data.match(
        /https:\/\/i\.ytimg\.com\/vi\/([A-Za-z0-9\-_]+)\/hqdefault_live\.jpg/
      );

      return liveMatch ? liveMatch[1] : null;
    } catch (error) {
      console.error('Error checking YouTube live status:', error instanceof Error ? error.message : error);
      this.noteCheckFailure();
      return null;
    }
  }

  /**
   * Check Facebook live status from HTML
   * Note: Facebook often blocks automated requests (400/403 errors)
   * Consider using Facebook Graph API with authentication for production
   */
  private async checkFacebookLive(pageId: string | null): Promise<string | null> {
    if (!pageId) return null;

    try {
      const url = `https://www.facebook.com/${pageId}/live_videos`;
      const response = await axios.get(url, {
        timeout: 10000,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept-Encoding': 'gzip, deflate, br',
          'DNT': '1',
          'Connection': 'keep-alive',
          'Upgrade-Insecure-Requests': '1',
        },
      });

      if (!response.data) return null;

      // Look for video ID in the page HTML
      const videoMatch = response.data.match(/"videoID":"(\d+)"/);
      return videoMatch ? videoMatch[1] : null;
    } catch (error) {
      // Facebook often blocks automated requests - this is expected
      // Only log on first occurrence or different errors
      const status = axios.isAxiosError(error) ? error.response?.status : undefined;
      if (status === 400 || status === 403 || status === 404) {
        // Expected Facebook blocking of unauthenticated requests. Not a failure.
        return null;
      }
      console.error('Error checking Facebook live status:', error instanceof Error ? error.message : error);
      this.noteCheckFailure();
      return null;
    }
  }

  /**
   * Check Mixlr live status from API
   * Uses the same approach as the Dart implementation
   */
  private async checkMixlrLive(username: string | null): Promise<string | null> {
    if (!username) return null;

    try {
      const url = `https://api.mixlr.com/users/${username}?source=embed`;
      const response = await axios.get(url, {
        timeout: 10000,
      });

      if (!response.data) return null;

      const data = response.data;
      const isLive = data.is_live === true;
      const broadcastIds = data.broadcast_ids || [];

      return isLive && broadcastIds.length > 0 ? broadcastIds[0] : null;
    } catch (error) {
      console.error('Error checking Mixlr live status:', error instanceof Error ? error.message : error);
      this.noteCheckFailure();
      return null;
    }
  }

  /**
   * Check live status for all platforms
   */
  async checkLiveStatus(scrapedData: ScrapedData | null): Promise<BroadcastStatus> {
    if (!scrapedData || !scrapedData.appData) {
      console.warn('No scraped data available for broadcast check');
      return this.currentStatus;
    }

    this.cycleErrors = 0;

    // Extract channel IDs from broadcast items
    const channels = this.extractChannelIds(scrapedData.appData.broadcastItems);
    this.destinations = [
      channels.youtubeChannelId,
      channels.facebookChannelId,
      channels.mixlrChannelId,
    ].filter(Boolean).length;

    console.log('🔴 Checking live broadcast status...');
    if (channels.youtubeChannelId) {
      console.log(`  YouTube channel: ${channels.youtubeChannelId}`);
    }
    if (channels.facebookChannelId) {
      console.log(`  Facebook page: ${channels.facebookChannelId}`);
    }
    if (channels.mixlrChannelId) {
      console.log(`  Mixlr user: ${channels.mixlrChannelId}`);
    }

    // Check all platforms in parallel
    const [youtubeVideoId, facebookVideoId, mixlrVideoId] = await Promise.all([
      this.checkYoutubeLive(channels.youtubeChannelId),
      this.checkFacebookLive(channels.facebookChannelId),
      this.checkMixlrLive(channels.mixlrChannelId),
    ]);

    // Determine if status changed
    const hasChanged =
      this.lastVideoIds.youtube !== youtubeVideoId ||
      this.lastVideoIds.facebook !== facebookVideoId ||
      this.lastVideoIds.mixlr !== mixlrVideoId;

    if (hasChanged) {
      // Update last video IDs
      this.lastVideoIds = {
        youtube: youtubeVideoId,
        facebook: facebookVideoId,
        mixlr: mixlrVideoId,
      };
      await this.saveLastVideoIds();

      // Update current status
      this.currentStatus = {
        isYoutubeLive: youtubeVideoId !== null,
        isFacebookLive: facebookVideoId !== null,
        isMixlrLive: mixlrVideoId !== null,
      };

      console.log('✓ Broadcast status updated:');
      console.log(`  YouTube: ${this.currentStatus.isYoutubeLive ? '🔴 LIVE' : '⚫ Offline'}`);
      console.log(`  Facebook: ${this.currentStatus.isFacebookLive ? '🔴 LIVE' : '⚫ Offline'}`);
      console.log(`  Mixlr: ${this.currentStatus.isMixlrLive ? '🔴 LIVE' : '⚫ Offline'}`);
    } else {
      console.log('ℹ Broadcast status unchanged');
    }

    const completedAt = new Date().toISOString();
    this.lastCheckAt = completedAt;
    this.lastCheckErrors = this.cycleErrors;
    if (this.cycleErrors === 0) {
      this.lastSuccessAt = completedAt;
    } else {
      this.lastFailureAt = completedAt;
    }

    return this.currentStatus;
  }

  /**
   * Get current broadcast status without checking
   */
  getCurrentStatus(): BroadcastStatus {
    return this.currentStatus;
  }

  /** Evidence for `/_health`; performs no network I/O. */
  getDiagnostics(): BroadcastDiagnostics {
    return {
      destinations: this.destinations,
      platformsLive: [
        this.currentStatus.isYoutubeLive,
        this.currentStatus.isFacebookLive,
        this.currentStatus.isMixlrLive,
      ].filter(Boolean).length,
      lastCheckAt: this.lastCheckAt,
      lastSuccessAt: this.lastSuccessAt,
      lastFailureAt: this.lastFailureAt,
      lastCheckErrors: this.lastCheckErrors,
    };
  }
}
