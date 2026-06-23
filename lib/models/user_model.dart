class UserModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String profilePicture;
  final String dob;
  final String country;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    this.profilePicture = '',
    this.dob = '',
    this.country = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'farmer',
      profilePicture: map['profile_picture'] ?? '',
      dob: map['dob'] ?? '',
      country: map['country'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      'profile_picture': profilePicture,
      'dob': dob,
      'country': country,
    };
  }
}
