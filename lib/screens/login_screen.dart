import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../services/auth_service.dart";
import "main_navigation_screen.dart";
import "phone_login_screen.dart";

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  bool obscurePassword = true;
  String? errorMessage;

  String getFirebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case "invalid-email":
        return "Geçerli bir e-posta adresi girin.";
      case "user-not-found":
      case "wrong-password":
      case "invalid-credential":
        return "E-posta veya şifre yanlış.";
      case "email-already-in-use":
        return "Bu e-posta adresi zaten kayıtlı.";
      case "weak-password":
        return "Şifre en az 6 karakter olmalı.";
      case "missing-password":
        return "Şifre alanı boş bırakılamaz.";
      case "network-request-failed":
        return "İnternet bağlantınızı kontrol edin.";
      default:
        return "İşlem başarısız oldu. Bilgilerinizi kontrol edin.";
    }
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        errorMessage = "Şifre sıfırlamak için e-posta adresinizi yazın.";
      });
      return;
    }

    try {
      await authService.resetPassword(email: email);

      setState(() {
        errorMessage = "Şifre sıfırlama maili gönderildi.";
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        errorMessage = getFirebaseErrorMessage(error);
      });
    } catch (error) {
      setState(() {
        errorMessage = "Şifre sıfırlama işlemi başarısız oldu.";
      });
    }
  }

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "E-posta ve şifre alanları boş bırakılamaz.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (isLogin) {
        final credential = await authService.login(
          email: email,
          password: password,
        );

        await credential.user?.reload();

        final user = FirebaseAuth.instance.currentUser;

        if (user != null && !user.emailVerified) {
          await FirebaseAuth.instance.signOut();

          setState(() {
            errorMessage =
                "E-posta doğrulanmamış. Lütfen mail adresinizi doğrulayın.";
          });

          return;
        }

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      } else {
        final credential = await authService.register(
          email: email,
          password: password,
        );

        await credential.user?.sendEmailVerification();
        await FirebaseAuth.instance.signOut();

        setState(() {
          isLogin = true;
          errorMessage =
              "Doğrulama maili gönderildi. Lütfen mailinizi doğrulayıp giriş yapın.";
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        errorMessage = getFirebaseErrorMessage(error);
      });
    } catch (error) {
      setState(() {
        errorMessage = "Beklenmeyen bir hata oluştu.";
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
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      height: 58,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF60A5FA),
          ),
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF94A3B8),
          ),
          filled: true,
          fillColor: const Color(0xFF111827),
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

  Widget errorBox() {
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }

    final bool success =
        errorMessage!.contains("gönderildi") || errorMessage!.contains("doğrulayıp");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: success
            ? const Color(0xFF064E3B).withOpacity(0.40)
            : const Color(0xFF7F1D1D).withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: success
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

  Widget modeSwitch() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF334155),
        ),
      ),
      child: Row(
        children: [
          modeButton("Giriş Yap", true),
          modeButton("Kayıt Ol", false),
        ],
      ),
    );
  }

  Widget modeButton(String text, bool loginValue) {
    final bool active = isLogin == loginValue;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isLogin = loginValue;
            errorMessage = null;
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
            child: Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("PREMIUM_LOGIN_SCREEN_LOADED");

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: const Color(0xFF334155),
              ),
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
                    Icons.directions_car_filled,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "AutoCompare",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  isLogin
                      ? "Premium araç analiz sistemine giriş yap"
                      : "Yeni hesabını oluştur ve araç analizlerine başla",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                modeSwitch(),

                const SizedBox(height: 18),

                premiumInput(
                  controller: emailController,
                  label: "E-posta",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 12),

                premiumInput(
                  controller: passwordController,
                  label: "Şifre",
                  icon: Icons.lock,
                  obscure: obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                errorBox(),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : submit,
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            isLogin ? Icons.login : Icons.person_add,
                          ),
                    label: Text(
                      isLoading
                          ? "Bekleyin..."
                          : isLogin
                              ? "Giriş Yap"
                              : "Kayıt Ol",
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

                if (isLogin)
                  TextButton(
                    onPressed: isLoading ? null : resetPassword,
                    child: const Text("Şifremi Unuttum"),
                  ),

                TextButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PhoneLoginScreen(),
                            ),
                          );
                        },
                  icon: const Icon(Icons.phone_android),
                  label: const Text("Telefon ile giriş yap"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}