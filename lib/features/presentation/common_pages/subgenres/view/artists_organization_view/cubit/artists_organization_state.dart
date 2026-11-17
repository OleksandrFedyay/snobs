part of 'artists_organization_cubit.dart';

enum ArtistsOrganizationStatus {
  initial,
  error,
  loading,
  success,
  loadingButton,
}

@immutable
class ArtistsOrganizationState extends Equatable {
  const ArtistsOrganizationState({
    this.status = ArtistsOrganizationStatus.loading,
    this.errorMessage = '',
    this.userId = '',
    this.genreSubgenres = const <GenreSubgenresTotal>[],
    this.subgenres = const <String>[],
    this.artistCollections = const <ArtistCollectionDto>[],
    this.selectedArtistCollections = const <String>[],
    this.query = '',
  });

  final ArtistsOrganizationStatus status;
  final String errorMessage;
  final String userId;
  final List<GenreSubgenresTotal> genreSubgenres;
  final List<String> subgenres;
  final List<ArtistCollectionDto> artistCollections;
  final List<String> selectedArtistCollections;
  final String query;

  ArtistsOrganizationState copyWith({
    ArtistsOrganizationStatus? status,
    String? errorMessage,
    String? userId,
    List<GenreSubgenresTotal>? genreSubgenres,
    List<String>? subgenres,
    List<ArtistCollectionDto>? artistCollections,
    List<String>? selectedArtistCollections,
    String? query,
  }) {
    return ArtistsOrganizationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      userId: userId ?? this.userId,
      genreSubgenres: genreSubgenres ?? this.genreSubgenres,
      subgenres: subgenres ?? this.subgenres,
      artistCollections: artistCollections ?? this.artistCollections,
      selectedArtistCollections:
          selectedArtistCollections ?? this.selectedArtistCollections,
      query: query ?? this.query,
    );
  }

  @override
  List<Object> get props {
    return <Object>[
      status,
      errorMessage,
      userId,
      genreSubgenres,
      subgenres,
      artistCollections,
      selectedArtistCollections,
      query,
    ];
  }
}
