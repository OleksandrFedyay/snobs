import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/artists/artist.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/vote_genre.dart';
import 'package:kingfishertom/core/domain/exception/app.exception.dart';
import 'package:kingfishertom/core/domain/repositories/recommendation_artist_service.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';

const String artistChartCollectionName = 'artists_charts';
const String voteCollectionName = 'vote';

@lazySingleton
class RemoteArtistChartDataSource {
  RemoteArtistChartDataSource(
    this._firebaseFirestore,
    this._firebaseAuth,
  );

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  Future<List<ArtistChartDto>> getArtistCharts(String subgenre) async {
    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFirestore
        .collection(artistChartCollectionName)
        .where('subgenres', arrayContains: subgenre)
        .orderBy('likes', descending: true)
        .limit(999)
        .get();

    return res.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
            ArtistChartDto.fromJson(doc.data()))
        .toList();
  }

  Future<List<ArtistChartDto>> getArtistChartsForAllSubGenres(
    List<String> subgenres,
  ) async {
    if (subgenres.isEmpty) return <ArtistChartDto>[];

    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFirestore
        .collection(artistChartCollectionName)
        .where('subgenres', arrayContainsAny: subgenres)
        .orderBy('likes', descending: true)
        .limit(999)
        .get();

    return res.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
            ArtistChartDto.fromJson(doc.data()))
        .toList();
  }

  Future<List<ArtistChartDto>> getAllArtists() async {
    final QuerySnapshot<Map<String, dynamic>> res =
        await _firebaseFirestore.collection(artistChartCollectionName).get();

    return res.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
            ArtistChartDto.fromJson(doc.data()))
        .toList();
  }

  Future<List<ArtistChartDto>> getAllLikedArtist(
    List<String> likedArtists,
  ) async {
    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFirestore
        .collection(artistChartCollectionName)
        .where('id', whereIn: likedArtists)
        .orderBy('likes', descending: true)
        .get();

    return res.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
            ArtistChartDto.fromJson(doc.data()))
        .toList();
  }

  Future<ArtistsWithLastDto> getRecommendationsArtistCharts(
    String subgenre,
  ) async {
    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFirestore
        .collection(artistChartCollectionName)
        .where('subgenres', arrayContains: subgenre)
        .orderBy('likes', descending: true)
        .limit(size)
        .get();

    return ArtistsWithLastDto(
      artists: res.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              ArtistChartDto.fromJson(doc.data()))
          .toList(),
      last: res.docs.lastOrNull,
    );
  }

  Future<ArtistsWithLastDto> getRecommendationsArtistChartsForAllSubgenre(
    List<String> subgenres,
  ) async {
    if (subgenres.isEmpty) return const ArtistsWithLastDto();

    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFirestore
        .collection(artistChartCollectionName)
        .where('subgenres', arrayContainsAny: subgenres)
        .orderBy('likes', descending: true)
        .limit(size)
        .get();

    return ArtistsWithLastDto(
      artists: res.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              ArtistChartDto.fromJson(doc.data()))
          .toList(),
      last: res.docs.lastOrNull,
    );
  }

  Future<ArtistsWithLastDto> getRecommendationsNextArtistCharts(
    String subgenre,
    DocumentSnapshot<Object?> documentSnapshot,
  ) async {
    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFirestore
        .collection(artistChartCollectionName)
        .where('subgenres', arrayContains: subgenre)
        .orderBy('likes', descending: true)
        .limit(size)
        .startAfterDocument(documentSnapshot)
        .get();

    return ArtistsWithLastDto(
      artists: res.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              ArtistChartDto.fromJson(doc.data()))
          .toList(),
      last: res.docs.lastOrNull,
    );
  }

  Future<ArtistsWithLastDto> getRecommendationsNextArtistChartsForAllSubgenre(
    List<String> subgenres,
    DocumentSnapshot<Object?> documentSnapshot,
  ) async {
    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFirestore
        .collection(artistChartCollectionName)
        .where('subgenres', arrayContainsAny: subgenres)
        .orderBy('likes', descending: true)
        .limit(size)
        .startAfterDocument(documentSnapshot)
        .get();

    return ArtistsWithLastDto(
      artists: res.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              ArtistChartDto.fromJson(doc.data()))
          .toList(),
      last: res.docs.lastOrNull,
    );
  }

  //Todo(Issa): Need to change it when will be the server ready with "Pagination" parameter and without sensitive case
  Future<List<ArtistChartDto>> searchArtists(String query) async {
    final String queryCapitalized = query.toCapitalizeAllWords();
    final String queryLowerCase = query.toLowerCase();

    /// Query for capitalized
    final QuerySnapshot<Map<String, dynamic>> responseCapitalized =
        await _firebaseFirestore
            .collectionGroup(artistChartCollectionName)
            .where(
              'name',
              isGreaterThanOrEqualTo: queryCapitalized,
              isLessThan: queryCapitalized.substring(
                      0, queryCapitalized.length - 1) +
                  String.fromCharCode(
                    queryCapitalized.codeUnitAt(queryCapitalized.length - 1) +
                        1,
                  ),
            )
            .get();

    /// Query for lowercase
    final QuerySnapshot<Map<String, dynamic>> responseLowerCase =
        await _firebaseFirestore
            .collectionGroup(artistChartCollectionName)
            .where(
              'name',
              isGreaterThanOrEqualTo: queryLowerCase,
              isLessThan: queryLowerCase.substring(
                      0, queryLowerCase.length - 1) +
                  String.fromCharCode(
                    queryLowerCase.codeUnitAt(queryLowerCase.length - 1) + 1,
                  ),
            )
            .get();

    /// Combine results, removing duplicates
    return responseCapitalized.docs
        .followedBy(responseLowerCase.docs)
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => doc.data())
        .toSet()
        .map((Map<String, dynamic> data) => ArtistChartDto.fromJson(data))
        .toList();
  }

  Future<void> updateArtistChart(
    String artistId, {
    required bool like,
  }) async {
    final DocumentReference<Map<String, dynamic>> doc =
        _firebaseFirestore.collection(artistChartCollectionName).doc(artistId);

    final Map<String, dynamic>? data = (await doc.get()).data();

    if (data == null) {
      return;
    }

    final ArtistChartDto artistChart = ArtistChartDto.fromJson(data);
    await doc.set(
      ArtistChartDto(
        id: artistId,
        bio: artistChart.bio,
        name: artistChart.name,
        popularity: artistChart.popularity,
        image: artistChart.image,
        tracks: artistChart.tracks,
        subgenres: artistChart.subgenres,
        likes: like ? artistChart.likes + 1 : artistChart.likes,
        unlikes: like ? artistChart.unlikes : artistChart.unlikes + 1,
      ).toJson(),
    );
  }

  Future<void> updateArtistChartSubgenres(
    String artistId,
    List<String> subgenres,
  ) async {
    final DocumentReference<Map<String, dynamic>> doc =
        _firebaseFirestore.collection(artistChartCollectionName).doc(artistId);

    final Map<String, dynamic>? data = (await doc.get()).data();

    if (data == null) {
      return;
    }

    final ArtistChartDto artistChart = ArtistChartDto.fromJson(data);
    await doc.set(
      artistChart.copyWith(subgenres: subgenres).toJson(),
    );
  }

  Future<void> updateArtistChartBio(
    Artist artist,
    List<String> subgenres,
  ) async {
    final DocumentReference<Map<String, dynamic>> doc = _firebaseFirestore
        .collection(artistChartCollectionName)
        .doc(artist.id.toString());

    final Map<String, dynamic>? data = (await doc.get()).data();

    if (data == null) {
      await doc.set(
        ArtistChartDto(
          id: artist.id.toString(),
          name: artist.name,
          popularity: artist.popularity ?? 0,
          image: artist.image ?? '',
          bio: artist.bio,
          subgenres: subgenres,
        ).toJson(),
      );
      return;
    }

    final ArtistChartDto artistChart = ArtistChartDto.fromJson(data);

    await doc.set(
      ArtistChartDto(
        id: artist.id.toString(),
        name: artist.name,
        popularity: artist.popularity ?? 0,
        image: artist.image ?? artistChart.image,
        bio: artist.bio,
        tracks: artistChart.tracks,
        subgenres: subgenres,
        likes: artistChart.likes,
        unlikes: artistChart.unlikes,
      ).toJson(),
    );
  }

  Future<void> deleteArtistChart(String artistId) async {
    final DocumentReference<Map<String, dynamic>> doc =
        _firebaseFirestore.collection(artistChartCollectionName).doc(artistId);

    final Map<String, dynamic>? data = (await doc.get()).data();

    if (data == null) return;

    final ArtistChartDto artistChart = ArtistChartDto.fromJson(data);
    await doc.set(
      artistChart.copyWith(likes: artistChart.likes - 1).toJson(),
    );
  }

  ///
  /// Vote
  ///

  Future<List<VoteGenre>> getVotes(String artistId) async {
    final String? authUser = _firebaseAuth.currentUser?.uid;

    if (authUser == null) {
      throw const AppException.notSignedIn();
    }

    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFirestore
        .collection(artistChartCollectionName)
        .doc(artistId)
        .collection(voteCollectionName)
        .get();

    return res.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
            VoteGenre.fromJson(doc.data()))
        .toList();
  }

  Future<VoteGenre> upvoteGenreChart(String genre, String artistId) async {
    final String? authUser = _firebaseAuth.currentUser?.uid;

    if (authUser == null) {
      throw const AppException.notSignedIn();
    }

    final DocumentReference<Map<String, dynamic>> doc = _firebaseFirestore
        .collection(artistChartCollectionName)
        .doc(artistId)
        .collection(voteCollectionName)
        .doc(genre);

    final Map<String, dynamic>? data = (await doc.get()).data();

    if (data == null) {
      final VoteGenre genreChart = VoteGenre(
        genre: genre,
        upvote: <String>[authUser],
      );
      await doc.set(genreChart.toJson());
      return genreChart;
    }

    final VoteGenre genreChart = VoteGenre.fromJson(data);

    final List<String> downvote = <String>[...genreChart.downvote]
      ..remove(authUser);
    final VoteGenre resChart = VoteGenre(
      genre: genre,
      downvote: downvote,
      upvote: <String>[authUser, ...genreChart.upvote],
    );
    await doc.set(resChart.toJson());
    return resChart;
  }

  Future<VoteGenre> downVoteGenreChart(String genre, String artistId) async {
    final String? authUser = _firebaseAuth.currentUser?.uid;

    if (authUser == null) {
      throw const AppException.notSignedIn();
    }

    final DocumentReference<Map<String, dynamic>> doc = _firebaseFirestore
        .collection(artistChartCollectionName)
        .doc(artistId)
        .collection(voteCollectionName)
        .doc(genre);

    final Map<String, dynamic>? data = (await doc.get()).data();

    if (data == null) {
      final VoteGenre genreChart = VoteGenre(
        genre: genre,
        downvote: <String>[authUser],
      );
      await doc.set(genreChart.toJson());
      return genreChart;
    }

    final VoteGenre genreChart = VoteGenre.fromJson(data);

    final List<String> upvote = <String>[...genreChart.upvote]
      ..remove(authUser);
    final VoteGenre resChart = VoteGenre(
      genre: genre,
      upvote: upvote,
      downvote: <String>[authUser, ...genreChart.downvote],
    );
    await doc.set(resChart.toJson());
    return resChart;
  }

  Future<VoteGenre> removeVoteGenreChart(String genre, String artistId) async {
    final String? authUser = _firebaseAuth.currentUser?.uid;

    if (authUser == null) {
      throw const AppException.notSignedIn();
    }

    final DocumentReference<Map<String, dynamic>> doc = _firebaseFirestore
        .collection(artistChartCollectionName)
        .doc(artistId)
        .collection(voteCollectionName)
        .doc(genre);

    final Map<String, dynamic>? data = (await doc.get()).data();

    if (data == null) {
      final VoteGenre genreChart = VoteGenre(genre: genre);
      await doc.set(genreChart.toJson());
      return genreChart;
    }

    final VoteGenre genreChart = VoteGenre.fromJson(data);

    final List<String> upvote = <String>[...genreChart.upvote]
      ..remove(authUser);
    final List<String> downvote = <String>[...genreChart.downvote]
      ..remove(authUser);
    final VoteGenre resChart = VoteGenre(
      genre: genre,
      upvote: upvote,
      downvote: downvote,
    );
    await doc.set(resChart.toJson());
    return resChart;
  }
}
