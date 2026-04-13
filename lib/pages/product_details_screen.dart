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
  bool _loadingReviews = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    if (productId == null) return;
    final app = context.read<AppReviewProvider>();
    await app.fetchReviewsForProduct(productId);
    if (mounted) setState(() => _loadingReviews = false);
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    return Consumer<AppReviewProvider>(
      builder: (context, app, _) {
        final product = productId == null ? null : app.productById(productId);
        if (product == null) {
          return AppShell(currentRoute: AppRoutes.products,
            child: const Padding(padding: EdgeInsets.all(16), child: EmptyStateView(title: 'Product unavailable', message: 'The selected product could not be found.')));
        }

        final reviews = app.reviewsForProduct(product.id).take(2).toList();
        final isWide = MediaQuery.of(context).size.width > 880;

        return AppShell(
          currentRoute: AppRoutes.products,
          actions: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.writeReview, arguments: product.id),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Write Review'),
            ),
          ],
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SurfaceCard(
                child: isWide
                    ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: _ProductImage(imageUrl: product.imageUrl)),
                        const SizedBox(width: 20),
                        Expanded(child: _DetailsPane(productId: product.id)),
                      ])
                    : Column(children: [
                        _ProductImage(imageUrl: product.imageUrl),
                        const SizedBox(height: 20),
                        _DetailsPane(productId: product.id),
                      ]),
              ),
              const SizedBox(height: 16),
              Text('Recent Reviews', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              if (_loadingReviews)
                const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
              else if (reviews.isEmpty)
                EmptyStateView(title: 'No reviews yet', message: 'Be the first to review this product.',
                  buttonLabel: 'Add Review', onPressed: () => Navigator.pushNamed(context, AppRoutes.writeReview, arguments: product.id))
              else
                ...reviews.map((review) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SurfaceCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        CircleAvatar(
                          backgroundImage: review.avatarUrl.isNotEmpty ? NetworkImage(review.avatarUrl) : null,
                          child: review.avatarUrl.isEmpty ? Text(review.displayName[0].toUpperCase()) : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(review.displayName, style: const TextStyle(fontWeight: FontWeight.w700)),
                          Row(children: List.generate(5, (i) => Icon(
                            i < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: AppColors.starYellow, size: 16,
                          ))),
                        ])),
                      ]),
                      const SizedBox(height: 10),
                      Text(review.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(review.description, style: const TextStyle(color: AppColors.textMuted)),
                      if (review.images.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        SizedBox(height: 80, child: ListView.separated(
                          scrollDirection: Axis.horizontal, itemCount: review.images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 6),
                          itemBuilder: (_, i) => ClipRRect(borderRadius: BorderRadius.circular(10),
                            child: Image.network(review.images[i].imageUrl, width: 80, height: 80, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: AppColors.inputBg,
                                    child: const Icon(Icons.broken_image_outlined, size: 20)))),
                        )),
                      ],
                    ]),
                  ),
                )),
            ],
          ),
        );
      },
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(aspectRatio: 1, child: Image.network(imageUrl, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: AppColors.inputBg, child: const Center(child: Icon(Icons.image_outlined, size: 48))))),
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

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(product.category.toUpperCase(),
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
      const SizedBox(height: 8),
      Text(product.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
      const SizedBox(height: 6),
      Text(product.brand, style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600, fontSize: 15)),
      const SizedBox(height: 10),
      Text(product.description, style: const TextStyle(color: AppColors.textMuted, height: 1.6)),
      const SizedBox(height: 16),
      Text('${app.averageRatingFor(product.id).toStringAsFixed(1)} average rating from ${app.reviewCountFor(product.id)} reviews',
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
      const SizedBox(height: 18),
      Wrap(spacing: 12, runSpacing: 12, children: [
        FilledButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.reviews, arguments: product.id),
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Read Reviews'),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.writeReview, arguments: product.id),
          child: const Text('Add Review'),
        ),
      ]),
    ]);
  }
}
