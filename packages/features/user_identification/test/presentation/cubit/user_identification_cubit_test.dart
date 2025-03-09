import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:user_identification/user_identification.dart';

import 'user_identification_cubit_test.mocks.dart';

@GenerateMocks([SaveUserIdentification, GetUserIdentification])
void main() {
  // Test variables
  late UserIdentificationCubit cubit;
  late MockSaveUserIdentification mockSaveUser;
  late MockGetUserIdentification mockGetUser;
  const testUserId = 'test123';

  // Setup before each test
  setUp(() {
    mockSaveUser = MockSaveUserIdentification();
    mockGetUser = MockGetUserIdentification();
    cubit = UserIdentificationCubit(mockSaveUser, mockGetUser);
  });

  // Cleanup after each test
  tearDown(() {
    cubit.close();
  });

  // Test group for initial state and basic setup
  group('UserIdentificationCubit', () {
    test('initial state is UserIdentificationState with initial status', () {
      expect(
        cubit.state,
        const UserIdentificationState(
          userId: '',
          status: IdentificationStatus.initial,
          errorMessage: '',
        ),
      );
    });
  });

  // Test group for saveUserId
  group('saveUserId', () {
    blocTest<UserIdentificationCubit, UserIdentificationState>(
      'emits [loading, loaded] states when saveUserId succeeds',
      build: () {
        when(mockSaveUser(any)).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.saveUserId(testUserId),
      expect: () => [
        const UserIdentificationState(
          status: IdentificationStatus.loading,
          userId: '',
          errorMessage: '',
        ),
        const UserIdentificationState(
          status: IdentificationStatus.loaded,
          userId: testUserId,
          errorMessage: '',
        ),
      ],
      verify: (_) {
        verify(mockSaveUser(any)).called(1);
      },
    );

    blocTest<UserIdentificationCubit, UserIdentificationState>(
      'emits [loading, error] states when saveUserId fails',
      build: () {
        when(mockSaveUser(any))
            .thenAnswer((_) async => Left(LocalStorageFailure('Save failed')));
        return cubit;
      },
      act: (cubit) => cubit.saveUserId(testUserId),
      expect: () => [
        const UserIdentificationState(
          status: IdentificationStatus.loading,
          userId: '',
          errorMessage: '',
        ),
        const UserIdentificationState(
          status: IdentificationStatus.error,
          userId: '',
          errorMessage: 'Save failed',
        ),
      ],
      verify: (_) {
        verify(mockSaveUser(any)).called(1);
      },
    );
  });

  // Test group for loadUser
  group('loadUser', () {
    blocTest<UserIdentificationCubit, UserIdentificationState>(
      'emits [loading, loaded] states when loadUser succeeds with existing user',
      build: () {
        when(mockGetUser(const NoParams()))
            .thenAnswer((_) async => Right(User(testUserId)));
        return cubit;
      },
      act: (cubit) => cubit.loadUser(),
      expect: () => [
        const UserIdentificationState(
          status: IdentificationStatus.loading,
          userId: '',
          errorMessage: '',
        ),
        const UserIdentificationState(
          status: IdentificationStatus.loaded,
          userId: testUserId,
          errorMessage: '',
        ),
      ],
      verify: (_) {
        verify(mockGetUser(const NoParams())).called(1);
      },
    );

    blocTest<UserIdentificationCubit, UserIdentificationState>(
      'emits [loading, initial] states when loadUser fails (no user found)',
      build: () {
        when(mockGetUser(const NoParams()))
            .thenAnswer((_) async => Left(LocalStorageFailure('No user')));
        return cubit;
      },
      act: (cubit) => cubit.loadUser(),
      expect: () => [
        const UserIdentificationState(
          status: IdentificationStatus.loading,
          userId: '',
          errorMessage: '',
        ),
        const UserIdentificationState(
          status: IdentificationStatus.initial,
          userId: '',
          errorMessage: '',
        ),
      ],
      verify: (_) {
        verify(mockGetUser(const NoParams())).called(1);
      },
    );
  });
}
