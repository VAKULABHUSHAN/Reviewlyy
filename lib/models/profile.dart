class UserProfile {
  final String id;
  final String username;
  final String fullName;
  final String bio;
  final String avatarUrl;
  final int reviewsWritten;
  final int helpfulVotes;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    this.username = '',
    required this.fullName,
    this.bio = '',
    this.avatarUrl = '',
    this.reviewsWritten = 0,
    this.helpfulVotes = 0,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      reviewsWritten: json['reviews_written'] as int? ?? 0,
      helpfulVotes: json['helpful_votes'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'bio': bio,
      'avatar_url': avatarUrl,
    };
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? fullName,
    String? bio,
    String? avatarUrl,
    int? reviewsWritten,
    int? helpfulVotes,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      reviewsWritten: reviewsWritten ?? this.reviewsWritten,
      helpfulVotes: helpfulVotes ?? this.helpfulVotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static UserProfile empty() => UserProfile(
        id: '',
        fullName: '',
        createdAt: DateTime.now(),
      );
}
