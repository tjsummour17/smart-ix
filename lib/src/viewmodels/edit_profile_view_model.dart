import 'package:flutter/cupertino.dart';
import 'package:smart_ix/src/models/user.dart';
import 'package:smart_ix/src/repo/edit_user_firebase_repo.dart';

class EditProfileViewModel with ChangeNotifier {
  final EditProfileFirebaseRepo _repo = EditProfileFirebaseRepo();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  @protected
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> update(User user) async {
    isLoading = true;
    await _repo.updateAccount(user: user);
    isLoading = false;
  }
}
