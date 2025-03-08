import 'package:car_challenge/core/error/factory/failure_factory.dart';
import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/user_identification/data/datasources/local_data_source.dart';
import 'package:car_challenge/features/user_identification/data/models/user_model.dart';
import 'package:car_challenge/features/user_identification/domain/entities/user.dart';
import 'package:car_challenge/features/user_identification/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

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
      final user = localDataSource.getUser();
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
