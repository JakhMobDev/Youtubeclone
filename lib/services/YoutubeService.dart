// lib/services/YoutubeService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:f1/config/ApiConfig.dart';
import 'package:f1/models/AppData.dart'; // ← o'zgartirildi

class YoutubeService {
  Future<List<VideoModel>> getVideos(String query) async {
    final url = Uri.parse(
      "${ApiConfig.baseUrl}/search"
          "?part=snippet"
          "&q=$query"
          "&type=video"
          "&maxResults=20"
          "&key=${ApiConfig.apiKey}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;
      return items.map((item) => VideoModel.fromJson(item)).toList();
    } else {
      throw Exception("Xato: ${response.statusCode}");
    }
  }
}