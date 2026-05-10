import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, String> job;

  const JobDetailScreen({
    super.key,
    required this.job,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late String currentStatus;

  final LocationService locationService = LocationService();

  Position? lastPosition;
  DateTime? lastUpdatedTime;
  bool isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.job['status'] ?? 'Assigned';
  }

  Future<void> updateStatus(String newStatus) async {
    setState(() {
      isUpdatingStatus = true;
    });

    final position = await locationService.getCurrentLocation();

    if (!mounted) return;

    if (position == null) {
      setState(() {
        isUpdatingStatus = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to get location. Please enable GPS and allow location permission.',
          ),
        ),
      );
      return;
    }

    setState(() {
      currentStatus = newStatus;
      lastPosition = position;
      lastUpdatedTime = DateTime.now();
      isUpdatingStatus = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Status updated to $newStatus with GPS location.',
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Assigned':
        return AppColors.primary;
      case 'En Route':
        return AppColors.warning;
      case 'Arrived':
        return Colors.deepPurple;
      case 'Completed':
        return AppColors.success;
      default:
        return AppColors.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                    Text(
                      job['jobId'] ?? 'Job Order',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(currentStatus).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        currentStatus,
                        style: TextStyle(
                          color: getStatusColor(currentStatus),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    _DetailRow(
                      icon: Icons.business_rounded,
                      label: 'Client',
                      value: job['client'] ?? 'N/A',
                    ),

                    _DetailRow(
                      icon: Icons.inventory_2_rounded,
                      label: 'Material',
                      value: job['material'] ?? 'N/A',
                    ),

                    _DetailRow(
                      icon: Icons.location_on_rounded,
                      label: 'Destination',
                      value: job['destination'] ?? 'N/A',
                    ),

                    const _DetailRow(
                      icon: Icons.schedule_rounded,
                      label: 'Schedule',
                      value: 'Today, 9:00 AM',
                    ),

                    const _DetailRow(
                      icon: Icons.note_alt_rounded,
                      label: 'Instruction',
                      value: 'Proceed to site and update status upon arrival.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

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
                    const Row(
                      children: [
                        Icon(
                          Icons.gps_fixed_rounded,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Latest GPS Update',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (lastPosition == null)
                      const Text(
                        'No GPS update yet. Update delivery status to capture location.',
                        style: TextStyle(color: AppColors.textLight),
                      )
                    else ...[
                      Text(
                        'Latitude: ${lastPosition!.latitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Longitude: ${lastPosition!.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Updated: ${lastUpdatedTime.toString()}',
                        style: const TextStyle(color: AppColors.textLight),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Update Delivery Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

            if (isUpdatingStatus) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 12),
            ],

            _StatusButton(
              label: 'Start Delivery / En Route',
              icon: Icons.route_rounded,
              color: AppColors.warning,
              onPressed: isUpdatingStatus ? () {} : () => updateStatus('En Route'),
            ),

            const SizedBox(height: 10),

            _StatusButton(
              label: 'Mark as Arrived',
              icon: Icons.location_pin,
              color: Colors.deepPurple,
              onPressed: isUpdatingStatus ? () {} : () => updateStatus('Arrived'),
            ),

            const SizedBox(height: 10),

            _StatusButton(
              label: 'Mark as Completed',
              icon: Icons.check_circle_rounded,
              color: AppColors.success,
              onPressed: isUpdatingStatus ? () {} : () => updateStatus('Completed'),
            ),

            const SizedBox(height: 24),

            const Text(
              'Next Modules',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: AppColors.card,
              child: ListTile(
                leading: const Icon(
                  Icons.map_rounded,
                  color: AppColors.primary,
                ),
                title: const Text('Open Maps Navigation'),
                subtitle: const Text('Navigate to the delivery destination.'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Maps navigation will be added next.'),
                    ),
                  );
                },
              ),
            ),

            Card(
              color: AppColors.card,
              child: ListTile(
                leading: const Icon(
                  Icons.document_scanner_rounded,
                  color: AppColors.primary,
                ),
                title: const Text('Capture Delivery Document'),
                subtitle: const Text('Upload receipt/job order for OCR.'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('OCR capture screen will be added next.'),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
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
          Icon(icon, color: AppColors.primary),
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

class _StatusButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _StatusButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}