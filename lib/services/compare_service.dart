import "dart:convert";
import "package:http/http.dart" as http;

import "../config/api_config.dart";
import "../models/compare_result_model.dart";

class CompareService {
  Future<CompareResultModel> compareCars({
    required String car1Id,
    required String car2Id,
  }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api/compare");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "car1Id": car1Id,
        "car2Id": car2Id,
      }),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      return CompareResultModel.fromJson(decodedData);
    } else {
      throw Exception("Karşılaştırma yapılamadı");
    }
  }
}