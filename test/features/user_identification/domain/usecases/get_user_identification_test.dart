import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/core/usecase/usecase.dart';
import 'package:car_challenge/features/user_identification/domain/entities/user.dart';
import 'package:car_challenge/features/user_identification/domain/repositories/user_repository.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/get_user_identification.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_identification_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUserIdentification usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserIdentification(mockUserRepository);
  });

  final user = User('123');

  test('should get user from the repository', () async {
    when(mockUserRepository.getUser()).thenAnswer((_) async => Right(user));

    final result = await usecase(const NoParams());

    expect(result, Right(user));
    verify(mockUserRepository.getUser());
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return failure when repository fails', () async {
    when(mockUserRepository.getUser())
        .thenAnswer((_) async => Left(IdentificationFailure()));

    final result = await usecase(const NoParams());
    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<IdentificationFailure>());
    }, (_) => fail('Should return a failure'));

    verify(mockUserRepository.getUser());
    verifyNoMoreInteractions(mockUserRepository);
  });
}
