import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';
import '../widgets/app_shell.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final app = context.read<AppReviewProvider>();
    await app.fetchDashboardStats();
    await app.fetchAllReviews();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppReviewProvider>(
      builder: (context, app, _) {
        final stats = app.dashboardStats;
        final topProducts = app.topRatedProducts.take(3).toList();

        return AppShell(
          currentRoute: AppRoutes.dashboard,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    const Text('Real-time stats from your database. Review activity, rating trends, and helpful votes.',
                        style: TextStyle(color: AppColors.textMuted)),
                    const SizedBox(height: 16),
                    Wrap(spacing: 12, runSpacing: 12, children: [
                      _StatCard(label: 'Products', value: '${stats['products_count'] ?? 0}', icon: Icons.inventory_2_outlined, color: AppColors.primary),
                      _StatCard(label: 'Reviews', value: '${stats['reviews_count'] ?? 0}', icon: Icons.rate_review_outlined, color: const Color(0xFF8B5CF6)),
                      _StatCard(label: 'Average Rating', value: (stats['average_rating'] as double? ?? 0).toStringAsFixed(1),
                          icon: Icons.star_rounded, color: AppColors.starYellow),
                      _StatCard(label: 'Helpful Votes', value: '${stats['total_helpful_votes'] ?? 0}', icon: Icons.thumb_up_outlined, color: AppColors.successGreen),
                    ]),
                    const SizedBox(height: 24),
                    if (app.isLoggedIn) ...[
                      SurfaceCard(
                        child: Row(children: [
                          CircleAvatar(radius: 24,
                            backgroundImage: app.profile.avatarUrl.isNotEmpty ? NetworkImage(app.profile.avatarUrl) : null,
                            child: app.profile.avatarUrl.isEmpty
                                ? Text(app.profile.fullName.isNotEmpty ? app.profile.fullName[0].toUpperCase() : '?') : null),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(app.profile.fullName.isNotEmpty ? app.profile.fullName : 'Your Profile',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                            Text('${app.profile.reviewsWritten} reviews • ${app.profile.helpfulVotes} helpful votes',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          ])),
                          OutlinedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.profile), child: const Text('Profile')),
                        ]),
                      ),
                      const SizedBox(height: 24),
                    ],
                    Text('Top Products Right Now', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    ...topProducts.map((product) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SurfaceCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(children: [
                          ClipRRect(borderRadius: BorderRadius.circular(12),
                            child: Image.network(product.imageUrl, width: 68, height: 68, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(width: 68, height: 68, color: AppColors.inputBg,
                                    child: const Icon(Icons.image_outlined)))),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(product.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text('${product.category} • ${product.reviewCount} reviews', style: const TextStyle(color: AppColors.textMuted)),
                          ])),
                          FilledButton(
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: product.id),
                            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                            child: const Text('Open'),
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: SizedBox(width: 210, child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        ])),
      ])),
    );
  }
}
