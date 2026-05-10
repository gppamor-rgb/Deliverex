class DatabaseService {
  Future<void> saveLocalDeliveryUpdate({
    required String jobOrderId,
    required String status,
    double? latitude,
    double? longitude,
  }) async {
    // TODO: Save locally using Hive, SQLite, or SharedPreferences.
  }

  Future<void> saveLocalDocumentRecord({
    required String jobOrderId,
    required String imagePath,
    required String status,
  }) async {
    // TODO: Save local document upload record.
  }

  Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    // TODO: Return pending offline queue items.
    return [];
  }
}