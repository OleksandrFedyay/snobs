import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback_type.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/cubit/feedback_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/cubit/feedback_state.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/success_view.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/view/description_field.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/view/file_picker_file.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum FeedbackField {
  artistName,
  subgenre,
  email,
  description,
  file,
}

class FeedbackView extends StatefulWidget {
  const FeedbackView._();

  static Widget create([FeedbackType? initialType]) {
    return BlocProvider<FeedbackCubit>(
      create: (BuildContext context) =>
          FeedbackCubit.create()..init(initialType),
      child: const FeedbackView._(),
    );
  }

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic>? get _formValues => _formKey.currentState?.value;

  FeedbackCubit _getCubit(BuildContext context) => context.read();

  void _sendFeedback(BuildContext context, FeedbackState state) {
    _getCubit(context).createFeedback(
      FeedbackDto(
        type: state.type,
        text: _formValues?[FeedbackField.description.name] as String? ?? '',
        artistName:
            _formValues?[FeedbackField.artistName.name] as String? ?? '',
        subgenre: _formValues?[FeedbackField.subgenre.name] as String? ?? '',
        email: _formValues?[FeedbackField.email.name] as String? ?? '',
      ),
      _formValues?[FeedbackField.file.name] as List<File>? ?? <File>[],
      artist: null,
    );
  }

  void _onStateChanged(BuildContext context, FeedbackState state) {
    switch (state.status) {
      case FeedbackStatus.error:
        state.errorMessage.showSnackBarInfo;
      case FeedbackStatus.success:
        Navigator.of(context).pop();
        showMaterialModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => const SuccessView(),
        );

      case FeedbackStatus.loading:
      case FeedbackStatus.initial:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.75,
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
        color: lightColorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Container(
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
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: BlocConsumer<FeedbackCubit, FeedbackState>(
          listener: _onStateChanged,
          builder: _buildContent,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FeedbackState state) {
    return FormBuilder(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
        children: <Widget>[
          Center(
            child: Text(
              context.i10n.howCanWeHelpYou,
              style: context.textStyle.headlineMedium,
            ),
          ),
          const SizedBox(height: 32),
          _buildTypes(state),
          const SizedBox(height: 32),
          _buildFields(state),
          const SizedBox(height: 40),
          _buildControls(state),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
        ],
      ),
    );
  }

  Widget _buildTypes(FeedbackState state) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: FeedbackType.values.map(
        (FeedbackType type) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _getCubit(context).setFeedbackType(type),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(42),
                border: Border.all(
                  color: state.type == type
                      ? lightColorScheme.yellowLight
                      : Colors.white30,
                ),
              ),
              child: Text(
                type.getTitle(context),
                style: context.textStyle.bodyLarge?.copyWith(
                  color: state.type == type
                      ? lightColorScheme.yellowLight
                      : lightColorScheme.onSecondary,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildFields(FeedbackState state) {
    switch (state.type) {
      case FeedbackType.reportIssue:
        return Column(
          children: <Widget>[
            Text(
              context.i10n.reportAnIssue,
              style: context.textStyle.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.description.name,
              context.i10n.pleaseShareDetailsYourIssue,
              4,
              4,
            ),
          ],
        );
      case FeedbackType.feature:
        return Column(
          children: <Widget>[
            Text(
              context.i10n.featureRequest,
              style: context.textStyle.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.description.name,
              context.i10n.pleaseShareYourIdeaHere,
              4,
              4,
            ),
          ],
        );
      case FeedbackType.artistIssue:
        return Column(
          children: <Widget>[
            Text(
              context.i10n.artistIssue,
              style: context.textStyle.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.artistName.name,
              context.i10n.artistName,
              null,
              null,
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.description.name,
              context.i10n.pleaseShareWhatNeedsUpdating,
              2,
              2,
            ),
          ],
        );
      case FeedbackType.missingArtist:
        return Column(
          children: <Widget>[
            Text(
              context.i10n.missingArtist,
              style: context.textStyle.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.artistName.name,
              context.i10n.writeArtistNameHere,
              null,
              null,
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.description.name,
              context.i10n.shareURLToArtistsMusicPage,
              2,
              2,
            ),
          ],
        );
      case FeedbackType.support:
        return Column(
          children: <Widget>[
            Text(
              context.i10n.support,
              style: context.textStyle.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.email.name,
              context.i10n.yourEmail,
              null,
              null,
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.description.name,
              context.i10n.pleaseShareHowWeCanHelpHere,
              2,
              2,
            ),
          ],
        );
      case FeedbackType.subgenreRequest:
        return Column(
          children: <Widget>[
            Text(
              context.i10n.requestSubgenre,
              style: context.textStyle.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.subgenre.name,
              context.i10n.writeSubgenreNameHere,
              null,
              null,
            ),
            const SizedBox(height: 8),
            _buildField(
              FeedbackField.description.name,
              context.i10n.write2ExampleArtistNamesHere,
              2,
              2,
            ),
          ],
        );
    }
  }

  Widget _buildField(
    String name,
    String hintText,
    int? minLines,
    int? maxLines,
  ) {
    return DescriptionField(
      key: ValueKey<String>(name),
      hintText: hintText,
      minLines: minLines,
      maxLines: maxLines,
      validator: FormBuilderValidators.required(
        errorText: context.i10n.emptyFieldMessage,
      ),
      onChanged: (_) {
        final bool valid = _formKey.currentState?.saveAndValidate() ?? false;

        _getCubit(context).setButtonEnabled(buttonEnabled: valid);
      },
      name: name,
    );
  }

  Widget _buildControls(FeedbackState state) {
    return Row(
      children: <Widget>[
        FilePickerFile(
          name: FeedbackField.file.name,
          onChanged: () {
            final bool valid =
                _formKey.currentState?.saveAndValidate() ?? false;

            _getCubit(context).setButtonEnabled(buttonEnabled: valid);
          },
          onComplete: _getCubit(context).pickFile,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppButton(
            withArrow: false,
            style: AppThemeModel.instance.getWelcomeButtonTheme().style,
            onPressed: () => _sendFeedback(context, state),
            loading: state.status == FeedbackStatus.loading,
            text: context.i10n.submit.toUpperCase(),
            enabled: state.buttonEnabled,
          ),
        ),
      ],
    );
  }
}
