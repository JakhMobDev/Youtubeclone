import 'package:flutter/material.dart';
import 'package:f1/screens/SearchScreen.dart';

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

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: showLogo
          ? Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 4),
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
        title ?? '',
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        if (extraActions != null) ...extraActions!,
        IconButton(
          icon: const Icon(Icons.cast, color: Colors.black, size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black, size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black, size: 22),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF1565C0),
              child: Text('A', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ),
        ),
      ],
    );
  }
}