import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'tracking_screen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> messages = [
    {
      'sender': 'bot',
      'text':
          'Hello! I am the Deliverex Assistant. I can help you with tracking, delivery status meanings, contact information, and document upload reminders.',
    },
  ];

  final List<Map<String, String>> faqs = [
    {
      'question': 'How can I track my delivery?',
      'answer':
          'You can track your delivery by entering your Tracking ID in the Track Delivery page. The system will show the latest status, location, and update time.',
    },
    {
      'question': 'Where can I find my Tracking ID?',
      'answer':
          'Your Tracking ID is provided by the company once your delivery record is created. You may ask the dispatcher or check your delivery confirmation details.',
    },
    {
      'question': 'What does En Route mean?',
      'answer':
          'En Route means the assigned driver has started the delivery trip and is currently on the way to the destination.',
    },
    {
      'question': 'What does Arrived mean?',
      'answer':
          'Arrived means the driver has reached the pickup point or delivery destination, depending on the current delivery step.',
    },
    {
      'question': 'What does Completed mean?',
      'answer':
          'Completed means the delivery task has been finished and the required delivery document or proof of delivery may be submitted for verification.',
    },
    {
      'question': 'How do I contact the company?',
      'answer':
          'For official inquiries, please contact Providential 628 Site Preparation Services through the company contact number or email provided by the office.',
    },
    {
      'question': 'Can I create a job order here?',
      'answer':
          'No. Deliverex does not support customer online ordering or job creation. Customers can only track deliveries and ask basic inquiries.',
    },
    {
      'question': 'What happens if OCR is incorrect?',
      'answer':
          'If Tesseract OCR extracts incorrect information, the admin will manually review, correct, and validate the document before it becomes an official record.',
    },
  ];

  void addFaqResponse(String question, String answer) {
    setState(() {
      messages.add({
        'sender': 'user',
        'text': question,
      });

      messages.add({
        'sender': 'bot',
        'text': answer,
      });
    });
  }

  void openTrackingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrackingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inquiry / Chatbot'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            tooltip: 'Track Delivery',
            onPressed: openTrackingPage,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 20),

                  for (final message in messages)
                    _ChatBubble(
                      text: message['text']!,
                      isUser: message['sender'] == 'user',
                    ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.card,
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Questions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: faqs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final faq = faqs[index];

                        return OutlinedButton(
                          onPressed: () {
                            addFaqResponse(
                              faq['question']!,
                              faq['answer']!,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            faq['question']!,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: openTrackingPage,
                      icon: const Icon(
                        Icons.confirmation_number_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Track Delivery by Tracking ID',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const _ChatBubble({
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: isUser
              ? null
              : Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : AppColors.textDark,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}