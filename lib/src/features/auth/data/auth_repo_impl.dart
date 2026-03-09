import 'package:andika/src/features/auth/domain/auth_repository.dart';

class AuthRepoImpl implements AuthRepository {
  @override
  Future<void> create({
    required String email,
    required String password,
    required String name,
  }) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> createSession({
    required String email,
    required String password,
  }) {
    // TODO: implement createSession
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSession({required String sessionId}) {
    // TODO: implement deleteSession
    throw UnimplementedError();
  }

  @override
  Future<void> get() {
    // TODO: implement get
    throw UnimplementedError();
  }
}
