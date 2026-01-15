import '../models/question_model.dart';

class QuestionHelper {
  static List<QuestionModel> random10(List<QuestionModel> all) {
    final list = List<QuestionModel>.from(all);
    list.shuffle();
    return list.take(10).toList();
  }
}
