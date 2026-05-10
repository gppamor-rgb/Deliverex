import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TextEditingController trackingController = TextEditingController();
  bool showResult = false;

  void searchTracking() {
    if (trackingController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      showResult = true;
    });
  }

  @override
  void dispose() {
    trackingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Track Delivery'),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(
              Icons.search_rounded,
              size: 72,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Track Your Delivery',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your Tracking ID to view the latest delivery status.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: trackingController,
              decoration: const InputDecoration(
                labelText: 'Tracking ID',
                hintText: 'Example: TRK-2026-001',
                prefixIcon: Icon(Icons.confirmation_number_rounded),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: searchTracking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            if (showResult) ...[
              const SizedBox(height: 24),
              Card(
                color: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Status',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text('Tracking ID: TRK-2026-001'),
                      Text('Status: En Route'),
                      Text('Last Location: Quezon City'),
                      Text('Last Updated: Today, 10:30 AM'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}