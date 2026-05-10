import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/api_service.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TextEditingController trackingController = TextEditingController();
  final ApiService apiService = ApiService();

  Map<String, dynamic>? trackingResult;
  String? errorMessage;
  bool isSearching = false;

  Future<void> searchTracking() async {
    final trackingId = trackingController.text.trim();

    if (trackingId.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a Tracking ID.';
        trackingResult = null;
      });
      return;
    }

    setState(() {
      isSearching = true;
      errorMessage = null;
      trackingResult = null;
    });

    final result = await apiService.trackDelivery(trackingId: trackingId);

    setState(() {
      isSearching = false;

      if (result == null) {
        errorMessage = 'Tracking ID not found. Please check and try again.';
      } else {
        trackingResult = result;
      }
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.warning;
      case 'Assigned':
        return AppColors.primary;
      case 'En Route':
        return Colors.deepPurple;
      case 'Arrived':
        return AppColors.warning;
      case 'Completed':
        return AppColors.success;
      default:
        return AppColors.textLight;
    }
  }

  @override
  void dispose() {
    trackingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = trackingResult?['status'] ?? '';

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
              textCapitalization: TextCapitalization.characters,
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
                onPressed: isSearching ? null : searchTracking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSearching
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            if (trackingResult != null) ...[
              const SizedBox(height: 24),

              Card(
                color: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Status',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(status).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: getStatusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _TrackingRow(
                        icon: Icons.confirmation_number_rounded,
                        label: 'Tracking ID',
                        value: trackingResult!['trackingId'],
                      ),

                      _TrackingRow(
                        icon: Icons.assignment_rounded,
                        label: 'Job Order ID',
                        value: trackingResult!['jobOrderId'],
                      ),

                      _TrackingRow(
                        icon: Icons.business_rounded,
                        label: 'Client',
                        value: trackingResult!['client'],
                      ),

                      _TrackingRow(
                        icon: Icons.inventory_2_rounded,
                        label: 'Material',
                        value: trackingResult!['material'],
                      ),

                      _TrackingRow(
                        icon: Icons.location_on_rounded,
                        label: 'Last Location',
                        value: trackingResult!['lastLocation'],
                      ),

                      _TrackingRow(
                        icon: Icons.update_rounded,
                        label: 'Last Updated',
                        value: trackingResult!['lastUpdated'],
                      ),

                      _TrackingRow(
                        icon: Icons.schedule_rounded,
                        label: 'Estimated Arrival',
                        value: trackingResult!['estimatedArrival'],
                      ),

                      _TrackingRow(
                        icon: Icons.document_scanner_rounded,
                        label: 'Proof of Delivery / OCR',
                        value: trackingResult!['proofOfDelivery'],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 18),

            const Text(
              'Demo Tracking ID: TRK-2026-001',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TrackingRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}