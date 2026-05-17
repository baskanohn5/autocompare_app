import "package:flutter/material.dart";

import "../services/ai_service.dart";

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final AiService aiService = AiService();

  final TextEditingController messageController =
      TextEditingController();

  final List<Map<String, dynamic>> messages = [];

  bool isLoading = false;

  Future<void> sendMessage() async {
    final message = messageController.text.trim();

    if (message.isEmpty) return;

    setState(() {
      messages.add({
        "isUser": true,
        "message": message,
      });

      isLoading = true;
    });

    messageController.clear();

    try {
      final response = await aiService.sendMessage(message);

      setState(() {
        messages.add({
          "isUser": false,
          "message": response,
        });
      });
    } catch (error) {
      setState(() {
        messages.add({
          "isUser": false,
          "message": error.toString(),
        });
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget messageBubble({
    required bool isUser,
    required String message,
  }) {
    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(
          maxWidth: 320,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blue
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Araç Danışmanı"),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      "AI araç danışmanına soru sor",
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final item = messages[index];

                      return messageBubble(
                        isUser: item["isUser"],
                        message: item["message"],
                      );
                    },
                  ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: CircularProgressIndicator(),
            ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: "Mesaj yaz...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : sendMessage,
                      child: const Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}