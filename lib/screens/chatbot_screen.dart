import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      'How can I track my delivery?',
      'Where can I find my Tracking ID?',
      'How do I contact the company?',
      'What does En Route mean?',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inquiry / Chatbot'),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Deliverex Assistant',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Basic inquiry support for delivery tracking and common questions.',
            style: TextStyle(color: AppColors.textLight),
          ),
          const SizedBox(height: 24),

          for (final faq in faqs)
            Card(
              color: AppColors.card,
              child: ListTile(
                leading: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: AppColors.primary,
                ),
                title: Text(faq),
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }
}