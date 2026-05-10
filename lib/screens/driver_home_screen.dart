import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'job_detail_screen.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobs = [
      {
        'jobId': 'JO-2026-001',
        'client': 'Providential Site A',
        'material': 'Gravel',
        'destination': 'Quezon City',
        'status': 'Assigned',
      },
      {
        'jobId': 'JO-2026-002',
        'client': 'Providential Site B',
        'material': 'Sand',
        'destination': 'Bulacan',
        'status': 'Pending',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Driver Home'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Assigned Deliveries',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'View your assigned delivery jobs for today.',
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 20),

            for (final job in jobs)
              Card(
                color: AppColors.card,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.12),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    job['jobId']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${job['client']}\nMaterial: ${job['material']}\nDestination: ${job['destination']}',
                    ),
                  ),
                  trailing: Text(
                    job['status']!,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailScreen(job: job),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}