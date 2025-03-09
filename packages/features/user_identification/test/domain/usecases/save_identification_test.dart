import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:user_identification/user_identification.dart';

import 'save_identification_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late SaveUserIdentification useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = SaveUserIdentification(mockRepository);
  });

  final tUser = User('test-user-id');

  test('should save user to the repository', () async {
    // arrange
    when(mockRepository.saveUser(any))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await useCase(tUser);

    // assert
    expect(result, const Right(null));
    verify(mockRepository.saveUser(tUser));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should forward repository failures', () async {
    // arrange
    final failure = LocalStorageFailure('Failed to save user');
    when(mockRepository.saveUser(any)).thenAnswer((_) async => Left(failure));

    // act
    final result = await useCase(tUser);

    // assert
    expect(result, Left(failure));
    verify(mockRepository.saveUser(tUser));
    verifyNoMoreInteractions(mockRepository);
  });
}
