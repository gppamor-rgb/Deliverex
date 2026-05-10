class ApiService {
  // Temporary base URL.
  // Replace this later with your actual web server/API URL.
  static const String baseUrl = 'https://your-api-url.com/api';

  Future<bool> loginDriver({
    required String username,
    required String password,
  }) async {
    // TODO: Connect to backend API.
    // Example later: POST /driver/login
    return true;
  }

  Future<bool> loginCustomer({
    required String email,
    required String password,
  }) async {
    // TODO: Connect to backend API.
    // Example later: POST /customer/login
    return true;
  }

  Future<bool> updateDeliveryStatus({
    required String jobOrderId,
    required String status,
    double? latitude,
    double? longitude,
  }) async {
    // TODO: Send status and GPS data to backend.
    // Example later: POST /delivery/status-update
    return true;
  }

  Future<Map<String, dynamic>?> trackDelivery({
    required String trackingId,
  }) async {
    // TODO: Connect to backend tracking endpoint later.
    // Example later: GET /tracking/{trackingId}

    if (trackingId.toUpperCase() != 'TRK-2026-001') {
      return null;
    }

    return { // Sample tracking data for testing.
      'trackingId': 'TRK-2026-001',
      'jobOrderId': 'JO-2026-001',
      'client': 'Providential Site A',
      'material': 'Gravel',
      'status': 'En Route',
      'lastLocation': 'Quezon City',
      'lastUpdated': 'Today, 10:30 AM',
      'estimatedArrival': 'Today, 11:15 AM',
      'proofOfDelivery': 'Pending OCR Review',
    };
  }
}