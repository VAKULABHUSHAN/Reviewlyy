import 'review_image.dart';

class AppReview {
  final String id;
  final String productId;
  final String userId;
  final String username;
  final String fullName;
  final String avatarUrl;
  final int rating;
  final String title;
  final String description;
  final int helpfulCount;
  final DateTime createdAt;
  final List<ReviewImage> images;
  final bool currentUserVoted;

  const AppReview({
    required this.id,
    required this.productId,
    required this.userId,
    this.username = '',
    this.fullName = '',
    this.avatarUrl = '',
    required this.rating,
    required this.title,
    required this.description,
    this.helpfulCount = 0,
    required this.createdAt,
    this.images = const [],
    this.currentUserVoted = false,
  });

  factory AppReview.fromJson(Map<String, dynamic> json,
      {String? currentUserId}) {
    // Parse the joined profile data
    final profileData = json['profiles'];
    final username = profileData is Map
        ? (profileData['username'] as String? ?? '')
        : '';
    final fullName = profileData is Map
        ? (profileData['full_name'] as String? ?? 'Anonymous')
        : 'Anonymous';
    final avatarUrl = profileData is Map
        ? (profileData['avatar_url'] as String? ?? '')
        : '';

    // Parse review images
    final imagesData = json['review_images'] as List<dynamic>? ?? [];
    final images = imagesData
        .map((e) => ReviewImage.fromJson(e as Map<String, dynamic>))
        .toList();

    // Parse votes
    final votesData = json['review_votes'] as List<dynamic>? ?? [];
    final currentUserVoted = currentUserId != null &&
        votesData.any((v) => v is Map && v['user_id'] == currentUserId);

    return AppReview(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      userId: json['user_id'] as String,
      username: username,
      fullName: fullName,
      avatarUrl: avatarUrl,
      rating: json['rating'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      helpfulCount: json['helpful_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      images: images,
      currentUserVoted: currentUserVoted,
    );
  }

  /// Display name: prefer full_name, fallback to username
  String get displayName =>
      fullName.isNotEmpty ? fullName : (username.isNotEmpty ? username : 'Anonymous');
}
