import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/services/YoutubeService.dart';

/// SearchScreen
/// YouTube qidiruv sahifasi
/// Video qidirish va natijalarni ko‘rsatish uchun ishlatiladi
class SearchScreen extends StatefulWidget {

  /// Constructor
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

/// SearchScreen state qismi
class _SearchScreenState
    extends State<SearchScreen> {

  /// Search field controller
  /// TextField ichidagi textni boshqaradi
  final TextEditingController _controller =
  TextEditingController();

  /// YouTube API service
  final YoutubeService _service =
  YoutubeService();

  /// Hozirgi qidiruv texti
  String _query = '';

  /// Search natijalari
  List<VideoModel> _results = [];

  /// Loading holati
  bool _isLoading = false;

  /// Search qilingan yoki yo‘qligi
  bool _searched = false;

  /// Tavsiya qilingan qidiruvlar
  final List<String> _suggestions = [

    'Ulug\'bek Rahmatullayev',
    'Yulduz Usmonova',
    'Jahongir Otajonov',
    'Sevinch Mo\'minova',
    'Shaxriyor',
    'Zoff Music',
    'O\'zbek musiqa 2024',
    'Konsert 2024',
  ];

  @override
  void dispose() {

    /// Controller ni xotiradan tozalaydi
    _controller.dispose();

    super.dispose();
  }

  /// Video qidirish funksiyasi
  Future<void> _search(String query) async {

    /// Agar text bo‘sh bo‘lsa ishlamaydi
    if (query.trim().isEmpty) return;

    /// Loading holatini yoqadi
    setState(() {
      _isLoading = true;
      _searched = true;
      _query = query;
    });

    try {

      /// API orqali videolarni oladi
      final results =
      await _service.getVideos(query);

      /// Widget mavjudligini tekshiradi
      if (!mounted) return;

      /// UI ni yangilaydi
      setState(() {
        _results = results;
        _isLoading = false;
      });

    } catch (e) {

      /// Xatolik bo‘lsa
      if (!mounted) return;

      setState(() {
        _results = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /// Keyboard ochilganda UI siqiladi
      resizeToAvoidBottomInset: true,

      /// Orqa fon rangi
      backgroundColor: Colors.white,

      // ───────────────── APP BAR ─────────────────

      appBar: AppBar(

        backgroundColor: Colors.white,
        elevation: 0,

        /// Orqaga qaytish tugmasi
        leading: IconButton(

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),

          onPressed: () =>
              Navigator.pop(context),
        ),

        // ───────────────── SEARCH FIELD ─────────────────

        title: TextField(

          controller: _controller,

          /// Sahifa ochilganda keyboard ochiladi
          autofocus: true,

          /// Text o‘zgarganda ishlaydi
          onChanged: (v) => setState(() {

            _query = v;

            /// Agar text o‘chirib tashlansa
            if (v.isEmpty) {
              _searched = false;
              _results = [];
            }
          }),

          /// Keyboard search bosilganda
          onSubmitted: (v) => _search(v),

          decoration: InputDecoration(

            /// Placeholder
            hintText: 'Qidiring...',

            /// Placeholder style
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 15,
            ),

            /// Borderni olib tashlaydi
            border: InputBorder.none,
          ),

          style: const TextStyle(
            fontSize: 15,
          ),
        ),

        // ───────────────── ACTION BUTTONS ─────────────────

        actions: [

          /// Agar text mavjud bo‘lsa clear button chiqadi
          if (_query.isNotEmpty)

            IconButton(

              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),

              /// Search ni tozalaydi
              onPressed: () => setState(() {

                _controller.clear();

                _query = '';
                _searched = false;
                _results = [];
              }),
            ),

          /// Search button
          IconButton(

            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),

            /// Search funksiyasini ishga tushiradi
            onPressed: () =>
                _search(_controller.text),
          ),
        ],
      ),

      // ───────────────── BODY ─────────────────

      body:

      /// Loading bo‘lsa spinner
      _isLoading

          ? const Center(
        child:
        CircularProgressIndicator(
          color: Colors.red,
        ),
      )

      /// Search qilinmagan bo‘lsa suggestions
          : !_searched

          ? _buildSuggestions()

      /// Natijalar
          : _buildResults(),
    );
  }

  // ───────────────── SUGGESTIONS ─────────────────

  /// Tavsiya qilingan qidiruvlar
  Widget _buildSuggestions() {

    return ListView(

      /// Scroll qilinganda keyboard yopiladi
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior
          .onDrag,

      children: [

        /// Section title
        Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            8,
          ),

          child: Text(
            'Mashhur qidiruvlar',

            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // ───────────────── SUGGESTION ITEMS ─────────────────

        ..._suggestions.map(

              (s) => ListTile(

            /// Chap icon
            leading: const Icon(
              Icons.trending_up,
              color: Colors.red,
              size: 20,
            ),

            /// Suggestion text
            title: Text(
              s,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),

            /// O‘ng icon
            trailing: const Icon(
              Icons.north_west,
              color: Colors.grey,
              size: 16,
            ),

            /// Suggestion bosilganda
            onTap: () {

              /// TextField ga yozadi
              _controller.text = s;

              /// Search qiladi
              _search(s);
            },
          ),
        ),
      ],
    );
  }

  // ───────────────── SEARCH RESULTS ─────────────────

  /// Search natijalari
  Widget _buildResults() {

    /// Natija topilmasa
    if (_results.isEmpty) {

      return Center(
        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            /// Search off icon
            Icon(
              Icons.search_off,
              color: Colors.grey[400],
              size: 64,
            ),

            const SizedBox(height: 12),

            /// Result topilmadi text
            Text(
              '"$_query" bo\'yicha natija topilmadi',

              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              ),

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            /// Hint text
            Text(
              'Boshqa kalit so\'z kiriting',

              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    // ───────────────── RESULTS LIST ─────────────────

    return ListView(

      /// Scroll qilinganda keyboard yopiladi
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior
          .onDrag,

      children: [

        /// Result count
        Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            4,
          ),

          child: Text(
            '${_results.length} ta natija',

            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),

        /// Natijalarni chiqaradi
        ..._results.map(

              (v) => HorizontalVideoCard(
            video: v,
          ),
        ),
      ],
    );
  }
}