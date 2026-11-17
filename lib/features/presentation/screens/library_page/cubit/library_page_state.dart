part of 'library_page_cubit.dart';

enum LibraryTabStatus {
  initial,
  error,
  loading,
}

@immutable
class LibraryPageState extends Equatable {
  const LibraryPageState({
    this.status = LibraryTabStatus.loading,
    this.errorMessage = '',
    this.collections = const <ArtistCollectionDto>[],
    this.likedArtist = const <ArtistChartDto>[],
    this.user,
    this.genres = const <TotalLibraryGenreDto>[],
    this.showMyCollection = false,
    this.currentCollection = '',
    this.isExploreLibraryTaskCompleted = false,
    this.isTrialOrSubscriptionActive = false,
  });

  final LibraryTabStatus status;
  final String errorMessage;
  final List<ArtistChartDto> likedArtist;
  final List<ArtistCollectionDto> collections;
  final UserModel? user;
  final List<TotalLibraryGenreDto> genres;
  final bool showMyCollection;
  final String currentCollection;
  final bool isExploreLibraryTaskCompleted;
  final bool isTrialOrSubscriptionActive;

  LibraryPageState copyWith({
    LibraryTabStatus? status,
    String? errorMessage,
    List<ArtistChartDto>? likedArtist,
    List<ArtistCollectionDto>? collections,
    UserModel? user,
    List<TotalLibraryGenreDto>? genres,
    bool? showMyCollection,
    String? currentCollection,
    bool? isExploreLibraryTaskCompleted,
    bool? isTrialOrSubscriptionActive,
  }) {
    return LibraryPageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      likedArtist: likedArtist ?? this.likedArtist,
      collections: collections ?? this.collections,
      user: user ?? this.user,
      genres: genres ?? this.genres,
      showMyCollection: showMyCollection ?? this.showMyCollection,
      currentCollection: currentCollection ?? this.currentCollection,
      isExploreLibraryTaskCompleted:
          isExploreLibraryTaskCompleted ?? this.isExploreLibraryTaskCompleted,
      isTrialOrSubscriptionActive:
          isTrialOrSubscriptionActive ?? this.isTrialOrSubscriptionActive,
    );
  }

  @override
  List<Object?> get props {
    return <Object?>[
      status,
      errorMessage,
      likedArtist,
      collections,
      user,
      genres,
      showMyCollection,
      currentCollection,
      isExploreLibraryTaskCompleted,
      isTrialOrSubscriptionActive,
    ];
  }
}

class TotalLibraryGenreDto {
  const TotalLibraryGenreDto({
    required this.genre,
    required this.totalSubgenres,
    required this.likesCount,
  });

  final String genre;
  final List<SubgenresArtistsDto> totalSubgenres;
  final int likesCount;
}

class SubgenresArtistsDto {
  const SubgenresArtistsDto({
    required this.artists,
    required this.subgenreLiked,
  });

  final SubgenreLiked subgenreLiked;
  final List<ArtistChartDto> artists;
}
