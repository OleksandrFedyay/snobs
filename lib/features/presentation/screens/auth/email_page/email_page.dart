import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/auth/email_page/cubit/email_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/icons/snobs_icons.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';

enum EmailFields {
  email,
}

@RoutePage()
class EmailPage extends StatelessWidget implements AutoRouteWrapper {
  EmailPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<EmailPageCubit>(
      create: (_) => EmailPageCubit.create(),
      child: this,
    );
  }

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic>? get _formValues => _formKey.currentState?.value;

  EmailPageCubit cubit(BuildContext context) => context.read();

  void _onEmailSubmitted(BuildContext context) {
    cubit(context).setButtonEnabled(
      buttonEnabled: _formKey.currentState?.saveAndValidate() ?? false,
    );
  }

  void _onStateChanged(BuildContext context, EmailPageState state) {
    switch (state.status) {
      case EmailPageStatus.error:
        state.errorMessage.showSnackBarInfo;
      case EmailPageStatus.success:
        router.pushAndClearStackNameRoute();
      case EmailPageStatus.initial:
      case EmailPageStatus.loading:
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
            child: BlocConsumer<EmailPageCubit, EmailPageState>(
              listener: _onStateChanged,
              builder: _buildBody,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EmailPageState state) {
    if (state.status == EmailPageStatus.loading) {
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
            context.i10n.enterEmail,
            textAlign: TextAlign.center,
            style:
                context.textStyle.headlineLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            context.i10n.enterYourEmailToContinue,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 32),
          FormBuilderTextField(
            style: context.textStyle.titleMedium,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            name: EmailFields.email.name,
            onChanged: (_) => _onEmailSubmitted(context),
            validator: FormBuilderValidators.compose(<FormFieldValidator<String>>[
              FormBuilderValidators.email(
                errorText: context.i10n.invalidEmail,
              ),
              FormBuilderValidators.required(
                errorText: context.i10n.emptyFieldMessage,
              ),
            ]),
            decoration: InputDecoration(
              hintText: context.i10n.enterEmailAddress,
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            style: AppThemeModel.instance.getWelcomeButtonTheme().style,
            enabled: state.buttonEnabled,
            withArrow: false,
            onPressed: () {
              router.pushPasswordRoute(
                _formValues?[EmailFields.email.name] as String? ?? '',
              );
            },
            text: context.i10n.submit.toUpperCase(),
          ),
          const SizedBox(height: 100),
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
