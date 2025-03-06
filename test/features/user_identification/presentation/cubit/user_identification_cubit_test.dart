import 'package:bloc_test/bloc_test.dart';
import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/core/usecase/usecase.dart';
import 'package:car_challenge/features/user_identification/domain/entities/user.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/get_user_identification.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/save_identification.dart';
import 'package:car_challenge/features/user_identification/presentation/cubit/user_identification_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

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
    test('initial state is UserIdentificationInitial', () {
      expect(cubit.state, UserIdentificationInitial());
    });
  });

  // Test group for saveUserId
  group('saveUserId', () {
    blocTest<UserIdentificationCubit, UserIdentificationState>(
      'emits [Loading, Loaded] when saveUserId succeeds',
      build: () {
        when(mockSaveUser(any)).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.saveUserId(testUserId),
      expect: () => [
        UserIdentificationLoading(),
        UserIdentificationLoaded(testUserId),
      ],
      verify: (_) {
        verify(mockSaveUser(any)).called(1);
      },
    );

    blocTest<UserIdentificationCubit, UserIdentificationState>(
      'emits [Loading, Error] when saveUserId fails',
      build: () {
        when(mockSaveUser(any))
            .thenAnswer((_) async => Left(LocalStorageFailure('Save failed')));
        return cubit;
      },
      act: (cubit) => cubit.saveUserId(testUserId),
      expect: () => [
        UserIdentificationLoading(),
        UserIdentificationError('Save failed'),
      ],
      verify: (_) {
        verify(mockSaveUser(any)).called(1);
      },
    );
  });

  // Test group for loadUser
  group('loadUser', () {
    blocTest<UserIdentificationCubit, UserIdentificationState>(
      'emits [Loading, Loaded] when loadUser succeeds with existing user',
      build: () {
        when(mockGetUser(const NoParams()))
            .thenAnswer((_) async => Right(User(testUserId)));
        return cubit;
      },
      act: (cubit) => cubit.loadUser(),
      expect: () => [
        UserIdentificationLoading(),
        UserIdentificationLoaded(testUserId),
      ],
      verify: (_) {
        verify(mockGetUser(const NoParams())).called(1);
      },
    );

    blocTest<UserIdentificationCubit, UserIdentificationState>(
      'emits [Loading, Initial] when loadUser fails (no user found)',
      build: () {
        when(mockGetUser(const NoParams()))
            .thenAnswer((_) async => Left(LocalStorageFailure('No user')));
        return cubit;
      },
      act: (cubit) => cubit.loadUser(),
      expect: () => [
        UserIdentificationLoading(),
        UserIdentificationInitial(),
      ],
      verify: (_) {
        verify(mockGetUser(const NoParams())).called(1);
      },
    );
  });
}
