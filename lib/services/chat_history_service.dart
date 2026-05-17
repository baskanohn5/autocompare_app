import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api_config.dart";
import "../models/chat_history_model.dart";
import "auth_service.dart";

class ChatHistoryService {
  final AuthService authService = AuthService();

  Future<List<ChatHistoryModel>> getChatHistory() async {
    final token = await authService.getIdToken();

    if (token == null) {
      throw Exception("Kullanıcı giriş yapmamış");
    }

    final url = Uri.parse("${ApiConfig.baseUrl}/api/chat-history");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List historyJson = decodedData["data"];

      return historyJson
          .map((item) => ChatHistoryModel.fromJson(item))
          .toList();
    } else {
      throw Exception(
        decodedData["message"] ?? "Chat geçmişi alınamadı",
      );
    }
  }
}