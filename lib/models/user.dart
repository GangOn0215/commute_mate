class User {
  int id;
  String userId;
  String name;
  String contact;
  DateTime createdAt;

  int level;
  bool isActive;

  String? nickname;
  String? profileImage;

  String? department;
  DateTime? lastLoginAt;

  bool notificationEnabled;

  User({
    required this.id,
    required this.userId,
    required this.name,
    required this.contact,
    required this.createdAt,
    this.level = 1,
    this.isActive = true,
    this.nickname,
    this.profileImage,
    this.department,
    this.lastLoginAt,
    this.notificationEnabled = true,
  });
}
