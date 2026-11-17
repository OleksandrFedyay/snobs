import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    required this.hintText,
    required this.onChanged,
    required this.name,
    super.key,
    this.withSpotifyIcon = true,
    this.validator,
    this.minLines,
    this.maxLines,
  });

  final String hintText;
  final ValueSetter<String?> onChanged;
  final bool withSpotifyIcon;
  final FormFieldValidator<String>? validator;
  final String name;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Colors.white54,
      ),
    );
    return FormBuilderTextField(
      name: name,
      style: const TextStyle(color: Colors.white),
      onChanged: (String? value) => onChanged(value?.trim()),
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        border: border,
        fillColor: lightColorScheme.surfaceContainerHighest,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
