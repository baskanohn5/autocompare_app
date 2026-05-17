import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api_config.dart";
import "../models/favorite_model.dart";
import "auth_service.dart";

class FavoriteService {
  final AuthService authService = AuthService();

  Future<List<FavoriteModel>> getFavorites() async {
    final token = await authService.getIdToken();

    final url = Uri.parse("${ApiConfig.baseUrl}/api/favorites");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List favoritesJson = decodedData["data"];

      return favoritesJson
          .map((favorite) => FavoriteModel.fromJson(favorite))
          .toList();
    } else {
      throw Exception("Favoriler getirilemedi");
    }
  }

  Future<void> addFavorite(String carId) async {
    final token = await authService.getIdToken();

    final url = Uri.parse("${ApiConfig.baseUrl}/api/favorites");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "carId": carId,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception("Favori eklenemedi");
    }
  }

  Future<void> removeFavorite(String favoriteId) async {
    final token = await authService.getIdToken();

    final url = Uri.parse(
      "${ApiConfig.baseUrl}/api/favorites/$favoriteId",
    );

    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Favori silinemedi");
    }
  }
}