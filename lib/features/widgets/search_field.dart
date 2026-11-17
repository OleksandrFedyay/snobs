import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.autofocus = false,
    this.usePrefixIcon = true,
    super.key,
  });

  final String hintText;
  final ValueSetter<String> onChanged;
  final TextEditingController? controller;
  final bool autofocus;
  final bool usePrefixIcon;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(52),
      borderSide: const BorderSide(
        color: Colors.white54,
      ),
    );
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: controller,
            autofocus: autofocus,
            style: const TextStyle(color: Colors.white),
            onChanged: (String value) => onChanged(value.trim()),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
              border: border,
              fillColor: lightColorScheme.surfaceContainerHighest,
              enabledBorder: border,
              focusedBorder: border,
              disabledBorder: border,
              hintText: hintText,
              prefixIcon: usePrefixIcon
                  ? const Icon(
                      Icons.search_outlined,
                      color: Colors.white54,
                    )
                  : null,
              hintStyle: const TextStyle(
                color: Colors.white30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
