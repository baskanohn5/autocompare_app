import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

import "../services/ai_service.dart";

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() =>
      _AiChatScreenState();
}

class _AiChatScreenState
    extends State<AiChatScreen> {
  final AiService aiService = AiService();

  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  final List<Map<String, dynamic>> messages = [];

  bool isLoading = false;

  Future<void> sendMessage() async {
    final message =
        messageController.text.trim();

    if (message.isEmpty) return;

    setState(() {
      messages.add({
        "isUser": true,
        "message": message,
      });

      isLoading = true;
    });

    messageController.clear();

    scrollToBottom();

    try {
      final response =
          await aiService.sendMessage(message);

      setState(() {
        messages.add({
          "isUser": false,
          "message": response,
        });
      });

      scrollToBottom();
    } catch (error) {
      setState(() {
        messages.add({
          "isUser": false,
          "message": error.toString(),
        });
      });

      scrollToBottom();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        if (!scrollController.hasClients) return;

        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration:
              const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }

  Widget quickPrompt(
    String text,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        messageController.text = text;
        sendMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF334155),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFF60A5FA),
              size: 18,
            ),

            const SizedBox(width: 8),

            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget welcomeCard() {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(28),
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
            color:
                Colors.blue.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 95,
            height: 95,
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
                  color:
                      Colors.cyan.withOpacity(
                    0.45,
                  ),
                  blurRadius: 25,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 52,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "AI Araç Danışmanı",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Araç karşılaştır, ikinci el değerlendirmesi al ve yapay zekadan profesyonel tavsiye iste.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFCBD5E1),
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 22),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              quickPrompt(
                "En az yakan SUV öner",
                Icons.local_gas_station,
              ),
              quickPrompt(
                "1 milyon altı aile aracı",
                Icons.family_restroom,
              ),
              quickPrompt(
                "Uzun yol için sedan öner",
                Icons.route,
              ),
              quickPrompt(
                "En sorunsuz dizel araçlar",
                Icons.build,
              ),
              quickPrompt(
                "Öğrenci için ekonomik araç",
                Icons.school,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget messageBubble({
    required bool isUser,
    required String message,
  }) {
    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 7,
        ),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context)
                      .size
                      .width *
                  0.72,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft:
                const Radius.circular(22),
            topRight:
                const Radius.circular(22),
            bottomLeft: Radius.circular(
              isUser ? 22 : 6,
            ),
            bottomRight: Radius.circular(
              isUser ? 6 : 22,
            ),
          ),
          gradient: isUser
              ? const LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF1D4ED8),
                  ],
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFF1E293B),
                    Color(0xFF0F172A),
                  ],
                ),
          border: Border.all(
            color: isUser
                ? Colors.blue.withOpacity(
                    0.30,
                  )
                : const Color(
                    0xFF334155,
                  ),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor:
                      Colors.white
                          .withOpacity(0.14),
                  child: Icon(
                    isUser
                        ? Icons.person
                        : Icons.smart_toy,
                    color: Colors.white,
                    size: 15,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  isUser
                      ? "Sen"
                      : "AutoCompare AI",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              message,
              softWrap: true,
              overflow:
                  TextOverflow.visible,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.55,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget typingLoader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF334155),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF60A5FA),
              ),
            ),

            const SizedBox(width: 12),

            Text(
              "AI düşünüyor...",
              style: TextStyle(
                color: Colors.white
                    .withOpacity(0.85),
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

 
  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
Widget inputArea() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
    color: const Color(0xFF020617),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 860,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1E293B),
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
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: const Color(0xFF60A5FA),
                    decoration: InputDecoration(
                      hintText: "Araç hakkında soru sor...",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.42),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),

                      filled: true,
                      fillColor: Colors.transparent,

                      isDense: true,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                    ),
                    onSubmitted: (_) {
                      if (!isLoading) {
                        sendMessage();
                      }
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            GestureDetector(
              onTap: isLoading ? null : sendMessage,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF06B6D4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.38),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF020617),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            const Color(0xFF020617),
        title: const Text(
          "AutoCompare AI",
          style: TextStyle(
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (messages.isEmpty)
                    welcomeCard(),

                  if (messages.isNotEmpty)
                    ListView.builder(
                      controller:
                          scrollController,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),
                      itemCount:
                          messages.length +
                              (isLoading
                                  ? 1
                                  : 0),
                      itemBuilder:
                          (context, index) {
                        if (isLoading &&
                            index ==
                                messages.length) {
                          return typingLoader();
                        }

                        final item =
                            messages[index];

                        return messageBubble(
                          isUser: item[
                              "isUser"],
                          message: item[
                              "message"],
                        )
                            .animate()
                            .fadeIn(
                              duration:
                                  500.ms,
                            )
                            .slideY(
                              begin: 0.25,
                              end: 0,
                              duration:
                                  500.ms,
                              curve: Curves
                                  .easeOutBack,
                            );
                      },
                    ),
                ],
              ),
            ),
          ),

          inputArea(),
        ],
      ),
    );
  }
}