import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';
import '../widgets/app_shell.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppReviewProvider>(
      builder: (context, app, _) {
        final products = app.searchProducts(_searchController.text);

        return AppShell(
          currentRoute: AppRoutes.products,
          child: app.products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SurfaceCard(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Products', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        const Text('Search the catalog and open any product to read detailed reviews or write your own.',
                            style: TextStyle(color: AppColors.textMuted)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(hintText: 'Search products...', prefixIcon: Icon(Icons.search)),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    if (products.isEmpty)
                      EmptyStateView(title: 'No products found', message: 'Try a different search keyword.',
                        buttonLabel: 'Clear Search', onPressed: () => setState(() => _searchController.clear()))
                    else
                      ...products.map((product) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SurfaceCard(
                          padding: const EdgeInsets.all(16),
                          child: Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(product.imageUrl, width: 92, height: 92, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(width: 92, height: 92,
                                      decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(14)),
                                      child: const Icon(Icons.image_outlined))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.textMuted)),
                              const SizedBox(height: 8),
                              Text('${product.category} • ${product.brand}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ])),
                            const SizedBox(width: 12),
                            FilledButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: product.id),
                              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                              child: const Text('Details'),
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
