import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/genres.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/dtos/vote_genre.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.like_genre.data_source.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_subgenre.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user_by_id.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/user_overrides.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/vote_genre.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

part 'genres_state.dart';

@injectable
class GenresCubit extends BaseCubit<GenresState> {
  GenresCubit(
    this._getGenresUseCase,
    this._getTotalGenreSubgenreUseCase,
    this._getSubgenreUseCase,
    this._getVotesUseCase,
    this.downvoteGenreUseCase,
    this.upvoteGenreUseCase,
    this._firebaseAuth,
    this._userOverridesUseCase,
    this._updateUserOverridesUseCase,
    this._removeVoteGenreUseCase,
    this._getUserByIdUseCase,
  ) : super(const GenresState());

  static GenresCubit create() {
    return GetIt.I<GenresCubit>();
  }

  final GetGenresUseCase _getGenresUseCase;
  final GetSubgenreUseCase _getSubgenreUseCase;
  final UpvoteGenreUseCase upvoteGenreUseCase;
  final DownvoteGenreUseCase downvoteGenreUseCase;
  final FirebaseAuth _firebaseAuth;
  final GetVotesUseCase _getVotesUseCase;
  final GetTotalGenreSubgenreUseCase _getTotalGenreSubgenreUseCase;
  final UserOverridesUseCase _userOverridesUseCase;
  final UpdateUserOverridesUseCase _updateUserOverridesUseCase;
  final RemoveVoteGenreUseCase _removeVoteGenreUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;

  Future<void> init(List<String> subgenres, String artistId) async {
    await performSafeAction(() async {
      if (isClosed) return;
      emit(state.copyWith(status: GenresStatus.loading));

      final List<Genre> listOfGenres = await _getGenresUseCase();
      final List<String> genresName =
          listOfGenres.map((Genre e) => e.name).toList();
      final List<SubgenreLiked> subs = await _getSubgenreUseCase();

      final List<GenreSubgenresTotal> totalGenres =
          await _getTotalGenreSubgenreUseCase(genresName, subs);

      ///To create the genre colors when creating buildSubgenre, after DataBase migration with the remaining Subgenres, need to remove it
      final List<GenresDto> subgenresOfGenre =
          await getIt<RemoteLikeGenreDataSource>().getGenres();

      final List<VoteGenre> votes = await _getVotesUseCase(artistId);
      final List<String> userSubgenres =
          (await _userOverridesUseCase(artistId))?.subgenres ?? subgenres;

      final List<VoteGenre> res = userSubgenres.map((String e) {
        final VoteGenre? vote =
            votes.firstWhereOrNull((VoteGenre v) => v.genre == e);
        if (vote != null) {
          return vote;
        }

        return VoteGenre(genre: e);
      }).toList();

      final String? userId = _firebaseAuth.currentUser?.uid;
      if (isClosed) return;
      emit(
        state.copyWith(
          artistSubgenres: subgenres,
          status: GenresStatus.initial,
          userId: userId,
          user: await _getUserByIdUseCase(userId),
          genreSubgenres: totalGenres,
          votes: res,
          allVotes: res,
          subgenres: userSubgenres,
          filterdVotes: res,
          subgenresOfGenre: subgenresOfGenre,
        ),
      );
    });
  }

  void search(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(filterdVotes: state.votes));
      return;
    }

    final Iterable<VoteGenre> votes = state.votes.where((VoteGenre v) {
      return v.genre.contains(value.toLowerCase());
    });

    emit(state.copyWith(filterdVotes: votes.toList()));
  }

  void setSearch({required bool search}) {
    emit(state.copyWith(search: search));
  }

  void setQuery(String query) {
    emit(state.copyWith(query: query));
  }

  Future<void> upvote(VoteGenre genre, ArtistChartDto artist) async {
    await performSafeAction(() async {
      if (genre.upvote.contains(state.userId)) {
        await removeVote(genre, artist);
        return;
      }
      final VoteGenre updatedGenre = await upvoteGenreUseCase(
        genre.genre,
        artist,
      );

      final int index = state.votes.indexOf(genre);
      if (index == -1) return;

      final List<VoteGenre> genres = <VoteGenre>[...state.votes]..replaceRange(
          index,
          index + 1,
          <VoteGenre>[updatedGenre],
        );

      emit(
        state.copyWith(
          status: GenresStatus.initial,
          votes: genres,
          filterdVotes: genres,
        ),
      );
    });
  }

  Future<void> downvote(VoteGenre genre, ArtistChartDto artist) async {
    await performSafeAction(() async {
      if (genre.downvote.contains(state.userId)) {
        await removeVote(genre, artist);
        return;
      }
      final VoteGenre updatedGenre = await downvoteGenreUseCase(
        genre.genre,
        artist,
      );

      final int index = state.votes.indexOf(genre);
      if (index == -1) return;

      final List<VoteGenre> genres = <VoteGenre>[...state.votes]..replaceRange(
          index,
          index + 1,
          <VoteGenre>[updatedGenre],
        );

      emit(
        state.copyWith(
          status: GenresStatus.initial,
          votes: genres,
          filterdVotes: genres,
        ),
      );
    });
  }

  Future<void> removeVote(VoteGenre genre, ArtistChartDto artist) async {
    await performSafeAction(() async {
      final VoteGenre updatedGenre = await _removeVoteGenreUseCase(
        genre.genre,
        artist,
      );

      final int index = state.votes.indexOf(genre);
      if (index == -1) return;

      final List<VoteGenre> genres = <VoteGenre>[...state.votes]..replaceRange(
          index,
          index + 1,
          <VoteGenre>[updatedGenre],
        );

      emit(
        state.copyWith(
          status: GenresStatus.initial,
          votes: genres,
          filterdVotes: genres,
        ),
      );
    });
  }

  Future<void> updateSubgenres(
    ArtistChartDto artist,
    List<String> subgenres, [
    String? addedGenre,
  ]) async {
    await performSafeAction(() async {
      await _updateUserOverridesUseCase(
        artist,
        subgenres,
        addedGenre,
      );
      await refresh(
        subgenres,
        artist.id,
        addedGenre != null ? null : state.allVotes,
      );
    });
  }

  Future<void> refresh(
    List<String> subgenres,
    String artistId,
    List<VoteGenre>? allVotes,
  ) async {
    await performSafeAction(() async {
      if (isClosed) return;

      final List<VoteGenre> votes = await _getVotesUseCase(artistId);

      final List<VoteGenre> res = subgenres.map((String e) {
        final VoteGenre? vote =
            votes.firstWhereOrNull((VoteGenre v) => v.genre == e);
        if (vote != null) {
          return vote;
        }

        return VoteGenre(genre: e);
      }).toList();

      if (isClosed) return;
      emit(
        state.copyWith(
          status: GenresStatus.initial,
          votes: res,
          subgenres: subgenres,
          allVotes: allVotes ?? res,
          filterdVotes: res,
        ),
      );
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: GenresStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
