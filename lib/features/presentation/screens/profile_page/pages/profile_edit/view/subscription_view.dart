import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/core/constants/constants.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/features/presentation/common_pages/premium/trail_premium_view.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/profile_edit/view/confirm_trial_end_dialog.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView._(this.user, this.isTrialOrSubscriptionActive);

  final UserModel user;
  final bool isTrialOrSubscriptionActive;

  static void showNotificationDialog(
    BuildContext context,
    UserModel user,
    bool isTrialOrSubscriptionActive,
  ) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SubscriptionView._(user, isTrialOrSubscriptionActive),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: lightColorScheme.onPrimary,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              lightColorScheme.primaryContainer,
              Colors.transparent,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: router.pop,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              context.i10n.done.toUpperCase(),
              style: context.textStyle.labelMedium,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          context.i10n.subscriptions,
          style: context.textStyle.headlineMedium,
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              end: Alignment.bottomRight,
              colors: <Color>[
                const Color(0xff4E0D8F).withValues(alpha: .06),
                lightColorScheme.yellowAccent.withValues(alpha: .24),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _buildInfoContainer(
                    context,
                    isTrialOrSubscriptionActive
                        ? context.i10n.active
                        : context.i10n.limitedOffer,
                    isTrialOrSubscriptionActive,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoContainer(
                    context,
                    isTrialOrSubscriptionActive && user.daysLeft != null
                        ? context.i10n.daysLeft(user.daysLeft!)
                        : user.daysLeft != null
                            ? context.i10n.getSnobsPremium
                            : context.i10n.getDayFreeTrial(Constants.trialDays),
                    false,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                context.i10n.snobsPremium,
                style: context.textStyle.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                context.i10n.fullSongRadio,
                style: context.textStyle.displaySmall?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    if (isTrialOrSubscriptionActive) {
                      await showDialog<void>(
                        context: context,
                        builder: (_) => ConfirmTrialEndDialog(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            await openStoreSubscriptionsPage();
                          },
                        ),
                      );

                      return;
                    }

                    Navigator.of(context).pop();

                    await TrailPremiumViewDialog.showDialog(
                      context: context,
                      isTrail: user.daysLeft == null,
                      pageName: StringsRes.settingsPage,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    isTrialOrSubscriptionActive
                        ? context.i10n.cancel.toUpperCase()
                        : user.daysLeft != null
                            ? context.i10n.startPremium.toUpperCase()
                            : context.i10n.startTrial.toUpperCase(),
                    style: context.textStyle.labelMedium?.copyWith(
                      color: lightColorScheme.yellowLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
      ],
    );
  }

  Widget _buildInfoContainer(BuildContext context, String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: lightColorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(42),
      ),
      child: Row(
        children: <Widget>[
          if (active) ...<Widget>[
            CircleAvatar(
              radius: 2,
              backgroundColor: lightColorScheme.green,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: context.textStyle.bodySmall?.copyWith(
              color: lightColorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openStoreSubscriptionsPage() async {
    if (!kIsWeb) {
      final String url = Platform.isAndroid
          ? StringsRes.androidSubscriptionsPage
          : StringsRes.appleSubscriptionsPage;
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        debugPrint("Could not open subscriptions page.");
      }
    }
  }
}
