import "package:flutter/material.dart";

import "../models/car_model.dart";
import "../models/compare_result_model.dart";
import "../services/car_service.dart";
import "../services/compare_service.dart";
import "../widgets/compare_result_card.dart";

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final CarService carService = CarService();
  final CompareService compareService = CompareService();

  late Future<List<CarModel>> carsFuture;

  CarModel? selectedCar1;
  CarModel? selectedCar2;

  bool isLoading = false;
  CompareResultModel? result;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    carsFuture = carService.getCars();
  }

  Future<void> compareCars() async {
    if (selectedCar1 == null || selectedCar2 == null) {
      setState(() {
        errorMessage = "Lütfen iki araç seçin.";
      });
      return;
    }

    if (selectedCar1!.id == selectedCar2!.id) {
      setState(() {
        errorMessage = "Aynı aracı karşılaştıramazsınız.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      result = null;
    });

    try {
      final compareResult = await compareService.compareCars(
        car1Id: selectedCar1!.id,
        car2Id: selectedCar2!.id,
      );

      setState(() {
        result = compareResult;
      });
    } catch (error) {
      setState(() {
        errorMessage = "Karşılaştırma sırasında hata oluştu.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String carLabel(CarModel car) {
    return "${car.brand} ${car.model} ${car.year} ${car.engine}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Araç Karşılaştır"),
      ),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<CarModel>(
                  value: selectedCar1,
                  decoration: const InputDecoration(
                    labelText: "1. Araç",
                    border: OutlineInputBorder(),
                  ),
                  items: cars.map((car) {
                    return DropdownMenuItem<CarModel>(
                      value: car,
                      child: Text(carLabel(car)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCar1 = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CarModel>(
                  value: selectedCar2,
                  decoration: const InputDecoration(
                    labelText: "2. Araç",
                    border: OutlineInputBorder(),
                  ),
                  items: cars.map((car) {
                    return DropdownMenuItem<CarModel>(
                      value: car,
                      child: Text(carLabel(car)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCar2 = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : compareCars,
                    icon: const Icon(Icons.compare_arrows),
                    label: Text(
                      isLoading ? "Karşılaştırılıyor..." : "Karşılaştır",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (result != null)
                  CompareResultCard(
                    result: result!,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}