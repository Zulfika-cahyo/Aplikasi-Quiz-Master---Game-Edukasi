class QuestionModel {
  final String question;
  final List<String> options;
  final String answer;

  late final List<String> shuffledOptions;

  QuestionModel({
    required this.question,
    required this.options,
    required this.answer,
  }) {
    shuffledOptions = List<String>.from(options)..shuffle();
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'],
      options: List<String>.from(map['options']),
      answer: map['answer'],
    );
  }
}
