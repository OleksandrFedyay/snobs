import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_subgenres.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/artists_organization_view/artists_organization_view.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddAndRemoveButtons extends StatelessWidget {
  const AddAndRemoveButtons({
    required this.selectedArtists,
    required this.overrides,
    required this.subgenre,
    this.user,
    super.key,
  });

  final List<ArtistChartDto> selectedArtists;
  final List<ArtistSubgenres> overrides;
  final String subgenre;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, padding.bottom + 16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: <Widget>[
            Expanded(
              child: AppButton(
                onPressed: () {
                  for (final ArtistChartDto a in selectedArtists) {
                    final List<String> subgenres = (overrides
                            .firstWhereOrNull(
                              (ArtistSubgenres o) => o.artistId == a.id,
                            )
                            ?.subgenres ??
                        a.subgenres)
                      ..remove(subgenre);

                    context
                        .read<SubgenrePageCubit>()
                        .updateArtistOverrides(a, subgenres);
                  }

                  context.read<SubgenrePageCubit>().setUpdate(update: false);
                },
                withArrow: false,
                style: AppThemeModel.instance.getRemoveButtonTheme().style,
                text: context.i10n.remove.toUpperCase(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await showMaterialModalBottomSheet<void>(
                    context: context,
                    barrierColor: lightColorScheme.surfaceContainerHighest
                        .withValues(alpha: .5),
                    backgroundColor: Colors.transparent,
                    isDismissible: false,
                    enableDrag: false,
                    builder: (_) => ArtistsOrganizationView.create(
                      artists: selectedArtists,
                      user: user,
                    ),
                  );
                },
                withArrow: false,
                style: AppThemeModel.instance.getWelcomeButtonTheme().style,
                text: context.i10n.add.toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
