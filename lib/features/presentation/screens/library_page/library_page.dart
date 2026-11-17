import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/premium/trail_premium_view.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/cubit/library_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/utils/extensions/popular_values.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/user_avatar.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

//Todo(Issa): need to refactor this widget,its too big
class LibraryPage extends StatefulWidget {
  const LibraryPage({
    required this.genre,
    required this.setGenre,
    required this.subgenre,
    required this.setSubgenre,
    required this.height,
    required this.exploreSubgenre,
    super.key,
  });

  final String genre;
  final ValueSetter<String> setGenre;
  final String subgenre;
  final ValueSetter<String> setSubgenre;
  final double height;
  final Function(String genre, String subgenre) exploreSubgenre;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final ScrollController _controller = ScrollController();

  LibraryPageCubit _getCubit(BuildContext context) => context.read();

  void _onStateChanged(BuildContext context, LibraryPageState state) {
    switch (state.status) {
      case LibraryTabStatus.error:
        state.errorMessage.showSnackBarInfo;
      case LibraryTabStatus.initial:
        if (!state.isExploreLibraryTaskCompleted) {
          _getCubit(context).completedExploreLibraryTask();
        }
      case LibraryTabStatus.loading:
    }
  }

  List<String> getActionsCollections(BuildContext context) => <String>[
        context.i10n.wakeup,
        context.i10n.workout,
        context.i10n.travel,
        context.i10n.focus,
        context.i10n.party,
        context.i10n.relax,
      ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryPageCubit, LibraryPageState>(
      listener: _onStateChanged,
      builder: _buildArtistsList,
    );
  }

  Widget _buildArtistsList(BuildContext context, LibraryPageState state) {
    if (state.status == LibraryTabStatus.loading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Text(
            context.i10n.library,
            style: context.textStyle.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: widget.height - 56,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: _buildGenres(state),
              ),
              const SizedBox(width: 16),
              Flexible(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.white12)),
                  ),
                  child: _buildSubgenres(state),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenres(LibraryPageState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: <Widget>[
          /// Random
          CupertinoButton(
            onPressed: () {
              _getCubit(context).setShowMyCollection(showMyCollection: false);
              final TotalLibraryGenreDto genre =
                  state.genres[Random().nextInt(state.genres.length)];
              widget.setGenre(genre.genre);

              final int subgenreInd =
                  Random().nextInt(genre.totalSubgenres.length);
              widget.setSubgenre(
                genre.totalSubgenres[subgenreInd].subgenreLiked.subGenre,
              );
              //Todo(Issa): Need to check why getting error that the Controller not Attached
              _controller.animateTo(
                subgenreInd * 84,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              );
            },
            padding: EdgeInsets.zero,
            child: Container(
              width: 76,
              height: 76,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: lightColorScheme.onSurfaceVariant,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: <Color>[
                      lightColorScheme.onPrimary.withValues(alpha: .9),
                      lightColorScheme.onSurface,
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(Assets.icons.dice, height: 32),
                    const SizedBox(height: 4),
                    Text(
                      context.i10n.random,
                      style: context.textStyle.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// My Collections
          CupertinoButton(
            onPressed: () {
              _getCubit(context).setShowMyCollection(showMyCollection: true);
            },
            padding: EdgeInsets.zero,
            child: Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: <Widget>[
                if (state.showMyCollection)
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomPaint(
                      painter: TrianglePainter(),
                      child: const SizedBox(
                        height: 12,
                        width: 4,
                      ),
                    ),
                  ),
                Container(
                  width: 76,
                  height: 76,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: state.showMyCollection
                        ? Border.all(
                            color: lightColorScheme.yellowLight,
                          )
                        : null,
                    boxShadow: <BoxShadow>[
                      if (state.showMyCollection)
                        BoxShadow(
                          color: lightColorScheme.yellowAccent
                              .withValues(alpha: .06),
                          blurRadius: 12,
                          offset: const Offset(0, 9),
                        ),
                    ],
                    color: lightColorScheme.onPrimary,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: <Color>[
                          lightColorScheme.onPrimary.withValues(alpha: .9),
                          lightColorScheme.onSurface,
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        UserAvatar(
                          user: state.user,
                          fontSize: 16,
                          padding: EdgeInsets.zero,
                          borderColor: lightColorScheme.onSurface,
                          radius: 16,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.i10n.me,
                          style: context.textStyle.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///TODO genres to change ???
          /// Genre Collections
          ...state.genres
              .where((TotalLibraryGenreDto g) => g.totalSubgenres.isNotEmpty)
              .map(
            (TotalLibraryGenreDto g) {
              final GenreEnum genre = g.genre.genreStingToEnum;
              final bool current =
                  widget.genre == g.genre && !state.showMyCollection;

              return CupertinoButton(
                onPressed: () {
                  _getCubit(context)
                      .setShowMyCollection(showMyCollection: false);
                  widget.setGenre(g.genre);
                },
                padding: EdgeInsets.zero,
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    if (current)
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomPaint(
                          painter: TrianglePainter(),
                          child: const SizedBox(
                            height: 12,
                            width: 4,
                          ),
                        ),
                      ),
                    Container(
                      width: 76,
                      height: 76,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: current
                            ? Border.all(
                                color: lightColorScheme.yellowLight,
                              )
                            : null,
                        boxShadow: <BoxShadow>[
                          if (current)
                            BoxShadow(
                              color: lightColorScheme.yellowAccent
                                  .withValues(alpha: .06),
                              blurRadius: 12,
                              offset: const Offset(0, 9),
                            ),
                        ],
                        color: lightColorScheme.onSurface,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: <Color>[
                              ...genre.getColors(.3),
                              lightColorScheme.backgroundGrey.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            genre.getGenreIcon(32, Colors.white54),
                            const SizedBox(height: 4),
                            Text(
                              g.genre.toTitleCase(),
                              style: context.textStyle.labelSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildSubgenres(LibraryPageState state) {
    final TotalLibraryGenreDto? genre = state.genres
        .where((TotalLibraryGenreDto g) => g.genre == widget.genre)
        .firstOrNull;

    /// My Collections
    if (state.showMyCollection) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: <Widget>[
            Text(
              '${state.collections.length + 1} ${context.i10n.collections}',
              style: context.textStyle.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...<ArtistCollectionDto>[
              ArtistCollectionDto(
                name: context.i10n.allLiked,
                artists: state.user?.likes ?? <String>[],
              ),
              ...state.collections.sorted(
                (ArtistCollectionDto a, ArtistCollectionDto b) =>
                    b.artists.length.compareTo(a.artists.length),
              ),
            ].map((ArtistCollectionDto collect) {
              final bool current = state.currentCollection == collect.name;

              final List<String> list = <String>[];
              final List<ArtistChartDto> artists =
                  state.likedArtist.where((ArtistChartDto a) {
                final bool res = collect.artists.contains(a.id);
                if (res) list.addAll(a.subgenres);

                return res;
              }).toList();

              return Row(
                children: <Widget>[
                  Expanded(
                    child: IgnorePointer(
                      ignoring: collect.artists.isEmpty,
                      child: Opacity(
                        opacity: collect.artists.isEmpty ? 0.4 : 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            unawaited(
                              _getCubit(context)
                                  .setCurrentCollection(collect.name),
                            );

                            await router.pushMyLikedArtistRoute(
                              collect,
                              exploreSubgenre: widget.exploreSubgenre,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: current
                                  ? Border.all(
                                      color: lightColorScheme.yellowLight,
                                    )
                                  : null,
                              boxShadow: <BoxShadow>[
                                if (current)
                                  BoxShadow(
                                    color: lightColorScheme.yellowAccent
                                        .withValues(alpha: .06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 9),
                                  ),
                              ],
                              color: lightColorScheme.onSurface,
                            ),
                            child: Container(
                              height: 60,
                              padding:
                                  const EdgeInsets.only(left: 12, right: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: <Color>[
                                    lightColorScheme.darkBackground
                                        .withValues(alpha: .5),
                                    lightColorScheme.onSurface
                                        .withValues(alpha: .5),
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        collect.name,
                                        style: context.textStyle.bodyMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.favorite,
                                            color: lightColorScheme.tertiary,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${collect.artists.length}',
                                            style: context.textStyle.labelSmall
                                                ?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    ignoring: collect.artists.isEmpty,
                    child: Opacity(
                      opacity: collect.artists.isEmpty ? 0.4 : 1,
                      child: _buildRadio(artists, () {
                        _getCubit(context).setCurrentCollection(collect.name);
                      }, list.mostPopularItems().toList(), collect.name),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 60),
          ],
        ),
      );
    }

    final List<SubgenresArtistsDto> subgenres =
        genre?.totalSubgenres ?? <SubgenresArtistsDto>[];

    final List<ArtistChartDto> genreArtists = <ArtistChartDto>{
      for (final SubgenresArtistsDto s in subgenres) ...s.artists
    }.toList();

    //   final bool premium = state.isTrialOrSubscriptionActive;

    /// Genre Collections
    return ListView(
      controller: _controller,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 17),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
          child: Text(
            genre?.genre.toTitleCase() ?? '',
            style: context.textStyle.headlineMedium,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,

                ///Navigates to Genres
                onTap: () async {
                  final LibraryPageCubit cubit = _getCubit(context);

                  widget.setSubgenre('');
                  await router.pushGenreSubgenresRouteRoute(
                    genre?.genre ?? '',
                    '',
                    widget.exploreSubgenre,
                    GenrePageType.genre,
                  );

                  await cubit.update();
                },
                child: Container(
                  key: UniqueKey(),
                  height: 60,
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: '&${genre?.genre}' == widget.subgenre
                          ? lightColorScheme.yellowLight
                          : Colors.white12,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${context.i10n.all} ${genre?.genre.toTitleCase() ?? ''}',
                            style: context.textStyle.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.favorite,
                                color: lightColorScheme.tertiary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${genre?.likesCount}',
                                style: context.textStyle.labelSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildRadio(
              genreArtists.toList(),
              () => widget.setSubgenre('&${genre?.genre}'),
              genre?.totalSubgenres
                      .map((SubgenresArtistsDto s) => s.subgenreLiked.subGenre)
                      .toList() ??
                  <String>[],
              genre?.genre ?? '',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
          child: Text(
            context.i10n.subgenres,
            style: context.textStyle.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        ...subgenres.map(
          (SubgenresArtistsDto sub) {
            final bool current = sub.subgenreLiked.subGenre == widget.subgenre;
            return _buildSubgenre(current, sub, genre);
          },
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildSubgenre(
    bool current,
    SubgenresArtistsDto sub,
    TotalLibraryGenreDto? genre,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final LibraryPageCubit cubit = _getCubit(context);

              widget.setSubgenre(sub.subgenreLiked.subGenre);
              await router.pushGenreSubgenresRouteRoute(
                genre?.genre ?? '',
                sub.subgenreLiked.subGenre,
                widget.exploreSubgenre,
                GenrePageType.subgenre,
              );

              await cubit.update();
            },
            child: Container(
              key: UniqueKey(),
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: current
                    ? Border.all(
                        color: lightColorScheme.yellowLight,
                      )
                    : null,
                boxShadow: <BoxShadow>[
                  if (current)
                    BoxShadow(
                      color:
                          lightColorScheme.yellowAccent.withValues(alpha: .06),
                      blurRadius: 12,
                      offset: const Offset(0, 9),
                    ),
                ],
                color: lightColorScheme.onSurface,
              ),
              child: Container(
                height: 60,
                padding: const EdgeInsets.only(left: 12, right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: <Color>[
                      ...widget.genre.genreStingToEnum.getColors(.3),
                      lightColorScheme.backgroundGrey.withValues(alpha: 0.5),
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      sub.subgenreLiked.subGenre.toTitleCase(),
                      style: context.textStyle.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: lightColorScheme.tertiary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${sub.artists.length}',
                          style: context.textStyle.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildRadio(
          sub.artists.toList(),
          () => widget.setSubgenre(sub.subgenreLiked.subGenre),
          <String>[sub.subgenreLiked.subGenre],
          genre?.genre ?? '',
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<TrackAudioPlayerCubit>().isTrialOrSubscriptionActive;
    context.read<LibraryPageCubit>().isTrialOrSubscriptionActive;
  }

  Widget _buildRadio(
    List<ArtistChartDto> artists,
    VoidCallback setActive,
    List<String> subgenres,
    String genre,
  ) {
    return SizedBox(
      width: 60,
      child: BlocBuilder<TrackAudioPlayerCubit, TracksAudioPlayerState>(
        builder: (BuildContext context, TracksAudioPlayerState state) {
          if (!state.isTrialOrSubscriptionActive) {
            return Center(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  unawaited(FirebaseAnalytics.instance.logEvent(
                    name: 'trial_30_day_library_impression',
                    parameters: <String, Object>{
                      'source_page': StringsRes.libraryPage,
                    },
                  ));
                  TrailPremiumViewDialog.showDialog(
                    context: context,
                    isTrail: state.user?.daysLeft == null,
                    pageName: StringsRes.libraryPage,
                  );
                },
                child: SvgPicture.asset(
                  Assets.icons.playRadio,
                  width: 50,
                ),
              ),
            );
          }

          if (!((subgenres.length == 1 ? subgenres.first : genre) ==
              state.radioTitle)) {
            return Center(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setActive();
                  context.read<TrackAudioPlayerCubit>().startRadio(
                        artists.toList(),
                        subgenres,
                        genre,
                      );
                },
                child: SvgPicture.asset(
                  Assets.icons.playRadio,
                  width: 50,
                ),
              ),
            );
          }

          switch (state.radioStatus) {
            case RadioStatus.active:
              if (state.active) {
                return Center(
                  child: GestureDetector(
                    onTap: context.read<TrackAudioPlayerCubit>().setActive,
                    child: SizedBox(
                      width: 60,
                      child: Lottie.asset(
                        Assets.anim.radioPauseButton,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              }

              return Center(
                child: GestureDetector(
                  onTap: () {
                    setActive();
                    context.read<TrackAudioPlayerCubit>().setActive();
                  },
                  child: SvgPicture.asset(
                    Assets.icons.playRadio,
                    width: 50,
                  ),
                ),
              );
            case RadioStatus.loading:
              return const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            case RadioStatus.initial:
              return Center(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setActive();
                    context.read<TrackAudioPlayerCubit>().startRadio(
                          artists.toList(),
                          subgenres,
                          genre,
                        );
                  },
                  child: SvgPicture.asset(
                    Assets.icons.playRadio,
                    width: 50,
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lightColorScheme.yellowLight
      ..style = PaintingStyle.fill;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x, y / 2)
      ..lineTo(0, 0)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return false;
  }
}
