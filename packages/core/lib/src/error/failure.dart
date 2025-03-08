// lib/core/error/failure.dart
abstract class Failure {
  final String message;
  final Map<String, dynamic>? extraData; // Optional extra properties

  Failure(this.message, {this.extraData});
}
