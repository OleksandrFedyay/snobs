import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';

const String _tracksCollectionName = 'tracks';

@lazySingleton
class RemoteTracksDataSource {
  RemoteTracksDataSource(this._firebaseFirestore);
  final FirebaseFirestore _firebaseFirestore;

  Future<List<Track>> getArtistTracks(String artistId) async {
    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFirestore
        .collection(artistChartCollectionName)
        .doc(artistId)
        .collection(_tracksCollectionName)
        .get();

    return res.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Track.fromJson(doc.data())).toList();
  }

  Future<List<Track>> getTracksByIds(List<int> tracksId) async {
    final List<Track> resultTracks = <Track>[];

    for (int i = 0; i < tracksId.length; i = i + 20) {
      final QuerySnapshot<Map<String, dynamic>> response = await _firebaseFirestore
          .collectionGroup(_tracksCollectionName)
          .where(
            'id',
            whereIn: tracksId.sublist(
              i,
              (tracksId.length > i + 20) ? i + 20 : tracksId.length,
            ),
          )
          .get();

      resultTracks.addAll(
        response.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Track.fromJson(doc.data())).toList(),
      );
    }
    return resultTracks;
  }

  Future<List<Track>> searchTrack(String query) async {
    final QuerySnapshot<Map<String, dynamic>> response = await _firebaseFirestore
        .collectionGroup(_tracksCollectionName)
        .where(
          'title',
          isGreaterThanOrEqualTo: query,
          isLessThan: query.substring(0, query.length - 1) +
              String.fromCharCode(
                query.codeUnitAt(query.length - 1) + 1,
              ),
        )
        .get();

    final QuerySnapshot<Map<String, dynamic>> response2 = await _firebaseFirestore
        .collectionGroup(_tracksCollectionName)
        .where(
          'displayArtists',
          isGreaterThanOrEqualTo: query,
          isLessThan: query.substring(0, query.length - 1) +
              String.fromCharCode(
                query.codeUnitAt(query.length - 1) + 1,
              ),
        )
        .get();

    return <QueryDocumentSnapshot<Map<String, dynamic>>>{...response.docs, ...response2.docs}
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Track.fromJson(doc.data()))
        .toList();
  }

  Future<List<Track>> getLikedTracks(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> response = await _firebaseFirestore
        .collectionGroup(_tracksCollectionName)
        .where(
          'likes',
          arrayContains: userId,
        )
        .get();

    return response.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Track.fromJson(doc.data())).toList();
  }

  Future<List<Track>> getChartTracks() async {
    final QuerySnapshot<Map<String, dynamic>> response = await _firebaseFirestore
        .collectionGroup(_tracksCollectionName)
        .orderBy('likes')
        .limit(1000)
        .get();

    return response.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Track.fromJson(doc.data())).toList();
  }

  Future<void> addTracks(String artistId, List<Track> tracks) async {
    final CollectionReference<Map<String, dynamic>> trackCollection = _firebaseFirestore
        .collection(artistChartCollectionName)
        .doc(artistId)
        .collection(_tracksCollectionName);

    for (final Track t in tracks) {
      final DocumentReference<Map<String, dynamic>> doc = trackCollection.doc(t.id.toString());

      final Map<String, dynamic>? data = (await doc.get()).data();
      if (data == null) await doc.set(t.toJson());
    }
  }

  Future<Track?> likeTracks(
    String artistId,
    String trackId,
    String userId,
  ) async {
    final DocumentReference<Map<String, dynamic>> doc = _firebaseFirestore
        .collection(artistChartCollectionName)
        .doc(artistId)
        .collection(_tracksCollectionName)
        .doc(trackId);

    final Map<String, dynamic>? data = (await doc.get()).data();

    if (data == null) return null;

    final Track track = Track.fromJson(data);
    if (track.likes.contains(userId)) {
      final List<String> likes = <String>[...track.likes]..remove(userId);
      final Track updatedTrack = track.copyWith(likes: likes);
      await doc.set(updatedTrack.toJson());
      return updatedTrack;
    }

    final Track updatedTrack = track.copyWith(likes: <String>[...track.likes, userId]);

    await doc.set(updatedTrack.toJson());

    return updatedTrack;
  }
}
