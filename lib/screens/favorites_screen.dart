import "package:flutter/material.dart";

import "../models/favorite_model.dart";
import "../services/favorite_service.dart";
import "car_detail_screen.dart";

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {
  final FavoriteService favoriteService =
      FavoriteService();

  late Future<List<FavoriteModel>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    favoritesFuture = favoriteService.getFavorites();
  }

  Future<void> refreshFavorites() async {
    setState(() {
      favoritesFuture =
          favoriteService.getFavorites();
    });
  }

  Future<void> removeFavorite(
    String favoriteId,
  ) async {
    try {
      await favoriteService.removeFavorite(
        favoriteId,
      );

      await refreshFavorites();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Favori silindi"),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Favori silinemedi"),
        ),
      );
    }
  }

  Widget emptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF111827),
              Color(0xFF0F172A),
            ],
          ),
          border: Border.all(
            color: Color(0xFF334155),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              color: Color(0xFFEF4444),
              size: 72,
            ),
            SizedBox(height: 18),
            Text(
              "Henüz favori araç yok",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Beğendiğin araçları favorilere ekleyerek daha sonra hızlıca inceleyebilirsin.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget favoriteCard(FavoriteModel favorite) {
    final car = favorite.car;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CarDetailScreen(car: car),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF111827),
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
              blurRadius: 18,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFEF4444),
                    Color(0xFF7F1D1D),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.32),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 38,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "${car.brand} ${car.model}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${car.year} • ${car.engine} • ${car.fuelType} • ${car.transmission}",
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      chip(
                        Icons.speed,
                        "${car.averageFuel} L",
                        const Color(0xFF22C55E),
                      ),
                      chip(
                        Icons.security,
                        "Güvenlik ${car.safetyScore}/10",
                        const Color(0xFF60A5FA),
                      ),
                      chip(
                        Icons.trending_up,
                        "2. El ${car.secondHandValue}/10",
                        const Color(0xFFF59E0B),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                removeFavorite(
                  favorite.favoriteId,
                );
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chip(
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
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
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text("Favoriler"),
        centerTitle: true,
        backgroundColor: const Color(0xFF020617),
      ),
      body: FutureBuilder<List<FavoriteModel>>(
        future: favoriteService.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
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

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return emptyState();
          }

          return RefreshIndicator(
            onRefresh: refreshFavorites,
            child: ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return favoriteCard(
                  favorites[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}