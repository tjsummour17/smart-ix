import 'package:flutter/cupertino.dart';
import 'package:smart_ix/src/repo/authentication_firebase_repo.dart';

class LoginViewModel with ChangeNotifier {
  final AuthenticationFirebaseRepo _repo = AuthenticationFirebaseRepo();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    final result = await _repo.signIn(
      email: email,
      password: password,
    );
    isLoading = false;
    return result;
  }
}
