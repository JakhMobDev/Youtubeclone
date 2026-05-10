import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/widgets/YouTubeTopBar.dart';
import 'package:f1/screens/VideoPlayerScreen.dart';
import 'package:f1/services/YoutubeService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedChip = 'All';
  final List<String> _chips = ['All', 'Mixes', 'Music', 'Graphic', 'Gaming', 'News', 'Live'];

  final YoutubeService _service = YoutubeService();
  List<VideoModel> _videos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final videos = await _service.getVideos('trending');
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        // API ishlamasa fallback data ishlatiladi
        _videos = AppData.videos;
      });
    }
  }

  Future<void> _onChipSelected(String chip) async {
    setState(() {
      _selectedChip = chip;
      _isLoading = true;
    });
    try {
      final videos = await _service.getVideos(chip == 'All' ? 'trending' : chip);
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _videos = AppData.videos;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const YouTubeTopBar(showLogo: true),
      body: Column(
        children: [
          // Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: _chips.length,
              itemBuilder: (context, index) {
                final chip = _chips[index];
                final isSelected = chip == _selectedChip;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _onChipSelected(chip),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        chip,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Body
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.red))
                : RefreshIndicator(
              color: Colors.red,
              onRefresh: _loadVideos,
              child: ListView(
                children: [
                  if (_videos.isNotEmpty) VideoCard(video: _videos[0]),
                  _buildShortsSection(),
                  ..._videos.skip(1).map((v) => VideoCard(video: v)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.white, size: 15),
                    SizedBox(width: 2),
                    Text('Shorts',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('BETA',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 9,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: AppData.shorts.length,
            itemBuilder: (context, index) {
              final s = AppData.shorts[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => VideoPlayerScreen(video: s, isShort: true)),
                ),
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              // URL bilan rasm, yo'q bo'lsa rang
                              child: s.thumbnail.startsWith('http')
                                  ? Image.network(
                                s.thumbnail,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.play_circle_outline,
                                      color: Colors.white70, size: 40),
                                ),
                              )
                                  : Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.play_circle_outline,
                                      color: Colors.white70, size: 40),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              right: 24,
                              child: Text(
                                s.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(s.views,
                          style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}