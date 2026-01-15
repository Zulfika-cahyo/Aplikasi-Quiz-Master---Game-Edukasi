import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score_model.dart';

class StorageService {
  /// ================= USER =================
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  /// ================= SCORE =================
  static Future<ScoreModel> loadScore(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('score_$category');

    if (raw == null) {
      return ScoreModel.initial();
    }

    return ScoreModel.fromJson(jsonDecode(raw));
  }

  static Future<void> saveScore(String category, ScoreModel score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('score_$category', jsonEncode(score.toJson()));
  }
}
