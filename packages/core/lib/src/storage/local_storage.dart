import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

abstract class LocalStorage {
  /// Saves a string value with the given key
  Future<Either<Failure, bool>> saveString(String key, String value);

  /// Retrieves a string value by key
  Future<Either<Failure, String?>> getString(String key);
}
