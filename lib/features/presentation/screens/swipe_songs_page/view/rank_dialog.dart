import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:kingfishertom/features/widgets/user_avatar.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RankDialog extends StatelessWidget {
  const RankDialog._(this.level, this.user);

  final LevelDto level;
  final UserModel? user;

  static Future<void> showModalDialog(
    BuildContext context,
    LevelDto level,
    UserModel? user,
    VoidCallback onDismiss,
  ) async {
    await showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => RankDialog._(level, user),
    ).then((_) {
      /// Called when the modal is dismissed
      onDismiss();
    });

    if (kIsWeb) return;

    if (level.name == StringsRes.rankScout) {
      await InAppReview.instance.requestReview();
    }
  }

  String _getBinocularsIcon(int xp) {
    if (xp >= 10000) {
      return Assets.rank.binocularsGold;
    }

    if (xp >= 500) {
      return Assets.rank.binocularsSilver;
    }
    return Assets.rank.binocularsBlack;
  }

  String _getContactsIcon(int xp) {
    if (xp >= 10000) {
      return Assets.rank.contactsGold;
    }

    if (xp >= 2000) {
      return Assets.rank.contactsSilver;
    }
    return Assets.rank.contactsBleck;
  }

  String _getSnobIcon(int xp) {
    if (xp >= 10000) {
      return Assets.rank.snobGolden;
    }

    if (xp >= 5000) {
      return Assets.rank.snobSilver;
    }
    return Assets.rank.snobBleck;
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return Container(
      width: double.infinity,
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
        color: lightColorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTopWidget(context),
          const SizedBox(height: 4),
          Text(
            '${context.i10n.music} ${level.name}',
            style: context.textStyle.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            '${context.i10n.nextRank}: ${level.xp.rankNextLevel}',
            style: context.textStyle.bodyLarge?.copyWith(
              color: lightColorScheme.onSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(24),
            child: AppButton(
              style: AppThemeModel.instance.getWelcomeButtonTheme().style,
              onPressed: Navigator.of(context).pop,
              withArrow: false,
              text: context.i10n.awesome.toUpperCase(),
            ),
          ),
          SizedBox(height: padding.bottom),
        ],
      ),
    );
  }

  Widget _buildTopWidget(BuildContext context) {
    final int xp = user?.levelXp ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            const Color(0xFF08000F),
            lightColorScheme.onPrimary,
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Positioned(
                top: 8,
                left: 20,
                child: SvgPicture.asset(_getBinocularsIcon(xp)),
              ),
              Positioned(
                top: 8,
                right: 20,
                child: SvgPicture.asset(_getContactsIcon(xp)),
              ),
              Positioned(
                bottom: 0,
                top: 20,
                left: 0,
                child: SvgPicture.asset(
                  xp >= 10000
                      ? Assets.rank.favoriteGold
                      : Assets.rank.favoriteSilver,
                ),
              ),
              Positioned(
                bottom: 0,
                top: 20,
                right: 0,
                child: SvgPicture.asset(_getSnobIcon(xp)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 60,
                ),
                child: UserAvatar(
                  user: user,
                  radius: 44,
                  fontSize: 36,
                  padding: const EdgeInsets.all(6),
                  borderColor: lightColorScheme.yellowLight,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xFFF9F2DE),
                      Color(0xFFCDB165),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: <double>[0.02, 0.28, 0.5, 0.75, 0.98],
                      colors: <Color>[
                        Color(0xFF856220),
                        Color(0xFFF4E683),
                        Color(0xFFBF923D),
                        Color(0xFF4E341B),
                        Color(0xFFF1EA82),
                      ],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: lightColorScheme.yellowLight.withValues(alpha: .6),
                    ),
                    child: Text(
                      level.name,
                      style: context.textStyle.titleMedium?.copyWith(
                        color: lightColorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.i10n.newRankAchieved,
            style: context.textStyle.bodyLarge?.copyWith(
              color: lightColorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
