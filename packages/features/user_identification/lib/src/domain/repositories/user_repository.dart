import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:user_identification/user_identification.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> saveUser(User user);
  Future<Either<Failure, User>> getUser();
}
