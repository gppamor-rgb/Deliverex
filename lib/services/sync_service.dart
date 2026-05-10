class SyncService {
  static final List<Map<String, String>> uploadQueue = [
    {
      'type': 'Status Update',
      'jobId': 'JO-2026-001',
      'description': 'Status changed to En Route',
      'status': 'Synced',
      'time': 'Today, 10:15 AM',
    },
    {
      'type': 'GPS Log',
      'jobId': 'JO-2026-002',
      'description': 'Latest location update',
      'status': 'Failed',
      'time': 'Today, 9:50 AM',
    },
  ];

  Future<bool> hasInternetConnection() async {
    // TODO: Later use connectivity_plus package.
    return true;
  }

  Future<void> addToUploadQueue({
    required String type,
    required String jobId,
    required String description,
    required String status,
    required String time,
  }) async {
    uploadQueue.insert(0, {
      'type': type,
      'jobId': jobId,
      'description': description,
      'status': status,
      'time': time,
    });
  }

  Future<List<Map<String, String>>> getUploadQueue() async {
    return uploadQueue;
  }

  Future<void> syncPendingItems() async {
    for (final item in uploadQueue) {
      if (item['status'] == 'Pending' || item['status'] == 'Failed') {
        item['status'] = 'Synced';
      }
    }
  }
}