import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';
import '../widgets/app_shell.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppReviewProvider>(
      builder: (context, app, _) {
        final topProducts = app.topRatedProducts.take(3).toList();
        final averageRating = app.reviews.isEmpty
            ? 0.0
            : app.reviews.fold<int>(0, (sum, review) => sum + review.rating) /
                app.reviews.length;

        return AppShell(
          currentRoute: AppRoutes.dashboard,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage review activity, inspect rating trends, and jump to your profile or product pages.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(label: 'Products', value: '${app.products.length}'),
                  _StatCard(label: 'Reviews', value: '${app.reviews.length}'),
                  _StatCard(
                    label: 'Average Rating',
                    value: averageRating.toStringAsFixed(1),
                  ),
                  _StatCard(
                    label: 'Profile Reviews',
                    value: '${app.profile.reviewsWritten}',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Top Products Right Now',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...topProducts.map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SurfaceCard(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final imageSize = constraints.maxWidth >= 900 ? 68.0 : 92.0;
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product.imageUrls.first,
                                width: imageSize,
                                height: imageSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product.category} • ${app.reviewCountFor(product.id)} reviews',
                                    style: const TextStyle(color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppRoutes.productDetails,
                                arguments: product.id,
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Open'),
                            ),
                          ],
                        );
                      },
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        width: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
