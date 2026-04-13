import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';
import '../widgets/app_shell.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool _loading = true;

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
    if (mounted) setState(() => _loading = false);
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
            child: const Padding(padding: EdgeInsets.all(16), child: EmptyStateView(title: 'Reviews unavailable', message: 'The selected product could not be found.')),
          );
        }

        final reviews = app.reviewsForProduct(product.id);
        final breakdown = app.ratingBreakdownFor(product.id);
        final total = reviews.isEmpty ? 1 : reviews.length;

        return AppShell(
          currentRoute: AppRoutes.products,
          actions: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.writeReview, arguments: product.id),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Write Review'),
            ),
          ],
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Rating summary
                    SurfaceCard(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(product.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Text(app.averageRatingFor(product.id).toStringAsFixed(1),
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.primary)),
                          const SizedBox(width: 8),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: List.generate(5, (i) => Icon(
                              i < app.averageRatingFor(product.id).round() ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: AppColors.starYellow, size: 18,
                            ))),
                            const SizedBox(height: 2),
                            Text('${reviews.length} reviews', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          ]),
                        ]),
                        const SizedBox(height: 16),
                        ...List.generate(5, (index) {
                          final stars = 5 - index;
                          final count = breakdown[stars] ?? 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(children: [
                              SizedBox(width: 56, child: Text('$stars star')),
                              Expanded(child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(value: count / total, minHeight: 10, backgroundColor: AppColors.inputBg,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary)),
                              )),
                              const SizedBox(width: 12),
                              Text('$count'),
                            ]),
                          );
                        }),
                      ]),
                    ),
                    const SizedBox(height: 16),

                    // Reviews list
                    if (reviews.isEmpty)
                      EmptyStateView(
                        title: 'No reviews yet', message: 'Be the first to leave a review for this product.',
                        buttonLabel: 'Add Review',
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.writeReview, arguments: product.id),
                      )
                    else
                      ...reviews.map((review) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SurfaceCard(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            // Header
                            Row(children: [
                              CircleAvatar(
                                backgroundImage: review.avatarUrl.isNotEmpty ? NetworkImage(review.avatarUrl) : null,
                                child: review.avatarUrl.isEmpty ? Text(review.displayName[0].toUpperCase()) : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(review.displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                                Row(children: [
                                  ...List.generate(5, (i) => Icon(
                                    i < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                                    color: AppColors.starYellow, size: 16,
                                  )),
                                  const SizedBox(width: 6),
                                  Text('${review.rating}/5', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                ]),
                              ])),
                              // Delete for own reviews
                              if (app.isLoggedIn && review.userId == app.profile.id)
                                PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'delete') {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Delete Review'),
                                          content: const Text('Are you sure you want to delete this review?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                            FilledButton(onPressed: () => Navigator.pop(ctx, true),
                                                style: FilledButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete')),
                                          ],
                                        ),
                                      );
                                      if (confirmed == true) await app.deleteReview(review.id);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(value: 'delete', child: Row(children: [
                                      Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                      SizedBox(width: 8),
                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                    ])),
                                  ],
                                ),
                            ]),
                            const SizedBox(height: 12),
                            Text(review.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(review.description, style: const TextStyle(color: AppColors.textMuted, height: 1.5)),

                            // Review images
                            if (review.images.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 120,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: review.images.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                                  itemBuilder: (context, imgIndex) => GestureDetector(
                                    onTap: () => showDialog(context: context, builder: (ctx) => Dialog(
                                      child: ClipRRect(borderRadius: BorderRadius.circular(16),
                                          child: Image.network(review.images[imgIndex].imageUrl, fit: BoxFit.contain)),
                                    )),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(review.images[imgIndex].imageUrl, width: 120, height: 120, fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(width: 120, height: 120, color: AppColors.inputBg,
                                              child: const Icon(Icons.broken_image_outlined))),
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            // Helpful vote
                            const SizedBox(height: 12),
                            ActionChip(
                              avatar: Icon(review.currentUserVoted ? Icons.thumb_up : Icons.thumb_up_outlined, size: 16,
                                  color: review.currentUserVoted ? AppColors.primary : AppColors.textMuted),
                              label: Text('Helpful (${review.helpfulCount})',
                                  style: TextStyle(color: review.currentUserVoted ? AppColors.primary : AppColors.textMuted,
                                      fontWeight: FontWeight.w600, fontSize: 13)),
                              onPressed: app.isLoggedIn ? () => app.toggleHelpfulVote(review.id) : null,
                            ),
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
