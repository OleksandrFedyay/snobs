import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/profile_edit/cubit/profile_edit_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/profile_edit/view/profile_edit_field.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:kingfishertom/features/widgets/user_avatar.dart';

enum ProfilePageFields {
  name,
  lastName,
  email,
  zipCode,
}

@RoutePage()
class ProfileEditPage extends StatefulWidget implements AutoRouteWrapper {
  const ProfileEditPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ProfileEditCubit>(
      create: (_) => ProfileEditCubit.create(),
      child: this,
    );
  }

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  ProfileEditCubit _getCubit(BuildContext context) => context.read();

  void _onFilePick(ValueSetter<File> onComplete) {
    _getCubit(context).pickProfilePhoto(
      onComplete: onComplete,
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          hideBottomControls: true,
          toolbarColor: lightColorScheme.main,
        ),
        IOSUiSettings(
          doneButtonTitle: context.i10n.done,
          cancelButtonTitle: context.i10n.cancel,
        ),
      ],
    );
  }

  //Todo(Issa): here is wrong enum, need [MenuStatus]
  void _onStateChanged(BuildContext context, ProfileEditState state) {
    if (state.status == ProfileStatus.error) {
      showTopSnackBar(context, state.errorMessage);
    }
    if (state.status == ProfileStatus.success) {
      router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 4, top: padding.top),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      lightColorScheme.primaryContainer,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: router.pop,
                      icon: Icon(
                        Icons.adaptive.arrow_back,
                        color: Colors.white54,
                      ),
                      iconSize: 20,
                    ),
                    const Spacer(flex: 2),
                    Text(
                      context.i10n.profile,
                      style: context.textStyle.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<ProfileEditCubit, ProfileEditState>(
      listener: _onStateChanged,
      builder: (BuildContext context, ProfileEditState state) {
        if (state.status == ProfileStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                if (state.user?.imageUrl == null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onFilePick(_getCubit(context).updatePhoto),
                    child: Container(
                      width: 144,
                      height: 144,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: lightColorScheme.yellowLight,
                          width: 2,
                        ),
                        color: lightColorScheme.secondary,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: lightColorScheme.yellowLight,
                          ),
                          Text(
                            context.i10n.add.toUpperCase(),
                            style: context.textStyle.labelMedium?.copyWith(
                              color: lightColorScheme.yellowLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onFilePick(_getCubit(context).updatePhoto),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: <Widget>[
                        UserAvatar(
                          user: state.user,
                          radius: 72,
                          borderColor: Colors.transparent,
                        ),
                        CircleAvatar(
                          backgroundColor:
                              lightColorScheme.surfaceContainerHighest,
                          child: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),
                if (state.user?.isUnCompleteProfileInfo ?? true)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      border: Border.all(
                        color: lightColorScheme.onErrorContainer,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.warning_rounded,
                          color: lightColorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.i10n.completeYourProfile.toUpperCase(),
                          style: context.textStyle.labelMedium,
                        ),
                      ],
                    ),
                  ),
                _buildNameField(state),
                const SizedBox(height: 16),
                _buildLastNameField(state),
                const SizedBox(height: 16),
                _buildEmailField(state),
                const SizedBox(height: 16),
                _buildZipField(state),
                const SizedBox(height: 24),
                AppButton(
                  style: AppThemeModel.instance.getWelcomeButtonTheme().style,
                  onPressed: () {
                    _getCubit(context).updateUser(
                      _formKey.currentState?.value ?? <String, dynamic>{},
                    );
                  },
                  withArrow: false,
                  text: context.i10n.save.toUpperCase(),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: router.pop,
                  child: Text(
                    context.i10n.cancel.toUpperCase(),
                    style: context.textStyle.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameField(ProfileEditState state) {
    return ProfileField(
      name: ProfilePageFields.name.name,
      initialValue: state.user?.name,
      hintText: context.i10n.name,
      onChanged: () {
        _formKey.currentState?.save();
        _formKey.currentState?.fields[ProfilePageFields.name.name]?.validate();
      },
    );
  }

  Widget _buildLastNameField(ProfileEditState state) {
    return ProfileField(
      name: ProfilePageFields.lastName.name,
      initialValue: state.user?.lastName,
      hintText: context.i10n.lastName,
      onChanged: () {
        _formKey.currentState?.save();
        _formKey.currentState?.fields[ProfilePageFields.lastName.name]
            ?.validate();
      },
    );
  }

  Widget _buildEmailField(ProfileEditState state) {
    return ProfileField(
      name: ProfilePageFields.email.name,
      initialValue: state.user?.email,
      hintText: context.i10n.email,
      onChanged: () {
        _formKey.currentState?.save();
        _formKey.currentState?.fields[ProfilePageFields.email.name]?.validate();
      },
      validator: FormBuilderValidators.email(
        errorText: context.i10n.invalidEmail,
      ),
    );
  }

  Widget _buildZipField(ProfileEditState state) {
    return ProfileField(
      name: ProfilePageFields.zipCode.name,
      initialValue: state.user?.zipCode,
      hintText: context.i10n.zipCode,
      onChanged: () {
        _formKey.currentState?.save();
        _formKey.currentState?.fields[ProfilePageFields.zipCode.name]
            ?.validate();
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
      ],
      validator: FormBuilderValidators.minLength(
        5,
        errorText: context.i10n.zipCodeShouldContainFiveDigits,
      ),
    );
  }
}
