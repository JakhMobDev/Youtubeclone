import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:f1/config/ApiConfig.dart';
import 'package:f1/models/AppData.dart';

class YoutubeService {

  // Oddiy videolar olish
  Future<List<VideoModel>> getVideos(String query) async {
    try {
      final url = Uri.parse(
        "${ApiConfig.baseUrl}/search"
            "?part=snippet"
            "&q=$query"
            "&type=video"
            "&maxResults=20"
            "&safeSearch=strict"
            "&key=${ApiConfig.apiKey}",
      );

      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List;
        final videos = items
            .map((item) => VideoModel.fromYouTubeSearch(item))
            .where((v) => v.id.isNotEmpty)
            .toList();
        // ✅ API natija bo'sh bo'lsa AppData ishlatiladi
        return videos.isNotEmpty ? videos : AppData.videos;
      }
      return AppData.videos;
    } catch (_) {
      // Timeout, internet yo'q, xato — AppData qaytariladi
      return AppData.videos;
    }
  }

  // Shorts olish
  Future<List<VideoModel>> getShorts({String query = 'kids shorts'}) async {
    try {
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

      final searchResponse =
      await http.get(searchUrl).timeout(const Duration(seconds: 5));

      if (searchResponse.statusCode != 200) return AppData.shorts;

      final searchData = jsonDecode(searchResponse.body);
      final searchItems = searchData['items'] as List;
      if (searchItems.isEmpty) return AppData.shorts;

      final ids = searchItems
          .map((item) {
        final rawId = item['id'];
        return rawId is Map ? rawId['videoId'] : rawId;
      })
          .where((id) => id != null && id.toString().isNotEmpty)
          .map((id) => id.toString())
          .join(',');

      final detailUrl = Uri.parse(
        "${ApiConfig.baseUrl}/videos"
            "?part=snippet,statistics,contentDetails"
            "&id=$ids"
            "&key=${ApiConfig.apiKey}",
      );

      final detailResponse =
      await http.get(detailUrl).timeout(const Duration(seconds: 5));

      if (detailResponse.statusCode != 200) return AppData.shorts;

      final detailData = jsonDecode(detailResponse.body);
      final detailItems = detailData['items'] as List;

      final shorts = detailItems
          .map((item) => VideoModel.fromYouTube(item))
          .where((video) => _isShort(video.duration))
          .toList();

      // ✅ API natija bo'sh bo'lsa AppData ishlatiladi
      return shorts.isNotEmpty ? shorts : AppData.shorts;
    } catch (_) {
      // Timeout, internet yo'q, xato — AppData qaytariladi
      return AppData.shorts;
    }
  }

  // "0:58" → true, "4:32" → false
  bool _isShort(String duration) {
    if (duration.isEmpty) return true;
    final parts = duration.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      return minutes == 0;
    }
    return false;
  }
}