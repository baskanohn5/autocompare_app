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
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "AutoCompare",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "AI destekli araç karşılaştırma ve öneri sistemi",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "$totalCars araç listeleniyor",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
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