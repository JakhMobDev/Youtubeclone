import 'package:flutter/material.dart';

class VideoModel {
  final String id;
  final String title;
  final String channel;
  final String views;
  final String date;
  final String thumbnail;
  final String avatarColor;
  final String duration;
  final bool isShort;
  final String? channelId;

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

  factory VideoModel.fromYouTubeSearch(Map<String, dynamic> item) {
    final snippet = item['snippet'] ?? {};
    final rawId = item['id'];
    final videoId = rawId is Map ? rawId['videoId'] : rawId;
    final publishedAt = snippet['publishedAt']?.toString() ?? '';
    return VideoModel(
      id: videoId?.toString() ?? '',
      title: snippet['title']?.toString() ?? '',
      channel: snippet['channelTitle']?.toString() ?? '',
      views: '',
      date: publishedAt.length >= 10 ? publishedAt.substring(0, 10) : '',
      thumbnail: snippet['thumbnails']?['high']?['url']?.toString() ??
          snippet['thumbnails']?['medium']?['url']?.toString() ?? '',
      avatarColor: '',
      duration: '',
      channelId: snippet['channelId']?.toString(),
    );
  }

  factory VideoModel.fromYouTube(Map<String, dynamic> item) {
    final snippet = item['snippet'] ?? {};
    final stats = item['statistics'] ?? {};
    final details = item['contentDetails'] ?? {};
    final viewCount = int.tryParse(stats['viewCount']?.toString() ?? '0') ?? 0;
    final views = viewCount > 1000000
        ? '${(viewCount / 1000000).toStringAsFixed(1)}M ko\'rish'
        : viewCount > 1000
        ? '${(viewCount / 1000).toStringAsFixed(0)}K ko\'rish'
        : '$viewCount ko\'rish';
    final publishedAt = snippet['publishedAt']?.toString() ?? '';
    final duration = _parseDuration(details['duration']?.toString() ?? '');
    return VideoModel(
      id: item['id']?.toString() ?? '',
      title: snippet['title']?.toString() ?? '',
      channel: snippet['channelTitle']?.toString() ?? '',
      views: views,
      date: publishedAt.length >= 10 ? publishedAt.substring(0, 10) : '',
      thumbnail: snippet['thumbnails']?['high']?['url']?.toString() ??
          snippet['thumbnails']?['medium']?['url']?.toString() ?? '',
      avatarColor: '',
      duration: duration,
      channelId: snippet['channelId']?.toString(),
    );
  }

  static String _parseDuration(String iso) {
    if (iso.isEmpty) return '';
    final match =
    RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?').firstMatch(iso);
    if (match == null) return '';
    final h = int.tryParse(match.group(1) ?? '') ?? 0;
    final m = int.tryParse(match.group(2) ?? '') ?? 0;
    final s = int.tryParse(match.group(3) ?? '') ?? 0;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class AppData {
  // ─── Channels ───────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> channels = [
    {'id': 'UCulugbek',  'name': 'Ulug\'bek Rahmatullayev', 'color': Color(0xFF7F77DD), 'hasNew': true},
    {'id': 'UCyulduz',   'name': 'Yulduz Usmonova',         'color': Color(0xFFD4537E), 'hasNew': true},
    {'id': 'UCjahongir', 'name': 'Jahongir Otajonov',       'color': Color(0xFF1D9E75), 'hasNew': false},
    {'id': 'UCsevinch',  'name': 'Sevinch Mo\'minova',      'color': Color(0xFF185FA5), 'hasNew': true},
    {'id': 'UCshaxriyor','name': 'Shaxriyor',               'color': Color(0xFFD85A30), 'hasNew': true},
    {'id': 'UCzoff',     'name': 'Zoff Music',              'color': Color(0xFF639922), 'hasNew': false},
    {'id': 'UCrizanova', 'name': 'RizaNova',                'color': Color(0xFFBA7517), 'hasNew': true},
    {'id': 'UCnevo',     'name': 'Nevo TV',                 'color': Color(0xFF534AB7), 'hasNew': false},
  ];

  // ─── Videos (isShort: false) — haqiqiy YouTube IDlar ────────────────────
  static const List<VideoModel> videos = [
    VideoModel(
      id: 'mFizgDuzeVs', // Ulug'bek Rahmatullayev - Farishtalar (2024)
      title: 'Ulug\'bek Rahmatullayev - Farishtalar',
      channel: 'Ulug\'bek Rahmatullayev',
      channelId: 'UCulugbek',
      views: '8.4M ko\'rish',
      date: '2024-02-22',
      thumbnail: 'https://img.youtube.com/vi/mFizgDuzeVs/hqdefault.jpg',
      avatarColor: '#7F77DD',
      duration: '3:52',
      isShort: false,
    ),
    VideoModel(
      id: 'nj9uRp4CNaI', // Ulug'bek Rahmatullayev - Onam (2023)
      title: 'Ulug\'bek Rahmatullayev - Onam',
      channel: 'Ulug\'bek Rahmatullayev',
      channelId: 'UCulugbek',
      views: '12.1M ko\'rish',
      date: '2023-12-05',
      thumbnail: 'https://img.youtube.com/vi/nj9uRp4CNaI/hqdefault.jpg',
      avatarColor: '#7F77DD',
      duration: '4:10',
      isShort: false,
    ),
    VideoModel(
      id: 'lJeuMJvV2Zc', // Yulduz Usmonova - Senmiding, Muhabbating (2024)
      title: 'Yulduz Usmonova - Senmiding, Muhabbating',
      channel: 'Yulduz Usmonova',
      channelId: 'UCyulduz',
      views: '6.3M ko\'rish',
      date: '2024-01-03',
      thumbnail: 'https://img.youtube.com/vi/lJeuMJvV2Zc/hqdefault.jpg',
      avatarColor: '#D4537E',
      duration: '3:38',
      isShort: false,
    ),
    VideoModel(
      id: 'TOFewkaTx6s', // Yulduz Usmonova - Sevmasam (2024)
      title: 'Yulduz Usmonova - Sevmasam',
      channel: 'Yulduz Usmonova',
      channelId: 'UCyulduz',
      views: '4.7M ko\'rish',
      date: '2024-03-15',
      thumbnail: 'https://img.youtube.com/vi/TOFewkaTx6s/hqdefault.jpg',
      avatarColor: '#D4537E',
      duration: '3:21',
      isShort: false,
    ),
    VideoModel(
      id: '0nZOw-rIpoA', // Jahongir Otajonov - Poram (2024)
      title: 'Jahongir Otajonov - Poram',
      channel: 'Jahongir Otajonov',
      channelId: 'UCjahongir',
      views: '5.9M ko\'rish',
      date: '2024-11-20',
      thumbnail: 'https://img.youtube.com/vi/0nZOw-rIpoA/hqdefault.jpg',
      avatarColor: '#1D9E75',
      duration: '3:44',
      isShort: false,
    ),
    VideoModel(
      id: '2XdveQvOMmw', // Sevinch Mo'minova - Konsert 2024
      title: 'Sevinch Mo\'minova - Konsert Dasturi 2024',
      channel: 'Sevinch Mo\'minova',
      channelId: 'UCsevinch',
      views: '9.2M ko\'rish',
      date: '2024-01-08',
      thumbnail: 'https://img.youtube.com/vi/2XdveQvOMmw/hqdefault.jpg',
      avatarColor: '#185FA5',
      duration: '45:30',
      isShort: false,
    ),
    VideoModel(
      id: 'BC5GXqpe2fw', // Shaxriyor - Xasta bo'lma
      title: 'Shaxriyor - Xasta bo\'lma',
      channel: 'Shaxriyor',
      channelId: 'UCshaxriyor',
      views: '7.8M ko\'rish',
      date: '2022-06-01',
      thumbnail: 'https://img.youtube.com/vi/BC5GXqpe2fw/hqdefault.jpg',
      avatarColor: '#D85A30',
      duration: '3:15',
      isShort: false,
    ),
    VideoModel(
      id: 'ysO4DF2dgmY', // Shaxriyor & Zoff - Seni ko'rdim (2025)
      title: 'Shaxriyor & Zoff - Seni Ko\'rdim',
      channel: 'Zoff Music',
      channelId: 'UCzoff',
      views: '3.5M ko\'rish',
      date: '2025-12-15',
      thumbnail: 'https://img.youtube.com/vi/ysO4DF2dgmY/hqdefault.jpg',
      avatarColor: '#639922',
      duration: '3:02',
      isShort: false,
    ),
  ];

  // ─── Shorts (isShort: true) — videos dan FARQLI IDlar ───────────────────
  static const List<VideoModel> shorts = [
    VideoModel(
      id: 'z6aTDnW-vIU', // Ulug'bek Rahmatullayev - Bemehrginam
      title: 'Ulug\'bek - Bemehrginam #short',
      channel: 'Ulug\'bek Rahmatullayev',
      channelId: 'UCulugbek',
      views: '15M ko\'rish',
      date: '2023-10-23',
      thumbnail: 'https://img.youtube.com/vi/z6aTDnW-vIU/hqdefault.jpg',
      avatarColor: '#7F77DD',
      duration: '0:58',
      isShort: true,
    ),
    VideoModel(
      id: 'riQJbIvB-xk', // Yulduz Usmonova - Senmiding
      title: 'Yulduz - Senmiding #short',
      channel: 'Yulduz Usmonova',
      channelId: 'UCyulduz',
      views: '8.2M ko\'rish',
      date: '2023-12-24',
      thumbnail: 'https://img.youtube.com/vi/riQJbIvB-xk/hqdefault.jpg',
      avatarColor: '#D4537E',
      duration: '0:55',
      isShort: true,
    ),
    VideoModel(
      id: '-PPHo7ampd8', // Jahongir Otajonov - Kachayte (2024)
      title: 'Jahongir - Kachayte #short',
      channel: 'Jahongir Otajonov',
      channelId: 'UCjahongir',
      views: '4.1M ko\'rish',
      date: '2024-04-23',
      thumbnail: 'https://img.youtube.com/vi/-PPHo7ampd8/hqdefault.jpg',
      avatarColor: '#1D9E75',
      duration: '0:52',
      isShort: true,
    ),
    VideoModel(
      id: 'IxVobN7oVr0', // Sevinch Mo'minova - Ne bo'ldi
      title: 'Sevinch - Ne bo\'ldi #short',
      channel: 'Sevinch Mo\'minova',
      channelId: 'UCsevinch',
      views: '57M ko\'rish',
      date: '2019-03-22',
      thumbnail: 'https://img.youtube.com/vi/IxVobN7oVr0/hqdefault.jpg',
      avatarColor: '#185FA5',
      duration: '0:49',
      isShort: true,
    ),
    VideoModel(
      id: 'O0v1yAko3EE', // Shaxriyor - Izhor
      title: 'Shaxriyor - Izhor #short',
      channel: 'Shaxriyor',
      channelId: 'UCshaxriyor',
      views: '6.3M ko\'rish',
      date: '2016-05-20',
      thumbnail: 'https://img.youtube.com/vi/O0v1yAko3EE/hqdefault.jpg',
      avatarColor: '#D85A30',
      duration: '0:59',
      isShort: true,
    ),
    VideoModel(
      id: 'XbIj-EuUHtQ', // Yulduz Usmonova - Seni Severdim
      title: 'Yulduz - Seni Severdim #short',
      channel: 'Yulduz Usmonova',
      channelId: 'UCyulduz',
      views: '115M ko\'rish',
      date: '2014-01-13',
      thumbnail: 'https://img.youtube.com/vi/XbIj-EuUHtQ/hqdefault.jpg',
      avatarColor: '#D4537E',
      duration: '0:45',
      isShort: true,
    ),
  ];
}