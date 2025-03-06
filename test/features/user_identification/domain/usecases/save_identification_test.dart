import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/user_identification/domain/entities/user.dart';
import 'package:car_challenge/features/user_identification/domain/repositories/user_repository.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/save_identification.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_identification_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late SaveUserIdentification usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = SaveUserIdentification(mockUserRepository);
  });

  final user = User('123');

  test('should save user to the repository', () async {
    when(mockUserRepository.saveUser(any))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(user);

    expect(result, const Right(null));
    verify(mockUserRepository.saveUser(any));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return failure when repository fails', () async {
    when(mockUserRepository.saveUser(any))
        .thenAnswer((_) async => Left(LocalStorageFailure()));

    final result = await usecase(user);
    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<LocalStorageFailure>());
    }, (_) => fail('Should return a failure'));
    verify(mockUserRepository.saveUser(any));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
