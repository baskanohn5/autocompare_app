import "package:flutter/material.dart";

import "../models/favorite_model.dart";
import "../services/favorite_service.dart";
import "car_detail_screen.dart";

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService favoriteService = FavoriteService();

  late Future<List<FavoriteModel>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    favoritesFuture = favoriteService.getFavorites();
  }

  Future<void> refreshFavorites() async {
    setState(() {
      favoritesFuture = favoriteService.getFavorites();
    });
  }

  Future<void> removeFavorite(String favoriteId) async {
    try {
      await favoriteService.removeFavorite(favoriteId);

      await refreshFavorites();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Favori silindi"),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Favori silinemedi"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoriler"),
      ),
      body: FutureBuilder<List<FavoriteModel>>(
        future: favoritesFuture,
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

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const Center(
              child: Text("Henüz favori araç yok"),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshFavorites,
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                final car = favorite.car;

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    title: Text("${car.brand} ${car.model}"),
                    subtitle: Text(
                      "${car.year} • ${car.engine} • ${car.fuelType} • ${car.transmission}",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailScreen(car: car),
                        ),
                      );
                    },
                    trailing: IconButton(
                      onPressed: () {
                        removeFavorite(favorite.favoriteId);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}