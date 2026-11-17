import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/mixins/rebuild_mixin.dart';


class ProfileField extends StatefulWidget {
  const ProfileField({
    required this.name,
    required this.hintText,
    required this.onChanged,
    super.key,
    this.initialValue,
    this.validator,
    this.inputFormatters,
    this.prefix,
  });

  final String name;
  final String hintText;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final VoidCallback onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefix;

  @override
  State<ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> with RebuildMixin<ProfileField> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(52),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: widget.name,
      controller: textEditingController,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      inputFormatters: widget.inputFormatters,
      onChanged: (_) => widget.onChanged(),
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        errorBorder: border,
        focusedErrorBorder: border,
        border: border,
        fillColor: lightColorScheme.secondary,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        hintText: widget.hintText,
        prefixText: widget.prefix,
        hintStyle: const TextStyle(
          color: Colors.white30,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
