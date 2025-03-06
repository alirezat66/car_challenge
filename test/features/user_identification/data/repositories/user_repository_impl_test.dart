import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/user_identification/data/datasources/local_data_source.dart';
import 'package:car_challenge/features/user_identification/data/models/user_model.dart';
import 'package:car_challenge/features/user_identification/data/repositories/user_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([LocalDataSource])
import 'user_repository_impl_test.mocks.dart';

void main() {
  late UserRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = UserRepositoryImpl(mockLocalDataSource);
  });

  group('getUser', () {
    final tUserModel = UserModel('test_user_id');

    test('should return User when local data source has data', () async {
      // arrange
      when(mockLocalDataSource.getUser()).thenReturn(tUserModel);

      // act
      final result = await repository.getUser();

      // assert
      verify(mockLocalDataSource.getUser());
      expect(result, equals(Right(tUserModel)));
    });

    test(
        'should return IdentificationFailure when local data source returns null',
        () async {
      // arrange
      when(mockLocalDataSource.getUser()).thenReturn(null);

      // act
      final result = await repository.getUser();

      // assert
      verify(mockLocalDataSource.getUser());
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<IdentificationFailure>());
      }, (_) => fail('Should return a failure'));
    });

    test(
        'should return LocalStorageFailure when local data source throws exception',
        () async {
      // arrange
      when(mockLocalDataSource.getUser()).thenThrow(Exception());

      // act
      final result = await repository.getUser();

      // assert

      verify(mockLocalDataSource.getUser());
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<LocalStorageFailure>());
      }, (_) => fail('Should return a failure'));
    });
  });

  group('saveUser', () {
    final tUserModel = UserModel('test_user_id');

    test('should call local data source to save the user', () async {
      // arrange
      when(mockLocalDataSource.saveUser(any)).thenAnswer((_) async {});

      // act
      await repository.saveUser(tUserModel);

      // assert
      verify(mockLocalDataSource.saveUser(any));
    });

    test('should return Right(null) when saving user is successful', () async {
      // arrange
      when(mockLocalDataSource.saveUser(any)).thenAnswer((_) async {});

      // act
      final result = await repository.saveUser(tUserModel);

      // assert
      expect(result, equals(const Right(null)));
    });

    test('should return LocalStorageFailure when saving user throws exception',
        () async {
      // arrange
      when(mockLocalDataSource.saveUser(any)).thenThrow(Exception());

      // act
      final result = await repository.saveUser(tUserModel);

      // assert
      verify(mockLocalDataSource.saveUser(any));

      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<LocalStorageFailure>());
      }, (_) => fail('Should return a failure'));
    });
  });
}
