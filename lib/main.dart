import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'Screens/dashboard_screen.dart';
import 'Screens/home page.dart';
import 'Screens/product_screen.dart';
import 'Screens/product_details_screen.dart';
import 'Screens/review_screen.dart';
import 'Screens/top_rated_screen.dart';
import 'Screens/write_review_screen.dart';

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
    return MaterialApp(
      title: 'ReviewHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2469EB),
          brightness: Brightness.light,
          surface: const Color(0xFFF6F6F8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F6F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2469EB),
          brightness: Brightness.dark,
          surface: const Color(0xFF111621),
        ),
        scaffoldBackgroundColor: const Color(0xFF111621),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111621),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/products': (ctx) => const ProductsScreen(),
        '/product-details': (ctx) => const ProductDetailsScreen(),
        '/reviews': (ctx) => const ReviewsScreen(),
        '/write-review': (ctx) => const WriteReviewScreen(),
        '/dashboard': (ctx) => const DashBoardScreen(),
        '/top-rated': (ctx) => const TopRatedScreen(),
      },
    );
  }
}
