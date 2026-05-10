import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/screens/ShortsScreen.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel video;
  final bool isShort;

  const VideoPlayerScreen({super.key, required this.video, this.isShort = false});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController? _controller;
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    // video.id YouTube ID bo'lishi kerak (masalan: dQw4w9WgXcQ)
    if (widget.video.id.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.video.id,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Controller yo'q bo'lsa thumbnail ko'rsatamiz
  Widget _buildVideoArea() {
    if (_controller == null) {
      return Container(
        width: double.infinity,
        height: 220,
        color: Colors.black,
        child: widget.video.thumbnail.startsWith('http')
            ? Image.network(
          widget.video.thumbnail,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.play_circle_outline, color: Colors.white70, size: 56)),
        )
            : const Center(
          child: Icon(Icons.play_circle_outline, color: Colors.white70, size: 56),
        ),
      );
    }

    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.red,
      progressColors: const ProgressBarColors(
        playedColor: Colors.red,
        handleColor: Colors.redAccent,
      ),
      topActions: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (widget.video.avatarColor.startsWith('http')) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(widget.video.avatarColor),
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.red,
      child: Text(
        widget.video.channel.isNotEmpty ? widget.video.channel[0] : '?',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isShort) {
      final startIndex = AppData.shorts.indexWhere((s) => s.id == widget.video.id);
      return ShortsScreen(startIndex: startIndex < 0 ? 0 : startIndex);
    }

    final playerWidget = _controller != null
        ? YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
      ),
      builder: (context, player) => _buildScaffold(player),
    )
        : _buildScaffold(_buildVideoArea());

    return playerWidget;
  }

  Widget _buildScaffold(Widget videoWidget) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button + video
            Stack(
              children: [
                videoWidget,
                if (_controller == null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
              ],
            ),
            // Video info
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15, height: 1.3),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.video.views} • ${widget.video.date}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _actionBtn(
                              icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                              label: 'Like',
                              active: _isLiked,
                              onTap: () => setState(() {
                                _isLiked = !_isLiked;
                                if (_isLiked) _isDisliked = false;
                              }),
                            ),
                            _actionBtn(
                              icon: _isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                              label: 'Dislike',
                              active: _isDisliked,
                              onTap: () => setState(() {
                                _isDisliked = !_isDisliked;
                                if (_isDisliked) _isLiked = false;
                              }),
                            ),
                            _actionBtn(icon: Icons.reply, label: 'Share', onTap: () {}),
                            _actionBtn(icon: Icons.download_outlined, label: 'Download', onTap: () {}),
                            _actionBtn(
                              icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                              label: 'Save',
                              active: _isSaved,
                              onTap: () => setState(() => _isSaved = !_isSaved),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Colors.grey.shade200),
                        // Channel info
                        Row(
                          children: [
                            _buildAvatar(),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.video.channel,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 13)),
                                  Text('2.1M subscribers',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                textStyle: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              child: const Text('Subscribe'),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey.shade200),
                        const Text('Up next',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  // Related videos
                  ...AppData.videos
                      .where((v) => v.id != widget.video.id)
                      .map((v) => HorizontalVideoCard(video: v)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          Icon(icon, color: active ? Colors.black : Colors.black87, size: 22),
          const SizedBox(height: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: active ? Colors.black : Colors.black87,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }
}