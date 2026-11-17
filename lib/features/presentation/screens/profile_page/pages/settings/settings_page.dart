import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/snackbar/snack_bar_service.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/feedback_view.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/profile_edit/view/subscription_view.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/profile_edit/view/verification_view.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/settings/cubit/settings_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/view/delete_account_dialog.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

@RoutePage()
class SettingsPage extends StatefulWidget implements AutoRouteWrapper {
  const SettingsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => SettingsCubit.create(),
      child: this,
    );
  }

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  SettingsCubit _getCubit(BuildContext context) => context.read();

  Future<void> showVerificationDialog(
    String phone,
    ValueSetter<String> verify,
  ) async {
    await showMaterialModalBottomSheet<void>(
      context: context,
      barrierColor:
          lightColorScheme.surfaceContainerHighest.withValues(alpha: .5),
      backgroundColor: Colors.transparent,
      builder: (_) => VerificationView(phoneNumber: phone, verify: verify),
    );
  }

  void _onStateChanged(BuildContext context, SettingsState state) {
    if (state.status == SettingsStatus.error) {
      showTopSnackBar(context, state.errorMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<SettingsCubit>().isTrialOrSubscriptionActive;
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 4, top: padding.top),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      lightColorScheme.primaryContainer,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: router.pop,
                      icon: Icon(
                        Icons.adaptive.arrow_back,
                        color: Colors.white54,
                      ),
                      iconSize: 20,
                    ),
                    const Spacer(),
                    Text(
                      context.i10n.settings,
                      style: context.textStyle.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: _onStateChanged,
      builder: (BuildContext context, SettingsState state) {
        if (state.status == SettingsStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          spacing: 350,
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProfileTile(
                    onTap: router.pushProfileRoute,
                    title: context.i10n.editProfile,
                  ),
                  //Note: Temporarily removed
                  /*       ProfileTile(
                    onTap: router.pushGetMusicRoute,
                    title: context.i10n.snobsForArtists,
                  ),*/
                  ProfileTile(
                    onTap: router.pushNotificationRoute,
                    title: context.i10n.notifications,
                  ),
                  ProfileTile(
                    onTap: () {
                      final UserModel? user = state.user;
                      if (user == null) return;
                      unawaited(FirebaseAnalytics.instance.logEvent(
                        name: 'trial_30_day_settings_impression',
                        parameters: <String, Object>{
                          'source_page': StringsRes.settingsPage,
                        },
                      ));
                      SubscriptionView.showNotificationDialog(
                        context,
                        user,
                        state.isTrialOrSubscriptionActive,
                      );
                    },
                    title: context.i10n.subscription.toTitleCase(),
                  ),
                  ProfileTile(
                    onTap: () {
                      showMaterialModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => FeedbackView.create(),
                      );
                    },
                    title: context.i10n.support,
                  ),
                  ProfileTile(
                    onTap: () {
                      showMaterialModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => FeedbackView.create(),
                      );
                    },
                    title: context.i10n.feedback,
                  ),
                  ProfileTile(
                    onTap: () {
                      context
                          .read<TrackAudioPlayerCubit>()
                          .setActive(value: false);
                      _getCubit(context).logout();
                    },
                    title: context.i10n.signOut,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: router.pushTermsRoute,
                    child: Text(
                      context.i10n.termsConditions,
                      style: context.textStyle.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: router.pushPrivacyRoute,
                    child: Text(
                      context.i10n.privacyPolicy,
                      style: context.textStyle.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDeleteAccount(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  /// Copy the app version to the clipboard
                  Clipboard.setData(ClipboardData(
                    text:
                        'App version: ${state.appVersionNumber} (${state.appVersionCode})',
                  ));
                  getIt<SnackBarService>().showMessage(
                      infoSnackBar(context.i10n.appVersionCopiedClipboard));
                },
                child: Text(
                  'App version: ${state.appVersionNumber} (${state.appVersionCode})',
                  style: context.textStyle.labelMedium?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeleteAccount() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) => DeleteAccountDialog(
            onPressed: () {
              Navigator.of(context).pop();
              _getCubit(context).deleteAccount();
            },
          ),
        );
      },
      child: Text(
        context.i10n.deleteAccount,
        style: context.textStyle.bodyLarge?.copyWith(
          color: lightColorScheme.red,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ///Needed to update the [Subscription Info] when the user return back from Store subscriptions
    if (state == AppLifecycleState.resumed) {
      _getCubit(context).init();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    required this.onTap,
    required this.title,
    super.key,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: context.textStyle.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: lightColorScheme.iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
