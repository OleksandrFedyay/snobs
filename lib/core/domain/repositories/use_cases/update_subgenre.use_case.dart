import 'dart:async';

import 'package:collection/collection.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/badge.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/data_sources/remote.badge.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.like_genre.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/local.genres_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/complete_task.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/badges/badges_enum.dart';

@injectable
class UpdateSubgenreUseCase extends BaseExceptionService {
  UpdateSubgenreUseCase(
    this.likeGenreDataSource,
    this.localAppInfoDataSource,
    this.remoteBadgeDataSource,
    this._localGenresInfoDataSourceImpl,
    this._remoteUserDataSource,
    this._completeTaskUseCase,
  );

  final RemoteLikeGenreDataSource likeGenreDataSource;
  final LocalAppInfoDataSource localAppInfoDataSource;
  final RemoteBadgeDataSource remoteBadgeDataSource;
  final LocalGenresInfoDataSourceImpl _localGenresInfoDataSourceImpl;
  final RemoteUserDataSource _remoteUserDataSource;
  final CompleteTaskUseCase _completeTaskUseCase;

  Future<Object?> call({required bool like}) async {
    return makeErrorParsedCall(() async {
      BadgeDto? badge;
      final String genre = localAppInfoDataSource.getGenre();
      String subgenre = localAppInfoDataSource.getSubgenre();

      if (subgenre.isEmpty) subgenre = '&$genre';
      final SubgenreLiked subgenreLiked =
          await likeGenreDataSource.updateLikeGenre(
        subgenre,
        like: like,
      );

      final List<SubgenreLiked> subgenres =
          _localGenresInfoDataSourceImpl.getSubgenres()
            ..removeWhere((SubgenreLiked sub) => sub.subGenre == subgenre)
            ..add(subgenreLiked);
      await _localGenresInfoDataSourceImpl.setSubgenre(subgenres);

      if (!subgenre.contains('&')) {
        for (final BadgesType b in BadgesType.values) {
          if (b.getNumber() == (subgenreLiked.likes + subgenreLiked.unlikes) &&
              (subgenreLiked.likes != 0 || subgenreLiked.unlikes != 0)) {
            badge = BadgeDto(subgenre: subgenre, type: b);
            final Iterable<BadgeDto> badges =
                (await remoteBadgeDataSource.createBadge(badge))
                    .where((BadgeDto b) => b.type == BadgesType.golden);

            if (badges.length == 3) {
              await _completeTaskUseCase('earn3subgenrebadges');
            } else if (badges.length == 10) {
              await _completeTaskUseCase('earn10subgenrebadges');
            } else if (badges.length == 7) {
              await _completeTaskUseCase('earn7subgenrebadges');
            } else if (badges.length == 1) {
              await _completeTaskUseCase('earnsubgenrebadge');
            }
          }
        }
      }

      final Iterable<SubgenreLiked> exploredSubgenres =
          subgenres.where((SubgenreLiked g) => g.likes + g.unlikes > 10);
      if (exploredSubgenres.length == 10) {
        await _completeTaskUseCase('explore10subgenres');
      } else if (exploredSubgenres.length == 50) {
        await _completeTaskUseCase('explore50subgenres');
      } else if (exploredSubgenres.length == 100) {
        await _completeTaskUseCase('explore100subgenres');
      } else if (exploredSubgenres.length == 30) {
        await _completeTaskUseCase('explore30subgenres');
      }

      final List<String> subgenresList =
          _localGenresInfoDataSourceImpl.getSubgenresByGenre(genre);

      final SubgenreLiked? allGenre =
          subgenres.firstWhereOrNull((SubgenreLiked s) => s.subGenre == '&$genre');
      final GenreSubgenresTotal total = GenreSubgenresTotal(
        genre: genre,
        totalSubgenres: <SubgenreLiked>[
          ...subgenresList.map((String g) {
            return subgenres.where((SubgenreLiked sub) {
                  return sub.subGenre == g;
                }).firstOrNull ??
                SubgenreLiked(subGenre: g);
          }),
          if (allGenre != null) allGenre,
        ],
      );

      final int swipesCount = total.swipesCount;
      if (total.roundSwipes() && swipesCount != 0) {
        final String eventName = 'level_${total.genre}_${total.level}';
        unawaited(FirebaseAnalytics.instance.logEvent(name: eventName));
        if (!kIsWeb) unawaited(FacebookAppEvents().logEvent(name: eventName));

        if (swipesCount == 300) {
          await _completeTaskUseCase('reachgenrelevel6');
        } else if (swipesCount == 20) {
          await _completeTaskUseCase('reachgenrelevel2');
        } else if (swipesCount == 720) {
          await _completeTaskUseCase('reachgenrelevel9');
        } else if (swipesCount == 900) {
          await _completeTaskUseCase('reachgenrelevel10');
        } else if (swipesCount == 120) {
          await _completeTaskUseCase('reachgenrelevel4');
        }

        return total;
      }
      if (badge != null) return badge;
      return null;
    });
  }
}
