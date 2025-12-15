/**
 * Homepage scraper - extracts main homepage elements
 * Updated for the NEW website structure (2025)
 */

import { BaseScraper } from '../core/scraper-base';
import {
  QuickLink,
  HeadingBanner,
  BroadcastItem,
  SocialMediaItem,
  DrawerItem,
  BroadcastType,
} from '../types/models';
import { toAbsoluteUrl, normalizeUrl } from '../utils/url.utils';
import { cleanText } from '../utils/text.utils';
import { createItem } from '../utils/content-type.utils';
import { CourseContentScraper } from './course-content.scraper';

export interface HomepageData {
  logoUrl: string;
  quickLinks: QuickLink[];
  banners: HeadingBanner[];
  broadcastItems: BroadcastItem[];
  socialMediaItems: SocialMediaItem[];
  drawerItems: DrawerItem[];
}

export class HomepageScraper extends BaseScraper<HomepageData> {
  async scrape(): Promise<HomepageData> {
    const $ = await this.navigateTo('');
    if (!$) {
      throw new Error('Failed to load homepage');
    }

    console.log('Scraping homepage...');

    // Extract logo
    const logoUrl = this.extractLogo($);
    console.log(`✓ Logo extracted: ${logoUrl}`);

    // Extract quick links
    const quickLinks = this.extractQuickLinks($);
    console.log(`✓ Quick links extracted: ${quickLinks.length}`);

    // Extract banners
    const banners = this.extractBanners($);
    console.log(`✓ Banners extracted: ${banners.length}`);

    // Extract broadcast items (YouTube, Facebook, etc.)
    const broadcastItems = this.extractBroadcastItems($);
    console.log(`✓ Broadcast items extracted: ${broadcastItems.length}`);

    // Extract social media items
    const socialMediaItems = this.extractSocialMediaItems($);
    console.log(`✓ Social media items extracted: ${socialMediaItems.length}`);

    // Extract drawer/navigation items
    const drawerItems = await this.extractDrawerItems($);
    console.log(`✓ Drawer items extracted: ${drawerItems.length}`);

    // Populate content for course pages
    await this.populateDrawerContent(drawerItems);
    console.log(`✓ Drawer content populated`);

    return {
      logoUrl,
      quickLinks,
      banners,
      broadcastItems,
      socialMediaItems,
      drawerItems,
    };
  }

  /**
   * Extract logo URL
   */
  private extractLogo($: any): string {
    // Try multiple selectors for the logo
    const selectors = [
      'img[src*="logo"]',
      '.header img',
      '.headerimg img',
      'nav img',
      '.navbar-brand img',
    ];

    for (const selector of selectors) {
      const logoEl = $(selector).first();
      if (logoEl.length > 0) {
        const src = logoEl.attr('src');
        if (src) {
          return normalizeUrl(toAbsoluteUrl(src, this.baseUrl), this.baseUrl);
        }
      }
    }

    console.warn('Logo not found, using default');
    return '';
  }

  /**
   * Extract quick links from homepage announcement ticker
   */
  private extractQuickLinks($: any): QuickLink[] {
    const quickLinks: QuickLink[] = [];
    const seen = new Set<string>();

    // Extract from announcement ticker
    $('.announcement-ticker .ticker-item').each((_: any, el: any) => {
      const $el = $(el);
      // Get the first <a> tag in the ticker item
      const $link = $el.find('a').first();

      if ($link.length > 0) {
        const href = $link.attr('href');
        let title = cleanText($link.text());

        // Remove icon text from title
        title = title.replace(/\s*\uF4C1\s*$/g, '').trim(); // Remove Bootstrap icon

        if (href && title) {
          const absoluteUrl = toAbsoluteUrl(href, this.baseUrl);
          const normalizedUrl = normalizeUrl(absoluteUrl, this.baseUrl);

          // Use normalized URL for deduplication
          if (!seen.has(normalizedUrl)) {
            seen.add(normalizedUrl);
            quickLinks.push({
              title,
              link: createItem(absoluteUrl),
            });
          }
        }
      }
    });

    return quickLinks;
  }

  /**
   * Extract banners/carousel items from carousel-inner
   */
  private extractBanners($: any): HeadingBanner[] {
    const banners: HeadingBanner[] = [];

    // Find carousel items - they're wrapped in <a> tags
    $('.carousel-inner > a').each((_: any, el: any) => {
      const $link = $(el);
      const href = $link.attr('href');

      // Find the carousel-item div inside the link
      const $carouselItem = $link.find('.carousel-item').first();

      if ($carouselItem.length > 0) {
        // Get image URL
        const $img = $carouselItem.find('img');
        const imageUrl = $img.attr('src');

        // Get caption text
        const $caption = $carouselItem.find('.carousel-caption');
        const heading = cleanText($caption.find('.caption-heading').text());
        const title = cleanText($caption.find('.caption-title').text());

        if (imageUrl && href) {
          const absoluteImageUrl = toAbsoluteUrl(imageUrl, this.baseUrl);
          const absoluteLink = toAbsoluteUrl(href, this.baseUrl);

          banners.push({
            imageUrl: normalizeUrl(absoluteImageUrl, this.baseUrl),
            item: createItem(absoluteLink),
            heading: heading || undefined,
            title: title || undefined,
          });
        }
      }
    });

    return banners;
  }

  /**
   * Extract broadcast items (YouTube, Facebook, Mixlr, etc.)
   */
  private extractBroadcastItems($: any): BroadcastItem[] {
    const broadcastItems: BroadcastItem[] = [];

    // Known broadcast platforms
    const platforms = [
      { domain: 'youtube.com', type: BroadcastType.YouTube },
      { domain: 'youtu.be', type: BroadcastType.YouTube },
      { domain: 'facebook.com', type: BroadcastType.Facebook },
      { domain: 'mixlr.com', type: BroadcastType.Mixlr },
    ];

    // Try old selector first
    $('.column6 .box4').each((_: any, el: any) => {
      const $el = $(el);
      const link = $el.find('a').attr('href');
      const imageUrl = $el.find('img').attr('src');

      if (link && imageUrl) {
        const platform = platforms.find((p) => link.includes(p.domain));
        if (platform) {
          broadcastItems.push({
            type: platform.type,
            item: createItem(toAbsoluteUrl(link, this.baseUrl)),
            imageUrl: normalizeUrl(toAbsoluteUrl(imageUrl, this.baseUrl), this.baseUrl),
          });
        }
      }
    });

    // If not found, try to find broadcast links in general
    if (broadcastItems.length === 0) {
      $('a[href*="youtube"], a[href*="facebook"], a[href*="mixlr"]').each((_: any, el: any) => {
        const $el = $(el);
        const link = $el.attr('href');

        if (link) {
          const platform = platforms.find((p) => link.includes(p.domain));
          if (platform) {
            const imageUrl = $el.find('img').attr('src') || $el.closest('div').find('img').attr('src');

            broadcastItems.push({
              type: platform.type,
              item: createItem(toAbsoluteUrl(link, this.baseUrl)),
              imageUrl: imageUrl
                ? normalizeUrl(toAbsoluteUrl(imageUrl, this.baseUrl), this.baseUrl)
                : '',
            });
          }
        }
      });
    }

    return broadcastItems;
  }

  /**
   * Extract social media items
   */
  private extractSocialMediaItems($: any): SocialMediaItem[] {
    const socialMediaItems: SocialMediaItem[] = [];

    // Social media platforms
    const platforms = ['facebook', 'twitter', 'x.com', 'instagram', 'tiktok', 'whatsapp'];

    // Try old selector first
    $('.column3footer a').each((_: any, el: any) => {
      const $el = $(el);
      const link = $el.attr('href');
      const imageUrl = $el.find('img').attr('src');

      if (link && imageUrl && platforms.some((p) => link.includes(p))) {
        let finalLink = link;

        // Special handling for WhatsApp
        if (imageUrl.includes('whatsapp')) {
          const whatsAppMessage = encodeURIComponent(
            'Assalamualaikum, I want to join the Arrahmah WhatsApp group. My name is {name} and my number is {number}.'
          );
          finalLink = `https://wa.me/17323050744?text=${whatsAppMessage}`;
        }

        socialMediaItems.push({
          item: createItem(toAbsoluteUrl(finalLink, this.baseUrl)),
          imageUrl: normalizeUrl(toAbsoluteUrl(imageUrl, this.baseUrl), this.baseUrl),
        });
      }
    });

    // If not found, try general social media links
    if (socialMediaItems.length === 0) {
      platforms.forEach((platform) => {
        $(`a[href*="${platform}"]`).each((_: any, el: any) => {
          const $el = $(el);
          const link = $el.attr('href');

          if (link) {
            const imageUrl = $el.find('img').attr('src') || '';

            socialMediaItems.push({
              item: createItem(toAbsoluteUrl(link, this.baseUrl)),
              imageUrl: imageUrl
                ? normalizeUrl(toAbsoluteUrl(imageUrl, this.baseUrl), this.baseUrl)
                : '',
            });
          }
        });
      });

      // Remove duplicates
      const seen = new Set<string>();
      return socialMediaItems.filter((item) => {
        if (seen.has(item.item.data)) return false;
        seen.add(item.item.data);
        return true;
      });
    }

    return socialMediaItems;
  }

  /**
   * Extract navigation drawer items
   */
  private async extractDrawerItems($: any): Promise<DrawerItem[]> {
    const drawerItems: DrawerItem[] = [];

    // Try different navigation selectors (prioritize new structure)
    const navSelectors = [
      '#navmenu > ul > li',           // New Bootstrap structure
      'nav.navmenu > ul > li',        // Alternative new structure
      '#container_nav ul#nav > li',   // Old structure
      '.navbar-nav > li',
      'nav ul > li',
      '.main-nav > li',
    ];

    let navItems: any | null = null;
    for (const selector of navSelectors) {
      const items = $(selector);
      if (items.length > 0) {
        navItems = items;
        console.log(`Found navigation items using selector: ${selector}`);
        break;
      }
    }

    if (!navItems || navItems.length === 0) {
      console.warn('No navigation items found');
      return drawerItems;
    }

    // Extract top-level navigation items
    navItems.each((_: any, el: any) => {
      const $el = $(el);
      const item = this.extractDrawerItem($, $el);
      if (item) {
        drawerItems.push(item);
      }
    });

    return drawerItems;
  }

  /**
   * Extract a single drawer item (with children)
   */
  private extractDrawerItem($: any, $el: any): DrawerItem | null {
    // Get the main link
    const $link = $el.find('> a').first();
    if ($link.length === 0) return null;

    const href = $link.attr('href');
    // Clean title - remove dropdown icons and extra whitespace
    let title = cleanText($link.text());
    // Remove Unicode/HTML entities for dropdown icons
    title = title.replace(/[\u25BE\u25B4\u25B6\u25C0▾▴▶◀►]/g, '').trim();

    if (!title) return null;

    // Create link item (required field)
    const absoluteUrl = href ? toAbsoluteUrl(href, this.baseUrl) : this.baseUrl + '#';
    const link = createItem(absoluteUrl);

    const item: DrawerItem = {
      title,
      link,
      media: null, // Will be populated by media scraper later
      content: null, // Will be populated by content scraper later
    };

    // Check for child items (submenu) - handle both old (.sub) and new (ul direct) structures
    const $submenu = $el.find('> ul').first();
    if ($submenu.length > 0) {
      const children: DrawerItem[] = [];

      $submenu.find('> li').each((_: any, childEl: any) => {
        const $childEl = $(childEl);
        const childItem = this.extractDrawerItem($, $childEl);
        if (childItem) {
          children.push(childItem);
        }
      });

      if (children.length > 0) {
        item.children = children;
      }
    }

    return item;
  }

  /**
   * Populate content for drawer items that link to course pages
   */
  private async populateDrawerContent(items: DrawerItem[]): Promise<void> {
    for (const item of items) {
      // Check if this is a course page (contains juz in the URL)
      const url = item.link.data;

      // Match patterns like:
      // /quran2019_n/juz30.php, /tafseer2025/juz1.php, /tafseer2019/juz1.php
      // /pashtu2025/juz1.php, /quran_english/juz5.php, etc.
      const juzMatch = url.match(/\/([\w-]+)\/(juz\d+|surah\d+)\.php/i);

      if (juzMatch && !item.link.isExternal) {
        try {
          // Always scrape from juz1.php for the course (or the actual URL if it's already juz1)
          const contentUrl = url.replace(/\/(juz|surah)\d+\.php/i, '/juz1.php');

          console.log(`  Scraping content: ${item.title} from ${contentUrl}`);
          const scraper = new CourseContentScraper(this.httpClient, contentUrl);
          const content = await scraper.scrape();
          if (content && content.surahs.length > 0) {
            item.content = content;
          } else {
            console.warn(`  No content found for ${item.title}`);
          }
        } catch (error) {
          console.error(`  Failed to scrape content for ${item.title}:`, error);
        }
      }

      // Recursively populate children
      if (item.children && item.children.length > 0) {
        await this.populateDrawerContent(item.children);
      }
    }
  }
}
