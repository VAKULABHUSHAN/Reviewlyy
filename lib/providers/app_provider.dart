import 'package:flutter/foundation.dart';

/// A simple review model used by the Provider.
class AppReview {
  final String id;
  final String username;
  final int rating;
  final String title;
  final String body;
  final DateTime date;

  AppReview({
    required this.id,
    required this.username,
    required this.rating,
    required this.title,
    required this.body,
    required this.date,
  });
}

/// Central state for reviews. Screens can read / add reviews via this provider.
class AppReviewProvider extends ChangeNotifier {
  final List<AppReview> _reviews = [
    AppReview(
      id: '1',
      username: 'Alex Johnson',
      rating: 5,
      title: 'Absolutely worth every penny',
      body:
          'The sound quality on the Z1 is unmatched in this price range. I have been using it for over 2 months now for competitive gaming and the directional audio is precise.',
      date: DateTime(2024, 5, 15),
    ),
    AppReview(
      id: '2',
      username: 'Sarah Chen',
      rating: 4,
      title: 'Great mic, slightly bulky',
      body:
          'The noise cancellation on the microphone is fantastic. My friends say I sound crystal clear. The only downside is that it feels a bit heavy after a few hours.',
      date: DateTime(2024, 5, 10),
    ),
    AppReview(
      id: '3',
      username: 'Marcus Wright',
      rating: 5,
      title: 'Exceptional Build Quality',
      body:
          'Feels very premium. The metal hinges are a nice touch. I dropped it once and not even a scratch. Software integration was easy too.',
      date: DateTime(2024, 5, 1),
    ),
  ];

  List<AppReview> get reviews => List.unmodifiable(_reviews);

  int get reviewCount => _reviews.length;

  double get averageRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        _reviews.length;
  }

  void addReview({
    required String username,
    required int rating,
    required String title,
    required String body,
  }) {
    _reviews.insert(
      0,
      AppReview(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        rating: rating,
        title: title,
        body: body,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
