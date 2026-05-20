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

  String brandMode = "Manuel";
  String selectedBrand = "";
  List<String> brandOptions = [];

  bool isLoading = false;
  bool hasSearched = false;
  List<CarModel> cars = [];

  @override
  void initState() {
    super.initState();
    loadBrandOptions();
  }

  Future<void> loadBrandOptions() async {
    try {
      final result = await carService.getCars();

      final brands = result
          .map((car) => car.brand)
          .where((brand) => brand.trim().isNotEmpty)
          .toSet()
          .toList();

      brands.sort();

      if (!mounted) return;

      setState(() {
        brandOptions = brands;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        brandOptions = [];
      });
    }
  }

  Future<void> searchCars() async {
    try {
      setState(() {
        isLoading = true;
        hasSearched = true;
      });

      final String brandValue = brandMode == "Auto"
    ? selectedBrand
    : brandController.text
        .trim()
        .split(" ")
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() +
                  word.substring(1).toLowerCase(),
        )
        .join(" ");
      final result = await carService.searchCars(
        brand: brandValue,
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

  Widget brandModeSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF334155),
        ),
      ),
      child: Row(
        children: [
          brandModeButton("Manuel", Icons.edit),
          brandModeButton("Auto", Icons.directions_car_filled),
        ],
      ),
    );
  }

  Widget brandModeButton(String value, IconData icon) {
    final bool active = brandMode == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            brandMode = value;

            if (value == "Manuel") {
              selectedBrand = "";
            } else {
              brandController.clear();
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: active
                ? const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF06B6D4),
                    ],
                  )
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: active ? Colors.white : const Color(0xFF94A3B8),
                  size: 18,
                ),
                const SizedBox(width: 7),
                Text(
                  value,
                  style: TextStyle(
                    color: active ? Colors.white : const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget brandInputArea() {
    if (brandMode == "Auto") {
      return dropdownField(
        label: "Marka Seç",
        icon: Icons.directions_car,
        value: selectedBrand,
        items: brandOptions,
        onChanged: (value) {
          setState(() {
            selectedBrand = value ?? "";
          });
        },
      );
    }

    return inputField(
      controller: brandController,
      label: "Marka",
      icon: Icons.directions_car,
    );
  }

  Widget inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 58,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF60A5FA),
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
            borderSide: const BorderSide(
              color: Color(0xFF60A5FA),
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget dropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return SizedBox(
      height: 58,
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        isExpanded: true,
        dropdownColor: const Color(0xFF0F172A),
        iconEnabledColor: const Color(0xFF60A5FA),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF60A5FA),
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
            borderSide: const BorderSide(
              color: Color(0xFF60A5FA),
              width: 1.4,
            ),
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget emptyState() {
    final text = hasSearched
        ? "Aramana uygun araç bulunamadı"
        : "Filtreleri seçip araç aramaya başla";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 22),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF111827),
            Color(0xFF0F172A),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF334155),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_rounded,
            color: Color(0xFF60A5FA),
            size: 52,
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
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
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text("Araç Ara"),
        centerTitle: true,
        backgroundColor: const Color(0xFF020617),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 125),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF020617),
                    Color(0xFF1E3A8A),
                    Color(0xFF2563EB),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.28),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.manage_search_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Akıllı Araç Arama",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Bütçe, yakıt ve vites seçerek uygun aracı bul.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFCBD5E1),
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            brandModeSelector(),

            const SizedBox(height: 12),

            brandInputArea(),

            const SizedBox(height: 12),

            dropdownField(
              label: "Yakıt Tipi",
              icon: Icons.local_gas_station,
              value: selectedFuel,
              items: const ["Benzin", "Dizel", "Hibrit", "Elektrik"],
              onChanged: (value) {
                setState(() {
                  selectedFuel = value ?? "";
                });
              },
            ),

            const SizedBox(height: 12),

            dropdownField(
              label: "Vites",
              icon: Icons.settings,
              value: selectedTransmission,
              items: const ["Otomatik", "Manuel"],
              onChanged: (value) {
                setState(() {
                  selectedTransmission = value ?? "";
                });
              },
            ),

            const SizedBox(height: 12),

            inputField(
              controller: maxPriceController,
              label: "Maksimum Bütçe",
              icon: Icons.payments,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : searchCars,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.search),
                label: Text(isLoading ? "Aranıyor..." : "Ara"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            if (cars.isEmpty) emptyState(),

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