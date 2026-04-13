import 'dart:io';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/profile.dart';
import '../models/review.dart';
import '../services/supabase_service.dart';

class AppReviewProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  UserProfile _profile = UserProfile.empty();
  List<AppProduct> _products = [];
  List<AppReview> _reviews = [];
  Map<String, dynamic> _dashboardStats = {};

  // ─── GETTERS ────────────────────────────────────────────
  ThemeMode get themeMode => _themeMode;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserProfile get profile => _profile;
  List<AppProduct> get products => List.unmodifiable(_products);
  List<AppReview> get reviews => List.unmodifiable(_reviews);
  Map<String, dynamic> get dashboardStats => _dashboardStats;

  // ─── INIT ───────────────────────────────────────────────
  Future<void> initialize() async {
    _isLoggedIn = SupabaseService.isLoggedIn;
    if (_isLoggedIn) {
      await _loadProfile();
    }
    await fetchProducts();

    // Listen for auth state changes
    SupabaseService.authStateChanges.listen((event) {
      final newLoggedIn = SupabaseService.isLoggedIn;
      if (newLoggedIn != _isLoggedIn) {
        _isLoggedIn = newLoggedIn;
        if (_isLoggedIn) {
          _loadProfile();
        } else {
          _profile = UserProfile.empty();
        }
        notifyListeners();
      }
    });
  }

  Future<void> _loadProfile() async {
    try {
      final userId = SupabaseService.currentUserId;
      if (userId != null) {
        _profile = await SupabaseService.fetchProfile(userId);
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  // ─── THEME ──────────────────────────────────────────────
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // ─── AUTH ───────────────────────────────────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await SupabaseService.signIn(email: email, password: password);
      _isLoggedIn = true;
      await _loadProfile();
      _error = null;
      notifyListeners();
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> signUp({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await SupabaseService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        username: username,
      );
      _isLoggedIn = true;
      // Small delay for the trigger to create the profile
      await Future.delayed(const Duration(milliseconds: 500));
      await _loadProfile();
      _error = null;
      notifyListeners();
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await SupabaseService.signOut();
    _isLoggedIn = false;
    _profile = UserProfile.empty();
    notifyListeners();
  }

  // ─── PROFILE ────────────────────────────────────────────
  Future<String?> updateProfile({
    required String fullName,
    required String username,
    required String bio,
  }) async {
    _setLoading(true);
    try {
      await SupabaseService.updateProfile(
        userId: _profile.id,
        fullName: fullName,
        username: username,
        bio: bio,
      );
      _profile = _profile.copyWith(
        fullName: fullName,
        username: username,
        bio: bio,
      );
      _error = null;
      notifyListeners();
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> uploadAvatar(File file) async {
    _setLoading(true);
    try {
      final url = await SupabaseService.uploadAvatar(file);
      _profile = _profile.copyWith(avatarUrl: url);
      _error = null;
      notifyListeners();
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  // ─── PRODUCTS ───────────────────────────────────────────
  Future<void> fetchProducts() async {
    try {
      _products = await SupabaseService.fetchProducts();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  AppProduct? productById(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  List<AppProduct> searchProducts(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return products;
    return _products.where((product) {
      return product.name.toLowerCase().contains(normalized) ||
          product.category.toLowerCase().contains(normalized) ||
          product.brand.toLowerCase().contains(normalized) ||
          product.description.toLowerCase().contains(normalized);
    }).toList();
  }

  // ─── REVIEWS ────────────────────────────────────────────
  Future<void> fetchReviewsForProduct(String productId) async {
    try {
      _reviews = await SupabaseService.fetchReviewsForProduct(productId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
    }
  }

  Future<void> fetchAllReviews() async {
    try {
      _reviews = await SupabaseService.fetchAllReviews();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching all reviews: $e');
    }
  }

  List<AppReview> reviewsForProduct(String productId) {
    final list =
        _reviews.where((review) => review.productId == productId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  double averageRatingFor(String productId) {
    final product = productById(productId);
    if (product != null && product.avgRating > 0) return product.avgRating;
    final productReviews = reviewsForProduct(productId);
    if (productReviews.isEmpty) return 0;
    final total = productReviews.fold<int>(0, (sum, r) => sum + r.rating);
    return total / productReviews.length;
  }

  int reviewCountFor(String productId) {
    final product = productById(productId);
    if (product != null && product.reviewCount > 0) return product.reviewCount;
    return reviewsForProduct(productId).length;
  }

  Map<int, int> ratingBreakdownFor(String productId) {
    final counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final review in reviewsForProduct(productId)) {
      counts[review.rating] = (counts[review.rating] ?? 0) + 1;
    }
    return counts;
  }

  List<AppProduct> get topRatedProducts {
    final ranked = [..._products];
    ranked.sort((a, b) => b.avgRating.compareTo(a.avgRating));
    return ranked;
  }

  Future<String?> addReview({
    required String productId,
    required int rating,
    required String title,
    required String description,
    List<File> imageFiles = const [], required String body, required String username,
  }) async {
    _setLoading(true);
    try {
      final review = await SupabaseService.createReview(
        productId: productId,
        rating: rating,
        title: title,
        description: description,
        imageFiles: imageFiles,
      );
      _reviews.insert(0, review);
      _profile = _profile.copyWith(
        reviewsWritten: _profile.reviewsWritten + 1,
      );
      _error = null;
      notifyListeners();
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> updateReview({
    required String reviewId,
    required int rating,
    required String title,
    required String description,
  }) async {
    _setLoading(true);
    try {
      await SupabaseService.updateReview(
        reviewId: reviewId,
        rating: rating,
        title: title,
        description: description,
      );
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index >= 0) {
        final old = _reviews[index];
        _reviews[index] = AppReview(
          id: old.id,
          productId: old.productId,
          userId: old.userId,
          username: old.username,
          fullName: old.fullName,
          avatarUrl: old.avatarUrl,
          rating: rating,
          title: title,
          description: description,
          createdAt: old.createdAt,
          images: old.images,
          helpfulCount: old.helpfulCount,
          currentUserVoted: old.currentUserVoted,
        );
      }
      notifyListeners();
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> deleteReview(String reviewId) async {
    _setLoading(true);
    try {
      await SupabaseService.deleteReview(reviewId);
      _reviews.removeWhere((r) => r.id == reviewId);
      _profile = _profile.copyWith(
        reviewsWritten:
            (_profile.reviewsWritten - 1).clamp(0, double.maxFinite.toInt()),
      );
      notifyListeners();
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  // ─── HELPFUL VOTES ──────────────────────────────────────
  Future<void> toggleHelpfulVote(String reviewId) async {
    if (!_isLoggedIn) return;
    try {
      final added = await SupabaseService.toggleHelpfulVote(reviewId);
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index >= 0) {
        final old = _reviews[index];
        _reviews[index] = AppReview(
          id: old.id,
          productId: old.productId,
          userId: old.userId,
          username: old.username,
          fullName: old.fullName,
          avatarUrl: old.avatarUrl,
          rating: old.rating,
          title: old.title,
          description: old.description,
          createdAt: old.createdAt,
          images: old.images,
          helpfulCount: old.helpfulCount + (added ? 1 : -1),
          currentUserVoted: added,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling vote: $e');
    }
  }

  // ─── DASHBOARD ──────────────────────────────────────────
  Future<void> fetchDashboardStats() async {
    try {
      _dashboardStats = await SupabaseService.fetchDashboardStats();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching stats: $e');
    }
  }

  // ─── HELPERS ────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
