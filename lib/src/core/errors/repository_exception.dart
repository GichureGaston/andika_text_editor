import 'dart:async';

import 'package:andika/src/core/errors/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RepositoryException implements Exception {
  const RepositoryException({
    required this.message,
    this.exception,
    this.stackTrace,
  });

  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return "RepositoryException: $message)";
  }
}

mixin RepositoryExceptionMixin {
  Future<T> exceptionHandler<T>(
    FutureOr computation, {
    String unkownMessage = 'Repository Exception',
  }) async {
    try {
      return await computation;
    } on FirebaseException catch (e) {
      logger.warning(e.message, e);
      throw RepositoryException(
        message: e.message ?? 'An undefined error occured',
      );
    }
  }
}
