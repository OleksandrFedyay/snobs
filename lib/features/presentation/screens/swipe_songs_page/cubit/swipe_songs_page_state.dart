part of 'swipe_songs_page_cubit.dart';

enum SongsPageStatus {
  initial,
  error,
  loading,
  showBadge,
  showLevel,
  showStreak,
}

enum SwipeCardViewType {
  artist,
  premium,
  product,
  ads,
}

@immutable
class SwipeSongsPageState extends Equatable {
  const SwipeSongsPageState({
    this.status = SongsPageStatus.loading,
    this.errorMessage = '',
    this.dragging = false,
    this.position = Offset.zero,
    this.artists = const <ArtistChartDto>[],
    this.deletedArtists = const <ArtistChartDto>[],
    this.artistCollections = const <ArtistCollectionDto>[],
    this.badgeDto,
    this.total,
    this.showTutorial = false,
    this.subgenre = '',
    this.newCollections = const <String>[],
    this.last = false,
    this.streak = 1,
    this.isTrialOrSubscriptionActive = false,
    this.swipeCardViewType = SwipeCardViewType.artist,
    this.productLink = '',
    this.productEventName = '',
  });

  final SongsPageStatus status;
  final String errorMessage;
  final bool dragging;
  final Offset position;
  final List<ArtistChartDto> artists;
  final List<ArtistChartDto> deletedArtists;
  final List<ArtistCollectionDto> artistCollections;
  final BadgeDto? badgeDto;
  final bool showTutorial;
  final String subgenre;
  final GenreSubgenresTotal? total;
  final List<String> newCollections;
  final bool last;
  final int streak;
  final bool isTrialOrSubscriptionActive;
  final SwipeCardViewType swipeCardViewType;
  final String productLink;
  final String productEventName;

  @override
  List<Object?> get props {
    return <Object?>[
      status,
      errorMessage,
      dragging,
      position,
      artists,
      deletedArtists,
      artistCollections,
      badgeDto,
      showTutorial,
      subgenre,
      total,
      newCollections,
      last,
      streak,
      isTrialOrSubscriptionActive,
      swipeCardViewType,
      productLink,
      productEventName,
    ];
  }

  SwipeSongsPageState copyWith({
    SongsPageStatus? status,
    String? errorMessage,
    bool? dragging,
    Offset? position,
    List<ArtistChartDto>? artists,
    List<ArtistChartDto>? deletedArtists,
    List<ArtistCollectionDto>? artistCollections,
    BadgeDto? badgeDto,
    bool? showTutorial,
    String? subgenre,
    GenreSubgenresTotal? total,
    List<String>? newCollections,
    bool? last,
    int? streak,
    bool? isTrialOrSubscriptionActive,
    SwipeCardViewType? swipeCardViewType,
    String? productLink,
    String? productEventName,
  }) {
    return SwipeSongsPageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      dragging: dragging ?? this.dragging,
      position: position ?? this.position,
      artists: artists ?? this.artists,
      deletedArtists: deletedArtists ?? this.deletedArtists,
      artistCollections: artistCollections ?? this.artistCollections,
      badgeDto: badgeDto ?? this.badgeDto,
      showTutorial: showTutorial ?? this.showTutorial,
      subgenre: subgenre ?? this.subgenre,
      total: total ?? this.total,
      newCollections: newCollections ?? this.newCollections,
      last: last ?? this.last,
      streak: streak ?? this.streak,
      isTrialOrSubscriptionActive:
          isTrialOrSubscriptionActive ?? this.isTrialOrSubscriptionActive,
      swipeCardViewType: swipeCardViewType ?? this.swipeCardViewType,
      productLink: productLink ?? this.productLink,
      productEventName: productEventName ?? this.productEventName,
    );
  }
}
