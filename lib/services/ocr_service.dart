class OcrService {
  Future<Map<String, dynamic>> submitDocumentForOcr({
    required String jobOrderId,
    required String imagePath,
  }) async {
    // Tesseract OCR will be handled by the backend/web server.
    // Admin will validate/correct the OCR result manually.

    return {
      'jobOrderId': jobOrderId,
      'imagePath': imagePath,
      'ocrStatus': 'Pending OCR Review',
      'engine': 'Tesseract OCR',
    };
  }
}