part of 'subgenre_liked_songs_cubit.dart';

sealed class SubgenreLikedSongsState extends Equatable {
  const SubgenreLikedSongsState();
}

final class SubgenreLikedSongsContentData extends SubgenreLikedSongsState {
  const SubgenreLikedSongsContentData({
    this.likedSongs = const <Track>[],
    this.currentArtist = '',
    this.searchedLikedSongs,
    this.subgenre = '',
  });

  final List<Track> likedSongs;
  final String currentArtist;
  final List<Track>? searchedLikedSongs;
  final String subgenre;

  @override
  List<Object?> get props => <Object?>[
        likedSongs,
        currentArtist,
        searchedLikedSongs,
        subgenre,
      ];
}

final class SubgenreLikedSongsContentLoading extends SubgenreLikedSongsState {
  @override
  List<Object?> get props => <Object?>[];
}

final class SubgenreLikedSongsContentError extends SubgenreLikedSongsState {
  const SubgenreLikedSongsContentError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => <Object?>[errorMessage];
}
