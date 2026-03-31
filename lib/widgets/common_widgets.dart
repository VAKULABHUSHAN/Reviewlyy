import 'package:flutter/material.dart';

import '../Themes/app_colors.dart';
import '../models/product_model.dart';
import '../routes/app_routes.dart';

class AppScaffoldShell extends StatelessWidget {
  const AppScaffoldShell({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.body,
    this.actions, required IconButton leading,
  });

  final String title;
  final String currentRoute;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 760;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDark : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? AppColors.cardBorderDark
                    : AppColors.cardBorderLight,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 32 : 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.reviews_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ReviewHub',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  if (isWide) ...[
                    const SizedBox(width: 24),
                    _NavButton(
                      label: 'Home',
                      routeName: AppRoutes.home,
                      currentRoute: currentRoute,
                    ),
                    _NavButton(
                      label: 'Products',
                      routeName: AppRoutes.products,
                      currentRoute: currentRoute,
                    ),
                    _NavButton(
                      label: 'Top Rated',
                      routeName: AppRoutes.topRated,
                      currentRoute: currentRoute,
                    ),
                    _NavButton(
                      label: 'Dashboard',
                      routeName: AppRoutes.dashboard,
                      currentRoute: currentRoute,
                    ),
                  ],
                  const Spacer(),
                  ...?actions,
                ],
              ),
            ),
          ),
        ),
      ),
      body: body,
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.rate_review_outlined,
            size: 42,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class ProductSummaryCard extends StatelessWidget {
  const ProductSummaryCard({
    super.key,
    required this.product,
    this.onTap,
    this.buttonLabel = 'Details',
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: Image.network(
                  product.imageUrls.first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey.shade300),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StarDisplay(rating: product.averageRating),
                      const SizedBox(width: 8),
                      Text(
                        '${product.averageRating.toStringAsFixed(1)} • ${product.reviewCount} reviews',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(buttonLabel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.routeName,
    required this.currentRoute,
  });

  final String label;
  final String routeName;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final isActive = currentRoute == routeName;
    return TextButton(
      onPressed: () {
        if (!isActive) {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
          color: isActive ? AppColors.primary : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _StarDisplay extends StatelessWidget {
  const _StarDisplay({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = rating >= index + 1;
        final half = !filled && rating > index;
        return Icon(
          filled
              ? Icons.star_rounded
              : half
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
          size: 16,
          color: AppColors.starYellow,
        );
      }),
    );
  }
}
