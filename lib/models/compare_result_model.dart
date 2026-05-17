class CompareResultModel {
  final String car1Name;
  final int car1Score;
  final String car2Name;
  final int car2Score;
  final String winner;
  final String comment;

  CompareResultModel({
    required this.car1Name,
    required this.car1Score,
    required this.car2Name,
    required this.car2Score,
    required this.winner,
    required this.comment,
  });

  factory CompareResultModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return CompareResultModel(
      car1Name: data["car1"]["name"],
      car1Score: data["car1"]["score"],
      car2Name: data["car2"]["name"],
      car2Score: data["car2"]["score"],
      winner: data["winner"],
      comment: data["comment"],
    );
  }
}