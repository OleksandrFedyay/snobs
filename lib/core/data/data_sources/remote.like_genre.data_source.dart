import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_subgenres.dart';
import 'package:kingfishertom/core/data/api/models/dtos/genre.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/genres.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/dtos/user_subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/domain/exception/app.exception.dart';

const String likeGenreCollectionName = 'like_genre';
const String artistSubgenresCollectionName = 'artist_subgenres';
const String _genreCollectionName = 'genres';

@lazySingleton
class RemoteLikeGenreDataSource {
  RemoteLikeGenreDataSource(
    this._firebaseFireStore,
    this._firebaseAuth,
    this._remoteUserDataSource,
  );

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFireStore;
  final RemoteUserDataSource _remoteUserDataSource;

  Future<List<SubgenreLiked>> getLikeGenreDto() async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) throw const AppException.notSignedIn();

    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(likeGenreCollectionName)
        .get();

    return res.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> badge) {
      return SubgenreLiked.fromJson(badge.data());
    }).toList();
  }

  Future<List<SubgenreLiked>> getUserLikeGenreDto(String id) async {
    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFireStore
        .collection(userCollectionName)
        .doc(id)
        .collection(likeGenreCollectionName)
        .get();

    return res.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> badge) {
      return SubgenreLiked.fromJson(badge.data());
    }).toList();
  }

  Future<SubgenreLiked> updateLikeGenre(
    String subgenre, {
    required bool like,
  }) async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) throw const AppException.notSignedIn();

    final DocumentReference<Map<String, dynamic>> doc = _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(likeGenreCollectionName)
        .doc(subgenre);

    SubgenreLiked subgenreLiked = SubgenreLiked.fromJson(
      (await doc.get()).data() ?? <String, dynamic>{},
    );

    if (like) {
      subgenreLiked = subgenreLiked.copyWith(
        likes: subgenreLiked.likes + 1,
        subGenre: subgenre,
      );
    } else {
      subgenreLiked = subgenreLiked.copyWith(
        unlikes: subgenreLiked.unlikes + 1,
        subGenre: subgenre,
      );
    }

    await doc.set(subgenreLiked.toJson());
    return subgenreLiked;
  }

  Future<List<String>> getSubgenres(String genre) async {
    if (genre.isEmpty) return <String>[];

    final DocumentSnapshot<Map<String, dynamic>> res = await _firebaseFireStore
        .collection(_genreCollectionName)
        .doc(genre)
        .get();

    final GenreDto genreDto =
        GenreDto.fromJson(res.data() ?? <String, dynamic>{});

    if (!genreDto.enabled) return <String>[];

    return genreDto.subgenres;
  }

  Future<List<GenresDto>> getGenres() async {
    final List<GenresDto> genres = <GenresDto>[];

    final QuerySnapshot<Map<String, dynamic>> res =
        await _firebaseFireStore.collection(_genreCollectionName).get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in res.docs) {
      genres.add(GenresDto(
        genre: doc.id,
        subgenres: GenresDto.fromJson(doc.data()).subgenres,
      ));
    }

    return genres;
  }

  ///Returns record which contains List of users of the type [UserModel]
  ///and List of subgenreLiked of the type [SubgenreLiked]
  //Todo(Issa): Need Pagination system to load more method for [SubgenrePageCubit]
  Future<(List<UserModel>, List<SubgenreLiked>)> getSnobSubgenreTopUsers(
    String subgenre,
  ) async {
    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFireStore
        .collectionGroup(likeGenreCollectionName)
        .where('genre', isEqualTo: subgenre)
        .orderBy('likes')
        .limit(30)
        .get();

    final List<UserModel> users = <UserModel>[];
    final List<SubgenreLiked> subgenreLikedList = <SubgenreLiked>[];

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in res.docs) {
      final List<String> paths = doc.reference.path.split('/');
      if (paths.length < 3) continue;

      final UserModel? user = await _remoteUserDataSource.getUserById(paths[1]);
      if (user == null) continue;
      if (user.imageUrl == null && user.name == null) continue;
      users.add(
        user,
      );
      subgenreLikedList.add(
        SubgenreLiked.fromJson(doc.data()),
      );

      if (users.length >= 20) return (users, subgenreLikedList);
    }

    return (users, subgenreLikedList);
  }

  Future<List<UserSubgenreLiked>> getUsersGenreChart() async {
    final QuerySnapshot<Map<String, dynamic>> res =
        await _firebaseFireStore.collectionGroup(likeGenreCollectionName).get();

    return res.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> badge) {
      final List<String> paths = badge.reference.path.split('/');
      if (paths.length < 3) return UserSubgenreLiked.fromJson(badge.data());

      return UserSubgenreLiked.fromJson(badge.data()).copyWith(
        userId: paths[1],
      );
    }).toList();
  }

  ///
  /// User's Genres Overrides
  ///

  Future<List<ArtistSubgenres>> getArtistsOverrides() async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) throw const AppException.notSignedIn();

    final QuerySnapshot<Map<String, dynamic>> res = await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(artistSubgenresCollectionName)
        .get();

    return res.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
            ArtistSubgenres.fromJson(doc.data()))
        .toList();
  }

  Future<ArtistSubgenres?> getArtistSubgenres(String artistId) async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) throw const AppException.notSignedIn();

    final DocumentSnapshot<Map<String, dynamic>> res = await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(artistSubgenresCollectionName)
        .doc(artistId)
        .get();

    final Map<String, dynamic>? data = res.data();
    if (data == null) return null;

    return ArtistSubgenres.fromJson(data);
  }

  Future<void> updateArtistSubgenres(
    String artistId,
    List<String> subgenres,
  ) async {
    final User? authUser = _firebaseAuth.currentUser;

    if (authUser == null) throw const AppException.notSignedIn();

    await _firebaseFireStore
        .collection(userCollectionName)
        .doc(authUser.uid)
        .collection(artistSubgenresCollectionName)
        .doc(artistId)
        .set(
          ArtistSubgenres(
            artistId: artistId,
            subgenres: subgenres,
          ).toJson(),
        );
  }
}
