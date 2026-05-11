import 'package:flutter/material.dart';
import 'package:f1/screens/SearchScreen.dart';

/// ==============================
/// CUSTOM YOUTUBE TOP BAR
/// ==============================
/// Bu AppBar YouTube dizaynini qayta yaratadi.
/// Qayta ishlatiladigan (reusable) komponent:
/// - Home screen (logo bilan)
/// - Library / Subscriptions (title bilan)
class YouTubeTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final List<Widget>? extraActions;

  const YouTubeTopBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.extraActions,
  });

  /// AppBar balandligini Flutter ga bildiradi
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // shadow yo‘q (flat design)

      /// title chapdan biroz suriladi
      titleSpacing: 16,

      /// =========================
      /// TITLE SECTION
      /// =========================
      title: showLogo
          ? Row(
        children: [
          /// YouTube logo (custom red play icon)
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 4),

          /// App nomi
          const Text(
            'YouTube',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
        ],
      )
          : Text(
        /// Agar logo yo‘q bo‘lsa oddiy title chiqadi
        title ?? '',
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      /// =========================
      /// ACTION ICONS (RIGHT SIDE)
      /// =========================
      actions: [
        /// Tashqaridan qo‘shimcha action qo‘shish imkoniyati
        if (extraActions != null) ...extraActions!,

        /// Cast → TV ga ulash
        IconButton(
          icon: const Icon(Icons.cast, color: Colors.black, size: 22),
          onPressed: () {
            // future: cast logic
          },
        ),

        /// Notifications → bildirishnomalar
        IconButton(
          icon: const Icon(Icons.notifications_outlined,
              color: Colors.black, size: 22),
          onPressed: () {
            // notifications screen
          },
        ),

        /// Search → qidiruv sahifasiga o'tish
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black, size: 22),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          ),
        ),

        /// Profil avatar
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              // profil screen ochiladi (future)
            },
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF1565C0),
              child: Text(
                'A',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }
}