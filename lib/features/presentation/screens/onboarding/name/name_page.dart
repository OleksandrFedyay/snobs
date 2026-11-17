import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/onboarding/name/cubit/name_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';

enum NameFields {
  name,
}

@RoutePage()
class NamePage extends StatefulWidget implements AutoRouteWrapper {
  const NamePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<NamePageCubit>(
      create: (_) => NamePageCubit.create(),
      child: this,
    );
  }

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  late final FocusNode focusNode;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });
    controller = TextEditingController();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic>? get _formValues => _formKey.currentState?.value;

  NamePageCubit cubit(BuildContext context) => context.read();

  void _onNameChanged(BuildContext context) {
    final bool? valid = _formKey.currentState?.saveAndValidate();
    cubit(context).setButtonEnabled(buttonEnabled: valid ?? false);
  }

  void _onStateChanged(BuildContext context, NamePageState state) {
    switch (state.status) {
      case NamePageStatus.error:
        state.errorMessage.showSnackBarInfo;
      case NamePageStatus.success:
        router.pushSelectGenreRoute(
          _formValues?[NameFields.name.name] as String? ?? '',
        );

      case NamePageStatus.initial:
        if (state.initialName.isEmpty) return;

        controller.text = state.initialName;
      case NamePageStatus.loadingButton:
    }
  }

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(52),
    borderSide: const BorderSide(
      color: Colors.white54,
    ),
  );

  final OutlineInputBorder focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(52),
    borderSide: const BorderSide(width: 0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: BlocConsumer<NamePageCubit, NamePageState>(
            listener: _onStateChanged,
            listenWhen: (NamePageState previous, NamePageState current) =>
                previous.status != current.status,
            builder: _buildBody,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NamePageState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          Text(
            context.i10n.whatShouldWeCallYou,
            style: context.textStyle.headlineSmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          FormBuilderTextField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            name: NameFields.name.name,
            onChanged: (_) => _onNameChanged(context),
            validator: FormBuilderValidators.required(
              errorText: context.i10n.emptyFieldMessage,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
              errorBorder: border,
              focusedErrorBorder: focusBorder,
              border: border,
              fillColor: focusNode.hasFocus
                  ? lightColorScheme.secondary
                  : lightColorScheme.surfaceContainerHighest,
              enabledBorder: border,
              focusedBorder: focusBorder,
              disabledBorder: border,
              hintText: context.i10n.enterYourName,
              hintStyle: const TextStyle(
                color: Colors.white30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            width: 160,
            style: AppThemeModel.instance.getWelcomeButtonTheme().style,
            enabled: state.buttonEnabled,
            withArrow: false,
            loading: state.status == NamePageStatus.loadingButton,
            onPressed: () {
              if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

              cubit(context).saveName(
                _formValues?[NameFields.name.name] as String? ?? '',
              );
            },
            text: context.i10n.continueTitle.toUpperCase(),
          ),
        ],
      ),
    );
  }
}
