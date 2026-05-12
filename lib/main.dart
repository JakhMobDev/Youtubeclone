import 'package:flutter/material.dart';
import 'package:f1/screens/HomeScreen.dart';
import 'package:f1/screens/ShortsScreen.dart';
import 'package:f1/screens/SubscriptionsScreen.dart';
import 'package:f1/screens/LibraryScreen.dart';
import 'package:f1/models/AppData.dart';

void main() {
  runApp(const YouTubeApp());
}

class YouTubeApp extends StatelessWidget {
  const YouTubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Hozir tanlangan tab indeksi
  int _selectedIndex = 0;

  /// Shorts uchun — qaysi index bosildi
  int _shortsStartIndex = 0;

  /// Shorts uchun — qaysi ro'yxat yuborildi
  List<VideoModel> _shortsData = List.from(AppData.shorts);

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const UploadBottomSheet(),
    );
  }

  /// HomeScreen dan Shorts bosilganda chaqiriladi
  /// index — qaysi short bosildi
  /// shorts — barcha shorts ro'yxati
  void _onShortsTab(int index, List<VideoModel> shorts) {
    setState(() {
      _shortsStartIndex = index;   // bosilgan short indeksi
      _shortsData = shorts;         // shorts ro'yxati
      _selectedIndex = 1;           // Shorts tabiga o'tadi
    });
  }

  /// Ekranlar ro'yxati
  /// _selectedIndex ga qarab ko'rsatiladi
  List<Widget> get _screens => [
    // 0 — Home
    HomeScreen(
      /// Shorts bosilganda bu callback chaqiriladi
      onShortsTab: _onShortsTab,
    ),
    // 1 — Shorts
    ShortsScreen(
      /// HomeScreen dan bosilgan short dan boshlanadi
      startIndex: _shortsStartIndex,
      /// HomeScreen dan kelgan shorts ro'yxati
      initialShorts: _shortsData,
    ),
    // 2 — + tugmasi (ekran emas)
    const SizedBox(),
    // 3 — Subscriptions
    const SubscriptionsScreen(),
    // 4 — Library
    const LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// _screens getter — har safar yangi ShortsScreen yaratadi
      body: IndexedStack(
        index: _selectedIndex == 2 ? 0 : _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1)),
        color: Colors.white,
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex == 2 ? 0 : _selectedIndex,
        onTap: (i) {
          /// + tugmasi — sheet ochadi
          if (i == 2) {
            _showUploadSheet();
            return;
          }
          /// Boshqa tablar
          setState(() => _selectedIndex = i);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bolt), label: 'Shorts'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 36),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_outlined),
              label: 'Subscriptions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined),
              label: 'Library'),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
//         UPLOAD BOTTOM SHEET
// ═══════════════════════════════════════════

class UploadBottomSheet extends StatefulWidget {
  const UploadBottomSheet({super.key});

  @override
  State<UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> {
  /// Yuklash jarayoni boshlandimi
  bool _uploading = false;

  /// Yuklash foizi
  double _progress = 0.0;

  /// Tanlangan fayl nomi
  String? _selectedFile;

  /// Yuklash variantlari
  final List<Map<String, dynamic>> _options = [
    {
      'icon': Icons.video_library_outlined,
      'title': 'Videoni yuklash',
      'subtitle': 'Galereyadan video tanlang',
      'color': Color(0xFFE53935),
    },
    {
      'icon': Icons.bolt,
      'title': 'Short yaratish',
      'subtitle': '60 soniyagacha qisqa video',
      'color': Color(0xFF8E24AA),
    },
    {
      'icon': Icons.live_tv,
      'title': 'Jonli efir',
      'subtitle': 'Hoziroq efirga chiqing',
      'color': Color(0xFF039BE5),
    },
    {
      'icon': Icons.article_outlined,
      'title': 'Post yaratish',
      'subtitle': 'Matn yoki rasm post',
      'color': Color(0xFF43A047),
    },
  ];

  /// Yuklashni simulatsiya qiladi
  void _simulateUpload() {
    setState(() {
      _uploading = true;
      _selectedFile = 'my_video.mp4';
      _progress = 0;
    });

    /// Har 120ms da 3% qo'shadi
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return false;
      setState(() => _progress += 0.03);
      return _progress < 1.0;
    }).then((_) {
      if (!mounted) return;
      setState(() => _progress = 1.0);

      /// 600ms kutib sheet yopiladi
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Video muvaffaqiyatli yuklandi!'),
              ],
            ),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// Tutqich chizig'i
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          /// Sarlavha va yopish tugmasi
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                const Text(
                  'Kontent yaratish',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 18, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

          /// Yuklash jarayoni
          if (_uploading)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        /// Fayl ikonasi
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.video_file,
                              color: Colors.red, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              /// Fayl nomi
                              Text(
                                _selectedFile ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                              /// Holat matni
                              Text(
                                _progress < 1.0
                                    ? 'Yuklanmoqda...'
                                    : 'Yuklandi ✓',
                                style: TextStyle(
                                  color: _progress < 1.0
                                      ? Colors.grey[600]
                                      : Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        /// Foiz ko'rsatgich
                        Text(
                          '${(_progress * 100).toInt()}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    /// Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.grey[200],
                        color: Colors.red,
                        minHeight: 7,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          /// Variantlar ro'yxati
          if (!_uploading)
            ..._options.map((opt) => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 4),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (opt['color'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(opt['icon'] as IconData,
                    color: opt['color'] as Color, size: 26),
              ),
              title: Text(
                opt['title'] as String,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: Text(
                opt['subtitle'] as String,
                style: TextStyle(
                    color: Colors.grey[500], fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right,
                  color: Colors.grey),
              onTap: () {
                if (opt['title'] == 'Videoni yuklash') {
                  _simulateUpload();
                }
              },
            )),

          /// Bekor qilish tugmasi
          if (_uploading && _progress < 1.0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _uploading = false;
                    _progress = 0;
                    _selectedFile = null;
                  }),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Bekor qilish',
                      style: TextStyle(color: Colors.black54)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}