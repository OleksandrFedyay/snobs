import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_subgenres.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_artist/cubit/subgenre_liked_artist_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/single_artist/single_artist_view.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/components/artist_tile.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:kingfishertom/features/widgets/carusel_artist_dialog/carusel_artist_dialog.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

///TODO logic of the selection should be fixed. Long press activates selection, but there is no any logic to deactivate this actions.
///TODO implement logic that enables sorted artists content not changing after selection.
class SubgenreLikedArtist extends StatelessWidget {
  const SubgenreLikedArtist({
    super.key,
    required this.genre,
    required this.exploreSubgenre,
  });

  final String genre;
  final Function(String genre, String subgenre) exploreSubgenre;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubgenreLikedArtistCubit, SubgenreLikedArtistState>(
      listener: (BuildContext context, SubgenreLikedArtistState state) {
        if (state
            case SubgenreMyLikedArtistContentError(
              :final String errorMessage
            )) {
          showSuccessSnackBar(context, errorMessage);
        }
      },
      builder: (BuildContext context, SubgenreLikedArtistState state) {
        switch (state) {
          case SubgenreMyLikedArtistContentLoading():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SubgenreMyLikedArtistContentError():
            return const SizedBox.shrink();
          case SubgenreMyLikedArtistContentData(
              :final List<ArtistChartDto> artists,
              :final bool update,
              :final List<ArtistChartDto> selectedArtists,
              :final List<ArtistSubgenres> overrides,
              :final String subgenre,
              :final String currentArtist,
              :final UserModel? user,
              :final List<ArtistChartDto>? searchedMyLikedArtists,
            ):
            return artists.isEmpty
                ? _noItems(context, subgenre)
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Column(
                      children: <Widget>[
                        if (searchedMyLikedArtists == null)
                          for (int i = 0; i < artists.length; i++)
                            GestureDetector(
                              onTapCancel: () => context
                                  .read<SubgenrePageCubit>()
                                  .setUpdate(update: false),
                              onLongPress: () => context
                                  .read<SubgenrePageCubit>()
                                  .setUpdate(update: true),
                              onTap: () {
                                if (update) {
                                  if (selectedArtists.contains(artists[i])) {
                                    context
                                        .read<SubgenrePageCubit>()
                                        .unselectArtist(artists[i]);
                                  } else {
                                    context
                                        .read<SubgenrePageCubit>()
                                        .selectArtist(artists[i]);
                                  }

                                  return;
                                }

                                showDialog<void>(
                                  context: context,
                                  builder: (_) {
                                    return CarouselArtistDialog(
                                      onPageChanged: (int index) {
                                        context
                                            .read<TrackAudioPlayerCubit>()
                                            .playTrack(
                                              artists[index],
                                              fullSong: true,
                                            );
                                      },
                                      initialIndex: i,
                                      artists: artists.map((ArtistChartDto a) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: SingleArtistView(
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
                                              context
                                                  .read<SubgenrePageCubit>()
                                                  .unlikeArtist(a);
                                            },
                                            editArtistInCollections:
                                                (List<String> collect) {
                                              context
                                                  .read<SubgenrePageCubit>()
                                                  .editArtistCollections(
                                                      a, collect);
                                            },
                                            addArtistInCollections:
                                                (List<String> collect) {
                                              context
                                                  .read<SubgenrePageCubit>()
                                                  .addArtistToLiked(a, collect);
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                );
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                children: <Widget>[
                                  if (update) ...<Widget>[
                                    if (selectedArtists.contains(artists[i]))
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: lightColorScheme.yellow,
                                        size: 24,
                                      )
                                    else
                                      const Icon(
                                        Icons.circle_outlined,
                                        color: Colors.white54,
                                        size: 24,
                                      ),
                                    const SizedBox(width: 16),
                                  ],
                                  Expanded(
                                    child: ArtistTile(
                                      onDelete: () {
                                        final List<String> subgenres =
                                            (overrides
                                                    .firstWhereOrNull(
                                                      (ArtistSubgenres o) =>
                                                          o.artistId ==
                                                          artists[i].id,
                                                    )
                                                    ?.subgenres ??
                                                artists[i].subgenres)
                                              ..remove(subgenre);

                                        context
                                            .read<SubgenrePageCubit>()
                                            .updateArtistOverrides(
                                              artists[i],
                                              subgenres,
                                            );
                                      },
                                      artist: artists[i],
                                      active: artists[i].id == currentArtist,
                                      setArtistCurrent: context
                                          .read<SubgenrePageCubit>()
                                          .setCurrentArtist,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        const SizedBox(height: 40),
                        if (searchedMyLikedArtists != null &&
                            searchedMyLikedArtists.isEmpty)
                          Center(
                            child: Text(context.i10n.noResult),
                          ),
                        if (searchedMyLikedArtists != null &&
                            searchedMyLikedArtists.isNotEmpty)
                          for (int i = 0;
                              i < searchedMyLikedArtists.length;
                              i++)
                            GestureDetector(
                              onLongPress: () => context
                                  .read<SubgenrePageCubit>()
                                  .setUpdate(update: true),
                              onTap: () {
                                if (update) {
                                  if (selectedArtists
                                      .contains(searchedMyLikedArtists[i])) {
                                    context
                                        .read<SubgenrePageCubit>()
                                        .unselectArtist(
                                            searchedMyLikedArtists[i]);
                                  } else {
                                    context
                                        .read<SubgenrePageCubit>()
                                        .selectArtist(
                                            searchedMyLikedArtists[i]);
                                  }

                                  return;
                                }

                                showDialog<void>(
                                  context: context,
                                  builder: (_) {
                                    return CarouselArtistDialog(
                                      onPageChanged: (int index) {
                                        context
                                            .read<TrackAudioPlayerCubit>()
                                            .playTrack(
                                              searchedMyLikedArtists[index],
                                              fullSong: true,
                                            );
                                      },
                                      initialIndex: i,
                                      artists: searchedMyLikedArtists
                                          .map((ArtistChartDto a) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: SingleArtistView(
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
                                              context
                                                  .read<SubgenrePageCubit>()
                                                  .unlikeArtist(a);
                                            },
                                            editArtistInCollections:
                                                (List<String> collect) {
                                              context
                                                  .read<SubgenrePageCubit>()
                                                  .editArtistCollections(
                                                      a, collect);
                                            },
                                            addArtistInCollections:
                                                (List<String> collect) {
                                              context
                                                  .read<SubgenrePageCubit>()
                                                  .addArtistToLiked(a, collect);
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                );
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                children: <Widget>[
                                  if (update) ...<Widget>[
                                    if (selectedArtists
                                        .contains(searchedMyLikedArtists[i]))
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: lightColorScheme.yellow,
                                        size: 24,
                                      )
                                    else
                                      const Icon(
                                        Icons.circle_outlined,
                                        color: Colors.white54,
                                        size: 24,
                                      ),
                                    const SizedBox(width: 16),
                                  ],
                                  Expanded(
                                    child: ArtistTile(
                                      onDelete: () {
                                        final List<
                                            String> subgenres = (overrides
                                                .firstWhereOrNull(
                                                  (ArtistSubgenres o) =>
                                                      o.artistId ==
                                                      searchedMyLikedArtists[i]
                                                          .id,
                                                )
                                                ?.subgenres ??
                                            searchedMyLikedArtists[i].subgenres)
                                          ..remove(subgenre);

                                        context
                                            .read<SubgenrePageCubit>()
                                            .updateArtistOverrides(
                                              searchedMyLikedArtists[i],
                                              subgenres,
                                            );
                                      },
                                      artist: searchedMyLikedArtists[i],
                                      active: searchedMyLikedArtists[i].id ==
                                          currentArtist,
                                      setArtistCurrent: context
                                          .read<SubgenrePageCubit>()
                                          .setCurrentArtist,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
        }
      },
    );
  }

  Widget _noItems(BuildContext context, String subgenre) => Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 186,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 48),
          decoration: BoxDecoration(
            border: Border.all(
              color: lightColorScheme.backgroundGrey,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                context.i10n.noLikedArtists(subgenre.toTitleCase()),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: FontFamily.nunitoSans,
                ),
              ),
              Text(
                context.i10n.visitSwipePageExploreArtists,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontFamily: FontFamily.nunitoSans,
                ),
              ),
              OutlinedButton(
                onPressed: () => exploreSubgenre(genre, subgenre),
                style: OutlinedButton.styleFrom(
                  backgroundColor: lightColorScheme.yellowLight,
                  padding: EdgeInsets.zero,
                  fixedSize: const Size(
                    280,
                    60,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  side: const BorderSide(color: Colors.transparent),
                ),
                child: Text(
                  context.i10n.exploreArtists.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: lightColorScheme.fieldText,
                    fontFamily: FontFamily.nunitoSans,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
