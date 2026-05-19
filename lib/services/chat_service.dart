import "dart:convert";

import "package:firebase_auth/firebase_auth.dart";
import "package:http/http.dart" as http;

import "../config/api_config.dart";

class ChatService {
  Future<List<dynamic>> getChatHistory() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (token == null) {
      throw Exception("Kullanıcı giriş yapmamış");
    }

    final url = Uri.parse("${ApiConfig.baseUrl}/api/chat-history");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (!response.body.trim().startsWith("{")) {
      throw Exception("Backend JSON dönmedi. Endpoint yanlış olabilir.");
    }

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return data["data"];
    }

    throw Exception(data["message"] ?? "Chat geçmişi alınamadı");
  }
}