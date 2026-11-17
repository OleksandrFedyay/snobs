import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/components/subgenre_drop_down_menu_resource.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/components/subgenre_search_button/state/search_button_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/components/subgenre_search_button/subgenre_search_button.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/components/subgenres_sort_by_button.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/components/tab_switch_view.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_artist_global_chart/cubit/subgenre_artist_global_chart_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_artist_global_chart/subgenre_artist_global_chart.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_fans_global_chart/cubit/subgenre_fans_global_chart_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_fans_global_chart/subgenre_fans_global_chart.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_artist/cubit/subgenre_liked_artist_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_artist/subgenre_liked_artist.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_songs/cubit/subgenre_liked_songs_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_songs/subgenre_liked_songs.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_songs_global_charts/cubit/subgenre_songs_chart_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_songs_global_charts/subgenre_songs_global_charts.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/add_and_remove_buttons.dart';
import 'package:provider/single_child_widget.dart';

///Constants
const Duration _kSubgenreDropDownMenuResourceAnimationDurationInMs =
    Duration(milliseconds: 100);
const Duration _kSubgenreFilterFieldButtonAnimationDurationInMs =
    Duration(microseconds: 500);
const Duration _kSubgenresSortByButtonAnimationDurationInMs =
    Duration(microseconds: 100);
const Duration _kSubgenresTextDescriptionAnimationDurationInMs =
    Duration(milliseconds: 300);
const double _kSubgenrePageBodyPadding = 16;
const double _kSubgenrePageBodyBackButtonMargin = 16;
const double _kSubgenrePageBodyBackButtonHeight = 32;
const double _kSubgenrePageBodyBackButtonWidth = 32;
const double _kSubgenrePageBodyBackButtonArrowPaddingLeft = 8;
const double _kSubgenrePageBodyBackButtonColorOpacity = .4;
const double _kSubgenrePageBodyBackButtonBorderRadius = 12;
const double _kSubgenrePageBodyBackButtonIconSize = 20;
const double _kSpaceBetweenSubgenreNameAndDescription = 12;
const double _kSpaceBetweenSubgenreIconAndText = 12;
const double _kSpaceBetweenDescriptionAndButtons = 26;
const double _kBorderRadiusTopLeft = 12;
const double _kBorderRadiusTopRight = 12;
const double _kSpaceBetweenButtonsAndToggle = 18;
const double _kSpaceBetweenToggleAndBottomWidgets = 12;

@RoutePage()
class GenreSubgenresPage extends StatefulWidget implements AutoRouteWrapper {
  const GenreSubgenresPage(
    this.genre,
    this.subgenre,
    this.exploreSubgenre, {
    required this.genrePageType,
    super.key,
  });

  final String genre;
  final String subgenre;
  final Function(String genre, String subgenre) exploreSubgenre;
  final GenrePageType genrePageType;

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<SubgenrePageCubit>(
          create: (BuildContext context) =>
              SubgenrePageCubit.create(genre, subgenre, genrePageType),
        ),
        BlocProvider<SubgenreLikedSongsCubit>(
          create: (BuildContext context) => SubgenreLikedSongsCubit(
            subgenrePageCubit: context.read(),
          ),
        ),
        BlocProvider<SubgenreLikedArtistCubit>(
          create: (BuildContext context) => SubgenreLikedArtistCubit(
            subgenrePageCubit: context.read(),
          ),
        ),
        BlocProvider<SubgenreArtistGlobalChartCubit>(
          create: (BuildContext context) => SubgenreArtistGlobalChartCubit(
            subgenrePageCubit: context.read(),
          ),
        ),
        BlocProvider<SubgenreSongsGlobalChartCubit>(
          create: (BuildContext context) => SubgenreSongsGlobalChartCubit(
            subgenrePageCubit: context.read(),
          ),
        ),
        BlocProvider<SubgenreFansGlobalChartCubit>(
          create: (BuildContext context) => SubgenreFansGlobalChartCubit(
            subgenrePageCubit: context.read(),
          ),
        ),
        BlocProvider<SearchButtonCubit>(
          create: (BuildContext context) => SearchButtonCubit(
            subgenrePageCubit: context.read(),
          ),
        ),
      ],
      child: GenreSubgenresPage(
        genre,
        subgenre,
        exploreSubgenre,
        genrePageType: genrePageType,
      ),
    );
  }

  @override
  State<GenreSubgenresPage> createState() => _GenreSubgenresPageState();
}

class _GenreSubgenresPageState extends State<GenreSubgenresPage> {
  ///[_isSearchIconTaped] controls the animation and search and sort by buttons' appearance
  bool _isSearchIconTaped = false;

  ///[VoidCallback] that is passed to SubgenreFilterButton
  ///to change [_isSearchIconTaped] value
  void _onSubgenreSearchButtonTap() {
    setState(() {
      _isSearchIconTaped = !_isSearchIconTaped;
    });
  }

  bool artistsContainsId(List<ArtistChartDto> artists, String id) {
    for (final ArtistChartDto a in artists) {
      if (a.id == id) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubgenrePageCubit, SubgenrePageState>(
      builder: (BuildContext context, SubgenrePageState state) {
        final double height = MediaQuery.of(context).size.height;
        final List<Color> genreColors = state.genre.getColors(.6);

        return Scaffold(
          body: Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: lightColorScheme.onPrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(_kBorderRadiusTopLeft),
                topRight: Radius.circular(_kBorderRadiusTopRight),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: height / 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: <Color>[
                          ...genreColors,
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(_kBorderRadiusTopLeft),
                        topRight: Radius.circular(_kBorderRadiusTopRight),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _kSubgenrePageBodyPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: router.pop,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: _kSubgenrePageBodyBackButtonMargin,
                              ),
                              height: _kSubgenrePageBodyBackButtonHeight,
                              padding: kIsWeb
                                  ? EdgeInsets.zero
                                  : Platform.isIOS
                                      ? const EdgeInsets.only(
                                          left:
                                              _kSubgenrePageBodyBackButtonArrowPaddingLeft,
                                        )
                                      : EdgeInsets.zero,
                              width: _kSubgenrePageBodyBackButtonWidth,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: lightColorScheme.surfaceContainerHighest
                                    .withValues(
                                  alpha:
                                      _kSubgenrePageBodyBackButtonColorOpacity,
                                ),
                                borderRadius: BorderRadius.circular(
                                  _kSubgenrePageBodyBackButtonBorderRadius,
                                ),
                              ),
                              child: Icon(
                                Icons.adaptive.arrow_back,
                                color: Colors.white54,
                                size: _kSubgenrePageBodyBackButtonIconSize,
                              ),
                            ),
                          ),
                        ),
                        state.genre.getGenreIcon(
                            60, Colors.white.withValues(alpha: .2)),
                        const SizedBox(
                          height: _kSpaceBetweenSubgenreIconAndText,
                        ),
                        Align(
                          child: Text(
                            (widget.genrePageType == GenrePageType.genre
                                    ? widget.genre
                                    : state.subgenre)
                                .toTitleCase(),
                            style: context.textStyle.headlineSmall,
                          ),
                        ),
                        const SizedBox(
                          height: _kSpaceBetweenSubgenreNameAndDescription,
                        ),
                        AnimatedSwitcher(
                          duration:
                              _kSubgenresTextDescriptionAnimationDurationInMs,
                          child: SizedBox(
                            key: UniqueKey(),
                            child: _isSearchIconTaped
                                ? null
                                : Text(
                                    state.genreSubgenreDescription,
                                    style:
                                        context.textStyle.bodySmall?.copyWith(
                                      color: lightColorScheme.onSecondary,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: _kSpaceBetweenDescriptionAndButtons,
                        ),
                        Stack(
                          children: <Widget>[
                            //Todo(Issa): Temporally hidden until the database will be ready!
                            if (widget.genrePageType == GenrePageType.subgenre)
                              AnimatedSwitcher(
                                duration:
                                    _kSubgenreDropDownMenuResourceAnimationDurationInMs,

                                /// If _isSearchIconTaped is true, the SubgenreDropDownMenuResource disappear.
                                child: _isSearchIconTaped
                                    ? null
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: SubgenreDropDownMenuResource(
                                          chosenResource: state.chosenResource,
                                        ),
                                      ),
                              ),

                            /// AnimatedContainer changes appearance of the SubgenreFilterFieldButton and makes SortByButton disappeared
                            //Todo(Issa): Temporally hidden until the database will be ready!
                            if (widget.genrePageType == GenrePageType.subgenre)
                              AnimatedContainer(
                                duration:
                                    _kSubgenreFilterFieldButtonAnimationDurationInMs,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: SubgenreSearchButton(
                                          onTapCallback:
                                              _onSubgenreSearchButtonTap,
                                          isTaped: _isSearchIconTaped,
                                          isCircleForm: state.chosenResource !=
                                              ChosenResource.myLiked,
                                        ),
                                      ),
                                      if (state.chosenResource ==
                                          ChosenResource.myLiked)
                                        AnimatedSwitcher(
                                          duration:
                                              _kSubgenresSortByButtonAnimationDurationInMs,
                                          child: _isSearchIconTaped
                                              ? null

                                              /// SubgenresSortByButton is the drop down button
                                              /// for sorting methods selection

                                              : SubgenresSortByButton(
                                                  sortByMethod:
                                                      state.chosenSortByMethod,
                                                  toggleButtonIndex:
                                                      state.toggleButtonIndex,
                                                ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: _kSpaceBetweenButtonsAndToggle,
                        ),

                        ///Tabs "Artists", "Songs" and "Fans".
                        TabSwitchView(
                          resource: state.chosenResource,
                          index: state.toggleButtonIndex,
                          genrePageType: widget.genrePageType,
                          onTap: (int index) async {
                            await context
                                .read<SubgenrePageCubit>()
                                .setToggleButtonIndex(
                                  toggleButtonIndex: index,
                                );
                          },
                        ),
                        const SizedBox(
                          height: _kSpaceBetweenToggleAndBottomWidgets,
                        ),

                        ///If SubgenreFilterFieldButton selection is 'Global Charts'
                        ///and  SubgenreSegmentedButton selection is 'Artist',
                        /// the  SubgenreArtistGlobalChart will be shown.

                        if (state.toggleButtonIndex == 0 &&
                            state.chosenResource == ChosenResource.global)
                           Expanded(
                            child: SubgenreArtistGlobalChart(
                              exploreSubgenre: (String genre, String subgenre) async {
                                widget.exploreSubgenre(genre, subgenre);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),

                        ///If SubgenreFilterFieldButton selection is 'My Liked'
                        ///and  SubgenreSegmentedButton selection is 'Artist',
                        ///the  SubgenreMyLikedArtist will be shown.
                        if (state.toggleButtonIndex == 0 &&
                            state.chosenResource == ChosenResource.myLiked)
                          Expanded(
                            child: SubgenreLikedArtist(
                              genre: widget.genre,
                              exploreSubgenre: (String genre, String subgenre) async {
                                widget.exploreSubgenre(genre, subgenre);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),

                        ///If SubgenreFilterFieldButton selection is 'My Liked'
                        ///and  SubgenreSegmentedButton selection is 'Songs',
                        ///the  SubgenreLikedSongs will be shown.
                        if (state.toggleButtonIndex == 1 &&
                            state.chosenResource == ChosenResource.myLiked)
                          const Expanded(
                            child: SubgenreLikedSongs(),
                          ),
                        if (state.toggleButtonIndex == 1 &&
                            state.chosenResource == ChosenResource.global)
                          const Expanded(
                            child: SubgenreSongsGlobalChart(),
                          ),
                        if (state.toggleButtonIndex == 2)
                          const Expanded(
                            child: SubgenreFansGlobalChart(),
                          ),
                      ],
                    ),
                  ),
                ),
                if (state.update && state.selectedArtists.isNotEmpty)
                  AddAndRemoveButtons(
                    selectedArtists: state.selectedArtists,
                    overrides: state.overrides,
                    subgenre: state.subgenre,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
