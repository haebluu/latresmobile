import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/anime_model.dart';

class SharedPrefService {
  static SharedPreferences? _prefs;

  static const String _keySession = 'session_username';
  static const String _keyFavorites = 'favorites_list';
  static const String _keyProfilePhoto = 'profile_photo';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveSession(String username) async {
    await _prefs?.setString(_keySession, username);
  }

  static String? getSession() {
    return _prefs?.getString(_keySession);
  }

  static Future<void> clearSession() async {
    await _prefs?.remove(_keySession);
  }

  // Favorites: store list of anime maps as JSON string
  static Future<void> saveFavorites(List<AnimeModel> list) async {
    final jsonList = list.map((a) => a.toMap()).toList();
    await _prefs?.setString(_keyFavorites, jsonEncode(jsonList));
  }

  static List<AnimeModel> getFavorites() {
    final raw = _prefs?.getString(_keyFavorites);
    if (raw == null) return [];
    final List parsed = jsonDecode(raw);
    return parsed.map((e) => AnimeModel.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  static Future<void> saveProfilePhoto(String base64) async {
    await _prefs?.setString(_keyProfilePhoto, base64);
  }

  static String? getProfilePhoto() {
    return _prefs?.getString(_keyProfilePhoto);
  }
}
