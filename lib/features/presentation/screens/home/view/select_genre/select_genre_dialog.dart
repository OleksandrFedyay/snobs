import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_state.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/select_genre/components/expansion_tile_genres.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/select_genre/components/top_genres_pill.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/select_genre/select_genres_view.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

enum ExpansionTileType {
  explored,
  unexplored,
}

class SelectGenreDialog extends StatefulWidget {
  const SelectGenreDialog({
    required this.genres,
    required this.onGenreSelect,
    required this.currentGenre,
    required this.currentSubgenre,
    required this.user,
    required this.selectedGenreOrSubGenre,
    super.key,
  });

  final List<GenreSubgenresTotal> genres;
  final void Function(String genre, String subgenre) onGenreSelect;
  final String currentGenre;
  final UserModel? user;
  final String currentSubgenre;
  final String selectedGenreOrSubGenre;

  @override
  State<SelectGenreDialog> createState() => _SelectGenreDialogState();
}

class _SelectGenreDialogState extends State<SelectGenreDialog> {
  final ExpansionTileController _exploredController = ExpansionTileController();
  final ExpansionTileController _unexploredController =
      ExpansionTileController();
  String _currentGenre = '';
  String _selectedGenreOrSubGenre = '';

  @override
  void initState() {
    super.initState();
    _currentGenre = widget.currentGenre;
    _selectedGenreOrSubGenre = widget.selectedGenreOrSubGenre;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Dialog(
        insetPadding: const EdgeInsets.only(right: 20, left: 20),
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: BlocListener<HomeCubit, HomeState>(
          listener: (BuildContext context, HomeState state) {
            if (state.currentGenreDialogue.isNotEmpty) {
              _currentGenre = state.currentGenreDialogue;
            }
            if (state.selectedRandomGenreDialogue.isNotEmpty) {
              _selectedGenreOrSubGenre = state.selectedRandomGenreDialogue;
              _expandRelevantTile();
            }
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (BuildContext context, HomeState state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /// Top-right Genres pill
                  TopGenresPill(
                    onRandom: () => context
                        .read<HomeCubit>()
                        .randomGenreSubgenre(isFromSwipePage: false),
                    selectedGenreOrSub: widget.currentSubgenre.isNotEmpty
                        ? widget.currentSubgenre
                        : widget.currentGenre,
                    genre: widget.currentGenre,
                    isGenreWithAllWord: state.isGenreWithAllWord,
                  ),

                  ///Details
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: lightColorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: <Widget>[
                        _genres(context, state),
                        const SizedBox(height: 16),
                        _genreLevelInfo(context),
                        const SizedBox(height: 21),

                        ///Explored View
                        ExpansionTileGenres(
                          expansionTileType: ExpansionTileType.explored,
                          subgenres:
                              _exploredSubgenres[ExpansionTileType.explored]!,
                          initiallyExpanded:
                              _exploredSubgenres[ExpansionTileType.explored]!
                                  .isNotEmpty,
                          controller: _exploredController,
                          currentGenre: _currentGenre,
                          selectedGenreOrSubGenre: state.isOnSetGenreDialogue
                              ? _currentGenre
                              : _selectedGenreOrSubGenre,
                          onSelectedSubgenre: (String subgenre) =>
                              _setSwipePageGenre(
                                  context, _currentGenre, subgenre),
                          onExpansionChanged: (bool value) {
                            if (value && _unexploredController.isExpanded) {
                              _unexploredController.collapse();
                            }
                          },
                        ),
                        const SizedBox(height: 10),

                        ///Unexplored View
                        ExpansionTileGenres(
                          expansionTileType: ExpansionTileType.unexplored,
                          initiallyExpanded:
                              _exploredSubgenres[ExpansionTileType.explored]!
                                  .isEmpty,
                          subgenres:
                              _exploredSubgenres[ExpansionTileType.unexplored]!,
                          controller: _unexploredController,
                          currentGenre: _currentGenre,
                          selectedGenreOrSubGenre: state.isOnSetGenreDialogue
                              ? _currentGenre
                              : _selectedGenreOrSubGenre,
                          onSelectedSubgenre: (String subgenre) =>
                              _setSwipePageGenre(
                                  context, _currentGenre, subgenre),
                          onExpansionChanged: (bool value) {
                            if (value && _exploredController.isExpanded) {
                              _exploredController.collapse();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _genres(BuildContext context, HomeState state) => SelectGenresView(
        genresSubgenres: widget.genres,
        currentGenre: _currentGenre,
        selectedGenreOrSubGenre: state.isOnSetGenreDialogue
            ? _currentGenre
            : _selectedGenreOrSubGenre,
        setSwipePageGenre: (String g, String s) {
          _setSwipePageGenre(context, g, s);
        },
        setDialogueGenre: (String genre, _) {
          context.read<HomeCubit>().updateSelectedGenreDialogue(genre);
        },
      );

  Widget _genreLevelInfo(BuildContext context) {
    final int level = _genreSubgenres.level;
    final int nextLevel = level * (level + 1) * 10;

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          Text(
            _currentGenre.toTitleCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: FontFamily.nunitoSans,
            ),
          ),
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${context.i10n.level} $level ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: lightColorScheme.onTertiaryContainer,
                fontFamily: FontFamily.nunitoSans,
              ),
            ),
          ),
          const Spacer(),
          if (level < 20)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${context.i10n.levelUpIn} $nextLevel ${context.i10n.swipes.toLowerCase()}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF767676),
                  fontFamily: FontFamily.nunitoSans,
                ),
              ),
            ),
        ],
      ),
    );
  }

  GenreSubgenresTotal get _genreSubgenres =>
      widget.genres.where((GenreSubgenresTotal i) {
        return i.genre == _currentGenre;
      }).first;

  Map<ExpansionTileType, List<SubgenreLiked>> get _exploredSubgenres {
    final List<SubgenreLiked> explored = <SubgenreLiked>[];
    final List<SubgenreLiked> unexplored = <SubgenreLiked>[];

    for (final SubgenreLiked sub in _genreSubgenres.subgenres) {
      ((widget.user?.unlockedSubgenres ?? <String>[]).contains(sub.subGenre)
              ? explored
              : unexplored)
          .add(sub);
    }

    explored
        .sort((SubgenreLiked a, SubgenreLiked b) => b.likes.compareTo(a.likes));

    return <ExpansionTileType, List<SubgenreLiked>>{
      ExpansionTileType.explored: explored,
      ExpansionTileType.unexplored: unexplored,
    };
  }

  void _setSwipePageGenre(BuildContext context, String genre, String subgenre) {
    widget.onGenreSelect(genre, subgenre);
    Navigator.of(context).pop();
  }

  void _expandRelevantTile() {
    final bool isInExplored = _exploredSubgenres[ExpansionTileType.explored]!
        .any((SubgenreLiked element) =>
            element.subGenre == _selectedGenreOrSubGenre);
    final bool isInUnexplored =
        _exploredSubgenres[ExpansionTileType.unexplored]!.any(
            (SubgenreLiked element) =>
                element.subGenre == _selectedGenreOrSubGenre);

    if (isInExplored && !_exploredController.isExpanded) {
      if (_unexploredController.isExpanded) {
        _unexploredController.collapse();
      }
      _exploredController.expand();
    } else if (isInUnexplored && !_unexploredController.isExpanded) {
      if (_exploredController.isExpanded) {
        _exploredController.collapse();
      }
      _unexploredController.expand();
    }
  }
}
