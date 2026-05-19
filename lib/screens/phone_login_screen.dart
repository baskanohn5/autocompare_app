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

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Telefon ile Giriş"),
      ),
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
                  const Icon(
                    Icons.phone_android,
                    size: 70,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "SMS Doğrulama",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    enabled: !isCodeSent,
                    decoration: const InputDecoration(
                      labelText: "Telefon Numarası",
                      hintText: "+905551112233",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (isCodeSent) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "SMS Kodu",
                        hintText: "123456",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
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
                      onPressed: isLoading
                          ? null
                          : isCodeSent
                              ? verifyCode
                              : sendCode,
                      child: Text(
                        isLoading
                            ? "Bekleyin..."
                            : isCodeSent
                                ? "Kodu Doğrula"
                                : "Kod Gönder",
                      ),
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