part of 'select_genre_cubit.dart';

enum SelectGenreStatus {
  initial,
  error,
  loading,
  success,
}

@immutable
class SelectGenreState extends Equatable {
  const SelectGenreState({
    this.genre = const Genre(
      enabled: true,
      id: 0,
      name: '',
      description: '',
      subgenres: <Subgenre>[],
    ),
    this.status = SelectGenreStatus.loading,
    this.errorMessage = '',
    this.genres = const <Genre>[],
  });

  final SelectGenreStatus status;
  final String errorMessage;
  final Genre genre;
  final List<Genre> genres;

  SelectGenreState copyWith({
    SelectGenreStatus? status,
    String? errorMessage,
    Genre? genre,
    List<Genre>? genres,
  }) {
    return SelectGenreState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      genre: genre ?? this.genre,
      genres: genres ?? this.genres,
    );
  }

  @override
  List<Object> get props => <Object>[status, errorMessage, genre, genres];
}
