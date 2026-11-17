import 'dart:async';

import 'package:collection/collection.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/badge.dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/badges/badges_dialog.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/streak_dialog.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/cubit/swipe_songs_page_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artist_collection_view.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artists_card/artists_card.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/level_dialog.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vibration/vibration.dart';

class SwipeSongsPage extends StatefulWidget {
  const SwipeSongsPage({
    required this.currentGenre,
    required this.subGenre,
    required this.onSelectGenre,
    required this.exploreSubgenre,
    required this.user,
    super.key,
  });

  final String currentGenre;
  final String subGenre;
  final VoidCallback onSelectGenre;
  final UserModel? user;
  final Function(String genre, String subgenre) exploreSubgenre;

  @override
  State<SwipeSongsPage> createState() => _SwipeSongsPageState();
}

class _SwipeSongsPageState extends State<SwipeSongsPage> {
  SwipeSongsPageCubit _getCubit(BuildContext context) => context.read();

  @override
  Future<void> didChangeDependencies() async {
    final SwipeSongsPageCubit cubit = _getCubit(context);
    final Size size = MediaQuery.of(context).size;

    if (cubit.state.subgenre != widget.subGenre) {
      await cubit.init(widget.subGenre);
    }
    if (cubit.state.swipeCardViewType == SwipeCardViewType.artist) {
      unawaited(cubit.startAnimation(size));
    }
    cubit.isTrialOrSubscriptionActive;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SwipeSongsPageCubit, SwipeSongsPageState>(
      listener: _onStateChanged,
      listenWhen: (SwipeSongsPageState previous, SwipeSongsPageState current) =>
          previous.status != current.status,
      builder: (BuildContext context, SwipeSongsPageState state) {
        if (state.status == SongsPageStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return _artistView(context, state);
      },
    );
  }

  Widget _artistView(BuildContext context, SwipeSongsPageState state) {
    final Size size = MediaQuery.of(context).size;

    return state.artists.isEmpty && widget.subGenre.isNotEmpty
        ? _emptyView(context)
        : ArtistsCard(
            artists: state.artists.reversed.toList(),
            exploreSubgenre: widget.exploreSubgenre,
            isTrailSubscription: widget.user?.daysLeft == null,
            onOrganizeArtistTap: (ArtistChartDto artist) async {
              final SwipeSongsPageCubit cubit = _getCubit(context);

              final ArtistChartDto? artist = state.artists.firstOrNull;
              if (artist == null) return;

              await showMaterialModalBottomSheet<void>(
                context: context,
                barrierColor: lightColorScheme.surfaceContainerHighest
                    .withValues(alpha: .5),
                backgroundColor: Colors.transparent,
                builder: (_) => ArtistCollectionView(
                  artist: artist,
                  artistCollections: state.artistCollections,
                  initialArtistCollections: state.newCollections,
                  onEnd: (List<String> collections) async {
                    Navigator.of(context).pop();

                    await cubit.addArtistInCollections(collections, size);
                  },
                ),
              );
            },
          );
  }

  Widget _emptyView(BuildContext context) {
    unawaited(
      FirebaseAnalytics.instance.logEvent(
        name: 'no_artists_left_${widget.currentGenre.toLowerCase()}',
      ),
    );
    if (!kIsWeb) {
      unawaited(
        FacebookAppEvents().logEvent(
          name: 'no_artists_left_${widget.currentGenre.toLowerCase()}',
        ),
      );
    }
    return Dialog(
      backgroundColor: lightColorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.all(24),
      child: ClipRRect(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                context.i10n.noArtistsLeft(
                  widget.subGenre.isEmpty
                      ? '${context.i10n.all} ${widget.currentGenre.toTitleCase()}'
                      : widget.subGenre.toTitleCase(),
                ),
                style: context.textStyle.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                context.i10n.switchGenreToContinueExploring,
                style: context.textStyle.bodyLarge,
              ),
              const SizedBox(height: 20),
              AppButton(
                style: AppThemeModel.instance.getWelcomeButtonTheme().style,
                onPressed: () {
                  widget.onSelectGenre();
                },
                withArrow: false,
                text: context.i10n.switchGenre.toUpperCase(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant SwipeSongsPage oldWidget) {
    if (widget.subGenre != oldWidget.subGenre ||
        widget.currentGenre != oldWidget.currentGenre) {
      _getCubit(context).init(widget.subGenre);
    }

    super.didUpdateWidget(oldWidget);
  }

  Future<void> _onStateChanged(
    BuildContext context,
    SwipeSongsPageState state,
  ) async {
    switch (state.status) {
      case SongsPageStatus.error:
        state.errorMessage.showSnackBarInfo;
      case SongsPageStatus.showBadge:
        final BadgeDto? badge = state.badgeDto;
        if (badge != null) {
          if (await Vibration.hasVibrator()) {
            unawaited(Vibration.vibrate());
          }

          if (!context.mounted) return;

          BadgesDialog.showDialog(
            context,
            badge,
            widget.currentGenre,
          );
        }

      case SongsPageStatus.showLevel:
        final GenreSubgenresTotal? total = state.total;
        if (total != null) {
          if (await Vibration.hasVibrator()) {
            unawaited(Vibration.vibrate());
          }

          if (!context.mounted) return;
          LevelDialog.showModalDialog(
            context,
            total,
          );
        }

      case SongsPageStatus.showStreak:
        StreakDialog.showStreakDialog(context, state.streak);

      case SongsPageStatus.initial:
      case SongsPageStatus.loading:
    }
  }
}
