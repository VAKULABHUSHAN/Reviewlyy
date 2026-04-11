import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Themes/app_themes.dart';
import 'app_routes.dart';
import 'providers/app_provider.dart';
import 'pages/dashboard_screen.dart';
import 'pages/home_screen.dart';
import 'pages/login_screen.dart';
import 'pages/product_details_screen.dart';
import 'pages/products_screen.dart';
import 'pages/profile_screen.dart';
import 'pages/reviews_screen.dart';
import 'pages/signup_screen.dart';
import 'pages/top_rated_screen.dart';
import 'pages/write_review_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppReviewProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppReviewProvider>(
      builder: (context, app, _) => MaterialApp(
        title: 'ReviewHub',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: app.themeMode,
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (ctx) => const HomeScreen(),
          AppRoutes.products: (ctx) => const ProductsScreen(),
          AppRoutes.productDetails: (ctx) => const ProductDetailsScreen(),
          AppRoutes.reviews: (ctx) => const ReviewsScreen(),
          AppRoutes.writeReview: (ctx) => const WriteReviewScreen(),
          AppRoutes.dashboard: (ctx) => const DashBoardScreen(),
          AppRoutes.topRated: (ctx) => const TopRatedScreen(),
          AppRoutes.login: (ctx) => const LoginScreen(),
          AppRoutes.signUp: (ctx) => const SignUpScreen(),
          AppRoutes.profile: (ctx) => const ProfileScreen(),
        },
      ),
    );
  }
}
