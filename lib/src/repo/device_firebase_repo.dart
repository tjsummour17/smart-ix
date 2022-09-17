import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_ix/src/models/device.dart';

class DeviceFirebaseRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<Device?> update({
    required Device device,
  }) async {
    try {
      if (userId.isNotEmpty && device.id.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('devices')
            .doc(device.id)
            .update(device.toJson());
        return device;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Device?> add({
    required Device device,
  }) async {
    try {
      if (userId.isNotEmpty && device.id.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('devices')
            .doc(device.id)
            .set(device.toJson());
        return device;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> delete({
    required String deviceId,
  }) async {
    try {
      if (userId.isNotEmpty && deviceId.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('devices')
            .doc(deviceId)
            .delete();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  //TODO: Add Pagination
  Future<List<Device>?> get() async {
    try {
      if (userId.isNotEmpty) {
        final result = await _firestore
            .collection('users')
            .doc(userId)
            .collection('devices')
            .get();
        return result.docs.map((doc) => Device.fromJson(doc.data())).toList();
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
