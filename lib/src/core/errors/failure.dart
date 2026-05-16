import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.errorMessage, this.statusCode});
  final String errorMessage;
  final String? statusCode;

  @override
  List<Object?> get props => [errorMessage, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errorMessage, super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.errorMessage});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.errorMessage});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.errorMessage, super.statusCode});
}

class FirebaseFailure extends Failure {
  const FirebaseFailure({required super.errorMessage, super.statusCode});
}
