import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/common_pages/create_collection/cubit/create_collection_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/create_collection/cubit/create_collection_state.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:kingfishertom/features/widgets/search_field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateCollectionPage extends StatefulWidget {
  const CreateCollectionPage._({
    required this.onEnd,
  });

  static void showModalDialog(
    BuildContext context,
    ValueSetter<String> onEnd,
  ) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider<CreateCollectionCubit>(
        create: (_) => CreateCollectionCubit.create(),
        child: CreateCollectionPage._(onEnd: onEnd),
      ),
    );
  }

  final ValueSetter<String> onEnd;

  @override
  State<CreateCollectionPage> createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  CreateCollectionCubit _getCubit(BuildContext context) => context.read();

  void _onStateChanged(BuildContext context, CreateCollectionState state) {
    switch (state.status) {
      case CreateCollectionStatus.error:
        state.errorMessage.showSnackBarInfo;
      case CreateCollectionStatus.success:
        widget.onEnd(state.name);

      case CreateCollectionStatus.loading:
      case CreateCollectionStatus.initial:
    }
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return BlocConsumer<CreateCollectionCubit, CreateCollectionState>(
      listener: _onStateChanged,
      builder: (BuildContext context, CreateCollectionState state) {
        return Container(
          height: MediaQuery.of(context).size.height - padding.top - 100,
          decoration: BoxDecoration(
            color: lightColorScheme.onPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 16, 16),
            margin: MediaQuery.of(context).viewInsets,
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
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.i10n.createNewCustomCollection,
                  style: context.textStyle.headlineMedium,
                ),
                const SizedBox(height: 24),
                SearchField(
                  hintText: '',
                  autofocus: true,
                  usePrefixIcon: false,
                  onChanged: _getCubit(context).setName,
                ),
                const Spacer(),
                AppButton(
                  style: AppThemeModel.instance.getWelcomeButtonTheme().style,
                  enabled: state.name.isNotEmpty,
                  withArrow: false,
                  loading: state.status == CreateCollectionStatus.loading,
                  onPressed: _getCubit(context).createCollection,
                  text: context.i10n.createCollection.toUpperCase(),
                ),
                SizedBox(height: padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
