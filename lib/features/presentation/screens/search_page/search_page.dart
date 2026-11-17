// ignore_for_file: no_wildcard_variable_uses
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback_type.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/feedback_view.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/single_artist/single_artist_view.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/components/artist_tile.dart';
import 'package:kingfishertom/features/presentation/screens/search_page/cubit/search_page_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artist_collection_view.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:kingfishertom/features/widgets/carusel_artist_dialog/carusel_artist_dialog.dart';
import 'package:kingfishertom/features/widgets/search_field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    required this.exploreSubgenre,
    this.subgenre,
    super.key,
  });

  final String? subgenre;
  final Function(String genre, String subgenre) exploreSubgenre;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final PublishSubject<String> _subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    _subject.stream
        .debounce(
            (_) => TimerStream<dynamic>(_, const Duration(milliseconds: 1300)))
        .listen(_getCubit(context).filterArtists);
  }

  SearchPageCubit _getCubit(BuildContext context) => context.read();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchPageCubit, SearchPageState>(
      listener: (BuildContext context, SearchPageState state) {
        if (state.status == SearchStatus.unlikeArtist) {
          showSuccessSnackBar(
            context,
            context.i10n.nameRemovedFromList(
              state.artist?.name ?? '',
              context.i10n.allLiked,
            ),
          );
        }
      },
      builder: (BuildContext context, SearchPageState state) {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  lightColorScheme.primaryContainer.withValues(alpha: .1),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 12),
                      Expanded(
                        child: SearchField(
                          controller: _textEditingController,
                          hintText: state.index == 0
                              ? context.i10n.searchArtists
                              : context.i10n.searchCollections,
                          onChanged: (String value) {
                            _subject.add(value.trim());
                          },
                        ),
                      ),
                      if (state.query.isNotEmpty) ...<Widget>[
                        const SizedBox(width: 12),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _textEditingController.clear();
                            _subject.add('');
                            FocusScope.of(context).unfocus();
                          },
                          child: Text(
                            context.i10n.cancel.toUpperCase(),
                            style: context.textStyle.labelMedium?.copyWith(
                              color: lightColorScheme.yellowLight,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 12),
                    ],
                  ),
                  const SizedBox(height: 24),
                  //Todo(Issa): need to remove [ToggleSwitch], no need plugin, need to create a local widget
                  Align(
                    child: ToggleSwitch(
                      minWidth: 316,
                      minHeight: 36,
                      fontSize: 12,
                      borderWidth: 1,
                      borderColor: <Color>[lightColorScheme.onSurface],
                      initialLabelIndex: state.index,
                      activeBgColor: <Color>[lightColorScheme.yellowLight],
                      activeFgColor: lightColorScheme.fieldText,
                      inactiveBgColor: Colors.transparent,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      labels: <String>[
                        context.i10n.artists,
                        context.i10n.collections,
                      ],
                      onToggle: _getCubit(context).setIndex,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCollectionList(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollectionList(BuildContext context, SearchPageState state) {
    if (state.status == SearchStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.index == 0) {
      final List<ArtistChartDto> artists =
          state.query.isEmpty ? state.likedArtists : state.filteredArtists;

      if (state.query.isNotEmpty && state.filteredArtists.isEmpty) {
        return _buildEmptyView();
      }

      return Expanded(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              context.i10n.showingResults(artists.length),
              style: context.textStyle.bodySmall,
            ),
            for (int i = 0; i < artists.length; i++)
              GestureDetector(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) {
                      return CarouselArtistDialog(
                        onPageChanged: (int index) {
                          context.read<TrackAudioPlayerCubit>().playTrack(
                                artists[index],
                              );
                        },
                        initialIndex: i,
                        artists: artists.map((ArtistChartDto a) {
                          return SingleArtistView(
                            artist: a,
                            exploreSubgenre: widget.exploreSubgenre,
                            like: state.user?.likes.contains(a.id) ?? false,
                            collections: state.user?.collections
                                    .map((Map<String, dynamic> item) {
                                  return ArtistCollectionDto.fromJson(item);
                                }).toList() ??
                                <ArtistCollectionDto>[],
                            showCollectionButton: false,
                            unlikeArtist: () {
                              _getCubit(context).unlikeArtist(a);
                            },
                            editArtistInCollections: (List<String> collect) {
                              _getCubit(context)
                                  .editArtistCollections(a, collect);
                            },
                            addArtistInCollections: (List<String> collect) {
                              _getCubit(context).addArtistToLiked(a, collect);
                            },
                          );
                        }).toList(),
                      );
                    },
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: ArtistTile(
                  onLiked: () async {
                    await showMaterialModalBottomSheet<void>(
                      context: context,
                      barrierColor: lightColorScheme.surfaceContainerHighest
                          .withValues(alpha: .5),
                      backgroundColor: Colors.transparent,
                      builder: (_) => ArtistCollectionView(
                        artist: artists[i],
                        artistCollections: state.user?.collections
                                .map((Map<String, dynamic> item) {
                              return ArtistCollectionDto.fromJson(item);
                            }).toList() ??
                            <ArtistCollectionDto>[],
                        initialArtistCollections: const <String>[],
                        onEnd: (List<String> collections) async {
                          Navigator.of(context).pop();

                          await _getCubit(context).addArtistToLiked(
                            artists[i],
                            collections,
                          );
                        },
                      ),
                    );
                  },
                  artist: artists[i],
                  active: artists[i].id == state.currentArtist,
                  setArtistCurrent: _getCubit(context).setCurrentArtist,
                ),
              ),
          ],
        ),
      );
    }

    final List<GenreSubgenresTotal> genres =
        state.genres.map((GenreSubgenresTotal genre) {
      return genre.copyWith(
        totalSubgenres: genre.subgenres
            .where(
              (SubgenreLiked s) => s.subGenre.contains(state.query),
            )
            .toList()
          ..sort(
              (SubgenreLiked a, SubgenreLiked b) => b.likes.compareTo(a.likes)),
      );
    }).toList();
    final List<ArtistCollectionDto> collections =
        state.user?.collections.map((Map<String, dynamic> item) {
              return ArtistCollectionDto.fromJson(item);
            }).where(
              (ArtistCollectionDto collection) {
                return collection.name.toLowerCase().contains(state.query);
              },
            ).toList() ??
            <ArtistCollectionDto>[]
          ..sort((ArtistCollectionDto a, ArtistCollectionDto b) =>
              b.artists.length.compareTo(a.artists.length));

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            context.i10n.subgenres,
            style: context.textStyle.bodySmall,
          ),
          for (int i = 0; i < genres.length; i++) ...<Widget>[
            for (final SubgenreLiked s in genres[i].subgenres)
              _buildSubgenre(s, genres[i].genre),
          ],
          const SizedBox(height: 32),
          Text(
            context.i10n.collections,
            style: context.textStyle.bodySmall,
          ),
          for (int i = 0; i < collections.length; i++) ...<Widget>[
            _buildCollect(collections[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: lightColorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  context.i10n.areWeMissingArtist,
                  style: context.textStyle.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  context.i10n.letUsKnowAndWeWillLookIntoIt,
                  style: context.textStyle.displaySmall?.copyWith(
                    color: lightColorScheme.greyTextColor,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    showMaterialModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) {
                        return FeedbackView.create(FeedbackType.missingArtist);
                      },
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    context.i10n.sendFeedback.toUpperCase(),
                    style: context.textStyle.titleSmall?.copyWith(
                      color: lightColorScheme.yellowLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubgenre(SubgenreLiked sub, String genre) {
    final GenreEnum g = genre.genreStingToEnum;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        router.pushGenreSubgenresRouteRoute(
          genre,
          sub.subGenre,
          widget.exploreSubgenre,
          GenrePageType.subgenre,
        );
      },
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              g.getGenreIcon(24),
              const SizedBox(width: 24),
              Text(
                sub.subGenre.toTitleCase(),
                style: context.textStyle.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '${sub.likes} ${context.i10n.artists}',
                style: context.textStyle.labelSmall?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white54,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: lightColorScheme.onSecondaryContainer,
          ),
        ],
      ),
    );
  }

  Widget _buildCollect(ArtistCollectionDto collect) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => router.pushMyLikedArtistRoute(
        collect,
        exploreSubgenre: widget.exploreSubgenre,
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(
                collect.name.getCollectionIcon(context),
                color: Colors.white54,
              ),
              const SizedBox(width: 24),
              Text(
                collect.name,
                style: context.textStyle.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '${collect.artists.length} ${context.i10n.artists}',
                style: context.textStyle.labelSmall?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white54,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: lightColorScheme.onSecondaryContainer,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _subject.close();
    super.dispose();
  }
}
