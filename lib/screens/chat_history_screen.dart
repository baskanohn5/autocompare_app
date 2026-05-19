import "package:flutter/material.dart";

import "../services/chat_service.dart";

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final ChatService chatService = ChatService();

  late Future<List<dynamic>> historyFuture;

  @override
  void initState() {
    super.initState();
    historyFuture = chatService.getChatHistory();
  }

  Future<void> refreshHistory() async {
    setState(() {
      historyFuture = chatService.getChatHistory();
    });
  }

  Widget historyCard(dynamic item) {
    final question = item["question"] ?? "Soru bulunamadı";
    final answer = item["answer"] ?? "Cevap bulunamadı";

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Soru",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 6),
            Text(question),
            const Divider(height: 24),
            const Text(
              "AI Cevabı",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 6),
            Text(answer),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Sohbet Geçmişi"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Hata: ${snapshot.error}"),
            );
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return const Center(
              child: Text("Henüz sohbet geçmişi yok"),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshHistory,
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return historyCard(history[index]);
              },
            ),
          );
        },
      ),
    );
  }
}