import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:f1/models/AppData.dart';

/// ShortsScreen
/// YouTube Shorts sahifasi
/// Vertical scroll orqali shorts videolarni ko‘rsatadi
class ShortsScreen extends StatefulWidget {

  /// Boshlanish index
  final int startIndex;

  /// Tashqaridan keladigan shorts list
  final List<VideoModel>? initialShorts;

  /// Constructor
  const ShortsScreen({
    super.key,
    this.startIndex = 0,
    this.initialShorts,
  });

  @override
  State<ShortsScreen> createState() =>
      _ShortsScreenState();
}

/// ShortsScreen state qismi
class _ShortsScreenState
    extends State<ShortsScreen> {

  /// Vertical PageView controller
  late final PageController _pageController;

  /// Shorts videolar ro‘yxati
  late List<VideoModel> _shorts;

  /// Hozirgi video index
  int _currentIndex = 0;

  /// Like holati
  bool _isLiked = false;

  /// Har bir short uchun YouTube controller
  final Map<int, YoutubePlayerController>
  _controllers = {};

  @override
  void initState() {
    super.initState();

    /// Agar tashqaridan list kelgan bo‘lsa ishlatadi
    /// bo‘lmasa AppData dagi shorts ishlatiladi
    _shorts =
        widget.initialShorts ?? AppData.shorts;

    /// PageView controller
    _pageController = PageController(
      initialPage: widget.startIndex,
    );

    /// Hozirgi index
    _currentIndex = widget.startIndex;

    /// Birinchi videoni yuklaydi
    _initController(
      _currentIndex,
      autoPlay: true,
    );

    /// Keyingi videoni oldindan yuklaydi
    if (_currentIndex + 1 < _shorts.length) {
      _initController(_currentIndex + 1);
    }
  }

  /// Video controller yaratish
  void _initController(
      int index, {
        bool autoPlay = false,
      }) {

    /// Agar controller mavjud bo‘lsa qaytadi
    if (_controllers.containsKey(index)) {
      return;
    }

    /// Hozirgi short
    final short = _shorts[index];

    /// Agar video ID mavjud bo‘lsa
    if (short.id.isNotEmpty) {

      /// YouTube controller yaratadi
      final controller =
      YoutubePlayerController(

        initialVideoId: short.id,

        flags: YoutubePlayerFlags(

          /// Auto play
          autoPlay: autoPlay,

          /// Mute
          mute: false,

          /// Loop
          loop: true,

          /// Control tugmalarini yashiradi
          hideControls: true,

          /// HD majburiy emas
          forceHD: false,

          /// Caption o‘chiq
          enableCaption: false,
        ),
      );

      /// Auto play yoqilgan bo‘lsa
      if (autoPlay) {

        controller.addListener(() {

          /// Video tayyor bo‘lsa play qiladi
          if (controller.value.isReady &&
              !controller.value.isPlaying) {

            controller.play();
          }
        });
      }

      /// Controller saqlanadi
      _controllers[index] = controller;
    }
  }

  /// Page o‘zgarganda ishlaydi
  void _onPageChanged(int index) {

    /// Eski videoni pause qiladi
    _controllers[_currentIndex]?.pause();

    setState(() {

      /// Yangi index
      _currentIndex = index;

      /// Like reset bo‘ladi
      _isLiked = false;
    });

    /// Yangi video controller
    _initController(
      index,
      autoPlay: true,
    );

    /// Video play qilish
    Future.delayed(
      const Duration(milliseconds: 300),
          () {

        if (mounted) {

          _controllers[index]?.play();
        }
      },
    );

    /// Keyingi videoni preload qiladi
    if (index + 1 < _shorts.length) {
      _initController(index + 1);
    }
  }

  @override
  void dispose() {

    /// Hozirgi videoni pause qiladi
    _controllers[_currentIndex]?.pause();

    /// Page controller dispose
    _pageController.dispose();

    /// Barcha video controllerlarni tozalaydi
    for (var c in _controllers.values) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// Ekran o‘lchami
    final screenSize =
        MediaQuery.of(context).size;

    return WillPopScope(

      /// Orqaga chiqilganda video pause bo‘ladi
      onWillPop: () async {

        _controllers[_currentIndex]?.pause();

        return true;
      },

      child: Scaffold(

        backgroundColor: Colors.black,

        // ───────────────── PAGE VIEW ─────────────────

        body: PageView.builder(

          controller: _pageController,

          /// Vertical scroll
          scrollDirection: Axis.vertical,

          /// Page o‘zgarganda
          onPageChanged: _onPageChanged,

          /// Shorts soni
          itemCount: _shorts.length,

          itemBuilder: (context, index) {

            /// Hozirgi short
            final short = _shorts[index];

            /// Hozirgi controller
            final controller =
            _controllers[index];

            return Stack(
              fit: StackFit.expand,

              children: [

                // ───────────────── VIDEO PLAYER ─────────────────

                if (controller != null)

                  YoutubePlayerBuilder(

                    player: YoutubePlayer(

                      controller: controller,

                      /// Progress yashirilgan
                      showVideoProgressIndicator:
                      false,
                    ),

                    builder: (ctx, player) {

                      return SizedBox.expand(

                        child: OverflowBox(
                          maxWidth: double.infinity,
                          maxHeight: double.infinity,

                          child: SizedBox(

                            /// 9:16 ratio
                            width:
                            screenSize.height *
                                9 /
                                16,

                            height:
                            screenSize.height,

                            child: player,
                          ),
                        ),
                      );
                    },
                  )

                // ───────────────── THUMBNAIL ─────────────────

                else

                  short.thumbnail
                      .startsWith('http')

                      ? Image.network(

                    short.thumbnail,

                    fit: BoxFit.cover,

                    width: double.infinity,
                    height: double.infinity,

                    /// Rasm yuklanmasa
                    errorBuilder:
                        (_, __, ___) {

                      return Container(
                        color:
                        Colors.grey[900],
                      );
                    },
                  )

                      : Container(
                    color: Colors.grey[900],
                  ),

                // ───────────────── GRADIENT ─────────────────

                Container(
                  decoration: const BoxDecoration(

                    gradient: LinearGradient(

                      begin: Alignment.topCenter,
                      end:
                      Alignment.bottomCenter,

                      colors: [
                        Colors.transparent,
                        Colors.black87,
                      ],

                      stops: [0.5, 1.0],
                    ),
                  ),
                ),

                // ───────────────── TOP BAR ─────────────────

                Positioned(

                  top:
                  MediaQuery.of(context)
                      .padding
                      .top +
                      8,

                  left: 16,
                  right: 16,

                  child: Row(
                    children: [

                      /// Back button
                      IconButton(

                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),

                        onPressed: () {

                          /// Video pause
                          _controllers[
                          _currentIndex]
                              ?.pause();

                          Navigator.pop(context);
                        },
                      ),

                      /// Shorts icon
                      const Icon(
                        Icons.bolt,
                        color: Colors.white,
                        size: 22,
                      ),

                      const SizedBox(width: 4),

                      /// Shorts text
                      const Text(
                        'Shorts',

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),

                      const Spacer(),

                      /// Current index
                      Text(
                        '${index + 1}/${_shorts.length}',

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),

                      /// Search button
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),

                      /// More button
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // ───────────────── RIGHT ACTIONS ─────────────────

                Positioned(
                  right: 12,
                  bottom: 100,

                  child: Column(
                    children: [

                      /// Like button
                      _actionButton(

                        icon: _isLiked
                            ? Icons.thumb_up
                            : Icons
                            .thumb_up_outlined,

                        label: '24K',

                        onTap: () {

                          setState(() {
                            _isLiked = !_isLiked;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Dislike button
                      _actionButton(
                        icon: Icons
                            .thumb_down_outlined,
                        label: 'Dislike',
                        onTap: () {},
                      ),

                      const SizedBox(height: 20),

                      /// Comment button
                      _actionButton(
                        icon:
                        Icons.comment_outlined,
                        label: 'Comment',
                        onTap: () {},
                      ),

                      const SizedBox(height: 20),

                      /// Share button
                      _actionButton(
                        icon: Icons.reply,
                        label: 'Share',
                        onTap: () {},
                      ),

                      const SizedBox(height: 20),

                      /// More button
                      _actionButton(
                        icon: Icons.more_horiz,
                        label: 'More',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // ───────────────── BOTTOM INFO ─────────────────

                Positioned(
                  left: 16,
                  right: 70,
                  bottom: 80,

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Row(
                        children: [

                          /// Channel avatar
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                            Colors.red,

                            child: Text(

                              short.channel
                                  .isNotEmpty
                                  ? short.channel[0]
                                  : '?',

                              style:
                              const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// Channel name
                          Expanded(
                            child: Text(

                              short.channel,

                              style:
                              const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 13,
                              ),

                              overflow:
                              TextOverflow
                                  .ellipsis,
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// Subscribe button
                          Container(

                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),

                            decoration:
                            BoxDecoration(

                              border: Border.all(
                                color: Colors.white,
                              ),

                              borderRadius:
                              BorderRadius
                                  .circular(20),
                            ),

                            child: const Text(
                              'Subscribe',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// Video title
                      Text(

                        short.title,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),

                        maxLines: 2,

                        overflow:
                        TextOverflow.ellipsis,
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

  // ───────────────── ACTION BUTTON ─────────────────

  /// O‘ng tomondagi action button widget
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: Column(
        children: [

          /// Icon
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),

          const SizedBox(height: 2),

          /// Text
          Text(
            label,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}