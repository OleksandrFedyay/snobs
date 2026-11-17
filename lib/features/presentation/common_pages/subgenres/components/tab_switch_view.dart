import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class TabSwitchView extends StatelessWidget {
  const TabSwitchView({
    required this.resource,
    required this.index,
    required this.onTap,
    required this.genrePageType,
    super.key,
  });

  final ChosenResource resource;
  final int index;
  final Function(int index) onTap;
  final GenrePageType genrePageType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 316,
      height: 36,
      child: Row(
        children: <Widget>[
          _tab(
            title: context.i10n.artists,
            index: 0,
            isSelected: index == 0,
            onTap: onTap,
          ),
          //Todo(Issa): Temporally hidden until the database will be ready!
          if (genrePageType == GenrePageType.subgenre) ...<Widget>[
            _tab(
              title: context.i10n.songs,
              index: 1,
              isSelected: index == 1,
              onTap: onTap,
            ),
            Visibility(
              visible: resource == ChosenResource.global,
              child: _tab(
                title: context.i10n.fans,
                index: 2,
                isSelected: index == 2,
                onTap: onTap,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tab({
    required String title,
    required int index,
    required Function(int index) onTap,
    required bool isSelected,
  }) =>
      Flexible(
        child: GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            width: double.infinity,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected
                  ? lightColorScheme.yellowLight
                  : lightColorScheme.surfaceContainerHighest,
              borderRadius: genrePageType == GenrePageType.subgenre
                  ? index.borderRadiusSubgenres(resource)
                  : const BorderRadius.all(
                      Radius.circular(12),
                    ),
              border: Border.all(color: lightColorScheme.backgroundGrey),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? lightColorScheme.fieldText : Colors.white,
                  fontFamily: FontFamily.nunitoSans,
                ),
              ),
            ),
          ),
        ),
      );
}
