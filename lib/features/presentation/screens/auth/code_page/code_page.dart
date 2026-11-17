import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/auth/code_page/cubit/code_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/icons/snobs_icons.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

@RoutePage()
class CodePage extends StatelessWidget implements AutoRouteWrapper {
  CodePage({
    required this.phone,
    super.key,
  });

  final String phone;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<CodePageCubit>(
      create: (_) => CodePageCubit.create(phone),
      child: this,
    );
  }

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  CodePageCubit cubit(BuildContext context) => context.read();

  void _onStateChanged(BuildContext context, CodePageState state) {
    switch (state.status) {
      case CodePageStatus.error:
        state.errorMessage.showSnackBarInfo;
      case CodePageStatus.success:
        if (state.userName.isNotEmpty) {
          router.pushAndClearStackSelectGenreRoute('');
        } else {
          router.pushAndClearStackNameRoute();
        }

      case CodePageStatus.loading:
      case CodePageStatus.initial:
      case CodePageStatus.loadingButton:
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
            child: BlocConsumer<CodePageCubit, CodePageState>(
              listener: _onStateChanged,
              builder: _buildBody,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CodePageState state) {
    if (state.status == CodePageStatus.loading) {
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
            context.i10n.enterCode,
            textAlign: TextAlign.center,
            style:
                context.textStyle.headlineLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildPhoneContainer(),
          const SizedBox(height: 32),
          _buildOtpField(context),
          const SizedBox(height: 4),
          AppButton(
            style: AppThemeModel.instance.getWelcomeButtonTheme().style,
            enabled: state.code.length == 6,
            withArrow: false,
            loading: state.status == CodePageStatus.loadingButton,
            onPressed: () {
              cubit(context).verifyOtp();
            },
            text: context.i10n.submit.toUpperCase(),
          ),
          const SizedBox(height: 100),
          _buildGoBack(context),
        ],
      ),
    );
  }

  Widget _buildPhoneContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: lightColorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        phone,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      animationType: AnimationType.fade,
      textStyle: context.textStyle.titleMedium,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      backgroundColor: Colors.transparent,
      pinTheme: PinTheme(
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        activeColor: Colors.white,
        disabledColor: Colors.white,
        inactiveColor: Colors.white,
        selectedColor: Colors.white,
        borderWidth: 0,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(50),
        fieldHeight: 48,
        fieldWidth: 42,
        fieldOuterPadding: EdgeInsets.zero,
        activeFillColor: Colors.white,
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      onChanged: (String value) => cubit(context).setCode(value),
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
