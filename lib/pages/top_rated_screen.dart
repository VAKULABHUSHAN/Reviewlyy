import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';
import '../widgets/app_shell.dart';

class TopRatedScreen extends StatelessWidget {
  const TopRatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppReviewProvider>(
      builder: (context, app, _) {
        final products = app.topRatedProducts;

        return AppShell(
          currentRoute: AppRoutes.topRated,
          child: app.products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SurfaceCard(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Top Rated Products', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        const Text('Rankings update automatically when new reviews are added.', style: TextStyle(color: AppColors.textMuted)),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    ...products.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SurfaceCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              gradient: entry.key == 0 ? const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)]) : null,
                              color: entry.key != 0 ? AppColors.primary.withValues(alpha: 0.12) : null,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(child: Text('#${entry.key + 1}',
                                style: TextStyle(color: entry.key == 0 ? Colors.white : AppColors.primary, fontWeight: FontWeight.w900, fontSize: 16))),
                          ),
                          const SizedBox(width: 14),
                          ClipRRect(borderRadius: BorderRadius.circular(10),
                            child: Image.network(entry.value.imageUrl, width: 48, height: 48, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: AppColors.inputBg,
                                    child: const Icon(Icons.image_outlined, size: 20)))),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(entry.value.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 2),
                            Text('${entry.value.category} • ${entry.value.brand}', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          ])),
                          Column(children: [
                            Text(entry.value.avgRating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary)),
                            const Icon(Icons.star_rounded, color: AppColors.starYellow, size: 18),
                          ]),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: entry.value.id),
                            child: const Text('View'),
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
