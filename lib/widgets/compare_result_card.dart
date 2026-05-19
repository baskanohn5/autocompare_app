import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

import "../models/car_model.dart";
import "../models/compare_result_model.dart";

class CompareResultCard extends StatelessWidget {
  final CompareResultModel result;
  final CarModel car1;
  final CarModel car2;

  const CompareResultCard({
    super.key,
    required this.result,
    required this.car1,
    required this.car2,
  });

  String get car1Name => "${car1.brand} ${car1.model}";
  String get car2Name => "${car2.brand} ${car2.model}";

  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF60A5FA),
            ),
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

  Widget darkCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
            color: Colors.black.withOpacity(0.30),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget radarChart() {
    return darkCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text(
              "Performans Grafiği",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 280,
              child: RadarChart(
                RadarChartData(
                  radarShape: RadarShape.polygon,
                  tickCount: 5,
                  radarBorderData: const BorderSide(
                    color: Color(0xFF475569),
                  ),
                  gridBorderData: BorderSide(
                    color: Colors.white.withOpacity(0.10),
                  ),
                  ticksTextStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                  ),
                  titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  getTitle: (index, angle) {
                    const titles = [
                      "Konfor",
                      "Performans",
                      "Güvenlik",
                      "Şehir",
                      "Uzun Yol",
                      "2. El",
                    ];

                    return RadarChartTitle(
                      text: titles[index],
                      angle: angle,
                    );
                  },
                  dataSets: [
                    RadarDataSet(
                      fillColor: Colors.blue.withOpacity(0.30),
                      borderColor: const Color(0xFF3B82F6),
                      entryRadius: 3,
                      borderWidth: 3,
                      dataEntries: [
                        RadarEntry(value: car1.comfortScore.toDouble()),
                        RadarEntry(value: car1.performanceScore.toDouble()),
                        RadarEntry(value: car1.safetyScore.toDouble()),
                        RadarEntry(value: car1.cityUseScore.toDouble()),
                        RadarEntry(value: car1.longRoadScore.toDouble()),
                        RadarEntry(value: car1.secondHandValue.toDouble()),
                      ],
                    ),
                    RadarDataSet(
                      fillColor: Colors.orange.withOpacity(0.30),
                      borderColor: const Color(0xFFF97316),
                      entryRadius: 3,
                      borderWidth: 3,
                      dataEntries: [
                        RadarEntry(value: car2.comfortScore.toDouble()),
                        RadarEntry(value: car2.performanceScore.toDouble()),
                        RadarEntry(value: car2.safetyScore.toDouble()),
                        RadarEntry(value: car2.cityUseScore.toDouble()),
                        RadarEntry(value: car2.longRoadScore.toDouble()),
                        RadarEntry(value: car2.secondHandValue.toDouble()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                legendDot(
                  const Color(0xFF3B82F6),
                  car1Name,
                ),
                const SizedBox(width: 20),
                legendDot(
                  const Color(0xFFF97316),
                  car2Name,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget legendDot(Color color, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: color,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget infoRow(
    String title,
    String value1,
    String value2,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E293B),
            Color(0xFF111827),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF334155),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF60A5FA),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFF97316),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget scoreBar(
    String title,
    int score1,
    int score2,
  ) {
    return darkCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "$car1Name • $score1 / 10",
              style: const TextStyle(
                color: Color(0xFF60A5FA),
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: score1 / 10,
                minHeight: 10,
                backgroundColor:
                    Colors.white.withOpacity(0.08),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(
                  Color(0xFF3B82F6),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              "$car2Name • $score2 / 10",
              style: const TextStyle(
                color: Color(0xFFF97316),
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: score2 / 10,
                minHeight: 10,
                backgroundColor:
                    Colors.white.withOpacity(0.08),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(
                  Color(0xFFF97316),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bulletList(
    String title,
    List<String> list1,
    List<String> list2,
  ) {
    return darkCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),

            Text(
              car1Name,
              style: const TextStyle(
                color: Color(0xFF60A5FA),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            ...list1.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 3,
                ),
                child: Text(
                  "• $e",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),

            const Divider(
              height: 28,
              color: Color(0xFF334155),
            ),

            Text(
              car2Name,
              style: const TextStyle(
                color: Color(0xFFF97316),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            ...list2.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 3,
                ),
                child: Text(
                  "• $e",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget winnerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF16A34A),
            Color(0xFF166534),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 38,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Kazanan: ${result.winner}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget aiCommentCard() {
    return darkCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.auto_awesome,
              color: Color(0xFFA78BFA),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                result.comment,
                style: const TextStyle(
                  color: Color(0xFFE2E8F0),
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF020617),
            Color(0xFF0F172A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Detaylı Karşılaştırma",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 20),

          radarChart(),

          sectionTitle(
            "Temel Bilgiler",
            Icons.info,
          ),

          infoRow(
            "Yıl",
            car1.year.toString(),
            car2.year.toString(),
          ),

          infoRow(
            "Motor",
            car1.engine,
            car2.engine,
          ),

          infoRow(
            "Yakıt",
            car1.fuelType,
            car2.fuelType,
          ),

          infoRow(
            "Vites",
            car1.transmission,
            car2.transmission,
          ),

          infoRow(
            "Segment",
            car1.segment,
            car2.segment,
          ),

          infoRow(
            "Fiyat",
            "${car1.minPrice} - ${car1.maxPrice} TL",
            "${car2.minPrice} - ${car2.maxPrice} TL",
          ),

          infoRow(
            "Yakıt Tüketimi",
            "${car1.averageFuel} L",
            "${car2.averageFuel} L",
          ),

          infoRow(
            "Bagaj",
            "${car1.trunkVolume} L",
            "${car2.trunkVolume} L",
          ),

          sectionTitle(
            "Skorlar",
            Icons.bar_chart,
          ),

          scoreBar(
            "Konfor",
            car1.comfortScore,
            car2.comfortScore,
          ),

          const SizedBox(height: 10),

          scoreBar(
            "Performans",
            car1.performanceScore,
            car2.performanceScore,
          ),

          const SizedBox(height: 10),

          scoreBar(
            "Güvenlik",
            car1.safetyScore,
            car2.safetyScore,
          ),

          const SizedBox(height: 10),

          scoreBar(
            "Uzun Yol",
            car1.longRoadScore,
            car2.longRoadScore,
          ),

          const SizedBox(height: 10),

          scoreBar(
            "İkinci El Değeri",
            car1.secondHandValue,
            car2.secondHandValue,
          ),

          sectionTitle(
            "Artılar / Eksiler",
            Icons.checklist,
          ),

          bulletList(
            "Artılar",
            car1.pros,
            car2.pros,
          ),

          const SizedBox(height: 12),

          bulletList(
            "Eksiler",
            car1.cons,
            car2.cons,
          ),

          const SizedBox(height: 12),

          bulletList(
            "Yaygın Kullanıcı Şikayetleri",
            car1.commonComplaints,
            car2.commonComplaints,
          ),

          sectionTitle(
            "Sonuç",
            Icons.emoji_events,
          ),

          winnerCard(),

          sectionTitle(
            "AI Detaylı Yorumu",
            Icons.smart_toy,
          ),

          aiCommentCard(),
        ],
      ),
    );
  }
}