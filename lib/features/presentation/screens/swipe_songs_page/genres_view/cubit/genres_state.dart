part of 'genres_cubit.dart';

enum GenresStatus {
  initial,
  error,
  loading,
}

@immutable
class GenresState extends Equatable {
  const GenresState({
    this.status = GenresStatus.loading,
    this.errorMessage = '',
    this.votes = const <VoteGenre>[],
    this.filterdVotes = const <VoteGenre>[],
    this.userId = '',
    this.genreSubgenres = const <GenreSubgenresTotal>[],
    this.subgenres = const <String>[],
    this.allVotes = const <VoteGenre>[],
    this.artistSubgenres = const <String>[],
    this.user,
    this.search = false,
    this.query = '',
    this.subgenresOfGenre = const <GenresDto>[],
  });

  final GenresStatus status;
  final String errorMessage;
  final List<VoteGenre> votes;
  final List<VoteGenre> filterdVotes;
  final String userId;
  final UserModel? user;
  final List<GenreSubgenresTotal> genreSubgenres;
  final List<String> subgenres;
  final List<VoteGenre> allVotes;
  final List<String> artistSubgenres;
  final bool search;
  final String query;

  //Note: Its just need to get the Genres and Subgenres from the FireStore, after migration need to remove it.
  final List<GenresDto> subgenresOfGenre;

  @override
  List<Object?> get props {
    return <Object?>[
      status,
      errorMessage,
      votes,
      filterdVotes,
      userId,
      user,
      genreSubgenres,
      subgenres,
      allVotes,
      artistSubgenres,
      search,
      query,
      subgenresOfGenre,
    ];
  }

  GenresState copyWith({
    GenresStatus? status,
    String? errorMessage,
    List<VoteGenre>? votes,
    List<VoteGenre>? filterdVotes,
    String? userId,
    UserModel? user,
    List<GenreSubgenresTotal>? genreSubgenres,
    List<String>? subgenres,
    List<VoteGenre>? allVotes,
    List<String>? artistSubgenres,
    bool? search,
    String? query,
    List<GenresDto>? subgenresOfGenre,
  }) {
    return GenresState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      votes: votes ?? this.votes,
      filterdVotes: filterdVotes ?? this.filterdVotes,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      genreSubgenres: genreSubgenres ?? this.genreSubgenres,
      subgenres: subgenres ?? this.subgenres,
      allVotes: allVotes ?? this.allVotes,
      artistSubgenres: artistSubgenres ?? this.artistSubgenres,
      search: search ?? this.search,
      query: query ?? this.query,
      subgenresOfGenre: subgenresOfGenre ?? this.subgenresOfGenre,
    );
  }
}
