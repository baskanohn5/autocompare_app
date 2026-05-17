import "package:flutter/material.dart";

import "../models/car_model.dart";
import "../services/car_service.dart";
import "../widgets/car_card.dart";
import "car_detail_screen.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CarService carService = CarService();

  final TextEditingController brandController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  String selectedFuel = "";
  String selectedTransmission = "";

  bool isLoading = false;
  List<CarModel> cars = [];

  Future<void> searchCars() async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await carService.searchCars(
        brand: brandController.text.trim(),
        fuelType: selectedFuel,
        transmission: selectedTransmission,
        maxPrice: maxPriceController.text.trim().isEmpty
            ? null
            : int.tryParse(maxPriceController.text.trim()),
      );

      setState(() {
        cars = result;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Araç arama başarısız"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    brandController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Araç Ara"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: brandController,
              decoration: const InputDecoration(
                labelText: "Marka",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedFuel.isEmpty ? null : selectedFuel,
              decoration: const InputDecoration(
                labelText: "Yakıt Tipi",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Benzin", child: Text("Benzin")),
                DropdownMenuItem(value: "Dizel", child: Text("Dizel")),
                DropdownMenuItem(value: "Hibrit", child: Text("Hibrit")),
                DropdownMenuItem(value: "Elektrik", child: Text("Elektrik")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedFuel = value ?? "";
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedTransmission.isEmpty ? null : selectedTransmission,
              decoration: const InputDecoration(
                labelText: "Vites",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Otomatik", child: Text("Otomatik")),
                DropdownMenuItem(value: "Manuel", child: Text("Manuel")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTransmission = value ?? "";
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Maksimum Bütçe",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : searchCars,
                icon: const Icon(Icons.search),
                label: Text(isLoading ? "Aranıyor..." : "Ara"),
              ),
            ),
            const SizedBox(height: 24),
            if (cars.isEmpty) const Text("Henüz arama yapılmadı"),
            ...cars.map(
              (car) => CarCard(
                car: car,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarDetailScreen(car: car),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}