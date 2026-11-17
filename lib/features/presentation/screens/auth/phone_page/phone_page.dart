import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/auth/phone_page/cubit/phone_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/icons/snobs_icons.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';

@RoutePage()
class PhonePage extends StatelessWidget implements AutoRouteWrapper {
  PhonePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<PhonePageCubit>(
      create: (_) => PhonePageCubit.create(),
      child: this,
    );
  }

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  PhonePageCubit cubit(BuildContext context) => context.read();

  void _onPhoneChanged(BuildContext context, PhoneNumber phone) {
    cubit(context).setPhoneAndButtonEnabled(
      phone.completeNumber,
      buttonEnabled: _formKey.currentState?.saveAndValidate() ?? false,
    );
  }

  void _onStateChanged(BuildContext context, PhonePageState state) {
    switch (state.status) {
      case PhonePageStatus.error:
        state.errorMessage.showSnackBarInfo;
      case PhonePageStatus.success:
        router.pushAndClearStackNameRoute();

      case PhonePageStatus.loading:
      case PhonePageStatus.initial:
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
              lightColorScheme.deepPurple.withValues(alpha:.6),
              lightColorScheme.deepPurple,
            ],
          ),
        ),
        child: SafeArea(
          child: FormBuilder(
            key: _formKey,
            child: BlocConsumer<PhonePageCubit, PhonePageState>(
              listener: _onStateChanged,
              builder: _buildBody,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PhonePageState state) {
    if (state.status == PhonePageStatus.loading) {
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
            context.i10n.enterMobileNumber,
            textAlign: TextAlign.center,
            style:
                context.textStyle.headlineLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 32),
          _buildPhoneField(context),
          const SizedBox(height: 4),
          AppButton(
            style: AppThemeModel.instance.getWelcomeButtonTheme().style,
            enabled: state.buttonEnabled,
            withArrow: false,
            onPressed: () => router.pushCodeRoute(state.phone),
            text: context.i10n.submit.toUpperCase(),
          ),
          const SizedBox(height: 100),
          _buildGoBack(context),
        ],
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.copyWith(
          bodyLarge: const TextStyle(color: Colors.black),
        ),
      ),
      child: IntlPhoneField(
        pickerDialogStyle: PickerDialogStyle(
          backgroundColor: lightColorScheme.onSecondaryContainer,
          searchFieldInputDecoration: InputDecoration(
            hintText: context.i10n.searchCountry,
          ),
          countryNameStyle: const TextStyle(color: Colors.white),
        ),
        style: context.textStyle.titleMedium,
        dropdownTextStyle: context.textStyle.titleMedium,
        decoration: InputDecoration(
          hintText: context.i10n.enterMobileNumber,
          prefixStyle: context.textStyle.titleMedium,
        ),
        invalidNumberMessage: context.i10n.invalidMobileNumber,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        onChanged: (PhoneNumber phone) => _onPhoneChanged(context, phone),
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
