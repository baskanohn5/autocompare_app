import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api_config.dart";
import "auth_service.dart";

class AiService {
  final AuthService authService = AuthService();

  Future<String> sendMessage(String message) async {
    final token = await authService.getIdToken();

    if (token == null) {
      throw Exception("Kullanıcı giriş yapmamış");
    }

    final url = Uri.parse("${ApiConfig.baseUrl}/api/ai/recommend");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "message": message,
      }),
    );

    if (!response.body.trim().startsWith("{")) {
      throw Exception(
        "Backend JSON dönmedi. URL yanlış olabilir: ${ApiConfig.baseUrl}",
      );
    }

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return decodedData["data"]["answer"];
    } else {
      throw Exception(
        decodedData["message"] ?? "Yapay zeka cevabı alınamadı",
      );
    }
  }
}