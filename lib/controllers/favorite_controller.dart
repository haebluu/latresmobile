import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../services/shared_pref_service.dart';

class FavoriteController with ChangeNotifier {
  List<AnimeModel> favorites = [];

  FavoriteController() {
    load();
  }

  void load() {
    favorites = SharedPrefService.getFavorites();
    notifyListeners();
  }

  bool isFavorite(AnimeModel a) {
    return favorites.any((f) => f.malId == a.malId);
  }

  Future<void> toggleFavorite(AnimeModel a) async {
    final exists = isFavorite(a);
    if (exists) {
      favorites.removeWhere((f) => f.malId == a.malId);
    } else {
      favorites.add(a);
    }
    await SharedPrefService.saveFavorites(favorites);
    notifyListeners();
  }

  Future<void> remove(AnimeModel a) async {
    favorites.removeWhere((f) => f.malId == a.malId);
    await SharedPrefService.saveFavorites(favorites);
    notifyListeners();
  }
}
