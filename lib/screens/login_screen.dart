import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../services/auth_service.dart";
import "main_navigation_screen.dart";
import "phone_login_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLogin ? "Giriş Yap" : "Kayıt Ol",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "E-posta",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Şifre",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submit,
                      child: Text(
                        isLoading
                            ? "Bekleyin..."
                            : isLogin
                                ? "Giriş Yap"
                                : "Kayıt Ol",
                      ),
                    ),
                  ),
                  if (isLogin)
                    TextButton(
                      onPressed: isLoading ? null : resetPassword,
                      child: const Text("Şifremi Unuttum"),
                    ),
                    TextButton.icon(
                     onPressed: isLoading ? null
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
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        errorMessage = null;
                      });
                    },
                    child: Text(
                      isLogin
                          ? "Hesabın yok mu? Kayıt ol"
                          : "Zaten hesabın var mı? Giriş yap",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}