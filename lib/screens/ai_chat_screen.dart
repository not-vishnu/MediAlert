import 'dart:ui';

import 'package:flutter/material.dart';

import '../services/openrouter_service.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final OpenRouterService ai = OpenRouterService();
  bool isLoading = false;

  final List<Map<String, dynamic>> messages = [
    {
      "isUser": false,
      "message":
          "👋 Hello! I'm MediAlert AI.\n\nAsk me about medicines, dosage, side effects, symptoms, or general health tips.",
    },
  ];

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final question = messageController.text.trim();

    setState(() {
      messages.add({"isUser": true, "message": question});
      isLoading = true;
    });

    messageController.clear();

    try {
      final reply = await ai.sendMessage(question);
      setState(() {
        messages.add({"isUser": false, "message": reply});
      });
    } catch (e) {
      setState(() {
        messages.add({"isUser": false, "message": "❌ Error\n\n$e"});
      });
    }

    setState(() => isLoading = false);
  }

  Widget _glass({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
    double radius = 20,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, .18),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, .30),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget chatBubble(bool isUser, String text) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isUser
                      ? AppColors.primary.withValues(alpha: .55)
                      : Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .28),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
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
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  "MediAlert AI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  setState(() {
                    messages.clear();
                    messages.add({
                      "isUser": false,
                      "message":
                          "👋 Hello! I'm MediAlert AI.\n\nHow can I help you today?",
                    });
                  });
                },
              ),
            ],
          ),
        ),

        // Disclaimer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _glass(
            padding: const EdgeInsets.all(12),
            radius: 14,
            child: Text(
              AppConstants.aiDisclaimer,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange.shade200,
                fontSize: 12,
              ),
            ),
          ),
        ),

        // Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return chatBubble(
                messages[index]["isUser"] as bool,
                messages[index]["message"] as String,
              );
            },
          ),
        ),

        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(color: Colors.white),
          ),

        // Input
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 90),
          child: _glass(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            radius: 22,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    textInputAction: TextInputAction.send,
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (_) {
                      if (!isLoading) sendMessage();
                    },
                    decoration: const InputDecoration(
                      hintText: "Ask about medicines...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: isLoading ? null : sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: .75),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .35),
                      ),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
