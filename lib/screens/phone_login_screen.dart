import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "main_navigation_screen.dart";

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  String? verificationId;
  String? errorMessage;

  bool isCodeSent = false;
  bool isLoading = false;

  Future<void> sendCode() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() {
        errorMessage = "Telefon numarası boş olamaz.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      },
      verificationFailed: (FirebaseAuthException error) {
        setState(() {
          errorMessage = "Kod gönderilemedi: ${error.message}";
          isLoading = false;
        });
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          isCodeSent = true;
          isLoading = false;
          errorMessage = "Kod gönderildi.";
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyCode() async {
    final code = codeController.text.trim();

    if (verificationId == null || code.isEmpty) {
      setState(() {
        errorMessage = "Doğrulama kodunu girin.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        errorMessage = "Kod hatalı veya süresi dolmuş: ${error.message}";
      });
    } catch (error) {
      setState(() {
        errorMessage = "Telefon doğrulama başarısız oldu.";
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget premiumInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required TextInputType keyboardType,
    bool enabled = true,
  }) {
    return SizedBox(
      height: 58,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF60A5FA)),
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF64748B)),
          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
          filled: true,
          fillColor: const Color(0xFF111827),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFF60A5FA),
              width: 1.4,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
        ),
      ),
    );
  }

  Widget errorBox() {
    if (errorMessage == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: errorMessage == "Kod gönderildi."
            ? const Color(0xFF064E3B).withOpacity(0.40)
            : const Color(0xFF7F1D1D).withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: errorMessage == "Kod gönderildi."
              ? const Color(0xFF22C55E).withOpacity(0.45)
              : const Color(0xFFEF4444).withOpacity(0.45),
        ),
      ),
      child: Text(
        errorMessage!,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text("Telefon ile Giriş"),
        centerTitle: true,
        backgroundColor: const Color(0xFF020617),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Container(
            width: 430,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF111827),
                  Color(0xFF0F172A),
                ],
              ),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.24),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF06B6D4),
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
                    Icons.phone_android,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "SMS Doğrulama",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Telefon numaranı doğrulayarak güvenli giriş yap.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                premiumInput(
                  controller: phoneController,
                  label: "Telefon Numarası",
                  hint: "+905551112233",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  enabled: !isCodeSent,
                ),
                if (isCodeSent) ...[
                  const SizedBox(height: 12),
                  premiumInput(
                    controller: codeController,
                    label: "SMS Kodu",
                    hint: "123456",
                    icon: Icons.sms,
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 16),
                errorBox(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : isCodeSent
                            ? verifyCode
                            : sendCode,
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(isCodeSent
                            ? Icons.verified
                            : Icons.send_to_mobile),
                    label: Text(
                      isLoading
                          ? "Bekleyin..."
                          : isCodeSent
                              ? "Kodu Doğrula"
                              : "Kod Gönder",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}