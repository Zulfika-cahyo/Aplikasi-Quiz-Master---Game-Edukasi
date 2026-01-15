import 'package:flutter/material.dart';
import '../models/score_model.dart';
import '../services/storage_service.dart';

class ScoreProvider extends ChangeNotifier {
  final Map<String, ScoreModel> _scores = {};

  ScoreModel getScore(String category) {
    return _scores[category] ?? ScoreModel.initial();
  }

  Future<void> load(String category) async {
    _scores[category] = await StorageService.loadScore(category);
    notifyListeners();
  }

  Future<void> update(String category, int score) async {
    final current = getScore(category);

    final updated = ScoreModel(
      highScore: score > current.highScore ? score : current.highScore,
      lastScore: score,
      playCount: current.playCount + 1,
    );

    _scores[category] = updated;
    await StorageService.saveScore(category, updated);
    notifyListeners();
  }

  int get totalHighScore {
    return _scores.values.fold(0, (a, b) => a + b.highScore);
  }

  int get averageHighScore {
    if (_scores.isEmpty) return 0;
    return (totalHighScore / _scores.length).round();
  }
}
