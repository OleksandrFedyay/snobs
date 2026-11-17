import 'package:flutter/material.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';

class LevelDialog extends StatelessWidget {
  const LevelDialog._(this.total);

  final GenreSubgenresTotal total;

  static void showModalDialog(
    BuildContext context,
    GenreSubgenresTotal total,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: lightColorScheme.primary,
      builder: (_) => LevelDialog._(total),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GenreEnum genre = total.genre.genreStingToEnum;
    final int level = total.level;
    final int nextLevel = level * (level + 1) * 10;

    return Container(
      decoration: BoxDecoration(
        color: lightColorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: genre.getColors(.4),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 20),
          genre.getGenreIcon(64, Colors.white54),
          const SizedBox(height: 20),
          Text(
            context.i10n.youHaveReachedLevelFor(
              level,
              total.genre.toTitleCase(),
            ),
            style: context.textStyle.headlineSmall?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 20),
          Text(
            context.i10n.exploreMoreArtistsToReachLevel(
              level + 1,
              nextLevel,
              total.genre.toTitleCase(),
            ),
            textAlign: TextAlign.center,
            style: context.textStyle.bodyLarge,
          ),
          const SizedBox(height: 60),
          AppButton(
            style: AppThemeModel.instance.getWelcomeButtonTheme().style,
            onPressed: () {
              Navigator.of(context).pop();
            },
            withArrow: false,
            text: context.i10n.awesome.toUpperCase(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
