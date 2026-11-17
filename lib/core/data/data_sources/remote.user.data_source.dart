import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/app.exception.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/features/utils/extensions/date_time_ext.dart';

const String userCollectionName = 'users';

@lazySingleton
class RemoteUserDataSource {
  RemoteUserDataSource(
    this._firebaseAuth,
    this._firebaseFireStore,
  );

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFireStore;

  String get userId => _firebaseAuth.currentUser?.uid ?? '';

  Future<UserModel> getUser() async {
    final User? authUser = _firebaseAuth.currentUser;

    //Todo(Issa): need to check [AppException.notSignedIn]
    if (authUser ==
        null /* || await getIt<LocalUserJwtSource>().getJwt() == null*/) {
      throw const AppException.notSignedIn();
    }

    final DocumentSnapshot<Map<String, dynamic>> res = await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .get();

    final Map<String, dynamic>? data = res.data();

    if (data == null || data.isEmpty) {
      throw const AppException.userNotContainsInDb();
    }

    final UserModel userModel = UserModel.fromJson(data);

    await getIt<UserModelStream>().updateSaveUserModel(userModel);

    return userModel;
  }

//Todo(Issa): This stream wil be replaced with [UserModelStream] when the Database will be ready
  Stream<UserModel?> getUserStream() {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) {
      return Stream<UserModel?>.value(null);
    }

    final Stream<DocumentSnapshot<Map<String, dynamic>>> res =
        _firebaseFireStore
            .collection(userCollectionName)
            .doc(authUser.uid)
            .snapshots();

    return res.asyncMap((DocumentSnapshot<Map<String, dynamic>> event) {
      final Map<String, dynamic>? data = event.data();
      if (data == null) return null;

      return UserModel.fromJson(data);
    });
  }

  //Todo(Issa): need to check if needed or may remove it
  Future<UserModel?> getUserById(String? id) async {
    final DocumentSnapshot<Map<String, dynamic>> res =
        await _firebaseFireStore.collection(userCollectionName).doc(id).get();

    final Map<String, dynamic>? data = res.data();
    if (data == null) return null;

    final UserModel userModel = UserModel.fromJson(data);

    await getIt<UserModelStream>().updateSaveUserModel(userModel);

    return userModel;
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) {
      throw const AppException.notSignedIn();
    }

    await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .set(
          data,
          SetOptions(merge: true),
        );
  }

  Future<List<UserModel>> getAllUsers() async {
    final QuerySnapshot<Map<String, dynamic>> res =
        await _firebaseFireStore.collection(userCollectionName).get();

    return res.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
            UserModel.fromJson(doc.data()))
        .toList();
  }

  ///
  /// Trial
  ///
  Future<void> startTrial() async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) {
      throw const AppException.notSignedIn();
    }

    if (getIt<UserModelStream>().model != null) {
      await getIt<UserModelStream>()
          .updateSaveUserModel(getIt<UserModelStream>().model!.update(
                startTrialDate: DateTime.now(),
              ));
    }

    await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .set(
      <String, dynamic>{
        'startTrialDate': DateTimeExt.toJsonInt(DateTime.now()),
        /*  'endTrialDate': null,*/
      },
      SetOptions(merge: true),
    );
  }

  //Todo(Issa): Need to check, its not needed
  Future<void> endTrial(int daysLeft) async {
/*    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) {
      throw const AppException.notSignedIn();
    }

    await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .set(
      <String, dynamic>{
        'endTrialDate': DateTimeExt.toJsonInt(DateTime.now()),
        'trialDaysLeft': daysLeft,
      },
      SetOptions(merge: true),
    );*/
  }

  ///
  /// FCM Token
  ///

  Future<void> setFcmToken(String fcmToken) async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) {
      throw const AppException.notSignedIn();
    }

    await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .set(
      <String, dynamic>{'fcmToken': fcmToken},
      SetOptions(merge: true),
    );
  }

  Future<void> addSubgenres(List<String> subgenres) async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) return;

    await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .set(
      <String, dynamic>{
        'keys': 0,
        'unlockedSubgenres': subgenres,
      },
      SetOptions(merge: true),
    );
  }

  ///
  /// Levels
  ///

  Future<void> completeTask(List<String> taskIds, int xp) async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) return;

    await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .set(
      <String, dynamic>{
        'levelXp': xp,
        'completedTasks': taskIds,
      },
      SetOptions(merge: true),
    );
  }
}
