import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:smart_ix/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountResult {
  CreateAccountResult({
    required this.status,
    required this.user,
  });

  User? user;
  CreateAccountStatus status;
}

class SignInResult {
  SignInResult({
    required this.status,
    required this.user,
  });

  User? user;
  SignInStatus status;
}

class AuthenticationFirebaseRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CreateAccountResult> createAccount({
    required User user,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser != null) {
        user = user.copy(id: firebaseUser.uid);
        _firestore.collection('users').doc(firebaseUser.uid).set(user.toJson());
        return CreateAccountResult(
          status: CreateAccountStatus.success,
          user: user,
        );
      } else {
        return CreateAccountResult(
          status: CreateAccountStatus.unknownError,
          user: null,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        return CreateAccountResult(
          status: CreateAccountStatus.weakPassword,
          user: null,
        );
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        return CreateAccountResult(
          status: CreateAccountStatus.alreadyExists,
          user: null,
        );
      }
    } catch (e) {
      log(e.toString());
      return CreateAccountResult(
        status: CreateAccountStatus.unknownError,
        user: null,
      );
    }
    return CreateAccountResult(
      status: CreateAccountStatus.success,
      user: null,
    );
  }

  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser != null) {
        final userData = (await _firestore
                .collection('users')
                .doc(
                  firebaseUser.uid,
                )
                .get())
            .data();
        if (userData != null) {
          User user = User.fromJson(userData);
          return SignInResult(status: SignInStatus.success, user: user);
        } else {
          return SignInResult(status: SignInStatus.unknownError, user: null);
        }
      } else {
        return SignInResult(status: SignInStatus.unknownError, user: null);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        return SignInResult(status: SignInStatus.userNotExists, user: null);
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        return SignInResult(status: SignInStatus.wrongPassword, user: null);
      }
    } catch (e) {
      log(e.toString());
      return SignInResult(status: SignInStatus.unknownError, user: null);
    }
    return SignInResult(status: SignInStatus.unknownError, user: null);
  }

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();
}

enum CreateAccountStatus {
  success,
  weakPassword,
  alreadyExists,
  unknownError,
}

enum SignInStatus {
  success,
  wrongPassword,
  userNotExists,
  unknownError,
}
