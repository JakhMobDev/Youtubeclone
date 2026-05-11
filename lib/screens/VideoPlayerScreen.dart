import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/screens/ShortsScreen.dart';

/// VideoPlayerScreen
/// Oddiy YouTube video player sahifasi
class VideoPlayerScreen extends StatefulWidget {

  /// Tanlangan video
  final VideoModel video;

  /// Short video ekanligini bildiradi
  final bool isShort;

  const VideoPlayerScreen({
    super.key,
    required this.video,
    this.isShort = false,
  });

  @override
  State<VideoPlayerScreen> createState() =>
      _VideoPlayerScreenState();
}

class _VideoPlayerScreenState
    extends State<VideoPlayerScreen> {

  /// YouTube player controller
  YoutubePlayerController? _controller;

  /// Player ishga tushganmi
  /// false bo‘lsa thumbnail chiqadi
  bool _playerReady = false;

  /// Like holati
  bool _isLiked = false;

  /// Dislike holati
  bool _isDisliked = false;

  /// Save holati
  bool _isSaved = false;

  // ───────────────── PLAYER START ─────────────────

  /// Foydalanuvchi play bosganda
  /// player yaratiladi va video yuklanadi
  void _startPlayer() {

    /// Agar controller mavjud bo‘lsa
    /// qayta yaratmaydi
    if (_controller != null) return;

    setState(() {

      /// YouTube controller yaratish
      _controller = YoutubePlayerController(

        /// Video ID
        initialVideoId: widget.video.id,

        flags: const YoutubePlayerFlags(

          /// Video avtomatik boshlanadi
          autoPlay: true,

          /// Ovoz yoqilgan
          mute: false,

          /// Player control ko‘rinadi
          hideControls: false,

          /// Caption o‘chiq
          enableCaption: false,
        ),
      );

      /// Player tayyor bo‘ldi
      _playerReady = true;
    });
  }

  @override
  void dispose() {

    /// Controller xotiradan tozalanadi
    _controller?.dispose();

    super.dispose();
  }

  // ───────────────── CHANNEL AVATAR ─────────────────

  /// Kanal avatarini chiqaradi
  Widget _buildAvatar() {

    /// Agar avatar URL bo‘lsa
    if (widget.video.avatarColor
        .startsWith('http')) {

      return CircleAvatar(
        radius: 18,

        backgroundImage: NetworkImage(
          widget.video.avatarColor,
        ),
      );
    }

    /// Aks holda oddiy rangli avatar
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.red,

      child: Text(

        /// Kanal nomining birinchi harfi
        widget.video.channel.isNotEmpty
            ? widget.video.channel[0]
            .toUpperCase()
            : '?',

        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // ───────────────── THUMBNAIL PLAYER ─────────────────

  /// Player hali yuklanmagan paytda
  /// thumbnail va play button chiqadi
  Widget _buildThumbnailPlayer() {

    return GestureDetector(

      /// Bosilganda player boshlanadi
      onTap: _startPlayer,

      child: Container(

        width: double.infinity,
        height: 220,
        color: Colors.black,

        child: Stack(
          fit: StackFit.expand,

          children: [

            // ───────── THUMBNAIL ─────────

            if (widget.video.thumbnail
                .startsWith('http'))

              Image.network(

                widget.video.thumbnail,

                fit: BoxFit.cover,

                /// Rasm yuklanmasa
                errorBuilder:
                    (_, __, ___) {

                  return const ColoredBox(
                    color: Colors.black,
                  );
                },
              ),

            // ───────── OVERLAY ─────────

            /// Thumbnail ustidagi qoraroq layer
            Container(
              color:
              Colors.black.withOpacity(0.3),
            ),

            // ───────── PLAY BUTTON ─────────

            Center(

              child: Container(

                width: 64,
                height: 64,

                decoration: BoxDecoration(

                  color: Colors.red,

                  shape: BoxShape.circle,

                  boxShadow: [

                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.4),

                      blurRadius: 12,
                    )
                  ],
                ),

                child: const Icon(

                  Icons.play_arrow_rounded,

                  color: Colors.white,
                  size: 44,
                ),
              ),
            ),

            // ───────── BACK BUTTON ─────────

            Positioned(
              top: 8,
              left: 8,

              child: GestureDetector(

                onTap: () =>
                    Navigator.pop(context),

                child: Container(

                  padding:
                  const EdgeInsets.all(6),

                  decoration:
                  const BoxDecoration(

                    color: Colors.black38,

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: SafeArea(

        child: Column(
          children: [

            // ───────────────── PLAYER ─────────────────

            /// Agar player tayyor bo‘lsa video chiqadi
            if (_playerReady &&
                _controller != null)

              YoutubePlayerBuilder(

                player: YoutubePlayer(

                  controller: _controller!,

                  /// Progress bar ko‘rinadi
                  showVideoProgressIndicator:
                  true,

                  /// Progress rangi
                  progressIndicatorColor:
                  Colors.red,

                  progressColors:
                  const ProgressBarColors(

                    playedColor: Colors.red,

                    handleColor:
                    Colors.redAccent,
                  ),

                  /// Yuqori actionlar
                  topActions: [

                    IconButton(

                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),

                      onPressed: () =>
                          Navigator.pop(context),
                    ),
                  ],
                ),

                builder:
                    (context, player) {

                  return player;
                },
              )

            // ───────────────── THUMBNAIL ─────────────────

            else

              _buildThumbnailPlayer(),

            // ───────────────── VIDEO INFO ─────────────────

            Expanded(

              child: ListView(

                padding: EdgeInsets.zero,

                children: [

                  Padding(

                    padding:
                    const EdgeInsets.fromLTRB(
                      12,
                      12,
                      12,
                      0,
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        // ───────── TITLE ─────────

                        Text(

                          widget.video.title,

                          style:
                          const TextStyle(

                            fontWeight:
                            FontWeight.bold,

                            fontSize: 15,

                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // ───────── VIEWS & DATE ─────────

                        Text(

                          '${widget.video.views} • ${widget.video.date}',

                          style: TextStyle(
                            color:
                            Colors.grey[600],

                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ───────────────── ACTIONS ─────────────────

                        Row(

                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,

                          children: [

                            // Like
                            _actionBtn(

                              icon: _isLiked
                                  ? Icons.thumb_up
                                  : Icons
                                  .thumb_up_outlined,

                              label: 'Like',

                              active: _isLiked,

                              onTap: () {

                                setState(() {

                                  _isLiked =
                                  !_isLiked;

                                  /// Like bo‘lsa
                                  /// dislike o‘chadi
                                  if (_isLiked) {
                                    _isDisliked =
                                    false;
                                  }
                                });
                              },
                            ),

                            // Dislike
                            _actionBtn(

                              icon: _isDisliked
                                  ? Icons
                                  .thumb_down
                                  : Icons
                                  .thumb_down_outlined,

                              label: 'Dislike',

                              active:
                              _isDisliked,

                              onTap: () {

                                setState(() {

                                  _isDisliked =
                                  !_isDisliked;

                                  /// Dislike bo‘lsa
                                  /// like o‘chadi
                                  if (_isDisliked) {
                                    _isLiked =
                                    false;
                                  }
                                });
                              },
                            ),

                            // Share
                            _actionBtn(
                              icon: Icons.reply,
                              label: 'Share',
                              onTap: () {},
                            ),

                            // Download
                            _actionBtn(
                              icon: Icons
                                  .download_outlined,
                              label: 'Download',
                              onTap: () {},
                            ),

                            // Save
                            _actionBtn(

                              icon: _isSaved
                                  ? Icons.bookmark
                                  : Icons
                                  .bookmark_border,

                              label: 'Save',

                              active: _isSaved,

                              onTap: () {

                                setState(() {

                                  _isSaved =
                                  !_isSaved;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Divider(
                          color:
                          Colors.grey.shade200,
                        ),

                        // ───────────────── CHANNEL INFO ─────────────────

                        Row(
                          children: [

                            /// Avatar
                            _buildAvatar(),

                            const SizedBox(width: 10),

                            /// Channel info
                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(

                                    widget.video
                                        .channel,

                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .w600,

                                      fontSize: 13,
                                    ),
                                  ),

                                  Text(

                                    '2.1M subscribers',

                                    style:
                                    TextStyle(
                                      color: Colors
                                          .grey[600],

                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Subscribe button
                            ElevatedButton(

                              onPressed: () {},

                              style:
                              ElevatedButton
                                  .styleFrom(

                                backgroundColor:
                                Colors.black,

                                foregroundColor:
                                Colors.white,

                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),

                                shape:
                                RoundedRectangleBorder(

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    20,
                                  ),
                                ),

                                textStyle:
                                const TextStyle(

                                  fontSize: 13,

                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),

                              child: const Text(
                                'Subscribe',
                              ),
                            ),
                          ],
                        ),

                        Divider(
                          color:
                          Colors.grey.shade200,
                        ),

                        // ───────────────── UP NEXT ─────────────────

                        const Text(

                          'Up next',

                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,

                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // ───────────────── RECOMMENDED VIDEOS ─────────────────

                  ...AppData.videos

                  /// Hozirgi videoni chiqarib tashlaydi
                      .where(
                        (v) =>
                    v.id !=
                        widget.video.id,
                  )

                  /// VideoCard yaratadi
                      .map(
                        (v) => HorizontalVideoCard(
                      video: v,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── ACTION BUTTON ─────────────────

  /// Like / Share / Save kabi button widget
  Widget _actionBtn({
    required IconData icon,
    required String label,
    bool active = false,
    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: Column(
        children: [

          /// Icon
          Icon(

            icon,

            color: active
                ? Colors.black
                : Colors.black87,

            size: 22,
          ),

          const SizedBox(height: 3),

          /// Label
          Text(

            label,

            style: TextStyle(

              fontSize: 11,

              color: active
                  ? Colors.black
                  : Colors.black87,

              fontWeight: active
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}