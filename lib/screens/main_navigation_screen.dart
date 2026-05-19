import "dart:ui";

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
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int selectedIndex = 3;

  final List<Widget> screens = const [
    HomeScreen(),
    SearchScreen(),
    CompareScreen(),
    AiChatScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  void changeTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isActive =
        selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => changeTab(index),
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(18),

            gradient: isActive
                ? const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF06B6D4),
                    ],
                  )
                : null,

            color: isActive
                ? null
                : Colors.transparent,

            boxShadow: isActive
                ? [
                    BoxShadow(
                      color:
                          Colors.blue.withOpacity(
                        0.35,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive
                    ? Colors.white
                    : const Color(0xFF94A3B8),
                size: isActive ? 25 : 22,
              ),

              const SizedBox(height: 5),

              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : const Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget premiumBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        0,
        12,
        14,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 14,
            sigmaY: 14,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(28),
              color: const Color(
                0xFF0F172A,
              ).withOpacity(0.92),
              border: Border.all(
                color: const Color(0xFF334155),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(
                    0.35,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  navItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: "Ana Sayfa",
                  ),

                  navItem(
                    index: 1,
                    icon: Icons.search_rounded,
                    label: "Ara",
                  ),

                  navItem(
                    index: 2,
                    icon:
                        Icons.compare_arrows_rounded,
                    label: "Karşılaştır",
                  ),

                  navItem(
                    index: 3,
                    icon: Icons.smart_toy_rounded,
                    label: "AI",
                  ),

                  navItem(
                    index: 4,
                    icon: Icons.favorite_rounded,
                    label: "Favoriler",
                  ),

                  navItem(
                    index: 5,
                    icon: Icons.person_rounded,
                    label: "Profil",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF020617),

      body: screens[selectedIndex],

      bottomNavigationBar:
          premiumBottomBar(),
    );
  }
}