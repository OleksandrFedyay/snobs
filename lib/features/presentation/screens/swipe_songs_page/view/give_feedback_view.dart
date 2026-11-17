import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback_type.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/cubit/feedback_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/cubit/feedback_state.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/success_view.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/view/description_field.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum GiveFeedbackViewField {
  description,
}

class GiveFeedbackView extends StatefulWidget {
  const GiveFeedbackView._(this.artist);

  final ArtistChartDto artist;

  static Widget create(ArtistChartDto artist) {
    return BlocProvider<FeedbackCubit>(
      create: (BuildContext context) => FeedbackCubit.create(),
      child: GiveFeedbackView._(artist),
    );
  }

  @override
  State<GiveFeedbackView> createState() => _GiveFeedbackViewState();
}

class _GiveFeedbackViewState extends State<GiveFeedbackView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic>? get _formValues => _formKey.currentState?.value;

  FeedbackCubit _getCubit(BuildContext context) => context.read();

  void _sendFeedback(BuildContext context, FeedbackState state) {
    _getCubit(context).createFeedback(
      FeedbackDto(
        type: FeedbackType.artistIssue,
        text: _formValues?[GiveFeedbackViewField.description.name] as String? ??
            '',
        needUpdate: state.selectedNeed.join(', '),
      ),
      <File>[],
      artist: widget.artist,
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

      case FeedbackStatus.initial:
      case FeedbackStatus.loading:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
        color: lightColorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BlocConsumer<FeedbackCubit, FeedbackState>(
        listener: _onStateChanged,
        builder: _buildContent,
      ),
    );
  }

  Widget _buildContent(BuildContext context, FeedbackState state) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTopDivider(context),
          const SizedBox(height: 24),
          Text(
            context.i10n.whatNeedsUpdating,
            style: context.textStyle.headlineMedium,
          ),
          const SizedBox(height: 24),
          _buildNeeds(state),
          const SizedBox(height: 16),
          DescriptionField(
            hintText: context.i10n.pleaseProvideDetailsHere,
            validator: FormBuilderValidators.required(
              errorText: context.i10n.emptyFieldMessage,
            ),
            maxLines: 5,
            minLines: 5,
            onChanged: (_) {
              final bool valid =
                  _formKey.currentState?.saveAndValidate() ?? false;
              _getCubit(context).setButtonEnabled(buttonEnabled: valid);
            },
            name: GiveFeedbackViewField.description.name,
          ),
          const SizedBox(height: 40),
          AppButton(
            withArrow: false,
            loading: state.status == FeedbackStatus.loading,
            onPressed: () => _sendFeedback(context, state),
            text: context.i10n.submit.toUpperCase(),
            enabled: state.buttonEnabled,
          ),
          const SizedBox(height: 24),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildTopDivider(BuildContext context) {
    return Align(
      child: Container(
        height: 6,
        width: 86,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: lightColorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildNeeds(FeedbackState state) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 8,
      spacing: 4,
      children: <String>[
        context.i10n.artistName,
        context.i10n.artistImage,
        context.i10n.bio,
        context.i10n.songs,
        context.i10n.genreSubgenre,
      ].map((String e) {
        return GestureDetector(
          onTap: () => _getCubit(context).selectNeeds(e),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42),
              border: Border.all(
                color: state.selectedNeed.contains(e)
                    ? lightColorScheme.main
                    : Colors.white30,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              e,
              style: context.textStyle.bodyLarge?.copyWith(
                color: state.selectedNeed.contains(e)
                    ? Colors.white
                    : lightColorScheme.onSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
