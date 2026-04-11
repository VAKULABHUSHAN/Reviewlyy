import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';
import '../widgets/app_shell.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImage = 0;

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
                message: 'The selected product could not be found.',
              ),
            ),
          );
        }

        final reviews = app.reviewsForProduct(product.id).take(2).toList();
        final isWide = MediaQuery.of(context).size.width > 880;

        return AppShell(
          currentRoute: AppRoutes.products,
          actions: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.writeReview,
                arguments: product.id,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Write Review'),
            ),
          ],
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SurfaceCard(
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _Gallery(product: product, selectedImage: _selectedImage, onSelect: (index) => setState(() => _selectedImage = index))),
                          const SizedBox(width: 20),
                          Expanded(child: _DetailsPane(productId: product.id)),
                        ],
                      )
                    : Column(
                        children: [
                          _Gallery(product: product, selectedImage: _selectedImage, onSelect: (index) => setState(() => _selectedImage = index)),
                          const SizedBox(height: 20),
                          _DetailsPane(productId: product.id),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              Text(
                'Recent Reviews',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              if (reviews.isEmpty)
                EmptyStateView(
                  title: 'No reviews yet',
                  message: 'Be the first to review this product.',
                  buttonLabel: 'Add Review',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.writeReview,
                    arguments: product.id,
                  ),
                )
              else
                ...reviews.map(
                  (review) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SurfaceCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${review.username} • ${review.rating}/5',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review.body,
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                        ],
                      ),
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

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.product,
    required this.selectedImage,
    required this.onSelect,
  });

  final AppProduct product;
  final int selectedImage;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              product.imageUrls[selectedImage],
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(
            product.imageUrls.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () => onSelect(index),
                child: Container(
                  margin: EdgeInsets.only(right: index == product.imageUrls.length - 1 ? 0 : 8),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: index == selectedImage
                          ? AppColors.primary
                          : AppColors.cardBorderLight,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        product.imageUrls[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsPane extends StatelessWidget {
  const _DetailsPane({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppReviewProvider>();
    final product = app.productById(productId)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.category.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.title,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        Text(
          product.description,
          style: const TextStyle(color: AppColors.textMuted, height: 1.6),
        ),
        const SizedBox(height: 16),
        Text(
          '\$${product.price.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        Text(
          '${app.averageRatingFor(product.id).toStringAsFixed(1)} average rating from ${app.reviewCountFor(product.id)} reviews',
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.reviews,
                arguments: product.id,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Read Reviews'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.writeReview,
                arguments: product.id,
              ),
              child: const Text('Add Review'),
            ),
          ],
        ),
      ],
    );
  }
}
