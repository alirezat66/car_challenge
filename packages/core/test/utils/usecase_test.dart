import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'usecase_test.mocks.dart';


@GenerateMocks([UseCase])
void main() {
  group('UseCase', () {
    late MockUseCase useCase;

    setUp(() {
      useCase = MockUseCase();
    });

    test('should call the usecase with the given parameters', () async {
      // arrange
      when(useCase.call(any))
          .thenAnswer((_) async => const Right('test result'));

      // act
      final result = await useCase('test parameter');

      // assert
      verify(useCase.call('test parameter'));
      expect(result, const Right('test result'));
    });

    test('should return failure when usecase fails', () async {
      // arrange
      final failure = ServerFailure('test failure');
      when(useCase.call(any)).thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase('test parameter');

      // assert
      verify(useCase.call('test parameter'));
      expect(result, Left(failure));
    });
  });

  group('NoParams', () {
    test('two NoParams instances should be equal', () {
      const noParams1 = NoParams();
      const noParams2 = NoParams();
      expect(noParams1, equals(noParams2));
    });
  });
}
