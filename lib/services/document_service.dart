class DocumentService {
  Future<bool> uploadDeliveryDocument({
    required String jobOrderId,
    required String imagePath,
  }) async {
    // TODO:
    // If backend is Firebase:
    // Upload image to Firebase Storage.
    //
    // If backend is Laravel/API:
    // Upload image using multipart/form-data.
    //
    // For now, return true for demo mode.
    return true;
  }

  Future<void> markDocumentAsPendingOcr({
    required String jobOrderId,
    required String imagePath,
  }) async {
    // TODO:
    // Save document record as "Pending OCR Review"
    // once backend/database is ready.
  }
}