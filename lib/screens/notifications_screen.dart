import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'New Job Assigned',
        'message': 'You have been assigned to Job Order JO-2026-001.',
        'time': 'Today, 9:00 AM',
        'type': 'assignment',
      },
      {
        'title': 'Delivery Status Reminder',
        'message': 'Please update your delivery status when you arrive on site.',
        'time': 'Today, 9:30 AM',
        'type': 'reminder',
      },
      {
        'title': 'Document Upload Pending',
        'message': 'Delivery receipt is pending OCR submission.',
        'time': 'Today, 10:15 AM',
        'type': 'document',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Job updates, reminders, and document alerts will appear here.',
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 20),

            for (final item in notifications)
              Card(
                color: AppColors.card,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.12),
                    child: Icon(
                      _getNotificationIcon(item['type']!),
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    item['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${item['message']}\n${item['time']}',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'assignment':
        return Icons.assignment_rounded;
      case 'reminder':
        return Icons.access_time_rounded;
      case 'document':
        return Icons.document_scanner_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }
}
