import "package:flutter/material.dart";

import "../models/car_model.dart";
import "../services/favorite_service.dart";

class CarCard extends StatefulWidget {
  final CarModel car;
  final VoidCallback onTap;

  const CarCard({
    super.key,
    required this.car,
    required this.onTap,
  });

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  final FavoriteService favoriteService = FavoriteService();

  bool isLoading = false;
  bool isFavorite = false;

  Future<void> toggleFavorite() async {
    try {
      setState(() {
        isLoading = true;
      });

      await favoriteService.addFavorite(widget.car.id);

      setState(() {
        isFavorite = true;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favorilere eklendi")),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favori işlemi başarısız")),
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
  Widget build(BuildContext context) {
    final car = widget.car;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.directions_car,
                  size: 42,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${car.brand} ${car.model}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text("${car.year} • ${car.engine}"),
                    const SizedBox(height: 4),
                    Text("${car.fuelType} • ${car.transmission}"),
                    const SizedBox(height: 8),
                    Text(
                      "${car.minPrice} - ${car.maxPrice} TL",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: isLoading ? null : toggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_gas_station,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text("${car.averageFuel} L"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}