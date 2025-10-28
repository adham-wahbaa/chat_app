class UserModel {

  final String id;
  final String username;
  final String email;

  UserModel({required this.email,required this.id,required this.username});

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
      email: map["email"],
      id: map["id"],
      username: map["username"]);
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "username": username,
      "email": email
    };
  }

}
