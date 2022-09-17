import 'package:flutter/foundation.dart';
import 'package:smart_ix/src/models/user.dart';
import 'package:smart_ix/src/repo/authentication_firebase_repo.dart';
import 'package:smart_ix/src/services/hive_database.dart';

class CurrentUserProvider with ChangeNotifier {
  User? currentUser = HiveDatabase.getLastLoggedInUser();

  void saveUser(User user) {
    currentUser = user;
    notifyListeners();
    HiveDatabase.saveLastLoggedInUser(user);
  }

  void logout() {
    currentUser = null;
    AuthenticationFirebaseRepo().signOut();
    HiveDatabase.deleteLastLoggedInUser();
  }
}
