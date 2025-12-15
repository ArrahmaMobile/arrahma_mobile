/**
 * Content type detection utilities
 */

import { ItemType, Item } from '../types/models';
import { isExternalUrl } from './url.utils';

/**
 * File extension to content type mapping
 */
const FILE_TYPE_MAP: Record<string, ItemType> = {
  // Documents
  '.pdf': ItemType.Pdf,

  // Audio
  '.mp3': ItemType.Audio,
  '.wav': ItemType.Audio,
  '.ogg': ItemType.Audio,
  '.m4a': ItemType.Audio,

  // Video
  '.mp4': ItemType.Video,
  '.avi': ItemType.Video,
  '.mov': ItemType.Video,
  '.wmv': ItemType.Video,
  '.flv': ItemType.Video,
  '.webm': ItemType.Video,

  // Images
  '.jpg': ItemType.Image,
  '.jpeg': ItemType.Image,
  '.png': ItemType.Image,
  '.gif': ItemType.Image,
  '.bmp': ItemType.Image,
  '.svg': ItemType.Image,
  '.webp': ItemType.Image,
};

/**
 * External video platforms
 */
const VIDEO_PLATFORMS = ['youtube.com', 'youtu.be', 'vimeo.com'];

/**
 * Detect content type from URL
 */
export function detectContentType(url: string): ItemType {
  const lowerUrl = url.toLowerCase();

  // Check if it's a video platform (external)
  if (VIDEO_PLATFORMS.some((platform) => lowerUrl.includes(platform))) {
    return ItemType.Video;
  }

  // Check file extension
  for (const [ext, type] of Object.entries(FILE_TYPE_MAP)) {
    if (lowerUrl.includes(ext)) {
      return type;
    }
  }

  // Default to webpage
  return ItemType.WebPage;
}

/**
 * Check if URL is a direct source (actual file, not a page linking to it)
 */
export function isDirectSource(url: string): boolean {
  const lowerUrl = url.toLowerCase();

  // PDFs, audio, video, and images are direct sources
  const directExtensions = ['.pdf', '.mp3', '.wav', '.ogg', '.m4a', '.mp4', '.avi', '.mov', '.jpg', '.jpeg', '.png', '.gif'];

  return directExtensions.some(ext => lowerUrl.includes(ext));
}

/**
 * Create an Item object from URL
 */
export function createItem(url: string, imageUrl: string | null = null): Item {
  const type = detectContentType(url);
  const isExternal = isExternalUrl(url);
  const isDirect = isDirectSource(url);

  return {
    isDirectSource: isDirect,
    isExternal,
    type,
    data: url,
    imageUrl,
  };
}

/**
 * Check if URL is a PDF
 */
export function isPdfUrl(url: string): boolean {
  return url.toLowerCase().includes('.pdf');
}

/**
 * Check if URL is an audio file
 */
export function isAudioUrl(url: string): boolean {
  return detectContentType(url) === ItemType.Audio;
}

/**
 * Check if URL is a video
 */
export function isVideoUrl(url: string): boolean {
  return detectContentType(url) === ItemType.Video;
}

/**
 * Check if URL is an image
 */
export function isImageUrl(url: string): boolean {
  return detectContentType(url) === ItemType.Image;
}
