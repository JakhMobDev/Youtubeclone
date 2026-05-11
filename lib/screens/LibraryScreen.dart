import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/widgets/YouTubeTopBar.dart';
import 'package:f1/screens/HistoryScreen.dart';
import 'package:f1/screens/DownloadsScreen.dart';

/// LibraryScreen
/// YouTube Library sahifasi
/// Playlistlar, History, Downloads va Recently Watched qismlarini chiqaradi
class LibraryScreen extends StatelessWidget {

  /// Constructor
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /// Sahifa orqa fon rangi
      backgroundColor: Colors.white,

      /// Custom AppBar
      appBar: const YouTubeTopBar(
        title: 'Library',
        showLogo: false,
      ),

      /// Body qismi
      body: ListView(
        children: [

          // ───────────────── QUICK ACCESS ─────────────────

          /// Tez kirish tugmalari
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),

            child: Row(
              children: [

                /// History tugmasi
                _quickTile(
                  context,
                  Icons.history,
                  'History',
                  const HistoryScreen(),
                ),

                const SizedBox(width: 12),

                /// Inbox tugmasi
                _quickTile(
                  context,
                  Icons.inbox_outlined,
                  'Your inbox',
                  null,
                ),

                const SizedBox(width: 12),

                /// Watch later tugmasi
                _quickTile(
                  context,
                  Icons.watch_later_outlined,
                  'Watch later',
                  null,
                ),

                const SizedBox(width: 12),

                /// Downloads tugmasi
                _quickTile(
                  context,
                  Icons.download_outlined,
                  'Downloads',
                  const DownloadsScreen(),
                ),
              ],
            ),
          ),

          /// Divider
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          // ───────────────── PLAYLISTS TITLE ─────────────────

          Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              16,
              12,
              8,
            ),

            child: Row(

              /// Ikki tomonlama joylash
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                /// Playlists title
                const Text(
                  'Playlists',

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                /// Recently added button
                TextButton(

                  onPressed: () {},

                  child: const Text(
                    'Recently added',

                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ───────────────── NEW PLAYLIST ─────────────────

          ListTile(

            /// Chapdagi icon qismi
            leading: Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                color: Colors.grey[200],

                borderRadius:
                BorderRadius.circular(4),
              ),

              child: const Icon(
                Icons.add,
                color: Colors.black54,
              ),
            ),

            /// Playlist nomi
            title: const Text(
              'New Playlist',

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            /// Playlist videos soni
            subtitle: Text(
              '0 videos',

              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),

            /// More button
            trailing: Icon(
              Icons.more_vert,
              color: Colors.grey[400],
            ),
          ),

          // ───────────────── LIKED VIDEOS ─────────────────

          ListTile(

            /// Thumbnail qismi
            leading: ClipRRect(

              borderRadius:
              BorderRadius.circular(4),

              child: AppData
                  .videos[0]
                  .thumbnail
                  .startsWith('http')

              /// Agar URL mavjud bo‘lsa
                  ? Image.network(

                AppData
                    .videos[0]
                    .thumbnail,

                width: 52,
                height: 52,
                fit: BoxFit.cover,

                /// Rasm yuklanmasa
                errorBuilder:
                    (_, __, ___) {

                  return Container(
                    width: 52,
                    height: 52,
                    color:
                    Colors.grey[300],

                    child: const Icon(
                      Icons.thumb_up,
                      color:
                      Colors.white70,
                    ),
                  );
                },
              )

              /// URL bo‘lmasa
                  : Container(
                width: 52,
                height: 52,
                color: Colors.grey[300],

                child: const Icon(
                  Icons.thumb_up,
                  color: Colors.white70,
                ),
              ),
            ),

            /// Playlist nomi
            title: const Text(
              'Liked Videos',

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            /// Video soni
            subtitle: Text(
              '47 videos',

              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),

            /// More button
            trailing: Icon(
              Icons.more_vert,
              color: Colors.grey[400],
            ),
          ),

          /// Divider
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          // ───────────────── RECENTLY WATCHED ─────────────────

          /// Recently watched title
          const Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              16,
              12,
              8,
            ),

            child: Text(
              'Recently watched',

              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),

          /// Oxirgi ko‘rilgan videolar
          ...AppData.videos

          /// Faqat 3 ta video oladi
              .take(3)

          /// Har bir video uchun card yaratadi
              .map(
                (v) =>
                HorizontalVideoCard(
                  video: v,
                ),
          ),
        ],
      ),
    );
  }

  /// Quick access button widget
  ///
  /// icon  -> icon turi
  /// label -> text
  /// screen -> ochiladigan screen
  Widget _quickTile(
      BuildContext context,
      IconData icon,
      String label,
      Widget? screen,
      ) {

    return Expanded(

      child: GestureDetector(

        /// Screen mavjud bo‘lsa ochadi
        onTap: screen != null

            ? () => Navigator.push(

          context,

          MaterialPageRoute(
            builder: (_) => screen,
          ),
        )

            : null,

        child: Column(
          children: [

            // ───────────────── ICON BOX ─────────────────

            Container(
              width: 56,
              height: 56,

              decoration: BoxDecoration(
                color: Colors.grey[100],

                borderRadius:
                BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color: Colors.black87,
                size: 26,
              ),
            ),

            const SizedBox(height: 6),

            // ───────────────── LABEL ─────────────────

            Text(
              label,

              style: const TextStyle(
                fontSize: 11,
              ),

              textAlign: TextAlign.center,

              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}