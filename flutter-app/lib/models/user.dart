class User {
  int? id;
  String userId;
  String? password;
  String name;
  String contact;
  String? email;

  int level;
  bool isActive;

  String? nickname;
  String? profileImageUrl;

  String? department;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastLoginAt;

  bool? notificationEnabled;

  User({
    this.id,
    this.password,
    required this.userId,
    required this.name,
    required this.contact,
    this.createdAt,
    this.email,
    this.level = 1,
    this.isActive = true,
    this.nickname,
    this.profileImageUrl,
    this.department,
    this.lastLoginAt,
    this.notificationEnabled = true,
  });

  // JSON → User 객체
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      level: json['level'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
      nickname: json['nickname'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      department: json['department'] as String?,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      notificationEnabled: json['notificationEnabled'] as bool? ?? true,
    );
  }

  // User 객체 → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'password': password,
      'name': name,
      'contact': contact,
      'createdAt': createdAt,
      'level': level,
      'isActive': isActive,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'department': department,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'notificationEnabled': notificationEnabled,
    };
  }
}
