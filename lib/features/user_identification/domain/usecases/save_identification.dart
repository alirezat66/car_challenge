import 'package:car_challenge/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:car_challenge/core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SaveUserIdentification implements UseCase<void, User> {
  final UserRepository repository;

  SaveUserIdentification(this.repository);

  @override
  Future<Either<Failure, void>> call(User user) async {
    return await repository.saveUser(user);
  }
}
