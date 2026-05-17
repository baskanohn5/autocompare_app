import "package:flutter/material.dart";

import "../models/car_model.dart";

class CarDetailScreen extends StatelessWidget {
  final CarModel car;

  const CarDetailScreen({
    super.key,
    required this.car,
  });

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget scoreCard(String title, int score, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: Text(
          "$score / 10",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final familyText = car.familyFriendly ? "Uygun" : "Uygun değil";

    return Scaffold(
      appBar: AppBar(
        title: Text("${car.brand} ${car.model}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        size: 64,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "${car.brand} ${car.model}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${car.year} • ${car.engine} • ${car.fuelType} • ${car.transmission}",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            sectionTitle("Temel Bilgiler"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    infoRow("Segment", car.segment),
                    infoRow("Kasa Tipi", car.bodyType),
                    infoRow("Yakıt", car.fuelType),
                    infoRow("Vites", car.transmission),
                    infoRow("Beygir Gücü", "${car.horsePower} HP"),
                    infoRow("Bagaj Hacmi", "${car.trunkVolume} L"),
                    infoRow("Ortalama Yakıt", "${car.averageFuel} L/100 km"),
                    infoRow(
                      "Fiyat Aralığı",
                      "${car.minPrice} - ${car.maxPrice} TL",
                    ),
                  ],
                ),
              ),
            ),
            sectionTitle("Kullanım Uygunluğu"),
            scoreCard(
              "Konfor",
              car.comfortScore,
              Icons.airline_seat_recline_extra,
            ),
            scoreCard("Performans", car.performanceScore, Icons.speed),
            scoreCard("Güvenlik", car.safetyScore, Icons.security),
            scoreCard(
              "Şehir İçi Kullanım",
              car.cityUseScore,
              Icons.location_city,
            ),
            scoreCard("Uzun Yol", car.longRoadScore, Icons.route),
            Card(
              child: ListTile(
                leading: const Icon(Icons.family_restroom, color: Colors.blue),
                title: const Text("Aile Kullanımı"),
                trailing: Text(
                  familyText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            sectionTitle("Piyasa ve Maliyet"),
            scoreCard(
              "Türkiye'de Tutulma",
              car.marketPopularity,
              Icons.trending_up,
            ),
            scoreCard(
              "Parça Bulunabilirliği",
              car.sparePartAvailability,
              Icons.build,
            ),
            scoreCard("Bakım Maliyeti", car.maintenanceCost, Icons.money),
            scoreCard("İkinci El Değeri", car.secondHandValue, Icons.sell),
            scoreCard(
              "Kronik Sorun Puanı",
              car.chronicProblemScore,
              Icons.warning,
            ),
          ],
        ),
      ),
    );
  }
}