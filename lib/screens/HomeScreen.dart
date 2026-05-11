import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/widgets/YouTubeTopBar.dart';
import 'package:f1/screens/ShortsScreen.dart';
import 'package:f1/services/YoutubeService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedChip = 'All';

  final List<String> _chips = [
    'All', 'Musiqa', 'Konsert', 'Klip', 'Live', 'Podcast', 'Yangi'
  ];

  final YoutubeService _service = YoutubeService();

  List<VideoModel> _videos = List.from(AppData.videos);
  List<VideoModel> _shorts = List.from(AppData.shorts);
  bool _isLoading = false;
  bool _isShortsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _isShortsLoading = true;
    });

    final results = await Future.wait([
      _service.getVideos('o\'zbek musiqa'),
      _service.getShorts(query: 'o\'zbek musiqa shorts'),
    ]);

    if (!mounted) return;
    setState(() {
      _videos = results[0];
      _shorts = results[1];
      _isLoading = false;
      _isShortsLoading = false;
    });
  }

  Future<void> _onChipSelected(String chip) async {
    setState(() {
      _selectedChip = chip;
      _isLoading = true;
    });

    final query = chip == 'All' ? 'o\'zbek musiqa' : 'o\'zbek $chip';
    final videos = await _service.getVideos(query);

    if (!mounted) return;
    setState(() {
      _videos = videos;
      _isLoading = false;
    });
  }

  // ✅ Refresh — yangi ma'lumot yuklanadi
  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const YouTubeTopBar(showLogo: true),
      body: Column(
        children: [
          // Kategoriya tugmalari
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        chip,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Videolar ro'yxati
          Expanded(
            child: _isLoading
                ? const Center(
                child: CircularProgressIndicator(color: Colors.red))
                : RefreshIndicator(
              color: Colors.red,
              onRefresh: _onRefresh,
              child: ListView(
                children: [
                  if (_videos.isNotEmpty)
                    VideoCard(video: _videos[0]),
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
    if (_shorts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: Colors.white, size: 15),
                SizedBox(width: 2),
                Text(
                  'Shorts',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ],
            ),
          ),
        ),

        SizedBox(
          height: 230,
          child: _isShortsLoading
              ? const Center(
              child: CircularProgressIndicator(color: Colors.red))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _shorts.length,
            itemBuilder: (context, index) {
              final s = _shorts[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShortsScreen(
                      startIndex: index,
                      initialShorts: _shorts,
                    ),
                  ),
                ),
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              s.thumbnail.startsWith('http')
                                  ? Image.network(
                                s.thumbnail,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (_, child, progress) {
                                  if (progress == null)
                                    return child;
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child:
                                      CircularProgressIndicator(
                                        color: Colors.red,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (_, __, ___) =>
                                    Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white70,
                                        size: 40,
                                      ),
                                    ),
                              )
                                  : Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white70,
                                    size: 40,
                                  ),
                                ),
                              ),

                              // Play overlay
                              Center(
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.black.withOpacity(0.55),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),

                              // Davomiylik
                              if (s.duration.isNotEmpty)
                                Positioned(
                                  bottom: 30,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius:
                                      BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      s.duration,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9),
                                    ),
                                  ),
                                ),

                              // Sarlavha
                              Positioned(
                                bottom: 8,
                                left: 8,
                                right: 8,
                                child: Text(
                                  s.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black54,
                                          blurRadius: 4)
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.views.isNotEmpty ? s.views : s.channel,
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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