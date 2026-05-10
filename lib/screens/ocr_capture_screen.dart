import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';
import '../services/document_service.dart';
import '../services/ocr_service.dart';
import '../services/sync_service.dart';

class OcrCaptureScreen extends StatefulWidget {
  final Map<String, String> job;

  const OcrCaptureScreen({
    super.key,
    required this.job,
  });

  @override
  State<OcrCaptureScreen> createState() => _OcrCaptureScreenState();
}

class _OcrCaptureScreenState extends State<OcrCaptureScreen> {
  final ImagePicker picker = ImagePicker();
  final DocumentService documentService = DocumentService();
  final OcrService ocrService = OcrService();
  final SyncService syncService = SyncService();

  File? selectedImage;
  String documentStatus = 'No document selected';
  bool isSubmitting = false;

  Future<void> pickImageFromCamera() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
      documentStatus = 'Ready for OCR Submission';
    });
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
      documentStatus = 'Ready for OCR Submission';
    });
  }

  Future<void> submitDocument() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture or select a document first.'),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final jobOrderId = widget.job['jobId'] ?? 'N/A';
    final imagePath = selectedImage!.path;

    final uploaded = await documentService.uploadDeliveryDocument(
      jobOrderId: jobOrderId,
      imagePath: imagePath,
    );

    if (!uploaded) {
      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document upload failed. Please try again.'),
        ),
      );
      return;
    }

    final ocrResult = await ocrService.submitDocumentForOcr(
      jobOrderId: jobOrderId,
      imagePath: imagePath,
    );

    await syncService.addToUploadQueue(
      type: 'OCR Document',
      jobId: jobOrderId,
      description: 'Delivery document submitted for OCR review',
      status: 'Pending',
      time: 'Just now',
    );

    setState(() {
      documentStatus = ocrResult['ocrStatus'];
      isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document submitted for OCR processing.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('OCR Document Capture'),
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
                    const Text(
                      'Delivery Document',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Job Order: ${job['jobId'] ?? 'N/A'}'),
                    Text('Client: ${job['client'] ?? 'N/A'}'),
                    Text('Material: ${job['material'] ?? 'N/A'}'),
                    Text('Destination: ${job['destination'] ?? 'N/A'}'),
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
                  children: [
                    const Icon(
                      Icons.document_scanner_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Capture or Upload Document',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Take a clear photo of the receipt, job order, or invoice for OCR processing.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textLight),
                    ),

                    const SizedBox(height: 20),

                    if (selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          selectedImage!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Center(
                          child: Text(
                            'No image selected',
                            style: TextStyle(color: AppColors.textLight),
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Status: $documentStatus',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (isSubmitting) ...[
                      const SizedBox(height: 16),
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : pickImageFromCamera,
                icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                label: const Text(
                  'Take Photo',
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

            const SizedBox(height: 10),

            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: isSubmitting ? null : pickImageFromGallery,
                icon: const Icon(Icons.photo_library_rounded),
                label: const Text('Choose from Gallery'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : submitDocument,
                icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
                label: const Text(
                  'Submit for OCR',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
