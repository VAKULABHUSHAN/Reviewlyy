class AppProduct {
  final String id;
  final String name;
  final String categoryId;
  final String category;
  final String description;
  final String brand;
  final String imageUrl;
  final double avgRating;
  final int reviewCount;
  final DateTime createdAt;

  const AppProduct({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.category,
    required this.description,
    required this.brand,
    required this.imageUrl,
    this.avgRating = 0,
    this.reviewCount = 0,
    required this.createdAt,
  });

  factory AppProduct.fromJson(Map<String, dynamic> json) {
    // Handle the joined category object
    final categoryData = json['categories'];
    final categoryName = categoryData is Map
        ? (categoryData['name'] as String? ?? 'Uncategorized')
        : 'Uncategorized';

    return AppProduct(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      category: categoryName,
      description: json['description'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
      reviewCount: json['review_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
