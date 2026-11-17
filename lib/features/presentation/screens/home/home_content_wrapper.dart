import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_state.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/genres_top_panel.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/select_genre/select_genre_dialog.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/library_page.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/profile_page.dart';
import 'package:kingfishertom/features/presentation/screens/search_page/search_page.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/swipe_songs_page.dart';

class HomeContentWrapper extends StatelessWidget {
  const HomeContentWrapper({
    required this.index,
    required this.changeIndex,
    super.key,
  });

  final int index;
  final ValueSetter<int> changeIndex;

  HomeCubit _getCubit(BuildContext context) => context.read();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, HomeState state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                lightColorScheme.homeBackground1,
                lightColorScheme.homeBackground2,
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildTopWidget(context, state),
                    ),
                    <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: SwipeSongsPage(
                            key: ValueKey<String>('song${state.subGenre}'),
                            currentGenre: state.genre,
                            subGenre: state.subGenre,
                            onSelectGenre: () =>
                                showSelectGenreDialog(context, state),
                            exploreSubgenre: (String genre, String subgenre) {
                              exploreSubgenre(context, genre, subgenre);
                            },
                            user: state.user,
                          ),
                        ),
                      ),
                      LibraryPage(
                        genre: state.libraryGenre,
                        setGenre: _getCubit(context).setLibraryGenre,
                        subgenre: state.librarySubgenre,
                        setSubgenre: _getCubit(context).setLibrarySubgenre,
                        height: constraints.maxHeight,
                        exploreSubgenre: (String genre, String subgenre) {
                          exploreSubgenre(context, genre, subgenre);
                        },
                      ),
                      SearchPage(
                        subgenre: state.subGenre,
                        key: ValueKey<String>('search${state.subGenre}'),
                        exploreSubgenre: (String genre, String subgenre) {
                          exploreSubgenre(context, genre, subgenre);
                        },
                      ),
                      ProfilePage(
                        genres: state.genresSubgenres,
                        onGetPremium: () {
                          //Todo(Issa): Need to show tool tip when the User got the premium account from Profile
                          changeIndex(1);
                        },
                        onExploreSubgenre: (String genre, String subgenre) {
                          exploreSubgenre(context, genre, subgenre);
                        },
                      ),
                    ][index],
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopWidget(BuildContext context, HomeState state) {
    if (index == 0) {
      return GenresTopPanel(
        genre: state.genre,
        selectedGenreOrSub: state.isGenreWithAllWord
            ? 'ALL ${state.selectedGenreOrSubGenre}'
            : state.selectedGenreOrSubGenre,
        isTrialOrSubscriptionActive: state.isTrialOrSubscriptionActive,
        onGenresTap: () {
          showSelectGenreDialog(context, state);
          //Todo(Issa): Need action here for task [New Selector]
        },
      );
    } else if (index == 3) {
      return Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: router.pushSettingsRoute,
          icon: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
          ),
          iconSize: 28,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> showSelectGenreDialog(
    BuildContext context,
    HomeState state,
  ) async {
    final HomeCubit cubit = context.read<HomeCubit>();

    await showDialog<void>(
      context: context,
      barrierColor: lightColorScheme.onPrimary.withValues(alpha: 0.5),
      builder: (_) => BlocProvider<HomeCubit>.value(
        value: cubit
          ..setIsOnSetGenreDialogue(false)
          ..setSelectedRandomGenreDialogue('')
          ..setIsFirstScrollGenreDialogue(true)
          ..updateSelectedGenreDialogue(''),
        child: SelectGenreDialog(
          genres: state.genresSubgenres,
          currentGenre: state.genre,
          currentSubgenre: state.subGenre,
          selectedGenreOrSubGenre: state.selectedGenreOrSubGenre,
          onGenreSelect: cubit.setGenre,
          user: state.user,
        ),
      ),
    );
  }

  void exploreSubgenre(
    BuildContext context,
    String genre,
    String subgenre,
  ) {
    changeIndex(0);
    context.read<HomeCubit>().setGenre(genre, subgenre);
  }
}
