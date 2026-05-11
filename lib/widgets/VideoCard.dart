import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/screens/VideoPlayerScreen.dart';
import 'package:f1/screens/ShortsScreen.dart';

/// =========================
/// VIDEO CARD (VERTICAL UI)
/// =========================
/// Bu widget YouTube home feeddagi video kartani chizadi.
/// - Oddiy video
/// - Shorts video
/// ikkalasini ham qo‘llab-quvvatlaydi
class VideoCard extends StatelessWidget {
  final VideoModel video;
  final bool compact;

  const VideoCard({super.key, required this.video, this.compact = false});

  /// Thumbnail builder:
  /// - Internetdan rasm bo‘lsa Image.network
  /// - bo‘lmasa fallback container
  Widget _buildThumbnail(double height) {
    if (video.thumbnail.startsWith('http')) {
      return Image.network(
        video.thumbnail,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;

          // loading paytida skeleton ko‘rsatamiz
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

  /// Internet rasm yo‘q bo‘lsa fallback UI
  Widget _fallback(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.play_circle_outline,
            size: 56, color: Colors.white70),
      ),
    );
  }

  /// Kanal avatar:
  /// - Agar URL bo‘lsa rasm
  /// - bo‘lmasa harfli avatar
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
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  /// Shorts uchun markaziy play overlay
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
        // VIDEO TURI BO‘YICHA NAVIGATSIYA

        if (video.isShort) {
          // Shorts screen ochiladi
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
          // Oddiy video player
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPlayerScreen(video: video),
            ),
          );
        }
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // THUMBNAIL + OVERLAY
          Stack(
            children: [
              _buildThumbnail(thumbHeight),

              // Shorts bo‘lsa play icon chiqadi
              if (video.isShort) _buildShortPlayOverlay(),

              // Duration badge
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    video.duration.isNotEmpty ? video.duration : '0:00',
                    style:
                    const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),

              // Shorts label
              if (video.isShort)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'Shorts',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),

          // VIDEO INFO SECTION
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(),

                const SizedBox(width: 10),

                // Title + meta data
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),

                      Text(
                        '${video.channel} • ${video.views} • ${video.date}',
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 11),
                      ),
                    ],
                  ),
                ),

                Icon(Icons.more_vert,
                    color: Colors.grey[500], size: 20),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

/// =========================
/// HORIZONTAL VIDEO CARD
/// (Library, History uchun)
/// =========================
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
      );
    }

    return Container(
      width: 130,
      height: 78,
      color: Colors.grey[300],
      child: const Icon(Icons.play_circle_outline),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Oddiy video player ochiladi
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(video: video),
          ),
        );
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildThumbnail(),
            ),

            const SizedBox(width: 10),

            // TEXT INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
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

            Icon(Icons.more_vert,
                color: Colors.grey[400], size: 18),
          ],
        ),
      ),
    );
  }
}