import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:monex/features/auth/auth_repository.dart';

class AuthProvider extends Notifier<User?> {
  final _repository = AuthRepository();

  @override
  User? build() {
    return _repository.currentUser();
  }

  Future<void> signInWithGoogle() async {
    await _repository.signInWithGoogle();
    state = _repository.currentUser();
  }

  Future<void> register(String username, String email, String password) async {
    await _repository.register(
      username: username,
      email: email,
      password: password,
    );

    state = _repository.currentUser();
  }

  Future<void> login(String identifier, String password) async {
    await _repository.login(identifier: identifier, password: password);

    state = _repository.currentUser();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _repository.sendPasswordResetEmail(email);
  }

  Future<void> logout() async {
    await _repository.logout();

    state = null;
  }
}

final loadAuthProvider = NotifierProvider<AuthProvider, User?>(() {
  return AuthProvider();
});

final isTextFieldEnableProvider = StateProvider<bool>((ref) {
  return true;
});

final isVisibleProvider = StateProvider<bool>((ref) {
  return false;
});

final loginErrorProvider = StateProvider<bool>((ref) {
  return false;
});

final registerErrorProvider = StateProvider<bool>((ref) {
  return false;
});

final errorMessageRegister = StateProvider<String>((ref) {
  return '';
});

final errorMessageLogin = StateProvider<String>((ref) {
  return '';
});

final errorMessageForgotPasswordProvider = StateProvider<String>((ref) {
  return '';
});

final isForgotPasswordErrorProvider = StateProvider<bool>((ref) {
  return false;
});
