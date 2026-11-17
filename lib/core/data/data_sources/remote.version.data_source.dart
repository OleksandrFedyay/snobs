import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

const String _swipesCollectionName = 'swipes';

@LazySingleton()
class RemoteVersionDataSource {
  RemoteVersionDataSource(this._firebaseFireStore);
  final FirebaseFirestore _firebaseFireStore;

  Future<int> getVersion() async {
    final DocumentSnapshot<Map<String, dynamic>> res = await _firebaseFireStore
        .collection(_swipesCollectionName)
        .doc('version')
        .get();

    return (res.data() ?? <String, dynamic>{})['genreVersion'] as int? ?? 0;
  }
}
