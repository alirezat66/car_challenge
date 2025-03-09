import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:user_identification/user_identification.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveUser(User user) async {
    try {
      await localDataSource.saveUser(UserModel(
        user.id,
      ));
      return const Right(null);
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final user = await localDataSource.getUser();
      if (user != null) {
        return Right(user);
      }
      return Left(FailureFactory.authenticationFailure('User not found'));
    } catch (e) {
      return Left(
          FailureFactory.storageFailure('Error accessing local storage'));
    }
  }
}
