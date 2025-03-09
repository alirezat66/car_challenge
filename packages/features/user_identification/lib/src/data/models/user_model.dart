import 'package:user_identification/user_identification.dart';

class UserModel extends User {
  UserModel(super.id);

  Map<String, dynamic> toJson() => {'id': id};
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(json['id']);
}
