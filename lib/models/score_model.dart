class ScoreModel {
  final int highScore;
  final int lastScore;
  final int playCount;

  ScoreModel({
    required this.highScore,
    required this.lastScore,
    required this.playCount,
  });

  factory ScoreModel.initial() {
    return ScoreModel(highScore: 0, lastScore: 0, playCount: 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'highScore': highScore,
      'lastScore': lastScore,
      'playCount': playCount,
    };
  }

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      highScore: json['highScore'] ?? 0,
      lastScore: json['lastScore'] ?? 0,
      playCount: json['playCount'] ?? 0,
    );
  }
}
