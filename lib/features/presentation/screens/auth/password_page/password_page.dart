import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/auth/password_page/cubit/password_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/icons/snobs_icons.dart';
import 'package:kingfishertom/features/utils/input_validators.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';

enum PasswordFields {
  password,
}

@RoutePage()
class PasswordPage extends StatelessWidget implements AutoRouteWrapper {
  PasswordPage({
    required this.email,
    super.key,
  });

  final String email;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<PasswordPageCubit>(
      create: (_) => PasswordPageCubit.create(email),
      child: this,
    );
  }

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic>? get _formValues => _formKey.currentState?.value;

  PasswordPageCubit cubit(BuildContext context) => context.read();

  void _onPasswordChanged(BuildContext context) {
    final bool? valid = _formKey.currentState?.saveAndValidate();
    cubit(context).setButtonEnabled(buttonEnabled: valid ?? false);
  }

  void _onStateChanged(BuildContext context, PasswordPageState state) {
    switch (state.status) {
      case PasswordPageStatus.error:
        state.errorMessage.showSnackBarInfo;
      case PasswordPageStatus.passwordResset:
        state.errorMessage.showSnackBarInfo;
      case PasswordPageStatus.success:
        router.pushAndClearStackNameRoute();

      case PasswordPageStatus.loading:
      case PasswordPageStatus.loadingButton:
      case PasswordPageStatus.initial:
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
          child: FormBuilder(
            key: _formKey,
            child: BlocConsumer<PasswordPageCubit, PasswordPageState>(
              listener: _onStateChanged,
              builder: _buildBody,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PasswordPageState state) {
    if (state.status == PasswordPageStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          const Align(
            alignment: Alignment(-0.5, 0),
            child: Icon(
              SnobsIcons.snobsLogo,
              size: 100,
            ),
          ),
          const SizedBox(height: 100),
          Text(
            state.userExist
                ? context.i10n.enterPassword
                : context.i10n.addPasswordToCreateNewAccount,
            textAlign: TextAlign.center,
            style:
                context.textStyle.headlineLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: lightColorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          FormBuilderTextField(
            style: context.textStyle.titleMedium,
            name: PasswordFields.password.name,
            onChanged: (_) => _onPasswordChanged(context),
            validator: passwordValidator(context),
            obscureText: true,
            decoration: InputDecoration(
              hintText: context.i10n.enterPassword,
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            style: AppThemeModel.instance.getWelcomeButtonTheme().style,
            enabled: state.buttonEnabled,
            withArrow: false,
            loading: state.status == PasswordPageStatus.loadingButton,
            onPressed: () {
              if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

              cubit(context).signInOrRegisterViaEmail(
                email: email,
                password:
                    _formValues?[PasswordFields.password.name] as String? ?? '',
              );
            },
            text: context.i10n.finish.toUpperCase(),
          ),
          const SizedBox(height: 100),
          if (state.userExist) ...<Widget>[
            GestureDetector(
              onTap: () => cubit(context).forgetPasswordUseCase(email),
              behavior: HitTestBehavior.opaque,
              child: Text(
                context.i10n.forgotPassword.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          _buildGoBack(context),
        ],
      ),
    );
  }

  Widget _buildGoBack(BuildContext context) {
    return GestureDetector(
      onTap: context.router.maybePop,
      behavior: HitTestBehavior.opaque,
      child: Text(
        context.i10n.goBack.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
