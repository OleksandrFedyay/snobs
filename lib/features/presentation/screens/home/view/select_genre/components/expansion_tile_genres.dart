import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/select_genre/select_genre_dialog.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class ExpansionTileGenres extends StatelessWidget {
  const ExpansionTileGenres({
    required this.subgenres,
    required this.controller,
    required this.currentGenre,
    required this.onSelectedSubgenre,
    required this.onExpansionChanged,
    required this.expansionTileType,
    required this.initiallyExpanded,
    required this.selectedGenreOrSubGenre,
    super.key,
  });

  final List<SubgenreLiked> subgenres;
  final ExpansionTileController controller;
  final String currentGenre;
  final ValueSetter<String> onSelectedSubgenre;
  final ValueSetter<bool> onExpansionChanged;
  final ExpansionTileType expansionTileType;
  final bool initiallyExpanded;
  final String selectedGenreOrSubGenre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ExpansionTile(
        backgroundColor: lightColorScheme.surfaceContainerHighest,
        controller: controller,
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: onExpansionChanged,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        collapsedIconColor: Colors.white54,
        iconColor: Colors.white54,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        collapsedBackgroundColor: lightColorScheme.surfaceContainerHighest,
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        title: _title(context),
        children: <Widget>[
          if (subgenres.isEmpty) _emptySubgenres(context) else _body(context),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) => Row(
        children: <Widget>[
          Text(
            expansionTileType == ExpansionTileType.explored
                ? context.i10n.exploredSubgenres
                : context.i10n.unexploredSubgenres,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: FontFamily.nunitoSans,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            '(${subgenres.length})',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontFamily: FontFamily.nunitoSans,
            ),
          ),
        ],
      );

  Widget _body(BuildContext context) => SizedBox(
        height: _fieldHeight,
        child: ListView.builder(
          itemCount: subgenres.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (BuildContext cotxt, int index) {
            final SubgenreLiked subData = subgenres[index];
            return GestureDetector(
              onTap: () => onSelectedSubgenre(subData.subGenre),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 43,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: lightColorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: _getBorderColor(subData),
                  ),
                  gradient: expansionTileType == ExpansionTileType.explored &&
                          subData.likes > 0
                      ? LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: <Color>[
                            ...currentGenre.genreStingToEnum.getColors(.5),
                            lightColorScheme.backgroundGrey
                                .withValues(alpha: 0.3),
                          ],
                        )
                      : null,
                ),
                child: _fieldContent(subData),
              ),
            );
          },
        ),
      );

  Widget _fieldContent(SubgenreLiked subData) => Row(
        children: <Widget>[
          Text(
            subData.subGenre.toTitleCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontFamily: FontFamily.nunitoSans,
            ),
          ),
          const Spacer(),
          Visibility(
            visible: expansionTileType == ExpansionTileType.explored,
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text(
                  '${subData.likes}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontFamily: FontFamily.nunitoSans,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _emptySubgenres(BuildContext context) => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            Text(
              expansionTileType == ExpansionTileType.explored
                  ? context.i10n.noExploredSubgenres(currentGenre.toTitleCase())
                  : context.i10n
                      .noUnexploredSubgenres(currentGenre.toTitleCase()),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: context.textStyle.displaySmall?.copyWith(
                color: lightColorScheme.tertiary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              expansionTileType == ExpansionTileType.explored
                  ? context.i10n.selectUnexploredSubgenre
                  : context.i10n.congratsExploredAllSubgenres,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: context.textStyle.bodySmall?.copyWith(
                color: lightColorScheme.tertiary,
              ),
            ),
          ],
        ),
      );

  /// (Subgenre height 43 + margin bottom 12) + List margin 12
  double get _fieldHeight {
    double height = 0;
    if (subgenres.length < 5) {
      height = (subgenres.length * (43 + 12)) + 12;
    } else {
      height = (4 * (43 + 12)) + 12;
    }

    return height;
  }

  Color _getBorderColor(SubgenreLiked subData) {
    if (subData.subGenre.toLowerCase() ==
        selectedGenreOrSubGenre.toLowerCase()) {
      return lightColorScheme.yellowLight;
    }
    if (expansionTileType == ExpansionTileType.explored && subData.likes > 0) {
      return Colors.transparent;
    }
    return lightColorScheme.iconGrey;
  }
}
