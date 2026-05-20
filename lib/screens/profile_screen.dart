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
        builder: (context) =>LoginScreen(),
      ),
      (route) => false,
    );
  }

  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
          border: Border.all(color: const Color(0xFF334155)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: color.withOpacity(0.16),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF64748B),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget infoPanel({
    required String userInfo,
    required String loginType,
    required bool emailVerified,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF111827),
            Color(0xFF0F172A),
          ],
        ),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user,
                color: Color(0xFF60A5FA),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Hesap Durumu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: emailVerified
                      ? const Color(0xFF22C55E).withOpacity(0.14)
                      : const Color(0xFFF59E0B).withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: emailVerified
                        ? const Color(0xFF22C55E).withOpacity(0.30)
                        : const Color(0xFFF59E0B).withOpacity(0.30),
                  ),
                ),
                child: Text(
                  emailVerified ? "Doğrulanmış" : "Aktif",
                  style: TextStyle(
                    color: emailVerified
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFF59E0B),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.account_circle, color: Color(0xFF94A3B8)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  userInfo,
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.login, color: Color(0xFF94A3B8)),
              const SizedBox(width: 10),
              Text(
                loginType,
                style: const TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final userInfo =
        user?.email ?? user?.phoneNumber ?? "Kullanıcı bilgisi bulunamadı";

    final loginType =
        user?.phoneNumber != null ? "Telefon ile giriş" : "E-posta ile giriş";

    final emailVerified = user?.emailVerified ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        backgroundColor: const Color(0xFF020617),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 125),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
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
                    color: Colors.blue.withOpacity(0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 104,
                    height: 104,
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
                          color: Colors.cyan.withOpacity(0.45),
                          blurRadius: 26,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 58,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userInfo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loginType,
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text(
                      "AutoCompare Premium Kullanıcı",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                statCard(
                  icon: Icons.smart_toy,
                  title: "AI Analiz",
                  value: "Aktif",
                  color: const Color(0xFF60A5FA),
                ),
                const SizedBox(width: 10),
                statCard(
                  icon: Icons.favorite,
                  title: "Favoriler",
                  value: "Hazır",
                  color: const Color(0xFFEF4444),
                ),
                const SizedBox(width: 10),
                statCard(
                  icon: Icons.compare_arrows,
                  title: "Compare",
                  value: "Pro",
                  color: const Color(0xFFF97316),
                ),
              ],
            ),

            const SizedBox(height: 18),

            infoPanel(
              userInfo: userInfo,
              loginType: loginType,
              emailVerified: emailVerified,
            ),

            const SizedBox(height: 20),

            actionButton(
              icon: Icons.history,
              title: "AI Sohbet Geçmişi",
              subtitle: "Geçmiş araç analizlerini ve AI cevaplarını görüntüle",
              color: const Color(0xFF60A5FA),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatHistoryScreen(),
                  ),
                );
              },
            ),

            actionButton(
              icon: Icons.logout,
              title: "Çıkış Yap",
              subtitle: "Hesabından güvenli şekilde çıkış yap",
              color: const Color(0xFFEF4444),
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
    );
  }
}