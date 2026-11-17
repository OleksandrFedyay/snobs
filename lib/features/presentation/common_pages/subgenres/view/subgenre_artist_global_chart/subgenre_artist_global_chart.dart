import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_artist_global_chart/cubit/subgenre_artist_global_chart_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/single_artist/single_artist_view.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/components/artist_chart_tile.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:kingfishertom/features/widgets/carusel_artist_dialog/carusel_artist_dialog.dart';

///Artists global charts
class SubgenreArtistGlobalChart extends StatelessWidget {
  const SubgenreArtistGlobalChart({
    required this.exploreSubgenre,
    super.key,
  });

  final Function(String genre, String subgenre) exploreSubgenre;

  SubgenrePageCubit _getCubit(BuildContext context) => context.read();

  bool _artistsContainsId(List<ArtistChartDto> artists, String id) {
    for (final ArtistChartDto a in artists) {
      if (a.id == id) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubgenreArtistGlobalChartCubit,
        SubgenreArtistGlobalChartState>(
      listener: (BuildContext context, SubgenreArtistGlobalChartState state) {
        if (state
            case SubgenreArtistGlobalChartContentError(
              :final String errorMessage
            )) {
          showSuccessSnackBar(context, errorMessage);
        }
      },
      builder: (BuildContext context, SubgenreArtistGlobalChartState state) {
        switch (state) {
          case SubgenreArtistGlobalChartLoading():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SubgenreArtistGlobalChartContentError():
            return const SizedBox.shrink();
          case SubgenreArtistGlobalChartContentData(
              :final List<ArtistChartDto> artistsChart,
              :final List<Track> likedSongs,
              :final UserModel? user,
              :final List<ArtistChartDto> artists,
              :final List<ArtistChartDto>? searchedArtistChart,
            ):
            return artistsChart.isEmpty
                ? Center(
                    child: Text(
                      context.i10n.noItems,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          if (searchedArtistChart == null)
                            for (int i = 0; i < artistsChart.length; i++)
                              ArtistChartTile(
                                index: i,
                                useHeart: likedSongs.fold(
                                      false,
                                      (bool value, Track track) {
                                        return value ||
                                            track.artists.contains(
                                              int.tryParse(artistsChart[i].id),
                                            );
                                      },
                                    ) ||
                                    _artistsContainsId(
                                        artists, artistsChart[i].id),
                                chart: artistsChart[i],
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return CarouselArtistDialog(
                                        onPageChanged: (int index) {
                                          context
                                              .read<TrackAudioPlayerCubit>()
                                              .playTrack(
                                                artistsChart[index],
                                                fullSong: true,
                                              );
                                        },
                                        initialIndex: i,
                                        artists: artistsChart
                                            .map((ArtistChartDto a) {
                                          return SingleArtistView(
                                            artist: a,
                                            exploreSubgenre: exploreSubgenre,
                                            showCollectionButton: false,
                                            like: user?.likes.contains(a.id) ??
                                                false,
                                            collections: user?.collections.map(
                                                    (Map<String, dynamic>
                                                        item) {
                                                  return ArtistCollectionDto
                                                      .fromJson(
                                                    item,
                                                  );
                                                }).toList() ??
                                                <ArtistCollectionDto>[],
                                            unlikeArtist: () {
                                              _getCubit(context)
                                                  .unlikeArtist(a);
                                            },
                                            editArtistInCollections:
                                                (List<String> collect) {
                                              _getCubit(context)
                                                  .editArtistCollections(
                                                      a, collect);
                                            },
                                            addArtistInCollections:
                                                (List<String> collect) {
                                              _getCubit(context)
                                                  .addArtistToLiked(a, collect);
                                            },
                                          );
                                        }).toList(),
                                      );
                                    },
                                  );
                                },
                              ),
                          if (searchedArtistChart != null &&
                              searchedArtistChart.isEmpty)
                            Center(
                              child: Text(context.i10n.noResult),
                            ),
                          if (searchedArtistChart != null &&
                              searchedArtistChart.isNotEmpty)
                            for (int i = 0; i < searchedArtistChart.length; i++)
                              ArtistChartTile(
                                index: i,
                                useHeart: likedSongs.fold(
                                      false,
                                      (bool value, Track track) {
                                        return value ||
                                            track.artists.contains(
                                              int.tryParse(
                                                  searchedArtistChart[i].id),
                                            );
                                      },
                                    ) ||
                                    _artistsContainsId(
                                      artists,
                                      searchedArtistChart[i].id,
                                    ),
                                chart: searchedArtistChart[i],
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return CarouselArtistDialog(
                                        onPageChanged: (int index) {
                                          context
                                              .read<TrackAudioPlayerCubit>()
                                              .playTrack(
                                                searchedArtistChart[index],
                                                fullSong: true,
                                              );
                                        },
                                        initialIndex: i,
                                        artists: searchedArtistChart
                                            .map((ArtistChartDto a) {
                                          return SingleArtistView(
                                            artist: a,
                                            exploreSubgenre: exploreSubgenre,
                                            showCollectionButton: false,
                                            like: user?.likes.contains(a.id) ??
                                                false,
                                            collections: user?.collections.map(
                                                    (Map<String, dynamic>
                                                        item) {
                                                  return ArtistCollectionDto
                                                      .fromJson(
                                                    item,
                                                  );
                                                }).toList() ??
                                                <ArtistCollectionDto>[],
                                            unlikeArtist: () {
                                              _getCubit(context)
                                                  .unlikeArtist(a);
                                            },
                                            editArtistInCollections:
                                                (List<String> collect) {
                                              _getCubit(context)
                                                  .editArtistCollections(
                                                      a, collect);
                                            },
                                            addArtistInCollections:
                                                (List<String> collect) {
                                              _getCubit(context)
                                                  .addArtistToLiked(a, collect);
                                            },
                                          );
                                        }).toList(),
                                      );
                                    },
                                  );
                                },
                              ),
                        ],
                      ),
                    ),
                  );
        }
      },
    );
  }
}
