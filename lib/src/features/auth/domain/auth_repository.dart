abstract class AuthRepository {
  Future<void> signInEmailAndPassword(String? email, String? password);
  Future<void> signUpEmailAndPassword(
    String? email,
    String? password, {
    String? name,
  });

  Future<void> signOut();
  Future<void> resetPassword(String? email);
}
