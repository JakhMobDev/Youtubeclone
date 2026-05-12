import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:f1/config/ApiConfig.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/services/CacheService.dart';

class YoutubeService {

  // ═══════════════════════════════════════
  //           ODDIY VIDEOLAR
  // ═══════════════════════════════════════

  /// YouTube dan videolar olish
  /// [query] — qidiruv so'zi (masalan: "kids cartoons")
  Future<List<VideoModel>> getVideos(String query) async {
    // Cache kaliti — har xil query uchun alohida cache
    final cacheKey = 'videos_$query';

    try {
      // ── 1. Cache tekshirish ──
      // Agar 24 soat ichida shu query qilingan bo'lsa
      // API ga bormay cache dan qaytaradi
      final cached = await CacheService.load(cacheKey);
      if (cached != null) {
        final videos = cached
            .map((item) => VideoModel.fromYouTubeSearch(item))
            .where((v) => v.id.isNotEmpty)
            .toList();
        if (videos.isNotEmpty) {
          return videos; // ← Cache dan qaytdi
        }
      }

      // ── 2. YouTube Search API ──
      // Cache yo'q bo'lsa yoki eski bo'lsa API chaqiriladi
      final url = Uri.parse(
        "${ApiConfig.baseUrl}/search"
            "?part=snippet"        // video ma'lumotlari
            "&q=$query"            // qidiruv so'zi
            "&type=video"          // faqat videolar
            "&maxResults=20"       // maksimal 20 ta
            "&safeSearch=strict"   // bolalar uchun filtr
            "&key=${ApiConfig.apiKey}",
      );

      // 10 soniya kutib javob oladi
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      // ── 3. Javobni qayta ishlash ──
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List;

        // Cache ga saqlash — 24 soat davomida ishlatiladi
        await CacheService.save(
          cacheKey,
          items.map((e) => Map<String, dynamic>.from(e)).toList(),
        );

        // JSON → VideoModel ga o'girish
        final videos = items
            .map((item) => VideoModel.fromYouTubeSearch(item))
            .where((v) => v.id.isNotEmpty) // bo'sh ID larni o'chirish
            .toList();

        // Agar API bo'sh qaytsa — lokal data
        return videos.isNotEmpty ? videos : AppData.videos;
      }

      // Status code xato bo'lsa — lokal data
      return AppData.videos;

    } catch (_) {
      // Internet yo'q / timeout / boshqa xato
      // Lokal data ko'rsatiladi
      return AppData.videos;
    }
  }

  // ═══════════════════════════════════════
  //              SHORTS
  // ═══════════════════════════════════════

  /// YouTube Shorts olish
  /// [query] — qidiruv so'zi (masalan: "kids funny shorts")
  /// 2 bosqichli: avval ID lar, keyin to'liq ma'lumot
  Future<List<VideoModel>> getShorts({
    String query = 'kids shorts',
  }) async {
    // Cache kaliti
    final cacheKey = 'shorts_$query';

    try {
      // ── 1. Cache tekshirish ──
      final cached = await CacheService.load(cacheKey);
      if (cached != null) {
        final shorts = cached
            .map((item) => VideoModel.fromYouTube(item))
            .where((v) => v.id.isNotEmpty && _isShort(v.duration))
            .toList();
        if (shorts.isNotEmpty) {
          return shorts; // ← Cache dan qaytdi
        }
      }

      // ── 2. Birinchi bosqich: Search API ──
      // "videoDuration=short" — 4 daqiqadan qisqa videolar
      final searchUrl = Uri.parse(
        "${ApiConfig.baseUrl}/search"
            "?part=snippet"
            "&q=$query"
            "&type=video"
            "&videoDuration=short"  // qisqa videolar filtri
            "&safeSearch=strict"    // bolalar uchun filtr
            "&maxResults=20"
            "&key=${ApiConfig.apiKey}",
      );

      final searchResponse = await http
          .get(searchUrl)
          .timeout(const Duration(seconds: 10));

      // Xato bo'lsa — lokal data
      if (searchResponse.statusCode != 200) {
        return AppData.shorts;
      }

      final searchData = jsonDecode(searchResponse.body);
      final searchItems = searchData['items'] as List;

      // Bo'sh bo'lsa — lokal data
      if (searchItems.isEmpty) return AppData.shorts;

      // ── 3. Video ID larni yig'ish ──
      // Search API faqat ID va snippet beradi
      // To'liq ma'lumot uchun alohida so'rov kerak
      final ids = searchItems
          .map((item) {
        final rawId = item['id'];
        // ID ba'zan Map, ba'zan String bo'ladi
        return rawId is Map ? rawId['videoId'] : rawId;
      })
          .where((id) => id != null && id.toString().isNotEmpty)
          .map((id) => id.toString())
          .join(','); // "id1,id2,id3" formatga keltiriladi

      // ── 4. Ikkinchi bosqich: Videos API ──
      // Duration, views, statistics olish uchun
      final detailUrl = Uri.parse(
        "${ApiConfig.baseUrl}/videos"
            "?part=snippet,statistics,contentDetails"
            "&id=$ids"              // yuqorida yig'ilgan ID lar
            "&key=${ApiConfig.apiKey}",
      );

      final detailResponse = await http
          .get(detailUrl)
          .timeout(const Duration(seconds: 10));

      // Xato bo'lsa — lokal data
      if (detailResponse.statusCode != 200) {
        return AppData.shorts;
      }

      final detailData = jsonDecode(detailResponse.body);
      final detailItems = detailData['items'] as List;

      // ── 5. Cache ga saqlash ──
      await CacheService.save(
        cacheKey,
        detailItems.map((e) => Map<String, dynamic>.from(e)).toList(),
      );

      // ── 6. Filtrlash ──
      // Faqat 60 soniyadan qisqa videolarni olamiz
      final shorts = detailItems
          .map((item) => VideoModel.fromYouTube(item))
          .where((video) => _isShort(video.duration))
          .toList();

      // Agar bo'sh bo'lsa — lokal data
      return shorts.isNotEmpty ? shorts : AppData.shorts;

    } catch (_) {
      // Internet yo'q / timeout / boshqa xato
      return AppData.shorts;
    }
  }

  // ═══════════════════════════════════════
  //         YORDAMCHI FUNKSIYA
  // ═══════════════════════════════════════

  /// Video short ekanligini tekshiradi
  /// "0:58" → true  (58 soniya — short)
  /// "1:30" → false (1 daqiqa 30 soniya — short emas)
  /// "4:32" → false (oddiy video)
  bool _isShort(String duration) {
    // Bo'sh bo'lsa short deb hisoblaymiz
    if (duration.isEmpty) return true;

    final parts = duration.split(':');

    // "0:58" → [0, 58] — daqiqa 0 bo'lsa short
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      return minutes == 0;
    }

    // "1:00:00" formatidagi uzun video — short emas
    return false;
  }
}