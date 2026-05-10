import 'package:flutter/material.dart';
import 'package:f1/models/AppData.dart';
import 'package:f1/widgets/VideoCard.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  bool _searched = false;

  final List<String> _suggestions = [
    'Nasheed',
    'DIY videos',
    'Nature 4K',
    'Relaxing music',
    'Islamic reminders',
  ];

  @override
  Widget build(BuildContext context) {
    final results = AppData.videos
        .where((v) => v.title.toLowerCase().contains(_query.toLowerCase()) ||
        v.channel.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
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
          onChanged: (v) => setState(() => _query = v),
          onSubmitted: (v) => setState(() => _searched = true),
          decoration: InputDecoration(
            hintText: 'Search YouTube',
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
              }),
            ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _query.isEmpty
          ? _buildSuggestions()
          : _buildResults(results),
    );
  }

  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text('Recent searches',
              style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600)),
        ),
        ..._suggestions.map((s) => ListTile(
          leading: const Icon(Icons.history, color: Colors.grey, size: 20),
          title: Text(s, style: const TextStyle(fontSize: 14)),
          trailing: const Icon(Icons.north_west, color: Colors.grey, size: 16),
          onTap: () => setState(() {
            _controller.text = s;
            _query = s;
            _searched = true;
          }),
        )),
      ],
    );
  }

  Widget _buildResults(List<VideoModel> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.grey[400], size: 64),
            const SizedBox(height: 12),
            Text('No results found',
                style: TextStyle(color: Colors.grey[600], fontSize: 15)),
            Text('Try different keywords',
                style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          ],
        ),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text('${results.length} results',
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ),
        ...results.map((v) => HorizontalVideoCard(video: v)),
      ],
    );
  }
}