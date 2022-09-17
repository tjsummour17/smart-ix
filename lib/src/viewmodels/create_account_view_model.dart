import 'package:flutter/cupertino.dart';
import 'package:smart_ix/src/models/user.dart';
import 'package:smart_ix/src/repo/authentication_firebase_repo.dart';
import 'package:smart_ix/src/services/hive_database.dart';

class CreateAccountViewModel with ChangeNotifier {
  final AuthenticationFirebaseRepo _repo = AuthenticationFirebaseRepo();

  Future<CreateAccountResult> createAccount({
    required User user,
    String langCode = 'en',
  }) async {
    final result = await _repo.createAccount(user: user);

    if (result.status == CreateAccountStatus.success) {
      final user = result.user;
      if (user != null) HiveDatabase.saveLastLoggedInUser(user);
    }

    return result;
  }
}
