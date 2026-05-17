import "package:flutter/material.dart";

import "../models/compare_result_model.dart";

class CompareResultCard extends StatelessWidget {
  final CompareResultModel result;

  const CompareResultCard({
    super.key,
    required this.result,
  });

  Widget scoreRow(String carName, int score, bool isWinner) {
    return Card(
      color: isWinner ? Colors.green.withOpacity(0.12) : null,
      child: ListTile(
        leading: Icon(
          isWinner ? Icons.emoji_events : Icons.directions_car,
          color: isWinner ? Colors.orange : Colors.blue,
        ),
        title: Text(carName),
        trailing: Text(
          "$score / 100",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final car1Winner = result.winner == result.car1Name;
    final car2Winner = result.winner == result.car2Name;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Karşılaştırma Sonucu",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            scoreRow(result.car1Name, result.car1Score, car1Winner),

            scoreRow(result.car2Name, result.car2Score, car2Winner),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Kazanan: ${result.winner}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Yorum",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 8),

            Text(result.comment),
          ],
        ),
      ),
    );
  }
}