import "package:flutter/material.dart";

import "../models/car_model.dart";

class CarDetailScreen extends StatelessWidget {
  final CarModel car;

  const CarDetailScreen({
    super.key,
    required this.car,
  });

  Color scoreColor(int score) {
    if (score >= 8) return const Color(0xFF22C55E);
    if (score >= 6) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  Widget heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF020617),
            Color(0xFF0F172A),
            Color(0xFF1D4ED8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 105,
            height: 105,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF38BDF8),
                  Color(0xFF2563EB),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.45),
                  blurRadius: 25,
                ),
              ],
            ),
            child: const Icon(
              Icons.directions_car_filled,
              color: Colors.white,
              size: 58,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${car.brand} ${car.model}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${car.year} • ${car.engine} • ${car.fuelType} • ${car.transmission}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              "${car.minPrice} - ${car.maxPrice} TL",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF60A5FA)),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget darkPanel({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF111827),
            Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Color(0xFF334155)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget aiSummary() {
    return darkPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFFA78BFA)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "${car.brand} ${car.model}, ${car.segment} sınıfında ${car.fuelType.toLowerCase()} yakıt tipi ve ${car.transmission.toLowerCase()} vitesiyle öne çıkıyor. Konfor ${car.comfortScore}/10, güvenlik ${car.safetyScore}/10, ikinci el değeri ${car.secondHandValue}/10.",
                style: const TextStyle(
                  color: Color(0xFFE5E7EB),
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoGrid() {
  final items = [
    ["Segment", car.segment, Icons.category],
    ["Kasa", car.bodyType, Icons.car_rental],
    ["Yakıt", car.fuelType, Icons.local_gas_station],
    ["Vites", car.transmission, Icons.settings],
    ["Beygir", "${car.horsePower} HP", Icons.bolt],
    ["Bagaj", "${car.trunkVolume} L", Icons.luggage],
    ["Tüketim", "${car.averageFuel} L/100 km", Icons.speed],
    ["Aile", car.familyFriendly ? "Uygun" : "Uygun değil", Icons.family_restroom],
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: 2.35,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    ),
    itemBuilder: (context, index) {
      final item = items[index];

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Color(0xFF334155),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: const Color(0xFF2563EB).withOpacity(0.20),
              child: Icon(
                item[2] as IconData,
                color: const Color(0xFF60A5FA),
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item[0] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item[1] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

  Widget scoreCard(String title, int score, IconData icon) {
    final color = scoreColor(score);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.16),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: score / 10,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.10),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "$score/10",
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget equipmentList() {
    final labels = {
      "multimedia": "Multimedya",
      "appleCarPlay": "Apple CarPlay",
      "androidAuto": "Android Auto",
      "sunroof": "Sunroof",
      "leatherSeat": "Deri Koltuk",
      "adaptiveCruiseControl": "Adaptif Hız Sabitleyici",
      "laneAssist": "Şerit Takip",
      "blindSpotWarning": "Kör Nokta Uyarı",
      "rearCamera": "Geri Görüş Kamerası",
      "parkingSensor": "Park Sensörü",
      "digitalDisplay": "Dijital Gösterge",
      "automaticClimate": "Otomatik Klima",
    };

    return darkPanel(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: labels.entries.map((entry) {
            final hasFeature = car.equipment[entry.key] == true;
            final color = hasFeature ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color.withOpacity(0.30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasFeature ? Icons.check_circle : Icons.cancel,
                    color: color,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    entry.value,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget bulletCard(List<String> items, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.isEmpty
            ? [
                const Text(
                  "Bilgi bulunmuyor",
                  style: TextStyle(color: Colors.white70),
                )
              ]
            : items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: color, size: 17),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Color(0xFFE5E7EB),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: Text("${car.brand} ${car.model}"),
        centerTitle: true,
        backgroundColor: const Color(0xFF020617),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heroCard(),
            const SizedBox(height: 16),
            aiSummary(),

            sectionTitle("Araç Kimliği", Icons.info),
            infoGrid(),

            sectionTitle("Donanım Paketi", Icons.dashboard_customize),
            equipmentList(),

            sectionTitle("Performans ve Kullanım Skorları", Icons.bar_chart),
            scoreCard("Konfor", car.comfortScore, Icons.airline_seat_recline_extra),
            scoreCard("Performans", car.performanceScore, Icons.speed),
            scoreCard("Güvenlik", car.safetyScore, Icons.security),
            scoreCard("Şehir İçi Kullanım", car.cityUseScore, Icons.location_city),
            scoreCard("Uzun Yol", car.longRoadScore, Icons.route),
            scoreCard("İkinci El Değeri", car.secondHandValue, Icons.sell),
            scoreCard("Parça Bulunabilirliği", car.sparePartAvailability, Icons.build),
            scoreCard("Bakım Maliyeti", car.maintenanceCost, Icons.money),
            scoreCard("Kronik Sorun Puanı", car.chronicProblemScore, Icons.warning),

            sectionTitle("Güçlü Yönler", Icons.thumb_up),
            bulletCard(car.pros, const Color(0xFF22C55E), Icons.check_circle),

            sectionTitle("Zayıf Yönler", Icons.thumb_down),
            bulletCard(car.cons, const Color(0xFFF59E0B), Icons.info),

            sectionTitle("Yaygın Kullanıcı Şikayetleri", Icons.report_problem),
            bulletCard(car.commonComplaints, const Color(0xFFEF4444), Icons.warning),

            sectionTitle("Önerilen Kullanım Tipi", Icons.recommend),
            bulletCard(car.recommendedUsage, const Color(0xFF60A5FA), Icons.star),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}