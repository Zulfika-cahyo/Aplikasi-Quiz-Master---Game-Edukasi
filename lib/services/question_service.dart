import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class QuestionService {
  static Future<List<QuestionModel>> loadQuestions(String category) async {
    String path;

    switch (category) {
      case 'general':
        path = 'assets/questions/general.json';
        break;
      case 'math':
        path = 'assets/questions/math.json';
        break;
      case 'english':
        path = 'assets/questions/english.json';
        break;
      case 'nationality':
        path = 'assets/questions/nationality.json'; // ✅ FIX
        break;
      default:
        throw Exception('Kategori tidak ditemukan');
    }

    final jsonString = await rootBundle.loadString(path);
    final List data = json.decode(jsonString);

    return data.map((e) => QuestionModel.fromMap(e)).toList();
  }
}
