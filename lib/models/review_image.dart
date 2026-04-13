class ReviewImage {
  final String id;
  final String reviewId;
  final String imageUrl;
  final int sortOrder;
  final DateTime createdAt;

  const ReviewImage({
    required this.id,
    required this.reviewId,
    required this.imageUrl,
    this.sortOrder = 0,
    required this.createdAt,
  });

  factory ReviewImage.fromJson(Map<String, dynamic> json) {
    return ReviewImage(
      id: json['id'] as String,
      reviewId: json['review_id'] as String,
      imageUrl: json['image_url'] as String,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
