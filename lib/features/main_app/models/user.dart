class UserCreate {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? phone;
  final String password;

  UserCreate({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}

class UserDetails {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? phone;

  UserDetails({
    required  this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.phone,
  });
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phone': phone,
    };
  }

} 