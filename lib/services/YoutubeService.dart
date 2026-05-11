import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:f1/config/ApiConfig.dart';
import 'package:f1/models/AppData.dart';

/// YoutubeService
/// YouTube API bilan ishlash uchun service klass
/// Video va Shorts ma’lumotlarini serverdan olib keladi
class YoutubeService {

  // ───────────────── NORMAL VIDEOS ─────────────────

  /// Oddiy videolarni qidirib olish
  /// query — foydalanuvchi kiritgan so‘z
  Future<List<VideoModel>> getVideos(String query) async {
    try {

      /// YouTube search API URL
      final url = Uri.parse(
        "${ApiConfig.baseUrl}/search"
            "?part=snippet"
            "&q=$query"
            "&type=video"
            "&maxResults=20"
            "&safeSearch=strict"
            "&key=${ApiConfig.apiKey}",
      );

      /// API so‘rov yuboriladi
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 5));

      /// Agar so‘rov muvaffaqiyatli bo‘lsa
      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        final items = data['items'] as List;

        /// JSON → VideoModel ga o‘giriladi
        final videos = items
            .map((item) =>
            VideoModel.fromYouTubeSearch(item))
            .where((v) => v.id.isNotEmpty)
            .toList();

        /// Agar API bo‘sh qaytsa → lokal data
        return videos.isNotEmpty
            ? videos
            : AppData.videos;
      }

      /// Status code noto‘g‘ri bo‘lsa
      return AppData.videos;

    } catch (_) {

      /// Internet yo‘q / timeout / error
      return AppData.videos;
    }
  }

  // ───────────────── SHORTS ─────────────────

  /// Shorts videolarni olish
  Future<List<VideoModel>> getShorts({
    String query = 'kids shorts',
  }) async {

    try {

      /// Search API (short video filter bilan)
      final searchUrl = Uri.parse(
        "${ApiConfig.baseUrl}/search"
            "?part=snippet"
            "&q=$query"
            "&type=video"
            "&videoDuration=short"
            "&safeSearch=strict"
            "&maxResults=20"
            "&key=${ApiConfig.apiKey}",
      );

      /// Qidiruv request
      final searchResponse = await http
          .get(searchUrl)
          .timeout(const Duration(seconds: 5));

      /// Agar xato bo‘lsa fallback
      if (searchResponse.statusCode != 200) {
        return AppData.shorts;
      }

      final searchData =
      jsonDecode(searchResponse.body);

      final searchItems =
      searchData['items'] as List;

      if (searchItems.isEmpty) {
        return AppData.shorts;
      }

      /// Video ID larni yig‘ib olamiz
      final ids = searchItems
          .map((item) {
        final rawId = item['id'];
        return rawId is Map
            ? rawId['videoId']
            : rawId;
      })
          .where((id) =>
      id != null &&
          id.toString().isNotEmpty)
          .map((id) => id.toString())
          .join(',');

      /// Video detail API
      final detailUrl = Uri.parse(
        "${ApiConfig.baseUrl}/videos"
            "?part=snippet,statistics,contentDetails"
            "&id=$ids"
            "&key=${ApiConfig.apiKey}",
      );

      final detailResponse = await http
          .get(detailUrl)
          .timeout(const Duration(seconds: 5));

      if (detailResponse.statusCode != 200) {
        return AppData.shorts;
      }

      final detailData =
      jsonDecode(detailResponse.body);

      final detailItems =
      detailData['items'] as List;

      /// VideoModel ga convert
      final shorts = detailItems
          .map((item) =>
          VideoModel.fromYouTube(item))
          .where((video) =>
          _isShort(video.duration))
          .toList();

      /// Agar bo‘sh bo‘lsa fallback
      return shorts.isNotEmpty
          ? shorts
          : AppData.shorts;

    } catch (_) {

      /// Internet yoki boshqa xato
      return AppData.shorts;
    }
  }

  // ───────────────── SHORT CHECK ─────────────────

  /// Video short ekanligini tekshiradi
  /// "0:58" → true
  /// "4:32" → false
  bool _isShort(String duration) {

    if (duration.isEmpty) return true;

    final parts = duration.split(':');

    if (parts.length == 2) {

      final minutes =
          int.tryParse(parts[0]) ?? 0;

      return minutes == 0;
    }

    return false;
  }
}