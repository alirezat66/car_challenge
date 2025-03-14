// Mocks generated by Mockito 5.4.4 from annotations
// in car_challenge/test/features/user_identification/presentation/cubit/user_identification_cubit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:car_challenge/core/error/failure.dart' as _i6;
import 'package:car_challenge/core/usecase/usecase.dart' as _i9;
import 'package:car_challenge/features/user_identification/domain/entities/user.dart'
    as _i7;
import 'package:car_challenge/features/user_identification/domain/repositories/user_repository.dart'
    as _i2;
import 'package:car_challenge/features/user_identification/domain/usecases/get_user_identification.dart'
    as _i8;
import 'package:car_challenge/features/user_identification/domain/usecases/save_identification.dart'
    as _i4;
import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeUserRepository_0 extends _i1.SmartFake
    implements _i2.UserRepository {
  _FakeUserRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SaveUserIdentification].
///
/// See the documentation for Mockito's code generation for more information.
class MockSaveUserIdentification extends _i1.Mock
    implements _i4.SaveUserIdentification {
  MockSaveUserIdentification() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, void>> call(_i7.User? user) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [user],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [user],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}

/// A class which mocks [GetUserIdentification].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetUserIdentification extends _i1.Mock
    implements _i8.GetUserIdentification {
  MockGetUserIdentification() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.User>> call(_i9.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i7.User>>.value(
            _FakeEither_1<_i6.Failure, _i7.User>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.User>>);
}
