class UserModel {
  String id;
  String name;
  String email;
  String? photoUrl;
  String themeMode;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.themeMode,
    required this.createdAt,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'themeMode': themeMode,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id : map['id'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      themeMode: map['themeMode'],
      createdAt: map['createdAt'],
    );
  }
}
