import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/icons/snobs_icons.dart';
import 'package:kingfishertom/features/widgets/track_progress_indicator.dart';

class ArtistTile extends StatefulWidget {
  const ArtistTile({
    required this.artist,
    required this.active,
    required this.setArtistCurrent,
    this.onDelete,
    this.onLiked,
    super.key,
  });

  final ArtistChartDto artist;
  final bool active;
  final ValueSetter<String> setArtistCurrent;
  final VoidCallback? onDelete;
  final VoidCallback? onLiked;

  @override
  State<ArtistTile> createState() => _ArtistTileState();
}

class _ArtistTileState extends State<ArtistTile> {
  TrackAudioPlayerCubit get _getTrackAudioCubit {
    return GetIt.I.get<TrackAudioPlayerCubit>();
  }

  Future<void> play() async {
    await _getTrackAudioCubit.playTrack(
      widget.artist,
      fullSong: true,
      active: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Slidable(
            key: const ValueKey<String>('Delete'),
            enabled: widget.onDelete != null,
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                onDismissed: () => widget.onDelete?.call(),
              ),
              children: <Widget>[
                SlidableAction(
                  onPressed: (BuildContext context) {
                    widget.onDelete?.call();
                  },
                  backgroundColor: lightColorScheme.surfaceContainerHighest,
                  foregroundColor: Colors.white,
                  label: context.i10n.remove,
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                _buildImage(),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildArtistInfo(context),
                ),
                const SizedBox(width: 16),
                _buildPlayButton(context),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: lightColorScheme.onSecondaryContainer,
          height: 1,
        ),
      ],
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: widget.artist.image,
      width: 80,
      height: 80,
      alignment: Alignment.topCenter,
      maxHeightDiskCache: 240,
      fit: BoxFit.cover,
      errorWidget: (BuildContext context, String error, Object stackTrace) {
        return Container(
          width: 80,
          height: 80,
          color: lightColorScheme.surfaceContainerHighest,
        );
      },
      placeholder: (BuildContext context, String url) {
        return Container(
          width: 80,
          height: 80,
          color: lightColorScheme.surfaceContainerHighest,
        );
      },
    );
  }

  Widget _buildArtistInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.artist.name,
          style: context.textStyle.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          widget.artist.subgenres.map((String s) => s.toTitleCase()).join(', '),
          style: context.textStyle.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    if (widget.onLiked != null) {
      return IconButton(
        onPressed: widget.onLiked,
        icon: const Icon(
          SnobsIcons.heartPlus,
          size: 32,
          color: Colors.white,
        ),
      );
    }
    if (_getTrackAudioCubit.state.active && widget.active) {
      return GestureDetector(
        onTap: () async {
          _getTrackAudioCubit.setActive(value: false);
          setState(() {});
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: lightColorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TrackProgressIndicator(),
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        await play();
        widget.setArtistCurrent(widget.artist.id);
        setState(() {});
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.white70,
          ),
          borderRadius: BorderRadius.circular(52),
        ),
        child: const Icon(
          Icons.play_arrow,
          size: 18,
          color: Colors.white70,
        ),
      ),
    );
  }
}
