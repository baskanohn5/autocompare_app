import "car_model.dart";

class FavoriteModel {
  final String favoriteId;
  final CarModel car;

  FavoriteModel({
    required this.favoriteId,
    required this.car,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      favoriteId: json["favoriteId"] ?? "",
      car: CarModel.fromJson(json["car"]),
    );
  }
}