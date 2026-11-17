import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/artists/artist.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/badge.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/api/rebelation_api/rebelation_api_client.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/local.swipes.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/swipe_card_data/swipe_card_data_models.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/repositories/recommendation_artist_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/add_artist.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/add_like.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/create_collection.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/edit_artist_in_collections.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_reports.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_subgenre.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_all_artist_likes.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_like.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/start_trial.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/streak.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/update_subgenre.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/badges/badges_enum.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'swipe_songs_page_state.dart';

const String defaultCollectionName = 'Favorites';

enum CardStatus {
  like,
  dislike,
}

@injectable
class SwipeSongsPageCubit extends BaseCubit<SwipeSongsPageState> {
  SwipeSongsPageCubit(
    this.rebelationApiService,
    this.localAppInfoDataSource,
    this.addLikeUseCase,
    this.createCollectionUseCase,
    this.updateSubgenreUseCase,
    this.addArtistUseCase,
    this.localSwipesDataSource,
    this.getSubgenreUseCase,
    this.getGenresUseCase,
    this.getTotalGenreSubgenreUseCase,
    this.removeAllLikeUseCase,
    this.generateGenresReports,
    this.getUsersReportUseCase,
    this.streakUseCase,
    this.startTrialUseCase,
    this.removeLikeUseCase,
    this.editArtistInCollectionUseCase,
  ) : super(const SwipeSongsPageState());

  static SwipeSongsPageCubit create() {
    return GetIt.I<SwipeSongsPageCubit>()..init();
  }

  final LocalAppInfoDataSource localAppInfoDataSource;
  final AddLikeUseCase addLikeUseCase;
  final CreateCollectionUseCase createCollectionUseCase;
  final UpdateSubgenreUseCase updateSubgenreUseCase;
  final AddArtistUseCase addArtistUseCase;
  final LocalSwipesDataSource localSwipesDataSource;
  final GetGenresUseCase getGenresUseCase;
  final GetSubgenreUseCase getSubgenreUseCase;
  final RecommendationArtistService rebelationApiService;
  final RemoveAllArtistLikesUseCase removeAllLikeUseCase;
  final GetTotalGenreSubgenreUseCase getTotalGenreSubgenreUseCase;
  final GenerateGenresReports generateGenresReports;
  final GetUsersReportUseCase getUsersReportUseCase;
  final StreakUseCase streakUseCase;
  final StartTrialUseCase startTrialUseCase;
  final RemoveLikeUseCase removeLikeUseCase;
  final EditArtistInCollectionUseCase editArtistInCollectionUseCase;

  Future<void> init([String? sub]) async {
    await performSafeAction(() async {
      if (isClosed) return;

      final String subgenre = sub ?? localAppInfoDataSource.getSubgenre();
      await isTrialOrSubscriptionActive;
      emit(
        state.copyWith(
          status: SongsPageStatus.loading,
          showTutorial: !localAppInfoDataSource.getShownSwipeWalkthrough(),
        ),
      );

      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      final List<ArtistCollectionDto>? artistCollections =
          user?.collections.map((Map<String, dynamic> item) {
        return ArtistCollectionDto.fromJson(item);
      }).toList();
      final bool? firstLiked = user?.likes.isEmpty;

      if (firstLiked ?? true) {
        final Iterable<ArtistCollectionDto>? favoriteCollections =
            artistCollections?.where((ArtistCollectionDto collection) {
          return collection.name == defaultCollectionName;
        });

        if (favoriteCollections?.isEmpty ?? true) {
          await createCollectionUseCase(defaultCollectionName);
          artistCollections?.add(
            const ArtistCollectionDto(
              name: defaultCollectionName,
            ),
          );
        }
      }

      final ArtistsListDto artists = await rebelationApiService.getArtists(
        subgenre,
        <String>[...user?.likes ?? <String>[], ...user?.skips ?? <String>[]],
      );

      unawaited(
        getIt<TrackAudioPlayerCubit>().playTrack(
          artists.artists.firstOrNull,
          reset: false,
        ),
      );

      if (isClosed) return;

      emit(
        state.copyWith(
          status: SongsPageStatus.initial,
          artists: artists.artists.artistsWithSwipeCardDataType(
            state.isTrialOrSubscriptionActive,
          ),
          last: artists.last,
          deletedArtists: <ArtistChartDto>[],
          subgenre: sub,
          artistCollections: artistCollections,
        ),
      );
    });
  }

  Future<void> getNextTrack(
    Size screenSize, {
    required bool liked,
    List<String> collections = const <String>[],
  }) async {
    await performSafeAction(() async {
      final Offset offset = Offset(2 * screenSize.width, 0);

      emit(
        state.copyWith(
          position: liked ? state.position + offset : state.position - offset,
        ),
      );

      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user?.swipesCount == 0) {
        unawaited(
          FirebaseAnalytics.instance.logEvent(name: 'swiped_1x'),
        );
        if (!kIsWeb) unawaited(FacebookAppEvents().logEvent(name: 'swiped_1x'));
      } else if (user?.swipesCount == 9) {
        unawaited(
          FirebaseAnalytics.instance.logEvent(name: 'swiped_10x'),
        );
        if (!kIsWeb) {
          unawaited(FacebookAppEvents().logEvent(name: 'swiped_10x'));
        }
      } else if (user?.swipesCount == 49) {
        unawaited(
          FirebaseAnalytics.instance.logEvent(name: 'swiped_50x'),
        );
        if (!kIsWeb) {
          unawaited(FacebookAppEvents().logEvent(name: 'swiped_50x'));
        }
      } else if (user?.swipesCount == 99) {
        unawaited(
          FirebaseAnalytics.instance.logEvent(name: 'swiped_100x'),
        );
        if (!kIsWeb) {
          unawaited(FacebookAppEvents().logEvent(name: 'swiped_100x'));
        }
      }

      await localSwipesDataSource.addSwipe(streakUseCase.call, emitStreak);
      final ArtistChartDto lastArtist = state.artists.first;

      final Map<String, Object> parameters = <String, Object>{
        'timeStamp': DateTime.now().toUtc().toString(),
        'user': user?.toEmailJson().toString() ?? '',
        'artistName': lastArtist.name,
        'subgenre': state.subgenre,
        'save': liked.toString(),
        'skip': (!liked).toString(),
      };
      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'swipe',
          parameters: parameters,
        ),
      );
      if (!kIsWeb) {
        unawaited(
          FacebookAppEvents().logEvent(name: 'swipe', parameters: parameters),
        );
      }

      final List<ArtistChartDto> deletedArtists = <ArtistChartDto>[
        lastArtist,
        ...state.deletedArtists
      ];
      final List<ArtistChartDto> artists = <ArtistChartDto>[...state.artists]
        ..removeAt(0);

      if (artists.firstOrNull?.id != StringsRes.premiumAdsId &&
          artists.firstOrNull?.id != StringsRes.productAdId) {
        unawaited(
          getIt<TrackAudioPlayerCubit>().playTrack(
            artists.firstOrNull,
            reset: false,
          ),
        );
      }

      emit(
        state.copyWith(
          status: SongsPageStatus.initial,
          artists: artists,
        ),
      );

      resetPosition();

      final Object? badge = await updateSubgenreUseCase(like: liked);
      if (liked) {
        await addLikeUseCase(lastArtist.id, collections);
      } else {
        await addArtistUseCase(lastArtist);
      }
      if (badge is BadgeDto && badge.type == BadgesType.golden) {
        emit(
          state.copyWith(
            status: SongsPageStatus.showBadge,
            badgeDto: badge,
          ),
        );
      }

      ///Showing [LevelDialog]
      if (badge is GenreSubgenresTotal) {
        emit(
          state.copyWith(
            status: SongsPageStatus.showLevel,
            total: badge,
          ),
        );
      }

      emit(
        state.copyWith(
          deletedArtists: deletedArtists,
        ),
      );
    });
  }

  void emitStreak(int streak) {
    emit(
      state.copyWith(
        status: SongsPageStatus.showStreak,
        streak: streak,
      ),
    );
  }

  Future<void> addArtistInCollections(
    List<String> collections,
    Size screenSize,
  ) async {
    if (collections.isEmpty) {
      await getNextTrack(screenSize, liked: true);
      return;
    }

    await performSafeAction(() async {
      await getNextTrack(screenSize, liked: true, collections: collections);
    });
  }

  Future<void> setNewCollections(List<String> collections) async {
    emit(state.copyWith(newCollections: collections));
  }

  Future<void> backToArtists() async {
    await performSafeAction(() async {
      if (isClosed) return;
      if (state.deletedArtists.isEmpty) return;
      emit(state.copyWith(status: SongsPageStatus.loading));

      final List<ArtistChartDto> deletedArtists = state.deletedArtists;

      final List<ArtistChartDto> artists = state.artists;
      final ArtistChartDto artist = deletedArtists.first;

      artists.insert(0, artist);
      deletedArtists.removeAt(0);
      await getIt<TrackAudioPlayerCubit>().playTrack(
        artists.firstOrNull,
        reset: false,
      );

      await removeAllLikeUseCase(artist);

      emit(
        state.copyWith(
          status: SongsPageStatus.initial,
          artists: artists,
          deletedArtists: deletedArtists,
        ),
      );
    });
  }

  void startPosition(DragStartDetails details) {
    emit(state.copyWith(dragging: true));
  }

  void updatePosition(DragUpdateDetails details, Size screenSize) {
    final Offset position = state.position + details.delta;
    emit(state.copyWith(position: position));
  }

  void setSwipeCardType({
    required String cardId,
    required String productLink,
    required String productEventName,
  }) {
    if (cardId == StringsRes.premiumAdsId) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'trial_30_day_card_impression',
        parameters: <String, Object>{
          'source_page': 'Swipe Page',
        },
      ));
      emit(state.copyWith(swipeCardViewType: SwipeCardViewType.premium));
    } else if (cardId == StringsRes.productAdId) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: '${productEventName}_card_impression',
        parameters: <String, Object>{
          'source_page': 'Swipe Page',
        },
      ));
      emit(state.copyWith(
        swipeCardViewType: SwipeCardViewType.product,
        productLink: productLink,
        productEventName: productEventName,
      ));
    } else if (cardId == StringsRes.nativeAdItemId) {
      emit(state.copyWith(swipeCardViewType: SwipeCardViewType.ads));
    } else {
      emit(state.copyWith(swipeCardViewType: SwipeCardViewType.artist));
    }
  }

  //Todo(Issa): Need to check the logic here
  Future<void> startAnimation(Size screenSize) async {
    if (state.artists.isEmpty) return;

    final Offset position = state.position + const Offset(20, 0);
    await Future<void>.delayed(const Duration(milliseconds: 400), () {
      emit(
        state.copyWith(
          position: position,
        ),
      );
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 400),
      resetPosition,
    );

    final Offset position2 = state.position + const Offset(-20, 0);
    await Future<void>.delayed(const Duration(milliseconds: 400), () {
      emit(
        state.copyWith(
          position: position2,
        ),
      );
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 400),
      resetPosition,
    );
  }

  Future<void> endPosition(
      Size screenSize, List<String> artistSubgenres) async {
    emit(state.copyWith(dragging: false));

    final CardStatus? status = getStatus();
    switch (status) {
      case CardStatus.like:
        if (state.showTutorial) {
          await localAppInfoDataSource.showSwipeWalkthrough();
          emit(state.copyWith(showTutorial: false));
        }
        if (state.swipeCardViewType == SwipeCardViewType.premium) {
          //Note: Need to call [getNextTrack()] before calling Subscription dialog, to avoid components freezing.
          await getNextTrack(screenSize, liked: false);
          await startTrialOrPremium();
        } else if (state.swipeCardViewType == SwipeCardViewType.product) {
          await getNextTrack(screenSize, liked: false);
          await goToProductStore(state.productLink, state.productEventName);
        } else if (state.swipeCardViewType == SwipeCardViewType.artist) {
          await getNextTrack(screenSize, liked: true);
        }
      case CardStatus.dislike:
        await getNextTrack(screenSize, liked: false);

      case null:
        resetPosition();
    }
    await _updateUserSubgenres(artistSubgenres);
  }

  Future<void> likeTheArtist(
      Size screenSize, List<String> artistSubgenres) async {
    await getNextTrack(screenSize, liked: true);

    if (state.swipeCardViewType == SwipeCardViewType.product) {
      await goToProductStore(state.productLink, state.productEventName);
    } else {
      await _updateUserSubgenres(artistSubgenres);
    }

  }

  Future<void> _updateUserSubgenres(List<String> artistSubgenres) async {
    final UserModel? user = getIt<UserModelStream>().model;
    if (user != null) {
      await getIt<UserModelStream>().updateSaveUserModel(
        user.update(
          unlockedSubgenres: <String>{
            ...user.unlockedSubgenres.where((String s) => s.isNotEmpty),
            ...artistSubgenres.where((String s) => s.isNotEmpty),
          }.toList(),
        ),
      );
    }
  }

  CardStatus? getStatus() {
    if (state.position.dx >= 100) {
      return CardStatus.like;
    }
    if (state.position.dx <= -100) {
      return CardStatus.dislike;
    }
    return null;
  }

  void resetPosition() {
    if (isClosed) return;

    emit(state.copyWith(position: Offset.zero));
  }

  Future<void> get isTrialOrSubscriptionActive async {
    final bool isActive = await getIt<PurchasesCat>().isActiveOffer();

    if (isActive && state.artists.contains(premiumAdCard)) {
      emit(state.copyWith(artists: state.artists.artistsWithOutPremiumOffer));
    }
    emit(state.copyWith(isTrialOrSubscriptionActive: isActive));
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: SongsPageStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }

  Future<void> updateArtistsInfo() async {
    final List<Genre> genres = await getGenresUseCase();

    for (final Genre genre in genres) {
      final List<Subgenre> subgenres = await getIt<GetGenreSubgenreUseCase>()
          .call(genre.name, updateInfo: true);

      for (final Subgenre subgenre in subgenres) {
        final List<Artist> artists =
            await getIt<RebelationApiClient>().getArtists(subgenre.name);

        for (int i = 0; i < artists.length; i++) {
          final Artist a = artists[i];
          if (a.id.toString().isNotEmpty) {
            await getIt<RemoteArtistChartDataSource>().updateArtistChartBio(
              a,
              <String>[subgenre.name],
            );
          }
        }
        log('set $subgenre');
      }
    }
    log('end');
  }

  bool containsGenre(List<GenreSubgenresTotal> genres, String sub) {
    for (final GenreSubgenresTotal g in genres) {
      for (final SubgenreLiked s in g.subgenres) {
        if (s.subGenre == sub) return true;
      }
    }

    return false;
  }

  Future<void> startTrialOrPremium() async {
    if (!kIsWeb) {
      await performSafeAction(() async {
        unawaited(FirebaseAnalytics.instance.logEvent(
          name: 'trial_30_day_card_click',
          parameters: <String, Object>{
            'source_page': 'Swipe Page',
          },
        ));

        await getIt<PurchasesCat>().getOfferAndShowDialog();
        await getIt<PurchasesCat>()
            .isActiveOffer()
            .then((bool isActiveOffer) async {
          if (isActiveOffer) {
            unawaited(FirebaseAnalytics.instance.logEvent(
              name: 'trial_30_day_card_converted',
              parameters: <String, Object>{
                'source_page': 'Swipe Page',
              },
            ));

            emit(state.copyWith(
              artists: state.artists.artistsWithOutPremiumOffer,
              isTrialOrSubscriptionActive: isActiveOffer,
            ));
            await startTrialUseCase();
            //Todo(Issa): Need to show tool tip when the User got the premium account
          }
        });
      });
    }
  }

  Future<void> goToProductStore(
      String storeLink, String productEventName) async {
    if (await canLaunchUrl(Uri.parse(storeLink))) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: '${productEventName}_card_click',
        parameters: <String, Object>{
          'source_page': 'Swipe Page',
        },
      ));
      await launchUrlString(storeLink);
    } else {
      debugPrint("Could not open product page.");
    }
  }

  Future<void> editArtistCollections(
    ArtistChartDto artist,
    List<String> collections,
    Size screenSize,
  ) async {
    await performSafeAction(() async {
      await editArtistInCollectionUseCase(artist, collections);
      await getNextTrack(screenSize, liked: true);
    });
  }

  Future<void> likeArtist(
    ArtistChartDto artist,
    List<String> collections,
    Size screenSize,
  ) async {
    await performSafeAction(() async {
      await addLikeUseCase(artist.id, collections);
      await getNextTrack(screenSize, liked: true);
    });
  }

  Future<void> unlikeArtist(ArtistChartDto artist, Size screenSize) async {
    await performSafeAction(() async {
      await removeLikeUseCase(artist, null);
      await getNextTrack(screenSize, liked: false);
    });
  }
}
