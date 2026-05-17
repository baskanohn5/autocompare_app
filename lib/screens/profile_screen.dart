import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../services/auth_service.dart";
import "chat_history_screen.dart";
import "login_screen.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final authService = AuthService();

    await authService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> printToken(BuildContext context) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();

    debugPrint("TOKEN:");
    debugPrint(token);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Token console'a yazdırıldı"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.person,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 16),

            Text(
              user?.email ?? "Kullanıcı bulunamadı",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatHistoryScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text("AI Sohbet Geçmişi"),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => printToken(context),
                icon: const Icon(Icons.key),
                label: const Text("TOKEN AL"),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => logout(context),
                icon: const Icon(Icons.logout),
                label: const Text("Çıkış Yap"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}