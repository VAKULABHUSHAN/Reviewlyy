import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';
import '../widgets/app_shell.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  int _rating = 0;
  bool _submitted = false;
  bool _submitting = false;
  String? _errorMessage;

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final images = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (images.isNotEmpty) {
        setState(() {
          for (final img in images) {
            if (_selectedImages.length < 5) {
              _selectedImages.add(File(img.path));
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image != null && _selectedImages.length < 5) {
        setState(() => _selectedImages.add(File(image.path)));
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  Future<void> _handleSubmit(AppReviewProvider app, String productId) async {
    if (!(_formKey.currentState?.validate() ?? false) || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the form and select a rating.'),
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final error = await app.addReview(
      productId: productId,
      rating: _rating,
      title: _titleController.text.trim(),
      description: _bodyController.text.trim(),
      imageFiles: _selectedImages, body: '', username: '',
    );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _submitting = false;
        _errorMessage = error;
      });
    } else {
      setState(() => _submitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppReviewProvider>(
      builder: (context, app, _) {
        // Must be logged in
        if (!app.isLoggedIn) {
          return AppShell(
            currentRoute: AppRoutes.products,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: EmptyStateView(
                title: 'Login Required',
                message: 'You need to be logged in to write a review.',
                buttonLabel: 'Go To Login',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.login),
              ),
            ),
          );
        }

        final product =
            productId == null ? null : app.productById(productId);
        if (product == null) {
          return AppShell(
            currentRoute: AppRoutes.products,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: EmptyStateView(
                title: 'Product unavailable',
                message: 'Choose a valid product before submitting a review.',
              ),
            ),
          );
        }

        return AppShell(
          currentRoute: AppRoutes.products,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SurfaceCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 64, height: 64,
                          color: AppColors.inputBg,
                          child: const Icon(Icons.image_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Reviewing',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(product.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _submitted ? _buildSuccessView(product.id) : _buildForm(app, product.id, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuccessView(String productId) {
    return SurfaceCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.successGreen, size: 48),
          ),
          const SizedBox(height: 16),
          const Text('Review Submitted!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Your review is now live and visible to everyone.',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.reviews, arguments: productId),
            icon: const Icon(Icons.reviews_outlined),
            label: const Text('View All Reviews'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(AppReviewProvider app, String productId, bool isDark) {
    return SurfaceCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13))),
                ]),
              ),
              const SizedBox(height: 16),
            ],
            const Text('Your Rating', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) => GestureDetector(
                  onTap: () => setState(() => _rating = index + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: AppColors.starYellow, size: 36,
                    ),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Review Title', hintText: 'e.g., "Absolutely love this product"'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Review title is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bodyController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Your Review', hintText: 'Share your experience...', alignLabelWithHint: true),
              validator: (value) => value == null || value.trim().length < 10 ? 'Write at least 10 characters' : null,
            ),
            const SizedBox(height: 20),
            const Text('Add Photos (optional)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('Up to 5 images • Helps other buyers', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 12),
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => Stack(children: [
                    ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(_selectedImages[index], width: 100, height: 100, fit: BoxFit.cover)),
                    Positioned(top: 4, right: 4, child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 16)),
                    )),
                  ]),
                ),
              ),
            if (_selectedImages.isNotEmpty) const SizedBox(height: 12),
            if (_selectedImages.length < 5)
              Wrap(spacing: 8, runSpacing: 8, children: [
                OutlinedButton.icon(onPressed: _pickImages, icon: const Icon(Icons.photo_library_outlined, size: 18), label: const Text('Gallery'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary)),
                OutlinedButton.icon(onPressed: _takePhoto, icon: const Icon(Icons.camera_alt_outlined, size: 18), label: const Text('Camera'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary)),
              ]),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 50,
              child: FilledButton(
                onPressed: _submitting ? null : () => _handleSubmit(app, productId),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: _submitting
                    ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                        SizedBox(width: 12), Text('Uploading...'),
                      ])
                    : const Text('Submit Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
