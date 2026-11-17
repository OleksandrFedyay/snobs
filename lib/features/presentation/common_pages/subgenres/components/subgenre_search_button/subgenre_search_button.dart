import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/components/subgenre_search_button/state/search_button_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_artist_global_chart/cubit/subgenre_artist_global_chart_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_fans_global_chart/cubit/subgenre_fans_global_chart_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_artist/cubit/subgenre_liked_artist_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_songs/cubit/subgenre_liked_songs_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_songs_global_charts/cubit/subgenre_songs_chart_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

///Constants
const Duration _kAnimationDurationInMs = Duration(milliseconds: 200);
const double _kNotActivatedAnimatedContainerWidth = 52;
const double _kNotActivatedAnimatedContainerHeight = 44;
const double _kActivatedAnimatedContainerHeight = 55;
const double _kBorderRadiusTopLeft = 32;
const double _kBorderRadiusBottomLeft = 32;
const double _kBorderRadiusActivatedTopRight = 32;
const double _kBorderRadiusNotActivatedTopRight = 0;
const double _kBorderRadiusActivatedBottomRight = 32;
const double _kBorderRadiusNotActivatedBottomRight = 0;
const double _kInkWellSearchIconSize = 22;
const double _kInkWellSearchPaddingHorizontal = 13;
const double _kInkWellSearchPaddingVertical = 8;
const double _kCloseInkWellIconSize = 20;
const double _kBorderRadiusCircular = 57;
const double _kCloseInkWellIconPaddingAll = 14;
const double _kPercentsOfTheWidth = 0.95;

///Searching field button.
///If it is activated, an animated transition to the activated searching field takes a place.
///And vice versa.

typedef Searching = void Function(String)?;
typedef Cancel = void Function()?;

///TODO check if it is better to move onTapCallback changes to the state of the subgenre page and listen to the changes inside search cubit
class SubgenreSearchButton extends StatefulWidget {
  const SubgenreSearchButton({
    required this.onTapCallback,
    required this.isTaped,
    required this.isCircleForm,
    super.key,
  });

  final VoidCallback onTapCallback;
  final bool isTaped;
  final bool isCircleForm;

  @override
  State<SubgenreSearchButton> createState() => _SubgenreSearchButtonState();
}

class _SubgenreSearchButtonState extends State<SubgenreSearchButton> {
  final TextEditingController textFieldController = TextEditingController();
  Searching search;
  Cancel cancel;

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchButtonCubit, SearchFieldState>(
      listener: (BuildContext context, SearchFieldState state) {
        switch (state) {
          case SearchFieldLoadingState():
            break;
          //Searching is going to be performed on SubgenreLikedSongsContent
          case SearchFieldForMyLikedSongs():
            textFieldController.clear();
            SubgenreLikedSongsCubit cubit(BuildContext context) =>
                context.read();
            search = (String value) {
              cubit(context).searchLikedSongs(value);
            };
            cancel = () {
              textFieldController.clear();
              cubit(context).cancelLikedSongsSearching();
              widget.onTapCallback();
            };
          //Searching is going to be performed on SubgenreSongsChartsContent
          case SearchFieldForGlobalChartsSong():
            textFieldController.clear();
            SubgenreSongsGlobalChartCubit cubit(BuildContext context) =>
                context.read();
            search = (String value) {
              cubit(context).searchGlobalChartsSongs(value);
            };
            cancel = () {
              textFieldController.clear();
              cubit(context).cancelSongsGlobalChartsSearching();
              widget.onTapCallback();
            };
          //Searching is going to be performed on SubgenreMyLikedArtistContent
          case SearchFieldForMyLikedArtists():
            textFieldController.clear();
            SubgenreLikedArtistCubit cubit(BuildContext context) =>
                context.read();
            search = (String value) {
              cubit(context).searchMyLikedArtist(value);
            };
            cancel = () {
              textFieldController.clear();
              cubit(context).cancelMyLikedArtistSearching();
              widget.onTapCallback();
            };
          //Searching is going to be performed on SubgenreArtistGlobalChartContent
          case SearchFieldForArtistGlobalCharts():
            textFieldController.clear();
            SubgenreArtistGlobalChartCubit cubit(BuildContext context) =>
                context.read();
            search = (String value) async {
              await cubit(context).searchArtistGlobalChart(value);
            };
            cancel = () {
              textFieldController.clear();
              cubit(context).cancelArtistGlobalChartSearching();
              widget.onTapCallback();
            };
          //Searching is going to be performed on SubgenreTopSnobs
          case SearchFieldForTopSnobsState():
            textFieldController.clear();
            SubgenreFansGlobalChartCubit cubit(BuildContext context) =>
                context.read();
            search = (String value) {
              cubit(context).searchTopSnobs(value);
            };
            cancel = () {
              textFieldController.clear();
              cubit(context).cancelTopSnobsSearching();
              widget.onTapCallback();
            };

          //Error
          case SearchFieldErrorState():
            textFieldController.clear();
            cancel = () {
              textFieldController.clear();
              widget.onTapCallback();
            };
        }
      },
      child: AnimatedContainer(
        duration: _kAnimationDurationInMs,
        width: widget.isTaped
            ? MediaQuery.sizeOf(context).width * _kPercentsOfTheWidth
            : _kNotActivatedAnimatedContainerWidth,
        height: widget.isTaped
            ? _kActivatedAnimatedContainerHeight
            : _kNotActivatedAnimatedContainerHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: lightColorScheme.onSurface,
          ),
          borderRadius: widget.isCircleForm
              ? BorderRadius.circular(
                  _kBorderRadiusCircular,
                )
              : BorderRadius.only(
                  topLeft: const Radius.circular(
                    _kBorderRadiusTopLeft,
                  ),
                  bottomLeft: const Radius.circular(_kBorderRadiusBottomLeft),
                  topRight: Radius.circular(
                    widget.isTaped
                        ? _kBorderRadiusActivatedTopRight
                        : _kBorderRadiusNotActivatedTopRight,
                  ),
                  bottomRight: Radius.circular(
                    widget.isTaped
                        ? _kBorderRadiusActivatedBottomRight
                        : _kBorderRadiusNotActivatedBottomRight,
                  ),
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                child: widget.isTaped
                    ? TextField(
                        controller: textFieldController,
                        onTapOutside: (PointerDownEvent p) {
                          FocusScope.of(context).unfocus();
                        },
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        onChanged: search,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search_outlined,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: widget.isTaped
                  ? CloseInkWell(
                      onTapCallback: cancel ?? widget.onTapCallback,
                    )
                  : SearchInkWell(onTapCallback: widget.onTapCallback),
            ),
          ],
        ),
      ),
    );
  }
}

///Activates the searching field
class SearchInkWell extends StatelessWidget {
  const SearchInkWell({
    required this.onTapCallback,
    super.key,
  });

  final VoidCallback onTapCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(_kBorderRadiusTopLeft),
        topRight: Radius.circular(_kBorderRadiusActivatedTopRight),
        bottomLeft: Radius.circular(_kBorderRadiusBottomLeft),
        bottomRight: Radius.circular(_kBorderRadiusActivatedBottomRight),
      ),
      onTap: onTapCallback,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _kInkWellSearchPaddingHorizontal,
          vertical: _kInkWellSearchPaddingVertical,
        ),
        child: Center(
          child: Icon(
            Icons.search_outlined,
            color: Colors.white,
            size: _kInkWellSearchIconSize,
          ),
        ),
      ),
    );
  }
}

///Deactivates the searching field
class CloseInkWell extends StatelessWidget {
  const CloseInkWell({
    required this.onTapCallback,
    super.key,
  });

  final VoidCallback onTapCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(_kBorderRadiusTopLeft),
        bottomLeft: Radius.circular(_kBorderRadiusBottomLeft),
      ),
      onTap: onTapCallback,
      child: const Padding(
        padding: EdgeInsets.all(
          _kCloseInkWellIconPaddingAll,
        ),
        child: Icon(
          Icons.close,
          color: Colors.white,
          size: _kCloseInkWellIconSize,
        ),
      ),
    );
  }
}
