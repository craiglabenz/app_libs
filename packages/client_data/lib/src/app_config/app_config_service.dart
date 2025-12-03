import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Interface of the AppConfigRepository's `service` field.
// ignore: one_member_abstracts
abstract class BaseAppConfigService {
  Stream<Map<String, Object?>> appConfig();
}

/// Real implementation of the AppConfigRepository's `service` field.
class FirestoreAppConfigService extends BaseAppConfigService {
  FirestoreAppConfigService() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<Map<String, Object?>> appConfig() => _firestore
      .doc('global/app_config')
      .snapshots()
      .map((snapshot) => snapshot.data() ?? <String, Object?>{})
      .asBroadcastStream();
}

/// Fake implementation of the AppConfigRepository's `service` field.
class FakeAppConfigService extends BaseAppConfigService {
  FakeAppConfigService()
    : _appConfigController = StreamController<Map<String, Object?>>();

  final StreamController<Map<String, Object?>> _appConfigController;

  void add(Map<String, Object?> val) => _appConfigController.add(val);

  @override
  Stream<Map<String, dynamic>> appConfig() =>
      _appConfigController.stream.asBroadcastStream();
}
