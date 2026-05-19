import "package:flutter/material.dart";

import "../models/chat_history_model.dart";
import "../services/chat_history_service.dart";

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() =>
      _ChatHistoryScreenState();
}

class _ChatHistoryScreenState
    extends State<ChatHistoryScreen> {
  final ChatHistoryService chatHistoryService =
      ChatHistoryService();

  late Future<List<ChatHistoryModel>>
      historyFuture;

  @override
  void initState() {
    super.initState();

    historyFuture =
        chatHistoryService.getChatHistory();
  }

  Widget emptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF111827),
              Color(0xFF0F172A),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF334155),
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
              Icons.history,
              color: Color(0xFF60A5FA),
              size: 72,
            ),
            SizedBox(height: 18),
            Text(
              "Henüz sohbet geçmişi yok",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "AI ile yaptığın araç analizleri burada görünecek.",
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

  Widget historyCard(ChatHistoryModel item) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(18),
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
          color: const Color(0xFF334155),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.30),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF06B6D4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.blue.withOpacity(
                        0.35,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "AutoCompare AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Sohbet Kaydı",
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(18),
              color: const Color(0xFF1E293B),
              border: Border.all(
                color: const Color(0xFF334155),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Soru",
                  style: TextStyle(
                    color: Color(0xFF60A5FA),
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  item.question,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(18),
              color: const Color(0xFF0F172A),
              border: Border.all(
                color: const Color(0xFF334155),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFA78BFA),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "AI Cevabı",
                      style: TextStyle(
                        color: Color(0xFFA78BFA),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  item.answer,
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
        title: const Text(
          "AI Sohbet Geçmişi",
        ),
        centerTitle: true,
        backgroundColor:
            const Color(0xFF020617),
      ),

      body: FutureBuilder<
          List<ChatHistoryModel>>(
        future: historyFuture,
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

          final history =
              snapshot.data ?? [];

          if (history.isEmpty) {
            return emptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 20,
            ),
            itemCount: history.length,
            itemBuilder: (context, index) {
              return historyCard(
                history[index],
              );
            },
          );
        },
      ),
    );
  }
}