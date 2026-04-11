import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product.dart';
import '../models/review.dart';
import '../models/profile.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // ─── AUTH ─────────────────────────────────────────────
  static SupabaseClient get client => _client;
  static User? get currentUser => _client.auth.currentUser;
  static String? get currentUserId => currentUser?.id;
  static bool get isLoggedIn => currentUser != null;

  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'username': username},
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ─── PROFILES ─────────────────────────────────────────
  static Future<UserProfile> fetchProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    // Get review count
    final reviewCount = await _client
        .from('reviews')
        .select()
        .eq('user_id', userId)
        .count(CountOption.exact);

    // Get total helpful votes received on user's reviews
    final helpfulVotes = await _client
        .from('review_votes')
        .select('review_id, reviews!inner(user_id)')
        .eq('reviews.user_id', userId)
        .count(CountOption.exact);

    return UserProfile.fromJson({
      ...data,
      'reviews_written': reviewCount.count,
      'helpful_votes': helpfulVotes.count,
    });
  }

  static Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String username,
    required String bio,
    String? avatarUrl,
  }) async {
    final update = <String, dynamic>{
      'full_name': fullName,
      'username': username,
      'bio': bio,
    };
    if (avatarUrl != null) {
      update['avatar_url'] = avatarUrl;
    }
    await _client.from('profiles').update(update).eq('id', userId);
  }

  // ─── PRODUCTS ─────────────────────────────────────────
  static Future<List<AppProduct>> fetchProducts() async {
    final data = await _client
        .from('products')
        .select('*, categories(name)')
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => AppProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<AppProduct?> fetchProductById(String productId) async {
    final data = await _client
        .from('products')
        .select('*, categories(name)')
        .eq('id', productId)
        .maybeSingle();

    if (data == null) return null;
    return AppProduct.fromJson(data);
  }

  // ─── REVIEWS ──────────────────────────────────────────
  static Future<List<AppReview>> fetchReviewsForProduct(
      String productId) async {
    final data = await _client
        .from('reviews')
        .select(
            '*, profiles(username, full_name, avatar_url), review_images(*), review_votes(*)')
        .eq('product_id', productId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => AppReview.fromJson(
              e as Map<String, dynamic>,
              currentUserId: currentUserId,
            ))
        .toList();
  }

  static Future<List<AppReview>> fetchAllReviews() async {
    final data = await _client
        .from('reviews')
        .select(
            '*, profiles(username, full_name, avatar_url), review_images(*), review_votes(*)')
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => AppReview.fromJson(
              e as Map<String, dynamic>,
              currentUserId: currentUserId,
            ))
        .toList();
  }

  static Future<AppReview> createReview({
    required String productId,
    required int rating,
    required String title,
    required String description,
    List<File> imageFiles = const [],
  }) async {
    final userId = currentUserId!;

    // Insert the review
    final reviewData = await _client
        .from('reviews')
        .insert({
          'product_id': productId,
          'user_id': userId,
          'rating': rating,
          'title': title,
          'description': description,
        })
        .select(
            '*, profiles(username, full_name, avatar_url), review_images(*), review_votes(*)')
        .single();

    final reviewId = reviewData['id'] as String;

    // Upload images
    if (imageFiles.isNotEmpty) {
      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final ext = file.path.split('.').last;
        final path =
            '$userId/$reviewId/${DateTime.now().millisecondsSinceEpoch}_$i.$ext';

        await _client.storage.from('reviews').upload(path, file);
        final publicUrl =
            _client.storage.from('reviews').getPublicUrl(path);

        await _client.from('review_images').insert({
          'review_id': reviewId,
          'image_url': publicUrl,
          'sort_order': i,
        });
      }

      // Re-fetch to include images
      final updated = await _client
          .from('reviews')
          .select(
              '*, profiles(username, full_name, avatar_url), review_images(*), review_votes(*)')
          .eq('id', reviewId)
          .single();

      return AppReview.fromJson(updated, currentUserId: currentUserId);
    }

    return AppReview.fromJson(reviewData, currentUserId: currentUserId);
  }

  static Future<void> updateReview({
    required String reviewId,
    required int rating,
    required String title,
    required String description,
  }) async {
    await _client.from('reviews').update({
      'rating': rating,
      'title': title,
      'description': description,
    }).eq('id', reviewId);
  }

  static Future<void> deleteReview(String reviewId) async {
    await _client.from('reviews').delete().eq('id', reviewId);
  }

  // ─── HELPFUL VOTES ────────────────────────────────────
  static Future<bool> toggleHelpfulVote(String reviewId) async {
    final userId = currentUserId!;

    // Check if vote exists
    final existing = await _client
        .from('review_votes')
        .select()
        .eq('review_id', reviewId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existing != null) {
      // Remove vote
      await _client
          .from('review_votes')
          .delete()
          .eq('review_id', reviewId)
          .eq('user_id', userId);
      return false; // vote removed
    } else {
      // Add vote
      await _client.from('review_votes').insert({
        'review_id': reviewId,
        'user_id': userId,
      });
      return true; // vote added
    }
  }

  // ─── STORAGE (AVATAR) ────────────────────────────────
  static Future<String> uploadAvatar(File file) async {
    final userId = currentUserId!;
    final ext = file.path.split('.').last;
    final path = '$userId/avatar.$ext';

    // Upsert: upload with overwrite
    await _client.storage.from('avatars').upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = _client.storage.from('avatars').getPublicUrl(path);
    // Update profile with new URL
    await _client
        .from('profiles')
        .update({'avatar_url': publicUrl}).eq('id', userId);

    return publicUrl;
  }

  // ─── DASHBOARD STATS ──────────────────────────────────
  static Future<Map<String, dynamic>> fetchDashboardStats() async {
    final productsCount =
        await _client.from('products').select().count(CountOption.exact);
    final reviewsCount =
        await _client.from('reviews').select().count(CountOption.exact);

    final allReviews = await _client.from('reviews').select('rating');

    double averageRating = 0;
    if ((allReviews as List).isNotEmpty) {
      final total =
          allReviews.fold<int>(0, (sum, r) => sum + (r['rating'] as int));
      averageRating = total / allReviews.length;
    }

    final totalVotes =
        await _client.from('review_votes').select().count(CountOption.exact);

    return {
      'products_count': productsCount.count,
      'reviews_count': reviewsCount.count,
      'average_rating': averageRating,
      'total_helpful_votes': totalVotes.count,
    };
  }
}
