import 'package:flutter/material.dart';
import 'package:reviewlyyy/Screens/product_details_screen.dart';
import 'package:reviewlyyy/Screens/product_screen.dart';

import 'Screens/home page.dart';
import 'Screens/review_screen.dart';
import 'Screens/write_review_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ReviewsScreen()
    );
  }
}

