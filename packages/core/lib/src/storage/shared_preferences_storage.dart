import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class SharedPreferencesStorage implements LocalStorage {
  final dynamic sharedPreferences;

  SharedPreferencesStorage(this.sharedPreferences);

  @override
  Future<Either<Failure, bool>> saveString(String key, String value) async {
    try {
      final result = await sharedPreferences.setString(key, value);
      return Right(result);
    } catch (e) {
      return Left(
          FailureFactory.storageFailure('Error saving string value: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> getString(String key) async {
    try {
      final result = sharedPreferences.getString(key);
      return Right(result);
    } catch (e) {
      return Left(
          FailureFactory.storageFailure('Error retrieving string value: $e'));
    }
  }
}
