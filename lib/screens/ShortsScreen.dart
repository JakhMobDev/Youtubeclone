import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:f1/models/AppData.dart';

class ShortsScreen extends StatefulWidget {
  final int startIndex;
  final List<VideoModel>? initialShorts;

  const ShortsScreen({
    super.key,
    this.startIndex = 0,
    this.initialShorts,
  });

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  late final PageController _pageController;
  late List<VideoModel> _shorts;
  int _currentIndex = 0;
  bool _isLiked = false;
  final Map<int, YoutubePlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _shorts = widget.initialShorts ?? AppData.shorts;
    _pageController = PageController(initialPage: widget.startIndex);
    _currentIndex = widget.startIndex;
    _initController(_currentIndex, autoPlay: true);
    // Keyingi video oldindan yuklansin
    if (_currentIndex + 1 < _shorts.length) {
      _initController(_currentIndex + 1);
    }
  }

  void _initController(int index, {bool autoPlay = false}) {
    if (_controllers.containsKey(index)) return;
    final short = _shorts[index];
    if (short.id.isNotEmpty) {
      final controller = YoutubePlayerController(
        initialVideoId: short.id,
        flags: YoutubePlayerFlags(
          autoPlay: autoPlay,
          mute: false,
          loop: true,
          hideControls: true,
          forceHD: false,
          enableCaption: false,
        ),
      );
      if (autoPlay) {
        controller.addListener(() {
          if (controller.value.isReady && !controller.value.isPlaying) {
            controller.play();
          }
        });
      }
      _controllers[index] = controller;
    }
  }

  void _onPageChanged(int index) {
    _controllers[_currentIndex]?.pause();
    setState(() {
      _currentIndex = index;
      _isLiked = false;
    });
    _initController(index, autoPlay: true);
    // Allaqachon yaratilgan controller bo'lsa play qilish
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controllers[index]?.play();
    });
    if (index + 1 < _shorts.length) {
      _initController(index + 1);
    }
  }

  @override
  void dispose() {
    // Orqaga ketishda video to'xtatiladi
    _controllers[_currentIndex]?.pause();
    _pageController.dispose();
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        // Orqaga ketishda videoni to'xtatish
        _controllers[_currentIndex]?.pause();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: _onPageChanged,
          itemCount: _shorts.length,
          itemBuilder: (context, index) {
            final short = _shorts[index];
            final controller = _controllers[index];

            return Stack(
              fit: StackFit.expand,
              children: [
                // ✅ Video to'liq ekran
                if (controller != null)
                  YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: controller,
                      showVideoProgressIndicator: false,
                    ),
                    builder: (ctx, player) {
                      return SizedBox.expand(
                        child: OverflowBox(
                          maxWidth: double.infinity,
                          maxHeight: double.infinity,
                          child: SizedBox(
                            // Ekran balandligiga mos kenglik hisoblash (9:16 nisbat)
                            width: screenSize.height * 9 / 16,
                            height: screenSize.height,
                            child: player,
                          ),
                        ),
                      );
                    },
                  )
                else
                // Thumbnail (video yuklanmagan vaqt)
                  short.thumbnail.startsWith('http')
                      ? Image.network(
                    short.thumbnail,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey[900]),
                  )
                      : Container(color: Colors.grey[900]),

                // Gradient overlay
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),

                // Top bar
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      IconButton(
                        icon:
                        const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          _controllers[_currentIndex]?.pause();
                          Navigator.pop(context);
                        },
                      ),
                      const Icon(Icons.bolt, color: Colors.white, size: 22),
                      const SizedBox(width: 4),
                      const Text(
                        'Shorts',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      const Spacer(),
                      Text(
                        '${index + 1}/${_shorts.length}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13),
                      ),
                      IconButton(
                        icon:
                        const Icon(Icons.search, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert,
                            color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Right actions
                Positioned(
                  right: 12,
                  bottom: 100,
                  child: Column(
                    children: [
                      _actionButton(
                        icon: _isLiked
                            ? Icons.thumb_up
                            : Icons.thumb_up_outlined,
                        label: '24K',
                        onTap: () =>
                            setState(() => _isLiked = !_isLiked),
                      ),
                      const SizedBox(height: 20),
                      _actionButton(
                        icon: Icons.thumb_down_outlined,
                        label: 'Dislike',
                        onTap: () {},
                      ),
                      const SizedBox(height: 20),
                      _actionButton(
                        icon: Icons.comment_outlined,
                        label: 'Comment',
                        onTap: () {},
                      ),
                      const SizedBox(height: 20),
                      _actionButton(
                        icon: Icons.reply,
                        label: 'Share',
                        onTap: () {},
                      ),
                      const SizedBox(height: 20),
                      _actionButton(
                        icon: Icons.more_horiz,
                        label: 'More',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // Bottom info
                Positioned(
                  left: 16,
                  right: 70,
                  bottom: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.red,
                            child: Text(
                              short.channel.isNotEmpty
                                  ? short.channel[0]
                                  : '?',
                              style:
                              const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              short.channel,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Subscribe',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        short.title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}