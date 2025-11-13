import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../services/api_service.dart';

class AnimeController with ChangeNotifier {
  List<AnimeModel> animes = [];
  bool loading = false;
  String? error;

  Future<void> fetch() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      animes = await ApiService.fetchTopAnime();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
