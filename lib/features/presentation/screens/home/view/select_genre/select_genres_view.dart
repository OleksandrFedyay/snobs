import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_state.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class SelectGenresView extends StatefulWidget {
  const SelectGenresView({
    required this.genresSubgenres,
    required this.setDialogueGenre,
    required this.setSwipePageGenre,
    required this.selectedGenreOrSubGenre,
    required this.currentGenre,
    super.key,
  });

  final String selectedGenreOrSubGenre;
  final String currentGenre;
  final List<GenreSubgenresTotal> genresSubgenres;
  final void Function(String genre, String subgenre) setDialogueGenre;
  final void Function(String genre, String subgenre) setSwipePageGenre;

  @override
  SelectGenresViewState createState() => SelectGenresViewState();
}

class SelectGenresViewState extends State<SelectGenresView> {
  final InfiniteScrollController _controller = InfiniteScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, HomeState state) {
        return SizedBox(
          height: 51,
          child: InfiniteCarousel.builder(
            itemCount: widget.genresSubgenres.length,
            controller: _controller,

            /// 65 item width + margin 12
            itemExtent: 65 + 12,
            center: false,
            itemBuilder: (BuildContext context, int itemIndex, int realIndex) {
              _scrollToItem(
                  itemIndex, state.isFirstScrollGenreDialogue, context);

              return GestureDetector(
                onDoubleTap: () => widget.setSwipePageGenre(
                    widget.genresSubgenres[itemIndex].genre, ''),
                onTap: () {
                  final String selectedGenre =
                      widget.genresSubgenres[itemIndex].genre;
                  final bool isSelected = selectedGenre.toLowerCase() ==
                      widget.selectedGenreOrSubGenre.toLowerCase();

                  isSelected
                      ? widget.setSwipePageGenre(selectedGenre, '')
                      : widget.setDialogueGenre(selectedGenre, '');
                },
                behavior: HitTestBehavior.opaque,
                child: _genreBox(context, widget.genresSubgenres[itemIndex]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _genreBox(BuildContext context, GenreSubgenresTotal genreSub) =>
      Container(
        height: 51,
        width: 65,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: lightColorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: lightColorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: genreSub.genre.toLowerCase() ==
                    widget.selectedGenreOrSubGenre.toLowerCase()
                ? Border.all(
                    color: lightColorScheme.yellowLight,
                  )
                : null,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[
                ...genreSub.genre.genreStingToEnum.getColors(.3),
                lightColorScheme.backgroundGrey.withValues(alpha: 0.5),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: genreSub.genre.genreStingToEnum
                    .getGenreIcon(24, Colors.white),
              ),
              Text(
                genreSub.genre.toTitleCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontFamily: FontFamily.nunitoSans,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      );

  void _scrollToItem(int index, bool isCanScroll, BuildContext context) {
    if (_controller.hasClients &&
        widget.genresSubgenres[index].genre.toLowerCase() ==
            widget.currentGenre.toLowerCase() &&
        isCanScroll) {
      context.read<HomeCubit>().setIsFirstScrollGenreDialogue(false);
      _controller.animateTo(
        /// 65 item width + margin 12
        index * (65 + 12),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
