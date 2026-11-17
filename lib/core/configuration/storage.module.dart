import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';
import 'package:kingfishertom/core/services/clearable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class StorageModule {
  @lazySingleton
  @preResolve
  Future<SharedPreferences> initPref() => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage initSecureStorage() => const FlutterSecureStorage();

  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

  @lazySingleton
  List<Clearable> clearables(
    AuthRepository authRepository,
  ) =>
      <Clearable>[authRepository];
}
