import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:f1/models/AppData.dart';

/// ShortsScreen
/// YouTube Shorts sahifasi — to'liq tuzatilgan versiya
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

class _ShortsScreenState extends State<ShortsScreen>
    with WidgetsBindingObserver {

  late final PageController _pageController;
  late List<VideoModel> _shorts;
  int _currentIndex = 0;
  bool _isLiked = false;

  /// Har bir short uchun controller
  final Map<int, YoutubePlayerController> _controllers = {};

  /// Listener reference — dispose uchun
  final Map<int, VoidCallback> _listeners = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // ✅ initialShorts bo'sh yoki null bo'lsa AppData ishlatiladi
    _shorts = (widget.initialShorts?.isNotEmpty == true)
        ? widget.initialShorts!
        : AppData.shorts;

    _currentIndex = widget.startIndex.clamp(0, _shorts.length - 1);

    _pageController = PageController(initialPage: _currentIndex);

    // Widget build bo'lgandan keyin controller ishga tushadi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initController(_currentIndex, autoPlay: true);

      if (_currentIndex + 1 < _shorts.length) {
        _initController(_currentIndex + 1);
      }
    });
  }

  // ───────────────── APP LIFECYCLE ─────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controllers[_currentIndex]?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _controllers[_currentIndex]?.play();
    }
  }

  // ───────────────── CONTROLLER ─────────────────

  void _initController(int index, {bool autoPlay = false}) {
    // Mavjud bo'lsa qaytadi
    if (_controllers.containsKey(index)) {
      if (autoPlay) {
        _controllers[index]?.play();
      }
      return;
    }

    if (index < 0 || index >= _shorts.length) return;

    final short = _shorts[index];

    // ✅ ID bo'sh bo'lsa log chiqar va skip
    if (short.id.isEmpty) {
      debugPrint('⚠️ Short[$index] id bo\'sh: "${short.title}"');
      return;
    }

    debugPrint('🎬 Controller[$index] yaratildi: ${short.id}');

    final controller = YoutubePlayerController(
      initialVideoId: short.id,
      flags: YoutubePlayerFlags(
        autoPlay: false, // biz o'zimiz play qilamiz
        mute: false,
        loop: true,
        hideControls: true,
        forceHD: false,
        enableCaption: false,
      ),
    );

    // isReady bo'lguncha kutib play qiladi
    if (autoPlay) {
      bool hasStarted = false;

      void listener() {
        if (!hasStarted && controller.value.isReady) {
          hasStarted = true;
          controller.play();
          debugPrint('▶️ isReady → play() [$index]');
        }
      }

      controller.addListener(listener);
      _listeners[index] = listener;
    }

    _controllers[index] = controller;
  }

  // ───────────────── PAGE CHANGE ─────────────────

  void _onPageChanged(int index) {
    // Eski video pause
    _controllers[_currentIndex]?.pause();

    setState(() {
      _currentIndex = index;
      _isLiked = false;
    });

    // Yangi controller
    _initController(index, autoPlay: true);

    // Kichik delay bilan play
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _controllers[index]?.play();
      }
    });

    // Preload: keyingi va oldingi
    if (index + 1 < _shorts.length) _initController(index + 1);
    if (index - 1 >= 0) _initController(index - 1);

    // Uzoq controllerlarni tozalash (xotira tejash)
    _disposeDistantControllers(index);
  }

  /// 3+ page uzoqdagi controllerlarni dispose qiladi
  void _disposeDistantControllers(int currentIndex) {
    final toDispose = _controllers.keys
        .where((i) => (i - currentIndex).abs() > 3)
        .toList();

    for (final i in toDispose) {
      final listener = _listeners.remove(i);
      if (listener != null) {
        _controllers[i]?.removeListener(listener);
      }
      _controllers[i]?.dispose();
      _controllers.remove(i);
      debugPrint('🗑️ Controller[$i] dispose edildi');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controllers[_currentIndex]?.pause();
    _pageController.dispose();

    // Barcha listenerlarni olib tashlash
    for (final entry in _listeners.entries) {
      _controllers[entry.key]?.removeListener(entry.value);
    }
    _listeners.clear();

    // Barcha controllerlarni dispose
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();

    super.dispose();
  }

  // ───────────────── BUILD ─────────────────

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // ✅ Shorts bo'sh bo'lsa xabar ko'rsatadi
    if (_shorts.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Shorts topilmadi',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        _controllers[_currentIndex]?.pause();
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

                // ───── VIDEO PLAYER ─────
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
                            width: screenSize.height * 9 / 16,
                            height: screenSize.height,
                            child: player,
                          ),
                        ),
                      );
                    },
                  )

                // ───── THUMBNAIL (controller yo'q bo'lganda) ─────
                else
                  _buildThumbnail(short),

                // ───── GRADIENT ─────
                _buildGradient(),

                // ───── TOP BAR ─────
                _buildTopBar(context, index),

                // ───── RIGHT ACTIONS ─────
                _buildRightActions(),

                // ───── BOTTOM INFO ─────
                _buildBottomInfo(short),
              ],
            );
          },
        ),
      ),
    );
  }

  // ───────────────── THUMBNAIL ─────────────────

  Widget _buildThumbnail(VideoModel short) {
    if (short.thumbnail.startsWith('http')) {
      return Image.network(
        short.thumbnail,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white30,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) {
          return Container(color: Colors.grey[900]);
        },
      );
    }
    return Container(color: Colors.grey[900]);
  }

  // ───────────────── GRADIENT ─────────────────

  Widget _buildGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black87,
          ],
          stops: [0.5, 1.0],
        ),
      ),
    );
  }

  // ───────────────── TOP BAR ─────────────────

  Widget _buildTopBar(BuildContext context, int index) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              fontSize: 17,
            ),
          ),
          const Spacer(),
          Text(
            '${index + 1}/${_shorts.length}',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ───────────────── RIGHT ACTIONS ─────────────────

  Widget _buildRightActions() {
    return Positioned(
      right: 12,
      bottom: 100,
      child: Column(
        children: [
          _actionButton(
            icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            label: '24K',
            onTap: () => setState(() => _isLiked = !_isLiked),
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
    );
  }

  // ───────────────── BOTTOM INFO ─────────────────

  Widget _buildBottomInfo(VideoModel short) {
    return Positioned(
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
                  short.channel.isNotEmpty ? short.channel[0] : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  short.channel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Subscribe',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            short.title,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ───────────────── ACTION BUTTON ─────────────────

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
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}