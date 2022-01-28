class User {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String bloodGroup;
  final Map<String, String> location;
  final password;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.bloodGroup,
    required this.location,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'location': location,
      'bloodGroup': bloodGroup,
      'gender': gender,
    };
  }
}
