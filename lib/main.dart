import 'package:flutter/material.dart';
import 'package:f1/screens/HomeScreen.dart';
import 'package:f1/screens/ShortsScreen.dart';
import 'package:f1/screens/SubscriptionsScreen.dart';
import 'package:f1/screens/LibraryScreen.dart';
import 'package:f1/models/AppData.dart';

// Dastur ishga tushadigan asosiy nuqta
void main() {
  runApp(const YouTubeApp());
}

// Asosiy ilova widgeti
class YouTubeApp extends StatelessWidget {
  const YouTubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Clone', // Ilova nomi
      debugShowCheckedModeBanner: false, // Debug banner o‘chirilgan
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(), // Boshlang‘ich sahifa
    );
  }
}

// Asosiy ekran (BottomNavigation bilan)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Tanlangan menu index

  // Upload oynasini ochish
  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const UploadBottomSheet(),
    );
  }

  // HomeScreen dagi Shorts ochilishi
  void _onShortsTab(int index, List<VideoModel> shorts) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShortsScreen(
          startIndex: index,
          initialShorts: shorts,
        ),
      ),
    );
  }

  // Bottom nav dagi Shorts tugmasi
  void _openShorts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShortsScreen(
          startIndex: 0,
          initialShorts: List.from(AppData.shorts),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onShortsTab: _onShortsTab), // Home
          const SizedBox(), // Shorts uchun bo‘sh joy
          const SizedBox(), // + tugma uchun bo‘sh joy
          const SubscriptionsScreen(), // Subscriptions
          const LibraryScreen(), // Library
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Pastki menu
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        color: Colors.white,
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex == 2 ? 0 : _selectedIndex,
        onTap: (i) {
          if (i == 2) {
            _showUploadSheet(); // + bosilganda upload oynasi
            return;
          }

          if (i == 1) {
            _openShorts(); // Shorts ochiladi
            return;
          }

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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Shorts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 36),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}

// Upload oynasi
class UploadBottomSheet extends StatefulWidget {
  const UploadBottomSheet({super.key});

  @override
  State<UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> {
  bool _uploading = false; // Yuklanish holati
  double _progress = 0.0; // Progress foiz
  String? _selectedFile; // Tanlangan fayl nomi

  // Menyu variantlari
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
  ];

  // Video yuklashni simulyatsiya qilish
  void _simulateUpload() {
    setState(() {
      _uploading = true;
      _selectedFile = 'my_video.mp4';
      _progress = 0;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 120));

      if (!mounted) return false;

      setState(() => _progress += 0.03);

      return _progress < 1.0;
    }).then((_) {
      if (!mounted) return;

      setState(() => _progress = 1.0);

      Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Video muvaffaqiyatli yuklandi!',
            ),
            backgroundColor: Colors.green,
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),

          // Sarlavha
          const Text(
            'Kontent yaratish',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Upload bo‘layotgan bo‘lsa progress ko‘rsatadi
          if (_uploading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(_selectedFile ?? ''),
                  LinearProgressIndicator(
                    value: _progress,
                    color: Colors.red,
                  ),
                  Text('${(_progress * 100).toInt()}%'),
                ],
              ),
            ),

          // Upload bo‘lmasa variantlar chiqadi
          if (!_uploading)
            ..._options.map(
                  (opt) => ListTile(
                leading: Icon(
                  opt['icon'],
                  color: opt['color'],
                ),
                title: Text(opt['title']),
                subtitle: Text(opt['subtitle']),
                onTap: () {
                  if (opt['title'] == 'Videoni yuklash') {
                    _simulateUpload();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}