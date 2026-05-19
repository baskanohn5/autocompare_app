import "package:flutter/material.dart";

import "../models/car_model.dart";
import "../services/car_service.dart";
import "../widgets/car_card.dart";
import "car_detail_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarService carService = CarService();

  late Future<List<CarModel>> carsFuture;

  @override
  void initState() {
    super.initState();
    carsFuture = carService.getCars();
  }

  Future<void> refreshCars() async {
    setState(() {
      carsFuture = carService.getCars();
    });
  }

 Widget header(int totalCars) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      gradient: const LinearGradient(
        colors: [
          Color(0xFF020617),
          Color(0xFF1E3A8A),
          Color(0xFF2563EB),
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
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 68,
              height: 68,
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
                    color:
                        Colors.cyan.withOpacity(0.45),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_car_filled,
                color: Colors.white,
                size: 34,
              ),
            ),

            const SizedBox(width: 16),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "AutoCompare",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    "AI destekli premium araç analiz sistemi",
                    style: TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white24,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.dashboard_customize,
                color: Colors.white,
                size: 20,
              ),

              const SizedBox(width: 10),

              Text(
                "$totalCars araç listeleniyor",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            premiumChip(
              Icons.auto_awesome,
              "AI Destekli",
              const Color(0xFFA78BFA),
            ),

            premiumChip(
              Icons.compare_arrows,
              "Karşılaştırma",
              const Color(0xFF60A5FA),
            ),

            premiumChip(
              Icons.favorite,
              "Favoriler",
              const Color(0xFFEF4444),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget premiumChip(
  IconData icon,
  String text,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: color.withOpacity(0.25),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),

        const SizedBox(width: 6),

        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CarModel>>(
        future: carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Hata: ${snapshot.error}"),
            );
          }

          final cars = snapshot.data ?? [];

          if (cars.isEmpty) {
            return const Center(
              child: Text("Araç bulunamadı"),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshCars,
            child: ListView.builder(
              itemCount: cars.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return header(cars.length);
                }

                final car = cars[index - 1];

                return CarCard(
                  car: car,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailScreen(car: car),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}