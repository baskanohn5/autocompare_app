import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api_config.dart";
import "../models/car_model.dart";

class CarService {
  Future<List<CarModel>> getCars() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api/cars");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final List carsJson = decodedData["data"];

      return carsJson
          .map((car) => CarModel.fromJson(car))
          .toList();
    } else {
      throw Exception("Araçlar alınamadı");
    }
  }

  Future<List<CarModel>> searchCars({
    String? brand,
    String? fuelType,
    String? transmission,
    int? maxPrice,
  }) async {
    final Map<String, String> queryParameters = {};

    if (brand != null && brand.isNotEmpty) {
      queryParameters["brand"] = brand;
    }

    if (fuelType != null && fuelType.isNotEmpty) {
      queryParameters["fuelType"] = fuelType;
    }

    if (transmission != null && transmission.isNotEmpty) {
      queryParameters["transmission"] = transmission;
    }

    if (maxPrice != null) {
      queryParameters["maxPrice"] = maxPrice.toString();
    }

    final url = Uri.parse(
      "${ApiConfig.baseUrl}/api/cars/search",
    ).replace(
      queryParameters: queryParameters,
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final List carsJson = decodedData["data"];

      return carsJson
          .map((car) => CarModel.fromJson(car))
          .toList();
    } else {
      throw Exception("Araç arama başarısız");
    }
  }
}