import 'package:flutter/material.dart';

/// Video ma'lumotlarini saqlovchi model class
class VideoModel {

  // Video ID (YouTube video ID)
  final String id;

  // Video nomi
  final String title;

  // Kanal nomi
  final String channel;

  // Ko‘rishlar soni
  final String views;

  // Video joylangan sana
  final String date;

  // Thumbnail rasmi URL manzili
  final String thumbnail;

  // Kanal avatar rangi
  final String avatarColor;

  // Video davomiyligi
  final String duration;

  // Shorts video ekanligini tekshiradi
  final bool isShort;

  // Kanal ID si
  final String? channelId;

  /// Constructor
  const VideoModel({
    required this.id,
    required this.title,
    required this.channel,
    required this.views,
    required this.date,
    required this.thumbnail,
    required this.avatarColor,
    required this.duration,
    this.isShort = false,
    this.channelId,
  });

  /// YouTube Search API dan kelgan ma'lumotni VideoModel ga o‘giradi
  factory VideoModel.fromYouTubeSearch(Map<String, dynamic> item) {

    // snippet ichidagi ma'lumotlarni olish
    final snippet = item['snippet'] ?? {};

    // video ID ni olish
    final rawId = item['id'];
    final videoId = rawId is Map ? rawId['videoId'] : rawId;

    // video joylangan sana
    final publishedAt = snippet['publishedAt']?.toString() ?? '';

    return VideoModel(
      id: videoId?.toString() ?? '',
      title: snippet['title']?.toString() ?? '',
      channel: snippet['channelTitle']?.toString() ?? '',
      views: '',
      date: publishedAt.length >= 10
          ? publishedAt.substring(0, 10)
          : '',
      thumbnail:
      snippet['thumbnails']?['high']?['url']?.toString() ??
          snippet['thumbnails']?['medium']?['url']?.toString() ??
          '',
      avatarColor: '',
      duration: '',
      channelId: snippet['channelId']?.toString(),
    );
  }

  /// YouTube Videos API dan kelgan to‘liq ma'lumotni VideoModel ga aylantiradi
  factory VideoModel.fromYouTube(Map<String, dynamic> item) {

    // snippet ma'lumotlari
    final snippet = item['snippet'] ?? {};

    // statistika ma'lumotlari
    final stats = item['statistics'] ?? {};

    // davomiylik ma'lumotlari
    final details = item['contentDetails'] ?? {};

    // view count ni int ga aylantirish
    final viewCount =
        int.tryParse(stats['viewCount']?.toString() ?? '0') ?? 0;

    // Ko‘rish sonini chiroyli formatlash
    final views = viewCount > 1000000
        ? '${(viewCount / 1000000).toStringAsFixed(1)}M ko\'rish'
        : viewCount > 1000
        ? '${(viewCount / 1000).toStringAsFixed(0)}K ko\'rish'
        : '$viewCount ko\'rish';

    // video joylangan sana
    final publishedAt = snippet['publishedAt']?.toString() ?? '';

    // ISO duration formatini oddiy formatga o‘tkazish
    final duration =
    _parseDuration(details['duration']?.toString() ?? '');

    return VideoModel(
      id: item['id']?.toString() ?? '',
      title: snippet['title']?.toString() ?? '',
      channel: snippet['channelTitle']?.toString() ?? '',
      views: views,
      date: publishedAt.length >= 10
          ? publishedAt.substring(0, 10)
          : '',
      thumbnail:
      snippet['thumbnails']?['high']?['url']?.toString() ??
          snippet['thumbnails']?['medium']?['url']?.toString() ??
          '',
      avatarColor: '',
      duration: duration,
      channelId: snippet['channelId']?.toString(),
    );
  }

  /// ISO 8601 duration formatini oddiy minut/sekund formatiga aylantiradi
  static String _parseDuration(String iso) {

    // bo‘sh bo‘lsa qaytaradi
    if (iso.isEmpty) return '';

    // Regex orqali H/M/S ni ajratib olish
    final match =
    RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?')
        .firstMatch(iso);

    if (match == null) return '';

    // Soat
    final h =
        int.tryParse(match.group(1) ?? '') ?? 0;

    // Minut
    final m =
        int.tryParse(match.group(2) ?? '') ?? 0;

    // Sekund
    final s =
        int.tryParse(match.group(3) ?? '') ?? 0;

    // Agar soat mavjud bo‘lsa
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }

    // Oddiy minut:sekund
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

/// Dasturdagi barcha static ma'lumotlar
class AppData {

  // ───────────────── CHANNELS ─────────────────

  /// Kanallar ro‘yxati
  static const List<Map<String, dynamic>> channels = [

    // Kanal ID
    // Kanal nomi
    // Avatar rangi
    // Yangi video mavjudligi

    {
      'id': 'UCulugbek',
      'name': 'Ulug\'bek Rahmatullayev',
      'color': Color(0xFF7F77DD),
      'hasNew': true
    },

    {
      'id': 'UCyulduz',
      'name': 'Yulduz Usmonova',
      'color': Color(0xFFD4537E),
      'hasNew': true
    },

    {
      'id': 'UCjahongir',
      'name': 'Jahongir Otajonov',
      'color': Color(0xFF1D9E75),
      'hasNew': false
    },
  ];

  // ───────────────── VIDEOS ─────────────────

  /// Oddiy videolar ro‘yxati
  static const List<VideoModel> videos = [

    // Video ID
    // Video nomi
    // Kanal nomi
    // Kanal ID
    // Ko‘rishlar soni
    // Sana
    // Thumbnail
    // Avatar rangi
    // Davomiylik

    VideoModel(
      id: 'mFizgDuzeVs',
      title: 'Ulug\'bek Rahmatullayev - Farishtalar',
      channel: 'Ulug\'bek Rahmatullayev',
      channelId: 'UCulugbek',
      views: '8.4M ko\'rish',
      date: '2024-02-22',
      thumbnail:
      'https://img.youtube.com/vi/mFizgDuzeVs/hqdefault.jpg',
      avatarColor: '#7F77DD',
      duration: '3:52',
      isShort: false,
    ),
  ];

  // ───────────────── SHORTS ─────────────────

  /// Shorts videolar ro‘yxati
  static const List<VideoModel> shorts = [

    VideoModel(
      id: 'z6aTDnW-vIU',
      title: 'Ulug\'bek - Bemehrginam #short',
      channel: 'Ulug\'bek Rahmatullayev',
      channelId: 'UCulugbek',
      views: '15M ko\'rish',
      date: '2023-10-23',
      thumbnail:
      'https://img.youtube.com/vi/z6aTDnW-vIU/hqdefault.jpg',
      avatarColor: '#7F77DD',
      duration: '0:58',
      isShort: true,
    ),
  ];
}