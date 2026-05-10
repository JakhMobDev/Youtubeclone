import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  // Thumbnail — URL bo'lsa rasm, bo'lmasa rang
  Widget _buildThumbnail(VideoModel v) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          v.thumbnail.startsWith('http')
              ? Image.network(
            v.thumbnail,
            width: 120,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 120,
              height: 70,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.play_circle_outline,
                    color: Colors.white70, size: 30),
              ),
            ),
          )
              : Container(
            width: 120,
            height: 70,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.play_circle_outline,
                  color: Colors.white70, size: 30),
            ),
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
              child: Text(v.duration,
                  style: const TextStyle(color: Colors.white, fontSize: 9)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Downloads',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        actions: [
          IconButton(
              icon: const Icon(Icons.cast, color: Colors.black), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.black),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF1565C0),
              child: Text('A', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Storage info
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.storage, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Storage used',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.35,
                          backgroundColor: Colors.grey[200],
                          color: Colors.red,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text('1.2 GB of 3.5 GB used',
                          style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('Downloaded videos',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                const Spacer(),
                Text('${AppData.videos.length} videos',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: AppData.videos.length,
              itemBuilder: (context, index) {
                final v = AppData.videos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      _buildThumbnail(v),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 3),
                            Text(v.channel,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 11)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.download_done,
                                    color: Colors.green, size: 13),
                                const SizedBox(width: 3),
                                Text('Downloaded',
                                    style: TextStyle(
                                        color: Colors.green[700], fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert,
                            color: Colors.grey[400], size: 18),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}