class ChatHistoryModel {
  final String id;
  final String question;
  final String answer;

  ChatHistoryModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
      id: json["id"],
      question: json["question"],
      answer: json["answer"],
    );
  }
}