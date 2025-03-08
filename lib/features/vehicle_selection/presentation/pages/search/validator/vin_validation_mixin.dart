import 'package:car_challenge/core/client/snippet.dart';

mixin VinValidationMixin {
  String? validateVin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a VIN';
    }
    if (value.length != CosChallenge.vinLength) {
      return 'VIN must be exactly ${CosChallenge.vinLength} characters';
    }
    return null;
  }
}
