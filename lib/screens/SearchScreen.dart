import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';
import 'package:f1/services/YoutubeService.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final YoutubeService _service = YoutubeService();

  String _query = '';
  List<VideoModel> _results = [];
  bool _isLoading = false;
  bool _searched = false;

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
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _searched = true;
      _query = query;
    });

    try {
      final results = await _service.getVideos(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
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
      resizeToAvoidBottomInset: true, // ✅ klaviatura ochilganda UI siqiladi
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (v) => setState(() {
            _query = v;
            if (v.isEmpty) {
              _searched = false;
              _results = [];
            }
          }),
          onSubmitted: (v) => _search(v),
          decoration: InputDecoration(
            hintText: 'Qidiring...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.black),
              onPressed: () => setState(() {
                _controller.clear();
                _query = '';
                _searched = false;
                _results = [];
              }),
            ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () => _search(_controller.text),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator(color: Colors.red))
          : !_searched
          ? _buildSuggestions()
          : _buildResults(),
    );
  }

  // ✅ Column o'rniga ListView — klaviatura ochilganda overflow bo'lmaydi
  Widget _buildSuggestions() {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Mashhur qidiruvlar',
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ),
        ..._suggestions.map((s) => ListTile(
          leading: const Icon(Icons.trending_up,
              color: Colors.red, size: 20),
          title: Text(s, style: const TextStyle(fontSize: 14)),
          trailing: const Icon(Icons.north_west,
              color: Colors.grey, size: 16),
          onTap: () {
            _controller.text = s;
            _search(s);
          },
        )),
      ],
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.grey[400], size: 64),
            const SizedBox(height: 12),
            Text(
              '"$_query" bo\'yicha natija topilmadi',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Boshqa kalit so\'z kiriting',
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            '${_results.length} ta natija',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        ..._results.map((v) => HorizontalVideoCard(video: v)),
      ],
    );
  }
}