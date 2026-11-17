import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class VerificationView extends StatefulWidget {
  const VerificationView({
    required this.phoneNumber,
    required this.verify,
    super.key,
  });
  final String phoneNumber;
  final ValueSetter<String> verify;

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  String code = '';

  void _changeCode(String newCode) {
    setState(() {
      code = newCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
        color: lightColorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildTopDivider(context),
        const SizedBox(height: 12),
        Text(
          context.i10n.verifyMobileNumber,
          style: context.textStyle.labelLarge,
        ),
        const SizedBox(height: 32),
        Text(
          context.i10n.weHaveSentDigitCodeTo(6),
          style: context.textStyle.bodyLarge,
        ),
        const SizedBox(height: 4),
        _buildPhoneNumber(context),
        const SizedBox(height: 32),
        _buildOtpField(context),
        const SizedBox(height: 32),
        AppButton(
          enabled: code.length == 6,
          onPressed: () => widget.verify(code),
          text: context.i10n.verify.toUpperCase(),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }

  Widget _buildTopDivider(BuildContext context) {
    return Align(
      child: Container(
        height: 4,
        width: 44,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: lightColorScheme.tertiaryContainer,
        ),
      ),
    );
  }

  Widget _buildPhoneNumber(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white70),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Text(
        widget.phoneNumber,
        style: context.textStyle.bodyLarge,
      ),
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      animationType: AnimationType.fade,
      textStyle: context.textStyle.titleMedium?.copyWith(color: Colors.white),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      backgroundColor: Colors.transparent,
      pinTheme: PinTheme(
        inactiveFillColor: lightColorScheme.surfaceContainerHighest,
        selectedFillColor: lightColorScheme.surfaceContainerHighest,
        activeColor: lightColorScheme.surfaceContainerHighest,
        disabledColor: lightColorScheme.surfaceContainerHighest,
        inactiveColor: lightColorScheme.surfaceContainerHighest,
        selectedColor: lightColorScheme.surfaceContainerHighest,
        borderWidth: 0,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(50),
        fieldHeight: 48,
        fieldWidth: 50,
        fieldOuterPadding: EdgeInsets.zero,
        activeFillColor: lightColorScheme.surfaceContainerHighest,
      ),
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      onChanged: _changeCode,
    );
  }
}
