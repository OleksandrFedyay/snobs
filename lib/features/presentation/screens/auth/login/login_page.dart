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
class LoginPage extends StatelessWidget implements AutoRouteWrapper {
  const LoginPage({super.key});

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
          const Spacer(flex: 4),
          const Align(
            alignment: Alignment(-0.5, 0),
            child: Icon(
              SnobsIcons.snobsLogo,
              size: 100,
            ),
          ),
          Text(
            context.i10n.weAreAnInclusiveCommunityOfMusicEnthusiasts,
            style: context.textStyle.headlineSmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: lightColorScheme.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            context.i10n.weAreGladYouAreJoiningUs,
            style: context.textStyle.bodySmall?.copyWith(
              color: lightColorScheme.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 5),
          _buildLoginSocialButton(context),
          const SizedBox(height: 16),
          CupertinoButton(
            onPressed: router.pushOptionsRoute,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  context.i10n.moreOptions.toUpperCase(),
                  style: context.textStyle.labelMedium,
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLoginSocialButton(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();

    if (Platform.isAndroid) {
      return CupertinoButton(
        onPressed: cubit(context).signInViaGoogle,
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54),
            borderRadius: BorderRadius.circular(200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                Assets.icons.googleLogo,
                height: 24,
              ),
              const SizedBox(width: 16),
              Text(
                context.i10n.continueWithGoogle,
                style: context.textStyle.labelMedium,
              ),
            ],
          ),
        ),
      );
    }

    return CupertinoButton(
      onPressed: cubit(context).signInViaApple,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54),
          borderRadius: BorderRadius.circular(200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(SnobsIcons.appleLogo, size: 24, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              context.i10n.continueWithApple.toUpperCase(),
              style: context.textStyle.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
