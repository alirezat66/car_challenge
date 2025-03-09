import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:user_identification/user_identification.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([LocalDataSource])
void main() {
  late UserRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = UserRepositoryImpl(mockLocalDataSource);
  });

  group('getUser', () {
    final tUserModel = UserModel('test-user-id');

    test('should return User when local data source has data', () async {
      // arrange
      when(mockLocalDataSource.getUser()).thenAnswer((_) async => tUserModel);

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
      when(mockLocalDataSource.getUser()).thenAnswer((_) async => null);

      // act
      final result = await repository.getUser();

      // assert
      verify(mockLocalDataSource.getUser());
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<IdentificationFailure>()),
        (_) => fail('Should return a failure'),
      );
    });

    test(
        'should return LocalStorageFailure when local data source throws exception',
        () async {
      // arrange
      when(mockLocalDataSource.getUser())
          .thenThrow(Exception('Test exception'));

      // act
      final result = await repository.getUser();

      // assert
      verify(mockLocalDataSource.getUser());
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalStorageFailure>());
          expect(failure.message, contains('Error accessing local storage'));
        },
        (_) => fail('Should return a failure'),
      );
    });
  });

  group('saveUser', () {
    final tUser = User('test-user-id');

    test('should save user to local data source as UserModel', () async {
      // arrange
      when(mockLocalDataSource.saveUser(any)).thenAnswer((_) async => {});

      // act
      final result = await repository.saveUser(tUser);

      // assert
      verify(mockLocalDataSource.saveUser(any));

      expect(result, equals(const Right(null)));
    });

    test(
        'should return LocalStorageFailure when local data source throws exception',
        () async {
      // arrange
      when(mockLocalDataSource.saveUser(any))
          .thenThrow(Exception('Test exception'));

      // act
      final result = await repository.saveUser(tUser);

      // assert
      verify(mockLocalDataSource.saveUser(any));
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalStorageFailure>());
          expect(failure.message, contains('Local Storage Failure'));
        },
        (_) => fail('Should return a failure'),
      );
    });
  });
}
