class UserModel {
  final String email;
  final String password;

  UserModel({required this.email, required this.password});

  Map<String, dynamic> usertomap() {
    return {'email': email, 'password': password};
  }

  factory UserModel.fromuserMap(Map<String, dynamic> map) {
    return UserModel(email: map['email'], password: map['password']);
  }
}
