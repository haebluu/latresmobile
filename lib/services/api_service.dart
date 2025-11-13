import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime_model.dart';

class ApiService {
  static const String base = 'https://api.jikan.moe/v4/top/anime';

  static Future<List<AnimeModel>> fetchTopAnime() async {
    final uri = Uri.parse(base);
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(resp.body);
      final List data = json['data'] ?? [];
      return data.map((e) => AnimeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load anime: ${resp.statusCode}');
    }
  }
}
