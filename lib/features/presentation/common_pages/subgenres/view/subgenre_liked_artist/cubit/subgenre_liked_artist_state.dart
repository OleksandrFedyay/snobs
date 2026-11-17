part of 'subgenre_liked_artist_cubit.dart';

sealed class SubgenreLikedArtistState extends Equatable {
  const SubgenreLikedArtistState();
}

final class SubgenreMyLikedArtistContentLoading
    extends SubgenreLikedArtistState {
  const SubgenreMyLikedArtistContentLoading();

  @override
  List<Object?> get props => <Object?>[];
}

final class SubgenreMyLikedArtistContentData extends SubgenreLikedArtistState {
  const SubgenreMyLikedArtistContentData({
    required this.artists,
    required this.update,
    required this.selectedArtists,
    required this.overrides,
    required this.subgenre,
    required this.currentArtist,
    this.user,
    this.searchedMyLikedArtists,
  });

  final List<ArtistChartDto> artists;
  final bool update;
  final List<ArtistChartDto> selectedArtists;
  final UserModel? user;
  final List<ArtistSubgenres> overrides;
  final String subgenre;
  final String currentArtist;
  final List<ArtistChartDto>? searchedMyLikedArtists;

  @override
  List<Object?> get props => <Object?>[
        artists,
        update,
        selectedArtists,
        user,
        overrides,
        subgenre,
        currentArtist,
        searchedMyLikedArtists,
      ];
}

final class SubgenreMyLikedArtistContentError extends SubgenreLikedArtistState {
  const SubgenreMyLikedArtistContentError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => <Object?>[
        errorMessage,
      ];
}
