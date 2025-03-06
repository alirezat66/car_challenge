import 'package:car_challenge/features/user_identification/domain/entities/user.dart';

class UserModel extends User {
  UserModel(super.id);

  Map<String, dynamic> toJson() => {'id': id};
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(json['id']);
}
