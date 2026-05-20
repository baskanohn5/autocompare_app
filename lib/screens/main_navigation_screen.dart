import "package:flutter/material.dart";

import "ai_chat_screen.dart";
import "compare_screen.dart";
import "favorites_screen.dart";
import "home_screen.dart";
import "profile_screen.dart";
import "search_screen.dart";

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int selectedIndex = 3;

  int favoritesRefreshKey = 0;

  void changeTab(int index) {
    setState(() {
      selectedIndex = index;

      if (index == 4) {
        favoritesRefreshKey++;
      }
    });
  }

  Widget currentScreen() {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const CompareScreen();
      case 3:
        return const AiChatScreen();
      case 4:
        return FavoritesScreen(
          key: ValueKey(favoritesRefreshKey),
        );
      case 5:
        return const ProfileScreen();
      default:
        return const AiChatScreen();
    }
  }

  Widget navItem(int index, IconData icon, String label) {
    final isActive = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => changeTab(index),
        child: Container(
          height: 62,
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isActive
                ? const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF06B6D4),
                    ],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF94A3B8),
                size: isActive ? 24 : 21,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF94A3B8),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(
          top: BorderSide(color: Color(0xFF334155)),
        ),
      ),
      child: Row(
        children: [
          navItem(0, Icons.home_rounded, "Ana Sayfa"),
          navItem(1, Icons.search_rounded, "Ara"),
          navItem(2, Icons.compare_arrows_rounded, "Karşılaştır"),
          navItem(3, Icons.smart_toy_rounded, "AI"),
          navItem(4, Icons.favorite_rounded, "Favoriler"),
          navItem(5, Icons.person_rounded, "Profil"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Column(
        children: [
          Expanded(
            child: currentScreen(),
          ),
          bottomBar(),
        ],
      ),
    );
  }
}