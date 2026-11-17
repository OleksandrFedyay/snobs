import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/badge.dto.dart';
import 'package:kingfishertom/core/data/data_sources/remote.like_genre.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/domain/exception/app.exception.dart';

const String _badgeCollectionName = 'badge';

@lazySingleton
class RemoteBadgeDataSource {
  RemoteBadgeDataSource(
    this._firebaseFireStore,
    this._firebaseAuth,
  );
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFireStore;

  Future<List<BadgeDto>> createBadge(BadgeDto badge) async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) throw const AppException.notSignedIn();

    await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(_badgeCollectionName)
        .doc(badge.subgenre)
        .set(badge.toJson());

    return getBadges();
  }

  Future<List<BadgeDto>> getBadges() async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) throw const AppException.notSignedIn();

    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(_badgeCollectionName)
        .get();

    return res.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> badge) {
      return BadgeDto.fromJson(badge.data());
    }).toList();
  }

  Future<void> deleteInfo() async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) throw const AppException.notSignedIn();

    await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .delete();

    final Future<QuerySnapshot<Map<String, dynamic>>> likeGenreCollectionRef = _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(likeGenreCollectionName)
        .get();

    await likeGenreCollectionRef.then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      for (final QueryDocumentSnapshot<Map<String, dynamic>> item in snapshot.docs) {
        await item.reference.delete();
      }
    });

    final Future<QuerySnapshot<Map<String, dynamic>>> badgeCollectionRef = _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(_badgeCollectionName)
        .get();

    await badgeCollectionRef.then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      for (final QueryDocumentSnapshot<Map<String, dynamic>> item in snapshot.docs) {
        await item.reference.delete();
      }
    });

    final Future<QuerySnapshot<Map<String, dynamic>>> artistSubgenresCollectionRef = _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(artistSubgenresCollectionName)
        .get();

    await artistSubgenresCollectionRef.then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      for (final QueryDocumentSnapshot<Map<String, dynamic>> item in snapshot.docs) {
        await item.reference.delete();
      }
    });
  }
}
