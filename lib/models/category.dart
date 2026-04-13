class Category {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    this.description = '',
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
