import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/widgets/YouTubeTopBar.dart';
import 'package:f1/screens/ShortsScreen.dart';
import 'package:f1/services/YoutubeService.dart';

/// HomeScreen
/// Asosiy sahifa
/// Videolar, Shorts va kategoriya bo‘limlarini chiqaradi
class HomeScreen extends StatefulWidget {

  /// Constructor
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// HomeScreen state qismi
class _HomeScreenState extends State<HomeScreen> {

  /// Hozir tanlangan kategoriya
  String _selectedChip = 'All';

  /// Kategoriya tugmalari
  final List<String> _chips = [
    'All',
    'Musiqa',
    'Konsert',
    'Klip',
    'Live',
    'Podcast',
    'Yangi'
  ];

  /// YouTube service object
  /// API bilan ishlash uchun
  final YoutubeService _service = YoutubeService();

  /// Oddiy videolar ro‘yxati
  List<VideoModel> _videos =
  List.from(AppData.videos);

  /// Shorts videolar ro‘yxati
  List<VideoModel> _shorts =
  List.from(AppData.shorts);

  /// Oddiy videolar loading holati
  bool _isLoading = false;

  /// Shorts loading holati
  bool _isShortsLoading = false;

  @override
  void initState() {
    super.initState();

    /// Sahifa ochilganda ma'lumotlarni yuklaydi
    _loadData();
  }

  /// API dan videolar va shorts yuklash
  Future<void> _loadData() async {

    /// Loading ni yoqadi
    setState(() {
      _isLoading = true;
      _isShortsLoading = true;
    });

    /// Ikkala API request parallel ishlaydi
    final results = await Future.wait([

      /// Oddiy videolar
      _service.getVideos('o\'zbek musiqa'),

      /// Shorts videolar
      _service.getShorts(
        query: 'o\'zbek musiqa shorts',
      ),
    ]);

    /// Widget hali mavjudligini tekshiradi
    if (!mounted) return;

    /// UI ni yangilaydi
    setState(() {

      /// Videolarni saqlaydi
      _videos = results[0];

      /// Shorts ni saqlaydi
      _shorts = results[1];

      /// Loading ni o‘chiradi
      _isLoading = false;
      _isShortsLoading = false;
    });
  }

  /// Kategoriya tanlanganda ishlaydi
  Future<void> _onChipSelected(String chip) async {

    /// Tanlangan chip ni saqlaydi
    setState(() {
      _selectedChip = chip;
      _isLoading = true;
    });

    /// Search query yaratadi
    final query = chip == 'All'
        ? 'o\'zbek musiqa'
        : 'o\'zbek $chip';

    /// API dan videolarni oladi
    final videos =
    await _service.getVideos(query);

    /// Widget mavjudligini tekshiradi
    if (!mounted) return;

    /// UI yangilanadi
    setState(() {
      _videos = videos;
      _isLoading = false;
    });
  }

  /// Pull to refresh
  /// Pastga tortilganda qayta yuklaydi
  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /// Orqa fon rangi
      backgroundColor: Colors.white,

      /// Custom YouTube AppBar
      appBar: const YouTubeTopBar(
        showLogo: true,
      ),

      body: Column(
        children: [

          // ───────────────── CATEGORY CHIPS ─────────────────

          SizedBox(
            height: 44,

            child: ListView.builder(

              /// Gorizontal scroll
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),

              /// Chiplar soni
              itemCount: _chips.length,

              itemBuilder: (context, index) {

                /// Hozirgi chip
                final chip = _chips[index];

                /// Tanlangan yoki yo‘qligi
                final isSelected =
                    chip == _selectedChip;

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),

                  child: GestureDetector(

                    /// Chip bosilganda
                    onTap: () =>
                        _onChipSelected(chip),

                    child: Container(

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(

                        /// Tanlangan bo‘lsa qora
                        color: isSelected
                            ? Colors.black
                            : Colors.grey[200],

                        borderRadius:
                        BorderRadius.circular(20),
                      ),

                      child: Text(
                        chip,

                        style: TextStyle(

                          /// Text color
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,

                          fontSize: 13,

                          /// Font weight
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

          // ───────────────── VIDEO LIST ─────────────────

          Expanded(

            /// Loading bo‘lsa spinner chiqaradi
            child: _isLoading

                ? const Center(
              child:
              CircularProgressIndicator(
                color: Colors.red,
              ),
            )

                : RefreshIndicator(

              /// Refresh rangi
              color: Colors.red,

              /// Pull to refresh function
              onRefresh: _onRefresh,

              child: ListView(
                children: [

                  /// Birinchi video
                  if (_videos.isNotEmpty)
                    VideoCard(
                      video: _videos[0],
                    ),

                  /// Shorts section
                  _buildShortsSection(),

                  /// Qolgan videolar
                  ..._videos
                      .skip(1)
                      .map(
                        (v) => VideoCard(
                      video: v,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shorts bo‘limi
  Widget _buildShortsSection() {

    /// Shorts bo‘sh bo‘lsa hech narsa chiqarmaydi
    if (_shorts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // ───────────────── SHORTS TITLE ─────────────────

        Padding(
          padding: const EdgeInsets.fromLTRB(
            12,
            16,
            12,
            10,
          ),

          child: Container(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),

            decoration: BoxDecoration(
              color: Colors.red,

              borderRadius:
              BorderRadius.circular(6),
            ),

            child: const Row(
              mainAxisSize: MainAxisSize.min,

              children: [

                /// Shorts icon
                Icon(
                  Icons.bolt,
                  color: Colors.white,
                  size: 15,
                ),

                SizedBox(width: 2),

                /// Shorts text
                Text(
                  'Shorts',

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ───────────────── SHORTS LIST ─────────────────

        SizedBox(
          height: 230,

          child: _isShortsLoading

              ? const Center(
            child:
            CircularProgressIndicator(
              color: Colors.red,
            ),
          )

              : ListView.builder(

            /// Gorizontal scroll
            scrollDirection:
            Axis.horizontal,

            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            /// Shorts soni
            itemCount: _shorts.length,

            itemBuilder:
                (context, index) {

              /// Hozirgi short video
              final s = _shorts[index];

              return GestureDetector(

                /// Shorts ochiladi
                onTap: () => Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        ShortsScreen(
                          startIndex: index,
                          initialShorts:
                          _shorts,
                        ),
                  ),
                ),

                child: Container(
                  width: 130,

                  margin:
                  const EdgeInsets.only(
                    right: 8,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      /// Thumbnail qismi
                      Expanded(
                        child: ClipRRect(

                          borderRadius:
                          BorderRadius
                              .circular(10),

                          child: Stack(
                            fit: StackFit.expand,

                            children: [

                              // ───── THUMBNAIL ─────

                              s.thumbnail
                                  .startsWith(
                                  'http')

                                  ? Image.network(
                                s.thumbnail,

                                fit: BoxFit
                                    .cover,

                                /// Loading holati
                                loadingBuilder:
                                    (_,
                                    child,
                                    progress) {

                                  if (progress ==
                                      null) {
                                    return child;
                                  }

                                  return Container(
                                    color: Colors
                                        .grey[
                                    300],

                                    child:
                                    const Center(
                                      child:
                                      CircularProgressIndicator(
                                        color:
                                        Colors.red,
                                        strokeWidth:
                                        2,
                                      ),
                                    ),
                                  );
                                },

                                /// Error bo‘lsa
                                errorBuilder:
                                    (_,
                                    __,
                                    ___) {

                                  return Container(
                                    color: Colors
                                        .grey[
                                    300],

                                    child:
                                    const Icon(
                                      Icons
                                          .play_circle_outline,
                                      color:
                                      Colors.white70,
                                      size:
                                      40,
                                    ),
                                  );
                                },
                              )

                                  : Container(
                                color: Colors
                                    .grey[300],

                                child:
                                const Center(
                                  child: Icon(
                                    Icons
                                        .play_circle_outline,
                                    color: Colors
                                        .white70,
                                    size: 40,
                                  ),
                                ),
                              ),

                              // ───── PLAY BUTTON ─────

                              Center(
                                child: Container(
                                  width: 44,
                                  height: 44,

                                  decoration:
                                  BoxDecoration(
                                    color: Colors
                                        .black
                                        .withOpacity(
                                        0.55),

                                    shape:
                                    BoxShape
                                        .circle,
                                  ),

                                  child:
                                  const Icon(
                                    Icons
                                        .play_arrow_rounded,
                                    color:
                                    Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),

                              // ───── VIDEO DURATION ─────

                              if (s.duration
                                  .isNotEmpty)

                                Positioned(
                                  bottom: 30,
                                  right: 6,

                                  child:
                                  Container(

                                    padding:
                                    const EdgeInsets.symmetric(
                                      horizontal:
                                      4,
                                      vertical:
                                      2,
                                    ),

                                    decoration:
                                    BoxDecoration(
                                      color: Colors
                                          .black87,

                                      borderRadius:
                                      BorderRadius.circular(
                                          3),
                                    ),

                                    child: Text(
                                      s.duration,

                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white,
                                        fontSize:
                                        9,
                                      ),
                                    ),
                                  ),
                                ),

                              // ───── VIDEO TITLE ─────

                              Positioned(
                                bottom: 8,
                                left: 8,
                                right: 8,

                                child: Text(
                                  s.title,

                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize:
                                    11,
                                    fontWeight:
                                    FontWeight
                                        .w600,

                                    shadows: [
                                      Shadow(
                                        color: Colors
                                            .black54,
                                        blurRadius:
                                        4,
                                      )
                                    ],
                                  ),

                                  maxLines: 2,

                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      // ───────────────── VIEWS ─────────────────

                      Text(

                        /// Views bo‘lsa chiqaradi
                        /// bo‘lmasa channel nomi
                        s.views.isNotEmpty
                            ? s.views
                            : s.channel,

                        style: TextStyle(
                          color:
                          Colors.grey[600],
                          fontSize: 11,
                        ),

                        maxLines: 1,

                        overflow:
                        TextOverflow
                            .ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        /// Divider
        Divider(
          height: 1,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }
}