import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';
import '../widgets/app_shell.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

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
                title: 'Reviews unavailable',
                message: 'The selected product could not be found.',
              ),
            ),
          );
        }

        final reviews = app.reviewsForProduct(product.id);
        final breakdown = app.ratingBreakdownFor(product.id);
        final total = reviews.isEmpty ? 1 : reviews.length;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${app.averageRatingFor(product.id).toStringAsFixed(1)} average rating from ${reviews.length} reviews',
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(5, (index) {
                      final stars = 5 - index;
                      final count = breakdown[stars] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(width: 56, child: Text('$stars star')),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: count / total,
                                minHeight: 10,
                                backgroundColor: AppColors.inputBg,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('$count'),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (reviews.isEmpty)
                EmptyStateView(
                  title: 'No reviews yet',
                  message: 'Be the first to leave a review for this product.',
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
                          Row(
                            children: [
                              CircleAvatar(child: Text(review.username[0].toUpperCase())),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  review.username,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Text(
                                '${review.rating}/5',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            review.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review.body,
                            style: const TextStyle(color: AppColors.textMuted, height: 1.5),
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
