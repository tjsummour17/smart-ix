import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_ix/src/models/user.dart';

class EditProfileFirebaseRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> updateAccount({
    required User user,
  }) async {
    try {
      if (user.id.isNotEmpty) {
        await _firestore.collection('users').doc(user.id).update(user.toJson());
        return user;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
