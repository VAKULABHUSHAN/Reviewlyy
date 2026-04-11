import 'package:flutter/material.dart';
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
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  int _rating = 0;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    return Consumer<AppReviewProvider>(
      builder: (context, app, _) {
        final product = productId == null ? null : app.productById(productId);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reviewing ${product.title}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _submitted
                  ? EmptyStateView(
                      title: 'Review submitted',
                      message:
                          'Your review is now part of the product rating and visible in the reviews and dashboard screens.',
                      buttonLabel: 'Go To Reviews',
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.reviews,
                        arguments: product.id,
                      ),
                    )
                  : SurfaceCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Star Rating',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(
                                5,
                                (index) => IconButton(
                                  onPressed: () => setState(() => _rating = index + 1),
                                  icon: Icon(
                                    index < _rating
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    color: AppColors.starYellow,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: 'Your Name'),
                              validator: (value) => value == null || value.trim().isEmpty
                                  ? 'Name is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(labelText: 'Review Title'),
                              validator: (value) => value == null || value.trim().isEmpty
                                  ? 'Review title is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _bodyController,
                              maxLines: 5,
                              decoration: const InputDecoration(labelText: 'Your Review'),
                              validator: (value) => value == null || value.trim().length < 10
                                  ? 'Write at least 10 characters'
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            FilledButton(
                              onPressed: () {
                                if (!(_formKey.currentState?.validate() ?? false) ||
                                    _rating == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please complete the form and rating.'),
                                    ),
                                  );
                                  return;
                                }
                                app.addReview(
                                  productId: product.id,
                                  username: _nameController.text.trim(),
                                  rating: _rating,
                                  title: _titleController.text.trim(),
                                  body: _bodyController.text.trim(),
                                );
                                setState(() => _submitted = true);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Submit Review'),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
