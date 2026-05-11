import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';

/// Download qilingan videolar sahifasi
class DownloadsScreen extends StatelessWidget {

  /// Constructor
  const DownloadsScreen({super.key});

  /// Thumbnail widget
  /// Agar URL mavjud bo‘lsa rasm chiqaradi
  /// Aks holda oddiy placeholder ko‘rsatadi
  Widget _buildThumbnail(VideoModel v) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),

      child: Stack(
        children: [

          // Agar thumbnail URL bo‘lsa
          v.thumbnail.startsWith('http')

          // Internetdan rasm yuklash
              ? Image.network(
            v.thumbnail,
            width: 120,
            height: 70,
            fit: BoxFit.cover,

            // Rasm yuklanmasa placeholder chiqaradi
            errorBuilder: (_, __, ___) => Container(
              width: 120,
              height: 70,
              color: Colors.grey[300],

              child: const Center(
                child: Icon(
                  Icons.play_circle_outline,
                  color: Colors.white70,
                  size: 30,
                ),
              ),
            ),
          )

          // URL bo‘lmasa oddiy container
              : Container(
            width: 120,
            height: 70,
            color: Colors.grey[300],

            child: const Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white70,
                size: 30,
              ),
            ),
          ),

          // Video davomiyligi
          Positioned(
            bottom: 4,
            right: 4,

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 1,
              ),

              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(3),
              ),

              child: Text(
                v.duration,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // Sahifa orqa fon rangi
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // Orqaga qaytish tugmasi
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),

          onPressed: () => Navigator.pop(context),
        ),

        // Sarlavha
        title: const Text(
          'Downloads',

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        // O‘ng tomondagi iconlar
        actions: [

          // Cast icon
          IconButton(
            icon: const Icon(
              Icons.cast,
              color: Colors.black,
            ),
            onPressed: () {},
          ),

          // Notification icon
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),

          // Search icon
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {},
          ),

          // Profil rasmi
          const Padding(
            padding: EdgeInsets.only(right: 8),

            child: CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF1565C0),

              child: Text(
                'A',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),

      // Body qismi
      body: Column(
        children: [

          // Storage haqida ma'lumot
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),

            child: Row(
              children: [

                // Storage icon
                const Icon(
                  Icons.storage,
                  color: Colors.grey,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      // Storage title
                      const Text(
                        'Storage used',

                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Progress bar
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(4),

                        child: LinearProgressIndicator(
                          value: 0.35,
                          backgroundColor:
                          Colors.grey[200],

                          color: Colors.red,
                          minHeight: 6,
                        ),
                      ),

                      const SizedBox(height: 3),

                      // Storage info text
                      Text(
                        '1.2 GB of 3.5 GB used',

                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Downloaded videos title
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),

            child: Row(
              children: [

                Text(
                  'Downloaded videos',

                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),

                const Spacer(),

                // Video soni
                Text(
                  '${AppData.videos.length} videos',

                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Video list
          Expanded(
            child: ListView.builder(

              // List elementlari soni
              itemCount: AppData.videos.length,

              itemBuilder: (context, index) {

                // Hozirgi video
                final v = AppData.videos[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),

                  child: Row(
                    children: [

                      // Thumbnail
                      _buildThumbnail(v),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            // Video title
                            Text(
                              v.title,

                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),

                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 3),

                            // Channel name
                            Text(
                              v.channel,

                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),

                            const SizedBox(height: 2),

                            // Download status
                            Row(
                              children: [

                                const Icon(
                                  Icons.download_done,
                                  color: Colors.green,
                                  size: 13,
                                ),

                                const SizedBox(width: 3),

                                Text(
                                  'Downloaded',

                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // More button
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.grey[400],
                          size: 18,
                        ),

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