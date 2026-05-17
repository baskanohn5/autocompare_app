class CarModel {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String engine;
  final String fuelType;
  final String transmission;
  final String bodyType;

  final int minPrice;
  final int maxPrice;

  final double averageFuel;

  final int marketPopularity;
  final int sparePartAvailability;
  final int maintenanceCost;
  final int secondHandValue;
  final int chronicProblemScore;

  final String segment;
  final int comfortScore;
  final int performanceScore;
  final int safetyScore;

  final bool familyFriendly;

  final int cityUseScore;
  final int longRoadScore;

  final int horsePower;
  final int trunkVolume;

  CarModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.engine,
    required this.fuelType,
    required this.transmission,
    required this.bodyType,
    required this.minPrice,
    required this.maxPrice,
    required this.averageFuel,
    required this.marketPopularity,
    required this.sparePartAvailability,
    required this.maintenanceCost,
    required this.secondHandValue,
    required this.chronicProblemScore,
    required this.segment,
    required this.comfortScore,
    required this.performanceScore,
    required this.safetyScore,
    required this.familyFriendly,
    required this.cityUseScore,
    required this.longRoadScore,
    required this.horsePower,
    required this.trunkVolume,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json["id"] ?? "",
      brand: json["brand"] ?? "",
      model: json["model"] ?? "",
      year: json["year"] ?? 0,
      engine: json["engine"] ?? "",
      fuelType: json["fuelType"] ?? "",
      transmission: json["transmission"] ?? "",
      bodyType: json["bodyType"] ?? "",

      minPrice: json["minPrice"] ?? 0,
      maxPrice: json["maxPrice"] ?? 0,

      averageFuel: ((json["averageFuel"] ?? 0) as num).toDouble(),

      marketPopularity: json["marketPopularity"] ?? 0,
      sparePartAvailability: json["sparePartAvailability"] ?? 0,
      maintenanceCost: json["maintenanceCost"] ?? 0,
      secondHandValue: json["secondHandValue"] ?? 0,
      chronicProblemScore: json["chronicProblemScore"] ?? 0,

      segment: json["segment"] ?? "Bilinmiyor",
      comfortScore: json["comfortScore"] ?? 0,
      performanceScore: json["performanceScore"] ?? 0,
      safetyScore: json["safetyScore"] ?? 0,

      familyFriendly: json["familyFriendly"] ?? false,

      cityUseScore: json["cityUseScore"] ?? 0,
      longRoadScore: json["longRoadScore"] ?? 0,

      horsePower: json["horsePower"] ?? 0,
      trunkVolume: json["trunkVolume"] ?? 0,
    );
  }
}