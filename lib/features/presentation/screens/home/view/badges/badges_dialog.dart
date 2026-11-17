import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingfishertom/core/data/api/models/dtos/badge.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/badges/badges_enum.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class BadgesDialog extends StatelessWidget {
  const BadgesDialog._(this.badge, this.genre);

  final BadgeDto badge;
  final String genre;

  static void showDialog(
    BuildContext context,
    BadgeDto badge,
    String genre,
  ) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BadgesDialog._(badge, genre),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: MediaQuery.of(context).viewInsets,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      decoration: BoxDecoration(
        color: lightColorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final int number = badge.type.getNumber();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16),
        Text(
          context.i10n.badgeUpdate,
          style: context.textStyle.bodyLarge?.copyWith(
            color: lightColorScheme.onTertiaryContainer,
          ),
        ),
        const SizedBox(height: 8),
        _buildSubgenreName(context, number),
        const SizedBox(height: 8),
        Container(
          width: 72,
          height: 1,
          color: Colors.white30,
        ),
        const SizedBox(height: 16),
        Text(
          badge.type == BadgesType.golden
              ? context.i10n.evaluateArtists(badge.type.getNumber())
              : context.i10n.youveSwipedTimes(
                  100 - number,
                  badge.type.getNumber(),
                  badge.subgenre,
                ),
          style: context.textStyle.labelLarge
              ?.copyWith(fontWeight: FontWeight.w400, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        _buildControls(context),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }

  Widget _buildSubgenreName(BuildContext context, int number) {
    final Color genreColor = genre.genreStingToEnum.getColors().first;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constrains) {
        return SizedBox(
          height: 120,
          width: 350,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  Assets.badges.background1.path,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                width: 310,
                height: 90,
                child: SvgPicture.asset(
                  Assets.badges.background2,
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    genreColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Container(
                width: 325,
                height: 105,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: genreColor),
                ),
                child: AutoSizeText(
                  badge.subgenre.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 28,
                  maxFontSize: 32,
                  style: TextStyle(
                    fontSize: 30,
                    color: genreColor,
                    fontWeight: FontWeight.w800,
                    fontFamily: FontFamily.nunitoSans,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControls(BuildContext context) {
    if (badge.type != BadgesType.golden) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: AppButton(
          style: AppThemeModel.instance.getWelcomeButtonTheme().style,
          onPressed: Navigator.of(context).pop,
          text: context.i10n.continueSwiping.toUpperCase(),
          withArrow: false,
        ),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Share.share(
        context.i10n.evaluateArtists(badge.type.getNumber()),
        subject: context.i10n.evaluateArtists(badge.type.getNumber()),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildSocialButton(
              context,
              icon: SvgPicture.asset(Assets.badges.facebook),
              title: context.i10n.facebook,
            ),
            _buildSocialButton(
              context,
              icon: SvgPicture.asset(Assets.badges.instagram),
              title: context.i10n.instagram,
            ),
            _buildSocialButton(
              context,
              icon: SvgPicture.asset(Assets.badges.social),
              title: context.i10n.snapchat,
            ),
            _buildSocialButton(
              context,
              icon: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lightColorScheme.onSurface,
                ),
                child: const Icon(
                  Icons.more_horiz_rounded,
                  size: 40,
                ),
              ),
              title: context.i10n.others,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required Widget icon,
    required String title,
  }) {
    return Column(
      children: <Widget>[
        icon,
        const SizedBox(height: 12),
        Text(title, style: context.textStyle.labelMedium),
      ],
    );
  }
}
