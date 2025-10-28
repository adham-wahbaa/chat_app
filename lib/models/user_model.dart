class UserModel {

  final String id;
  final String username;
  final String email;
  final bool isVerified;

  UserModel({
    required this.email,
    required this.id,
    required this.username,
    this.isVerified = false,
  });

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
      email: map["email"],
      id: map["id"],
      username: map["username"],
      isVerified: map["isVerified"] ?? false,
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "username": username,
      "email": email,
      "isVerified": isVerified,
    };
  }

}
