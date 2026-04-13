import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.currentRoute,
    required this.child,
    this.title,
    this.actions,
  });

  final String currentRoute;
  final String? title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppReviewProvider>(
      builder: (context, app, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final isWide = MediaQuery.of(context).size.width > 850;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(68),
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
                    horizontal: isWide ? 28 : 16,
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
                        title ?? 'ReviewHub',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      if (isWide) ...[
                        const SizedBox(width: 20),
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
                        if (app.isLoggedIn)
                          _NavButton(
                            label: 'Profile',
                            routeName: AppRoutes.profile,
                            currentRoute: currentRoute,
                          ),
                      ],
                      const Spacer(),
                      IconButton(
                        onPressed: app.toggleTheme,
                        icon: Icon(
                          isDark
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                        ),
                      ),
                      ...?actions,
                      const SizedBox(width: 8),
                      app.isLoggedIn
                          ? PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'profile') {
                                  Navigator.pushNamed(context, AppRoutes.profile);
                                } else if (value == 'logout') {
                                  app.logout();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.home,
                                    (route) => false,
                                  );
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: 'profile',
                                  child: Text('Profile'),
                                ),
                                PopupMenuItem(
                                  value: 'logout',
                                  child: Text('Logout'),
                                ),
                              ],
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(app.profile.avatarUrl),
                              ),
                            )
                          : Wrap(
                              spacing: 8,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, AppRoutes.login),
                                  child: const Text('Login'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, AppRoutes.signUp),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Sign Up'),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: child,
        );
      },
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: child,
    );
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel,
    this.onPressed,
  });

  final String title;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 40, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          if (buttonLabel != null && onPressed != null) ...[
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonLabel!),
            ),
          ],
        ],
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
      onPressed: isActive ? null : () => Navigator.pushNamed(context, routeName),
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
