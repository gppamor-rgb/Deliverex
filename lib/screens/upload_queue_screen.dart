import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/sync_service.dart';

class UploadQueueScreen extends StatefulWidget {
  const UploadQueueScreen({super.key});

  @override
  State<UploadQueueScreen> createState() => _UploadQueueScreenState();
}

class _UploadQueueScreenState extends State<UploadQueueScreen> {
  final SyncService syncService = SyncService();
  List<Map<String, String>> queueItems = [];

  @override
  void initState() {
    super.initState();
    loadQueueItems();
  }

  Future<void> loadQueueItems() async {
    final items = await syncService.getUploadQueue();

    setState(() {
      queueItems = items;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.warning;
      case 'Synced':
        return AppColors.success;
      case 'Failed':
        return AppColors.danger;
      default:
        return AppColors.textLight;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type) {
      case 'OCR Document':
        return Icons.document_scanner_rounded;
      case 'Status Update':
        return Icons.update_rounded;
      case 'GPS Log':
        return Icons.gps_fixed_rounded;
      default:
        return Icons.cloud_upload_rounded;
    }
  }

  void retryUpload(int index) {
    setState(() {
      queueItems[index]['status'] = 'Pending';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added back to pending queue.'),
      ),
    );
  }

  Future<void> syncAll() async {
    await syncService.syncPendingItems();

    await loadQueueItems();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All pending items synced successfully.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount =
        queueItems.where((item) => item['status'] == 'Pending').length;
    final failedCount =
        queueItems.where((item) => item['status'] == 'Failed').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Queue'),
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
                  children: [
                    const Icon(
                      Icons.cloud_sync_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Offline Sync Queue',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Items saved while offline will appear here and sync once internet connection is available.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textLight),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pending: $pendingCount • Failed: $failedCount',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: syncAll,
                        icon: const Icon(
                          Icons.sync_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Sync All',
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
            ),

            const SizedBox(height: 20),

            const Text(
              'Queue Items',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

            for (int index = 0; index < queueItems.length; index++)
              Card(
                color: AppColors.card,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor:
                        getStatusColor(queueItems[index]['status']!)
                            .withOpacity(0.12),
                    child: Icon(
                      getTypeIcon(queueItems[index]['type']!),
                      color: getStatusColor(queueItems[index]['status']!),
                    ),
                  ),
                  title: Text(
                    queueItems[index]['type']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Job: ${queueItems[index]['jobId']}\n'
                      '${queueItems[index]['description']}\n'
                      '${queueItems[index]['time']}',
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        queueItems[index]['status']!,
                        style: TextStyle(
                          color: getStatusColor(queueItems[index]['status']!),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (queueItems[index]['status'] == 'Failed')
                        TextButton(
                          onPressed: () => retryUpload(index),
                          child: const Text('Retry'),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}