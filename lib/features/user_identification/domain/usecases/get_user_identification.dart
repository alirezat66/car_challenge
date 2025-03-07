import 'package:car_challenge/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:car_challenge/core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserIdentification implements UseCase<User, NoParams> {
  final UserRepository repository;

  GetUserIdentification(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getUser();
  }
}
