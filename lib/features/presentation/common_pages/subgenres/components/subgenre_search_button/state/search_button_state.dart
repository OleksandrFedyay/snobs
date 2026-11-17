part of 'search_button_cubit.dart';

sealed class SearchFieldState extends Equatable {
  const SearchFieldState();
}

final class SearchFieldLoadingState extends SearchFieldState {
  const SearchFieldLoadingState();

  @override
  List<Object?> get props => <Object?>[];
}

final class SearchFieldForMyLikedSongs extends SearchFieldState {
  const SearchFieldForMyLikedSongs();

  @override
  List<Object?> get props => <Object?>[];
}

final class SearchFieldForGlobalChartsSong extends SearchFieldState {
  const SearchFieldForGlobalChartsSong();

  @override
  List<Object?> get props => <Object?>[];
}

final class SearchFieldForMyLikedArtists extends SearchFieldState {
  const SearchFieldForMyLikedArtists();

  @override
  List<Object?> get props => <Object?>[];
}

final class SearchFieldForArtistGlobalCharts extends SearchFieldState {
  const SearchFieldForArtistGlobalCharts();

  @override
  List<Object?> get props => <Object?>[];
}

final class SearchFieldForTopSnobsState extends SearchFieldState {
  const SearchFieldForTopSnobsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class SearchFieldErrorState extends SearchFieldState {
  const SearchFieldErrorState({
    required this.error,
  });

  final String? error;

  @override
  List<Object?> get props => <Object?>[error];
}
