import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/question_service.dart';
import '../utils/question_helper.dart';

class QuizProvider extends ChangeNotifier {
  // ✅ PERBAIKAN 1: Tambahkan konstanta durasi agar bisa diakses di layar
  static const int questionDuration = 30;

  List<QuestionModel> _questions = [];
  int _index = 0;
  int _score = 0;
  bool _finished = false;
  bool _loading = false;

  Timer? _timer;
  int _timeLeft = questionDuration;

  List<QuestionModel> get questions => _questions;
  QuestionModel? get current =>
      _index < _questions.length ? _questions[_index] : null;

  int get index => _index;
  int get score => _score;
  int get timeLeft => _timeLeft;
  bool get finished => _finished;
  bool get loading => _loading;

  Future<void> start(String category) async {
    _loading = true;
    notifyListeners();

    try {
      final all = await QuestionService.loadQuestions(category);
      _questions = QuestionHelper.random10(all);
    } catch (e) {
      debugPrint("Error loading questions: $e");
      _questions = [];
    }

    _index = 0;
    _score = 0;
    _finished = false;
    _timeLeft = questionDuration;

    _loading = false;
    notifyListeners();

    if (_questions.isNotEmpty) {
      _startTimer();
    }
  }

  // ✅ PERBAIKAN 2: Tambahkan fungsi ini untuk menghilangkan Error 'stopTimer undefined'
  void stopTimer() {
    _timer?.cancel();
  }

  void answer(String selected) {
    if (current == null) return;

    _timer?.cancel();

    if (selected == current!.answer) {
      _score++;
    }

    if (_index < _questions.length - 1) {
      _index++;
      _startTimer();
    } else {
      _finished = true;
    }

    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = questionDuration; // Reset ke 30 detik

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _timeLeft--;

      if (_timeLeft <= 0) {
        t.cancel();
        answer('__timeout__');
      }
      notifyListeners();
    });
  }

  int get stars {
    if (_questions.isEmpty) return 0;
    double percentage = (_score / _questions.length) * 100;
    if (percentage >= 80) return 3;
    if (percentage >= 50) return 2;
    return 1;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
