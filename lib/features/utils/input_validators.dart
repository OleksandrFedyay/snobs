import 'package:flutter/material.dart';

import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

String? Function(String?) passwordValidator(BuildContext context) {
  return (String? password) {
    if (password == null || password.isEmpty) {
      return context.i10n.emptyFieldMessage;
    }

    if (password.length > 5) return null;

    return context.i10n.invalidPassword;
  };
}
