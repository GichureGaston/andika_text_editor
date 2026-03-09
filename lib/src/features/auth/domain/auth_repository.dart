abstract class AuthRepository {
  Future<void> create({
    required String email,
    required String password,
    required String name,
  }) async {}

  Future<void> createSession({
    required String email,
    required String password,
  }) async {}

  Future<void> get() async {}

  Future<void> deleteSession({required String sessionId}) async {}
}
