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

  Widget heroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
            color: Colors.blue.withOpacity(0.30),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
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
                  color: Colors.cyan.withOpacity(0.42),
                  blurRadius: 24,
                ),
              ],
            ),
            child: const Icon(
              Icons.compare_arrows_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Premium Araç Karşılaştırma",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "İki aracı seç, AI destekli detaylı analiz ve skor karşılaştırmasını gör.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFCBD5E1),
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget carPreviewCard({
    required String title,
    required CarModel? car,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
        border: Border.all(
          color: car == null ? const Color(0xFF334155) : color.withOpacity(0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: car == null ? Colors.black.withOpacity(0.20) : color.withOpacity(0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.16),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  car == null ? "Henüz araç seçilmedi" : "${car.brand} ${car.model}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (car != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    "${car.year} • ${car.engine} • ${car.fuelType} • ${car.transmission}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget compareDropdown({
    required String label,
    required CarModel? value,
    required List<CarModel> cars,
    required void Function(CarModel?) onChanged,
    required Color color,
  }) {
    return SizedBox(
      height: 58,
      child: DropdownButtonFormField<CarModel>(
        value: value,
        isExpanded: true,
        dropdownColor: const Color(0xFF0F172A),
        iconEnabledColor: color,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.directions_car_filled,
            color: color,
            size: 21,
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF94A3B8),
          ),
          filled: true,
          fillColor: const Color(0xFF111827),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFF334155),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: color,
              width: 1.4,
            ),
          ),
        ),
        items: cars.map((car) {
          return DropdownMenuItem<CarModel>(
            value: car,
            child: Text(
              carLabel(car),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget vsBadge() {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEF4444),
            Color(0xFFF97316),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.34),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "VS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget errorCard() {
    if (errorMessage == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF7F1D1D).withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEF4444).withOpacity(0.45),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget compareButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : compareCars,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.auto_graph_rounded),
        label: Text(
          isLoading ? "Karşılaştırılıyor..." : "AI ile Karşılaştır",
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget selectionPanel(List<CarModel> cars) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF111827),
            Color(0xFF0F172A),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF334155),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          carPreviewCard(
            title: "1. Araç",
            car: selectedCar1,
            color: const Color(0xFF60A5FA),
            icon: Icons.looks_one_rounded,
          ),
          const SizedBox(height: 12),
          compareDropdown(
            label: "1. Araç Seç",
            value: selectedCar1,
            cars: cars,
            color: const Color(0xFF60A5FA),
            onChanged: (value) {
              setState(() {
                selectedCar1 = value;
              });
            },
          ),
          const SizedBox(height: 18),
          vsBadge(),
          const SizedBox(height: 18),
          carPreviewCard(
            title: "2. Araç",
            car: selectedCar2,
            color: const Color(0xFFF97316),
            icon: Icons.looks_two_rounded,
          ),
          const SizedBox(height: 12),
          compareDropdown(
            label: "2. Araç Seç",
            value: selectedCar2,
            cars: cars,
            color: const Color(0xFFF97316),
            onChanged: (value) {
              setState(() {
                selectedCar2 = value;
              });
            },
          ),
          errorCard(),
          const SizedBox(height: 18),
          compareButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text("Araç Karşılaştır"),
        centerTitle: true,
        backgroundColor: const Color(0xFF020617),
      ),
      body: FutureBuilder<List<CarModel>>(
        future: carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF60A5FA),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Hata: ${snapshot.error}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          final cars = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 125),
            child: Column(
              children: [
                heroHeader(),
                const SizedBox(height: 18),
                selectionPanel(cars),
                const SizedBox(height: 16),
                if (result != null &&
                    selectedCar1 != null &&
                    selectedCar2 != null)
                  CompareResultCard(
                    result: result!,
                    car1: selectedCar1!,
                    car2: selectedCar2!,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}