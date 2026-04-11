import 'package:flutter/material.dart';

class UserProfile {
  final String fullName;
  final String email;
  final String bio;
  final String location;
  final String avatarUrl;
  final int reviewsWritten;
  final int helpfulVotes;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.bio,
    required this.location,
    required this.avatarUrl,
    required this.reviewsWritten,
    required this.helpfulVotes,
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? bio,
    String? location,
    String? avatarUrl,
    int? reviewsWritten,
    int? helpfulVotes,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      reviewsWritten: reviewsWritten ?? this.reviewsWritten,
      helpfulVotes: helpfulVotes ?? this.helpfulVotes,
    );
  }
}

class AppReview {
  final String id;
  final String productId;
  final String username;
  final int rating;
  final String title;
  final String body;
  final DateTime date;
  final int helpfulVotes;

  const AppReview({
    required this.id,
    required this.productId,
    required this.username,
    required this.rating,
    required this.title,
    required this.body,
    required this.date,
    this.helpfulVotes = 0,
  });
}

class AppProduct {
  final String id;
  final String title;
  final String category;
  final String description;
  final double price;
  final List<String> imageUrls;

  const AppProduct({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrls,
  });
}

class AppReviewProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoggedIn = false;

  UserProfile _profile = const UserProfile(
    fullName: 'Alex Johnson',
    email: 'alex.johnson@example.com',
    bio: 'Tech enthusiast reviewing gadgets, office gear, and audio devices.',
    location: 'Bengaluru, India',
    avatarUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
    reviewsWritten: 3,
    helpfulVotes: 41,
  );

  final List<AppProduct> _products = const [
    AppProduct(
      id: 'pro-audio-gen-2',
      title: 'Pro Audio Gen-2',
      category: 'Electronics',
      description:
          'Noise-cancelling wireless headphones with 40-hour battery life and spatial audio support.',
      price: 299,
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBnh6NNvw0ublTnYkUqAsA-pT27xv1RXAn9JSe2ncgXuhoH-Z2wksSVzYmqrjsfResSfzcYL-T5mSsizKB_JyK9XjTWXSW5WFmXy1MiaKcPijZHNS-oM8yi-Y15i-Z90AuM9PVLznDIlATuhIxjBcMpPWm1xzNIHeY6Cnh0QXxKSW-rK3ta49yaWi36ihtoR8RorwZNbDbXg0IgIxwS6jBh_CYuCqDb3hJi1fk61SenTDCsO7o7EFYpo-UjrgsXVxFtD9Kf3i9uh2s',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBYWu0L4mkb0ZuFeBhHwAh_3EhCGPIvZN5k6nm_47f6E4LG9soJtyYDnbyk0sVD_zXI6iip4J7cvi_4r6XBhcyDsEhe9x_cPxY6YNxvuVOeeO6hCay-1JzoWWF02nyw5bzCklLwd7Ra6qnDtY0WLZQlIzcDwFFafCNp1yCbcW686a3O0ClCy7zdOkj4lGVDujR7rRQJxDoP2eYDay1DSGE4kmUUN_sw4ZYxNV8YYorTcxfHL3kzwDStk4xc3qult-PLUE-l2yJE6kA',
      ],
    ),
    AppProduct(
      id: 'lunar-minimalist-watch',
      title: 'Lunar Minimalist Watch',
      category: 'Accessories',
      description:
          'A timeless piece featuring sapphire glass and an Italian leather strap for everyday elegance.',
      price: 185,
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBV2eiSjxRs4HEkLnKWr3z4nDULdGDHijArCK1cWRWWfExFeirRAWeiJFxIkqHns4QjydJWRxNW6tGYW2tNdOuvw-3ZOmgZ9Zflohz4UkbTO0EyCpdO_Y1xRKeQvVVb5AIFc8kcSkK6I8VdmmWSRV-szCFQNImgIygqkfk172PpzcAnK88wp4rnYkotzlheDhBLzXqxRtUQQljqTu9W4Q-3jlxHIkJ-JfCIgwakuUYOc9my9jyfDmTghfkTHBvQkJPkP_0dbwDa550',
      ],
    ),
    AppProduct(
      id: 'velo-sprint-trainers',
      title: 'Velo Sprint Trainers',
      category: 'Footwear',
      description:
          'Ultra-lightweight performance shoes designed for both professional athletes and daily runners.',
      price: 140,
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCmmoCLCY-P6NdCLmRMBK83dCmo8CSjgW76Lbqne9c6b1yKXmOswCZDRvtYvsbfjuwpFiblN2q8cVpa8_ze1zUD51khonT5qGbR2-lEGwAyKkZKSjo5_49URYTOTFJ26MTwAapYE6GzhiaBzmTI3HX-_PZqHeTVmQUwMB5Sd_6Toakv7zfcDTLYiP26cLTixIZiWAMswRfgSdWfAiXGbV2QHbFVi7ssI_AwQJYRcXL8dnPaEklX8FpgDJo9-9yelenDSmSDRdtQCOY',
      ],
    ),
    AppProduct(
      id: 'novabook-14-air',
      title: 'NovaBook 14 Air',
      category: 'Tech',
      description:
          'Ultra-portable laptop with 4K OLED display and the latest high-efficiency processor.',
      price: 1199,
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAxVvzSRjUcjYH25z4Glihf5ZZgmkcgtmf7Mglc84cu40wJwHbbVA8IeqXG0z_IXJN46DNZ6pqIA1lGAdpoEHXo-vE-60V-G_JwlztbP6X2Opz21adsQrIKrGXPopoKdx-EAoZ1cfQ_0dN8lmhzra_kVcqCTjCbJJcPAQSevPqIdASIoj5rRH1PfEG1_ckX6DdZcXg4v02f5zVHlQm9NTakbhbLjYzmM3OIexrfeipWqLdedmfxdWlWP5BODJfePv3_qtj3CxOt4Ng',
      ],
    ),
  ];

  final List<AppReview> _reviews = [
    AppReview(
      id: '1',
      productId: 'pro-audio-gen-2',
      username: 'Alex Johnson',
      rating: 5,
      title: 'Absolutely worth every penny',
      body:
          'The sound quality is excellent and the directional audio is precise for music and gaming.',
      date: DateTime(2024, 5, 15),
      helpfulVotes: 18,
    ),
    AppReview(
      id: '2',
      productId: 'pro-audio-gen-2',
      username: 'Sarah Chen',
      rating: 4,
      title: 'Great mic, slightly bulky',
      body:
          'The microphone clarity is excellent. It gets a bit heavy after a few hours, but it still feels premium.',
      date: DateTime(2024, 5, 10),
      helpfulVotes: 12,
    ),
    AppReview(
      id: '3',
      productId: 'novabook-14-air',
      username: 'Marcus Wright',
      rating: 5,
      title: 'Exceptional Build Quality',
      body:
          'Feels very premium. The chassis is sturdy, the keyboard is excellent, and battery life is reliable.',
      date: DateTime(2024, 5, 1),
      helpfulVotes: 11,
    ),
  ];

  ThemeMode get themeMode => _themeMode;
  bool get isLoggedIn => _isLoggedIn;
  UserProfile get profile => _profile;
  List<AppProduct> get products => List.unmodifiable(_products);
  List<AppReview> get reviews => List.unmodifiable(_reviews);

  List<AppReview> reviewsForProduct(String productId) {
    final list = _reviews.where((review) => review.productId == productId).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  AppProduct? productById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (_) {
      return null;
    }
  }

  double averageRatingFor(String productId) {
    final productReviews = reviewsForProduct(productId);
    if (productReviews.isEmpty) return 0;
    final total = productReviews.fold<int>(0, (sum, review) => sum + review.rating);
    return total / productReviews.length;
  }

  int reviewCountFor(String productId) => reviewsForProduct(productId).length;

  Map<int, int> ratingBreakdownFor(String productId) {
    final counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final review in reviewsForProduct(productId)) {
      counts[review.rating] = (counts[review.rating] ?? 0) + 1;
    }
    return counts;
  }

  List<AppProduct> get topRatedProducts {
    final ranked = [..._products];
    ranked.sort(
      (a, b) => averageRatingFor(b.id).compareTo(averageRatingFor(a.id)),
    );
    return ranked;
  }

  List<AppProduct> searchProducts(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return products;
    return _products.where((product) {
      return product.title.toLowerCase().contains(normalized) ||
          product.category.toLowerCase().contains(normalized) ||
          product.description.toLowerCase().contains(normalized);
    }).toList();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void login({
    required String email,
    required String password,
  }) {
    _isLoggedIn = true;
    _profile = _profile.copyWith(email: email);
    notifyListeners();
  }

  void signUp({
    required String fullName,
    required String email,
    required String password,
  }) {
    _isLoggedIn = true;
    _profile = UserProfile(
      fullName: fullName,
      email: email,
      bio: 'New reviewer on ReviewHub.',
      location: 'India',
      avatarUrl:
          'https://images.unsplash.com/photo-1633332755192-727a05c4013d?auto=format&fit=crop&q=80&w=200',
      reviewsWritten: _profile.reviewsWritten,
      helpfulVotes: _profile.helpfulVotes,
    );
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void updateProfile({
    required String fullName,
    required String bio,
    required String location,
  }) {
    _profile = _profile.copyWith(
      fullName: fullName,
      bio: bio,
      location: location,
    );
    notifyListeners();
  }

  void addReview({
    required String productId,
    required String username,
    required int rating,
    required String title,
    required String body,
  }) {
    _reviews.insert(
      0,
      AppReview(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: productId,
        username: username,
        rating: rating,
        title: title,
        body: body,
        date: DateTime.now(),
      ),
    );
    _profile = _profile.copyWith(reviewsWritten: _profile.reviewsWritten + 1);
    notifyListeners();
  }
}
