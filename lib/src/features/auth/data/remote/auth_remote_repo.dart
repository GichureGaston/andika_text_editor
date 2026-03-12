import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/repository_exception.dart';
import '../models/user_model.dart';

abstract class AuthRepo {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  });
  Future<void> signOut();
}

class AuthRemoteRepo implements AuthRepo {
  AuthRemoteRepo({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw RepositoryException(message: e.message ?? 'Auth error');
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw RepositoryException(message: e.message ?? 'Auth error');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      final user = credential.user!;
      return UserModel(id: user.uid, name: name, email: user.email ?? '');
    } on FirebaseAuthException catch (e) {
      throw RepositoryException(message: e.message ?? 'Auth error');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw RepositoryException(message: e.message ?? 'Auth error');
    }
  }
}
