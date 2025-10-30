class User {
  int id;
  String userId;
  String name;
  String contact;
  String? email;

  int level;
  bool isActive;

  String? nickname;
  String? profileImage;

  String? department;
  DateTime? lastLoginAt;

  bool notificationEnabled;

  DateTime createdAt;

  User({
    required this.id,
    required this.userId,
    required this.name,
    required this.contact,
    this.email,
    this.level = 1,
    this.isActive = true,
    this.nickname,
    this.profileImage,
    this.department,
    this.lastLoginAt,
    this.notificationEnabled = true,
    required this.createdAt,
  });

  // JSON → User 객체
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      email: json['email'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
      nickname: json['nickname'] as String?,
      profileImage: json['profileImage'] as String?,
      department: json['department'] as String?,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      notificationEnabled: json['notificationEnabled'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  // User 객체 → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'contact': contact,
      'createdAt': createdAt.toIso8601String(),
      'level': level,
      'isActive': isActive,
      'nickname': nickname,
      'profileImage': profileImage,
      'department': department,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'notificationEnabled': notificationEnabled,
    };
  }
}
