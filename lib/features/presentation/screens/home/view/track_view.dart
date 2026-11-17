import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_app_user_level.use_case.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/music_player.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/radio_music_player.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/rank_dialog.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:kingfishertom/features/widgets/track_progress_indicator.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';

class BottomTrackView extends StatefulWidget {
  const BottomTrackView({
    required this.exploreSubgenre,
    super.key,
  });

  final Function(String genre, String subgenre) exploreSubgenre;

  @override
  BottomTrackViewState createState() => BottomTrackViewState();
}

class BottomTrackViewState extends State<BottomTrackView> {
  bool _isRankDialogShown = false;

  //Todo(Issa): Need to improve [listenWhen], its calling mutable times.
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrackAudioPlayerCubit, TracksAudioPlayerState>(
      listenWhen:
          (TracksAudioPlayerState previous, TracksAudioPlayerState current) {
        if (current.rank != null && current.isNewRankLevel) {
          GetAppUserLevelUseCase.isNewRankLevel = false;
          _showRankDialog(context,
              rankModel: current.rank!, user: current.user);
        }
        return true;
      },
      listener: (BuildContext context, TracksAudioPlayerState state) {
        if (state.error) {
          showSuccessSnackBar(context, context.i10n.somethingWentWrong);
        }
      },
      builder: (BuildContext context, TracksAudioPlayerState state) {
        if (state.artist == null) return const SizedBox.shrink();

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (state.radioStatus == RadioStatus.active) {
              RadioMusicPlayerDialog.showModalDialog(
                context,
                widget.exploreSubgenre,
              );
            } else {
              MusicPlayerDialog.showModalDialog(
                context,
                widget.exploreSubgenre,
              );
            }
          },

          /// Swipe from right to left: Next song
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.velocity.pixelsPerSecond.dx < 0) {
              context.read<TrackAudioPlayerCubit>().audioHandler.skipToNext();
            }
          },
          child: Container(
            color: lightColorScheme.onPrimary,
            height: 68,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: CachedNetworkImage(
                    imageUrl: state.artist?.artUri.toString() ?? '',
                    width: 52,
                    height: 52,
                    maxHeightDiskCache: 160,
                    fit: BoxFit.cover,
                    errorWidget: (BuildContext context, String error,
                        Object stackTrace) {
                      return Container(
                        width: 52,
                        height: 52,
                        color: lightColorScheme.surfaceContainerHighest,
                      );
                    },
                    placeholder: (BuildContext context, String url) {
                      return Container(
                        width: 52,
                        height: 52,
                        color: lightColorScheme.surfaceContainerHighest,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        state.artist?.title ?? '',
                        style: context.textStyle.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.artist?.artist ?? '',
                        style: context.textStyle.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: context.read<TrackAudioPlayerCubit>().setActive,
                  behavior: HitTestBehavior.opaque,
                  child: _buildPlayButton(state),
                ),
                if (state.loadingNext)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 0.7,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayButton(TracksAudioPlayerState state) {
    if (state.radioStatus == RadioStatus.active ||
        state.playerType == PlayerType.radio) {
      return SizedBox(
        width: 64,
        child: state.active
            ? Lottie.asset(
                Assets.anim.radioPauseButton,
                fit: BoxFit.fill,
              )
            : Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Opacity(
                    opacity: 0.3,
                    child: SvgPicture.asset(Assets.icons.sensors),
                  ),
                  Icon(
                    Icons.play_arrow,
                    size: 24,
                    color: lightColorScheme.yellowLight,
                  ),
                ],
              ),
      );
    }
    if (state.active) {
      return Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: lightColorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const TrackProgressIndicator(),
      );
    }
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.white54,
        ),
        borderRadius: BorderRadius.circular(52),
      ),
      child: const Icon(
        Icons.play_arrow,
        size: 24,
        color: Colors.white54,
      ),
    );
  }

  Future<void> _showRankDialog(
    BuildContext context, {
    required LevelDto rankModel,
    required UserModel? user,
  }) async {
    if (user != null && !_isRankDialogShown) {
      _isRankDialogShown = true;
      unawaited(Vibration.vibrate());
      await RankDialog.showModalDialog(
        context,
        rankModel,
        user,
        () => _isRankDialogShown = false,
      );
    }
  }
}
