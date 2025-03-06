import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/features/user_identification/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> saveUser(User user);
  Future<Either<Failure, User>> getUser();
}
