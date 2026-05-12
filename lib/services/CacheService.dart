import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const int _cacheHours = 24; // 24 soat saqlaydi

  // Saqlash
  static Future<void> save(String key, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final cache = {
      'data': data,
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(key, jsonEncode(cache));
  }

  // O'qish — eski bo'lsa null qaytaradi
  static Future<List<Map<String, dynamic>>?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;

    final cache = jsonDecode(raw);
    final savedTime = cache['time'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    final hours = (now - savedTime) / (1000 * 60 * 60);

    // 24 soatdan eski bo'lsa null qaytaradi
    if (hours > _cacheHours) return null;

    return List<Map<String, dynamic>>.from(cache['data']);
  }

  // O'chirish
  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Hammasini o'chirish
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}