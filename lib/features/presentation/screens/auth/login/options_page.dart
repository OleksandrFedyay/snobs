import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/auth/login/cubit/login_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/icons/snobs_icons.dart';
import 'package:kingfishertom/gen/assets.gen.dart';

@RoutePage()
class OptionsPage extends StatelessWidget implements AutoRouteWrapper {
  const OptionsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<LoginPageCubit>(
      create: (_) => LoginPageCubit.create(),
      child: this,
    );
  }

  LoginPageCubit cubit(BuildContext context) => context.read();

  void _onStateChanged(BuildContext context, LoginPageState state) {
    switch (state.status) {
      case LoginPageStatus.error:
        state.errorMessage.showSnackBarInfo;
      case LoginPageStatus.success:
        router.pushAndClearStackNameRoute();

      case LoginPageStatus.initial:
      case LoginPageStatus.loading:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.deepPurpleBackground,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              lightColorScheme.deepPurple,
              lightColorScheme.deepPurple.withValues(alpha: .6),
              lightColorScheme.deepPurple,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<LoginPageCubit, LoginPageState>(
            listener: _onStateChanged,
            builder: _buildBody,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LoginPageState state) {
    if (state.status == LoginPageStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          const Align(
            alignment: Alignment(-0.5, 0),
            child: Icon(
              SnobsIcons.snobsLogo,
              size: 100,
            ),
          ),
          const Spacer(flex: 2),
          _buildLoginSocialButton(
            context,
            context.i10n.continueWithApple,
            const Icon(SnobsIcons.appleLogo, color: Colors.white54, size: 24),
            cubit(context).signInViaApple,
          ),
          const SizedBox(height: 12),
          _buildLoginSocialButton(
            context,
            context.i10n.continueWithGoogle,
            SvgPicture.asset(
              Assets.icons.googleLogo,
              height: 24,
            ),
            cubit(context).signInViaGoogle,
          ),
          const SizedBox(height: 12),
          _buildLoginSocialButton(
            context,
            context.i10n.continueWithEmail,
            Icon(
              Icons.email_rounded,
              size: 26,
              color: lightColorScheme.tertiary,
            ),
            router.pushEmailRoute,
          ),
          const SizedBox(height: 12),
          _buildLoginSocialButton(
            context,
            context.i10n.continueWithSms,
            Icon(
              kIsWeb
                  ? Icons.phone
                  : Platform.isAndroid
                      ? Icons.phone_android_rounded
                      : Icons.phone_iphone_rounded,
              size: 26,
              color: lightColorScheme.tertiary,
            ),
            router.pushPhoneRoute,
          ),
          const SizedBox(height: 32),
          CupertinoButton(
            onPressed: router.pop,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  context.i10n.goBack.toUpperCase(),
                  style: context.textStyle.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginSocialButton(
    BuildContext context,
    String name,
    Widget icon,
    VoidCallback onPressed,
  ) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(width: 16),
            Text(
              name.toUpperCase(),
              style: context.textStyle.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
