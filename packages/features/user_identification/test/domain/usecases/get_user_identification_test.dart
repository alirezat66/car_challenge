import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:user_identification/user_identification.dart';

import 'save_identification_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUserIdentification useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserIdentification(mockRepository);
  });

  final tUser = User('test-user-id');

  test('should get user from the repository', () async {
    // arrange
    when(mockRepository.getUser()).thenAnswer((_) async => Right(tUser));

    // act
    final result = await useCase(const NoParams());

    // assert
    expect(result, Right(tUser));
    verify(mockRepository.getUser());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should forward repository failures', () async {
    // arrange
    final failure = IdentificationFailure('User not found');
    when(mockRepository.getUser()).thenAnswer((_) async => Left(failure));

    // act
    final result = await useCase(const NoParams());

    // assert
    expect(result, Left(failure));
    verify(mockRepository.getUser());
    verifyNoMoreInteractions(mockRepository);
  });
}
