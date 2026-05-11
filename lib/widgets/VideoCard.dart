import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/screens/VideoPlayerScreen.dart';
import 'package:f1/screens/ShortsScreen.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
  final bool compact;

  const VideoCard({super.key, required this.video, this.compact = false});

  // Thumbnail ko'rsatish
  Widget _buildThumbnail(double height) {
    if (video.thumbnail.startsWith('http')) {
      return Image.network(
        video.thumbnail,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            width: double.infinity,
            height: height,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => _fallback(height),
      );
    }
    return _fallback(height);
  }

  Widget _fallback(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.play_circle_outline, size: 56, color: Colors.white70),
      ),
    );
  }

  // Avatar ko'rsatish
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
        video.channel.isNotEmpty ? video.channel[0].toUpperCase() : '?',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Short video uchun play overlay
  Widget _buildShortPlayOverlay() {
    return Positioned.fill(
      child: Center(
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double thumbHeight = compact ? 160 : 210;

    return GestureDetector(
      onTap: () {
        if (video.isShort) {
          // Short bo'lsa to'g'ridan ShortsScreen ga
          final startIndex =
          AppData.shorts.indexWhere((s) => s.id == video.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShortsScreen(
                startIndex: startIndex < 0 ? 0 : startIndex,
                initialShorts: AppData.shorts,
              ),
            ),
          );
        } else {
          // Oddiy video — VideoPlayerScreen
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VideoPlayerScreen(video: video)),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail + davomiylik + play overlay (short uchun)
          Stack(
            children: [
              _buildThumbnail(thumbHeight),

              // Short bo'lsa markazda play tugmasi
              if (video.isShort) _buildShortPlayOverlay(),

              // Davomiylik badge (past o'ng burchak)
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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

              // Short belgisi (past chap burchak)
              if (video.isShort)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'Shorts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Video ma'lumotlari
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
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${video.channel} • ${video.views} • ${video.date}',
                        style:
                        TextStyle(color: Colors.grey[600], fontSize: 11),
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

// Gorizontal video karta (Library, History uchun)
class HorizontalVideoCard extends StatelessWidget {
  final VideoModel video;

  const HorizontalVideoCard({super.key, required this.video});

  Widget _buildThumbnail() {
    if (video.thumbnail.startsWith('http')) {
      return Image.network(
        video.thumbnail,
        width: 130,
        height: 78,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 130,
          height: 78,
          color: Colors.grey[300],
          child: const Center(
            child:
            Icon(Icons.play_circle_outline, size: 32, color: Colors.white70),
          ),
        ),
      );
    }
    return Container(
      width: 130,
      height: 78,
      color: Colors.grey[300],
      child: const Center(
        child:
        Icon(Icons.play_circle_outline, size: 32, color: Colors.white70),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildThumbnail(),
                ),

                // Short uchun play overlay
                if (video.isShort)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      video.duration.isNotEmpty ? video.duration : '0:00',
                      style:
                      const TextStyle(color: Colors.white, fontSize: 10),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(video.channel,
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 11)),
                  Text('${video.views} • ${video.date}',
                      style:
                      TextStyle(color: Colors.grey[500], fontSize: 11)),
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