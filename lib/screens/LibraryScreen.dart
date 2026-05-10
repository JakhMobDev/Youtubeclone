import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/widgets/YouTubeTopBar.dart';
import 'package:f1/screens/HistoryScreen.dart';
import 'package:f1/screens/DownloadsScreen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const YouTubeTopBar(title: 'Library', showLogo: false),
      body: ListView(
        children: [
          // Quick access
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _quickTile(context, Icons.history, 'History', const HistoryScreen()),
                const SizedBox(width: 12),
                _quickTile(context, Icons.inbox_outlined, 'Your inbox', null),
                const SizedBox(width: 12),
                _quickTile(context, Icons.watch_later_outlined, 'Watch later', null),
                const SizedBox(width: 12),
                _quickTile(context, Icons.download_outlined, 'Downloads', const DownloadsScreen()),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          // Playlists
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Playlists',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                TextButton(
                  onPressed: () {},
                  child: const Text('Recently added',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ],
            ),
          ),
          // New playlist
          ListTile(
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.add, color: Colors.black54),
            ),
            title: const Text('New Playlist',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            subtitle: Text('0 videos',
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            trailing: Icon(Icons.more_vert, color: Colors.grey[400]),
          ),
          // Liked videos playlist — Color o'rniga URL
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AppData.videos[0].thumbnail.startsWith('http')
                  ? Image.network(
                AppData.videos[0].thumbnail,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 52,
                  height: 52,
                  color: Colors.grey[300],
                  child: const Icon(Icons.thumb_up, color: Colors.white70),
                ),
              )
                  : Container(
                width: 52,
                height: 52,
                color: Colors.grey[300],
                child: const Icon(Icons.thumb_up, color: Colors.white70),
              ),
            ),
            title: const Text('Liked Videos',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            subtitle: Text('47 videos',
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            trailing: Icon(Icons.more_vert, color: Colors.grey[400]),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          // Recently watched
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
            child: Text('Recently watched',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          ...AppData.videos.take(3).map((v) => HorizontalVideoCard(video: v)),
        ],
      ),
    );
  }

  Widget _quickTile(BuildContext context, IconData icon, String label, Widget? screen) {
    return Expanded(
      child: GestureDetector(
        onTap: screen != null
            ? () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => screen))
            : null,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black87, size: 26),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
                maxLines: 2),
          ],
        ),
      ),
    );
  }
}