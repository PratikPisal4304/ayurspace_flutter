import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Helper to wrap image URLs with a CORS proxy for web platform.
/// Wikipedia Commons images don't have CORS headers for localhost origins.
class CorsImageHelper {
  /// CORS proxy service - using images.weserv.nl which is a free, reliable image proxy
  static const String _corsProxy = 'https://images.weserv.nl/?url=';

  /// Converts Wikipedia Special:FilePath URLs to direct upload.wikimedia.org URLs.
  /// The Special:FilePath URLs redirect to the actual image, but some proxies
  /// can't follow these redirects properly (resulting in 404 errors).
  static String _convertWikipediaUrl(String url) {
    // Check if this is a Wikipedia Special:FilePath URL
    const specialFilePathPattern = 'commons.wikimedia.org/wiki/Special:FilePath/';
    
    if (url.contains(specialFilePathPattern)) {
      // Extract the filename
      final startIndex = url.indexOf(specialFilePathPattern) + specialFilePathPattern.length;
      final filename = url.substring(startIndex);
      
      // Decode the filename if it's URL encoded, then normalize spaces to underscores
      final decodedFilename = Uri.decodeComponent(filename).replaceAll(' ', '_');
      
      // Calculate the MD5 hash for the Wikimedia upload path
      // Wikimedia uses the first two characters of the MD5 hash for directory structure
      final hashDigest = md5.convert(utf8.encode(decodedFilename));
      final hashHex = hashDigest.toString();
      final hashPrefix1 = hashHex.substring(0, 1);
      final hashPrefix2 = hashHex.substring(0, 2);
      
      // Construct the direct URL with URL-encoded filename
      final encodedFilename = Uri.encodeComponent(decodedFilename);
      return 'https://upload.wikimedia.org/wikipedia/commons/$hashPrefix1/$hashPrefix2/$encodedFilename';
    }
    
    return url;
  }

  /// Wraps the given image URL with a CORS proxy if running on web.
  /// On other platforms, returns the original URL.
  static String getImageUrl(String originalUrl) {
    if (kIsWeb && originalUrl.isNotEmpty) {
      // First convert Wikipedia Special:FilePath URLs to direct URLs
      final directUrl = _convertWikipediaUrl(originalUrl);
      // Encode the URL and prepend the proxy
      return '$_corsProxy${Uri.encodeComponent(directUrl)}';
    }
    return originalUrl;
  }
}
