import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_artist/cubit/subgenre_liked_artist_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_songs/cubit/subgenre_liked_songs_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

/// Constants
const double _kSubgenresSortByButtonHeight = 44;
const double _kSubgenresSortByButtonBorderRadius = 30;
const double _kSubgenresSortByButtonTextButtonFontSize = 12;
const double _kSubgenresSortByButtonDropdownButton2PaddingLeft = 16;
const double _kSubgenresSortByButtonDropdownButton2PaddingRight = 16;
const double _kSubgenresSortByButtonIconSize = 16;
const double _kSubgenresSortByButtonDropdownStyleDataMaxWidth = 200;
const double _kSubgenresSortByButtonDropdownStyleDataBorderRadius = 16;
const double _kSubgenresSortByButtonMenuItemStyleDataHeight = 40;
const double _kSubgenresSortByButtonMenuItemStyleDataPaddingLeft = 14;
const double _kSubgenresSortByButtonMenuItemStyleDataPaddingRight = 14;
const double _kSubgenresSortByButtonFontSize = 14;

typedef SortBy = void Function(SortByMethod?);

///Segmented button with 'Search' and 'Sort By' segments
class SubgenresSortByButton extends StatelessWidget {
  const SubgenresSortByButton({
    required this.toggleButtonIndex,
    required this.sortByMethod,
    super.key,
  });

  final int toggleButtonIndex;
  final SortByMethod sortByMethod;

  @override
  Widget build(BuildContext context) {
    final SortBy? sortBy = switch (toggleButtonIndex) {
      0 => (SortByMethod? value) {
          context.read<SubgenrePageCubit>().selectSortByMethod(value);
          context
              .read<SubgenreLikedArtistCubit>()
              .sortArtists(sortingMethod: value);
        },
      1 => (SortByMethod? value) {
          context.read<SubgenrePageCubit>().selectSortByMethod(value);
          context
              .read<SubgenreLikedSongsCubit>()
              .sortSongs(sortingMethod: value);
        },
      int() => null,
    };
    return Container(
      height: _kSubgenresSortByButtonHeight,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(
            _kSubgenresSortByButtonBorderRadius,
          ),
          bottomRight: Radius.circular(
            _kSubgenresSortByButtonBorderRadius,
          ),
        ),
        border: Border.all(
          color: lightColorScheme.onSurface,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<SortByMethod>(
          customButton: Padding(
            padding: const EdgeInsets.only(
              left: _kSubgenresSortByButtonDropdownButton2PaddingLeft,
              right: _kSubgenresSortByButtonDropdownButton2PaddingRight,
            ),
            child: Center(
              child: Text(
                context.i10n.sortBy.toUpperCase(),
                style: const TextStyle(
                  fontSize: _kSubgenresSortByButtonTextButtonFontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          value: sortByMethod,
          items: SortByMethod.values
              .map(
                (SortByMethod item) => DropdownMenuItem<SortByMethod>(
                  value: item,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          if (sortByMethod == item)
                            Icon(
                              Icons.check_circle_outline,
                              size: _kSubgenresSortByButtonIconSize,
                              color: lightColorScheme.iconGrey,
                            ),
                          SizedBox(
                            width: sortByMethod == item ? 10 : 26,
                          ),
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: _kSubgenresSortByButtonFontSize,
                              fontWeight: FontWeight.bold,
                              color: sortByMethod == item
                                  ? lightColorScheme.yellowLight
                                  : lightColorScheme.surface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: sortBy,
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: _kSubgenresSortByButtonDropdownStyleDataMaxWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                _kSubgenresSortByButtonDropdownStyleDataBorderRadius,
              ),
              color: lightColorScheme.onSurface,
            ),
            offset: const Offset(-116, -7),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: _kSubgenresSortByButtonMenuItemStyleDataHeight,
            padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: _kSubgenresSortByButtonMenuItemStyleDataPaddingLeft,
              right: _kSubgenresSortByButtonMenuItemStyleDataPaddingRight,
            ),
          ),
        ),
      ),
    );
  }
}
