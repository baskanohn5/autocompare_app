import "package:flutter/material.dart";

import "../models/chat_history_model.dart";
import "../services/chat_history_service.dart";

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final ChatHistoryService chatHistoryService = ChatHistoryService();

  late Future<List<ChatHistoryModel>> historyFuture;

  @override
  void initState() {
    super.initState();
    historyFuture = chatHistoryService.getChatHistory();
  }

  Future<void> refreshHistory() async {
    setState(() {
      historyFuture = chatHistoryService.getChatHistory();
    });
  }

  Widget historyCard(ChatHistoryModel item) {
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
            Text(item.question),
            const Divider(height: 24),
            const Text(
              "AI Cevabı",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 6),
            Text(item.answer),
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
      body: FutureBuilder<List<ChatHistoryModel>>(
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