import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/screens/VideoPlayerScreen.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
  final bool compact;

  const VideoCard({super.key, required this.video, this.compact = false});

  // Thumbnail widget — URL bo'lsa rasm, bo'lmasa rang
  Widget _buildThumbnail(double height) {
    return video.thumbnail.startsWith('http')
        ? Image.network(
      video.thumbnail,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackThumbnail(height),
    )
        : _fallbackThumbnail(height);
  }

  Widget _fallbackThumbnail(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.play_circle_outline, size: 56, color: Colors.white70),
      ),
    );
  }

  // Avatar — URL bo'lsa rasm, bo'lmasa harf
  Widget _buildAvatar() {
    if (video.avatarColor.startsWith('http')) {
      return CircleAvatar(
        radius: 17,
        backgroundImage: NetworkImage(video.avatarColor),
      );
    }
    return CircleAvatar(
      radius: 17,
      backgroundColor: Colors.red,
      child: Text(
        video.channel.isNotEmpty ? video.channel[0] : '?',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: video)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Stack(
            children: [
              _buildThumbnail(compact ? 160 : 210),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    video.duration.isNotEmpty ? video.duration : '0:00',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${video.channel} • ${video.views} • ${video.date}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.grey[500], size: 20),
              ],
            ),
          ),
          Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

class HorizontalVideoCard extends StatelessWidget {
  final VideoModel video;

  const HorizontalVideoCard({super.key, required this.video});

  Widget _buildThumbnail() {
    return video.thumbnail.startsWith('http')
        ? Image.network(
      video.thumbnail,
      width: 130,
      height: 78,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 130,
        height: 78,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.play_circle_outline, size: 32, color: Colors.white70),
        ),
      ),
    )
        : Container(
      width: 130,
      height: 78,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.play_circle_outline, size: 32, color: Colors.white70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: video)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildThumbnail(),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      video.duration.isNotEmpty ? video.duration : '0:00',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    video.channel,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                  Text(
                    '${video.views} • ${video.date}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert, color: Colors.grey[400], size: 18),
          ],
        ),
      ),
    );
  }
}