// lib/core/errors/failures.dart
class Failure {
  final String message;
  final int? statusCode;

  Failure({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.statusCode});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}
