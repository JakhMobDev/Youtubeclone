import 'package:flutter/material.dart';

class VideoModel {
  final String id;
  final String title;
  final String channel;
  final String views;
  final String date;
  final String thumbnail;      // Color → String (URL)
  final String avatarColor;    // Color → String (URL yoki bo'sh)
  final String duration;
  final bool isShort;

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
  });

  // API dan kelgan JSON → VideoModel
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id']['videoId'] ?? '',
      title: json['snippet']['title'] ?? '',
      channel: json['snippet']['channelTitle'] ?? '',
      views: '',
      date: json['snippet']['publishedAt'] ?? '',
      thumbnail: json['snippet']['thumbnails']['high']['url'] ?? '',
      avatarColor: '',
      duration: '',
    );
  }
}

class AppData {
  // Fallback data — API ishlamasa shu ko'rinadi
  static final List<VideoModel> videos = [
    VideoModel(
      id: '1',
      title: 'The Beauty of Existence - Heart Touching Nasheed',
      channel: 'Peaceful Channel',
      views: '19,210,251 views',
      date: 'Jul 1, 2016',
      thumbnail: 'https://picsum.photos/seed/1/480/270',
      avatarColor: '',
      duration: '4:32',
    ),
    VideoModel(
      id: '2',
      title: 'DIY Toys | Satisfying And Relaxing | DIY TikTok Compilation',
      channel: 'DIY World',
      views: '24M views',
      date: '2 years ago',
      thumbnail: 'https://picsum.photos/seed/2/480/270',
      avatarColor: '',
      duration: '10:15',
    ),
    VideoModel(
      id: '3',
      title: 'Amazing Nature Landscapes 4K - Relaxing Music & Beautiful',
      channel: 'Nature Vibes',
      views: '5.2M views',
      date: '1 year ago',
      thumbnail: 'https://picsum.photos/seed/3/480/270',
      avatarColor: '',
      duration: '1:02:30',
    ),
    VideoModel(
      id: '4',
      title: 'Compilation: Everything Belongs to Allah | Islamic Reminder',
      channel: 'Islamic Channel',
      views: '3.1M views',
      date: '3 years ago',
      thumbnail: 'https://picsum.photos/seed/4/480/270',
      avatarColor: '',
      duration: '8:44',
    ),
    VideoModel(
      id: '5',
      title: 'Stunning Sunsets Around The World - 4K Ultra HD',
      channel: 'World Views',
      views: '8.7M views',
      date: '6 months ago',
      thumbnail: 'https://picsum.photos/seed/5/480/270',
      avatarColor: '',
      duration: '22:11',
    ),
    VideoModel(
      id: '6',
      title: 'Voice of Robot - Futuristic Electronic Music Mix',
      channel: 'Electronic Beats',
      views: '1.2M views',
      date: '5 months ago',
      thumbnail: 'https://picsum.photos/seed/6/480/270',
      avatarColor: '',
      duration: '58:00',
    ),
    VideoModel(
      id: '7',
      title: 'Hawk Dashing Nasheed | Powerful Vocal Performance',
      channel: 'Vocal Arts',
      views: '2.4M views',
      date: 'Jan 3, 2016',
      thumbnail: 'https://picsum.photos/seed/7/480/270',
      avatarColor: '',
      duration: '5:18',
    ),
  ];

  static final List<VideoModel> shorts = [
    VideoModel(
      id: 's1',
      title: 'DIY Toys Satisfying TikTok Compilation',
      channel: 'DIY World',
      views: '24M views',
      date: '1 month ago',
      thumbnail: 'https://picsum.photos/seed/8/270/480',
      avatarColor: '',
      duration: '0:58',
      isShort: true,
    ),
    VideoModel(
      id: 's2',
      title: 'Amazing Sunset Timelapse Short',
      channel: 'Nature Vibes',
      views: '12M views',
      date: '2 weeks ago',
      thumbnail: 'https://picsum.photos/seed/9/270/480',
      avatarColor: '',
      duration: '0:45',
      isShort: true,
    ),
    VideoModel(
      id: 's3',
      title: 'Galaxy Space Stars Beautiful',
      channel: 'Cosmos',
      views: '31M views',
      date: '3 weeks ago',
      thumbnail: 'https://picsum.photos/seed/10/270/480',
      avatarColor: '',
      duration: '0:30',
      isShort: true,
    ),
    VideoModel(
      id: 's4',
      title: 'Relaxing Ocean Waves Sounds',
      channel: 'Chill Vibes',
      views: '7M views',
      date: '1 week ago',
      thumbnail: 'https://picsum.photos/seed/11/270/480',
      avatarColor: '',
      duration: '0:59',
      isShort: true,
    ),
  ];

  static const List<Map<String, dynamic>> channels = [
    {'name': 'Peaceful Channel', 'color': Color(0xFF1565C0), 'subs': '2.1M'},
    {'name': 'DIY World', 'color': Color(0xFFE65100), 'subs': '5.4M'},
    {'name': 'Nature Vibes', 'color': Color(0xFF2E7D32), 'subs': '3.8M'},
    {'name': 'Islamic Channel', 'color': Color(0xFF6A1B9A), 'subs': '1.2M'},
    {'name': 'World Views', 'color': Color(0xFFBF360C), 'subs': '890K'},
  ];
}