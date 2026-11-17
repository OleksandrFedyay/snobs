import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/single_artist/single_artist_view.dart';
import 'package:kingfishertom/features/widgets/carusel_artist_dialog/carusel_artist_dialog.dart';

void showArtistDialog(
  BuildContext context,
  ArtistChartDto? artist,
  TracksAudioPlayerState state,
  TrackAudioPlayerCubit cubit,
  Function(String genre, String subgenre) exploreSubgenre,
) {
  if (artist == null) return;

  showDialog<void>(
    context: context,
    builder: (_) {
      return CarouselArtistDialog(
        onPageChanged: (_) {},
        initialIndex: 0,
        artists: <Widget>[
          SingleArtistView(
            artist: artist,
            exploreSubgenre: exploreSubgenre,
            showCollectionButton: false,
            like: state.user?.likes.contains(artist.id) ?? false,
            collections:
                state.user?.collections.map((Map<String, dynamic> item) {
                      return ArtistCollectionDto.fromJson(item);
                    }).toList() ??
                    <ArtistCollectionDto>[],
            unlikeArtist: () => cubit.unlikeArtist(artist),
            editArtistInCollections: (List<String> collect) {
              cubit.editArtistCollections(
                artist,
                collect,
              );
            },
            addArtistInCollections: (List<String> collect) {
              cubit.addArtistToLiked(
                artist,
                collect,
              );
            },
          ),
        ],
      );
    },
  ).then((_) async {
    if (state.playerType == PlayerType.radio) {
      cubit.setIsRadioInfoTracks(false);
      await cubit.removeRadioInfoTracks();
    }
  });
}
