import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    required this.onChanged,
    super.key,
    this.value = 0.5,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  final double? value;
  final ValueSetter<double?> onChanged;
  final EdgeInsetsGeometry padding;

  @override
  State<CustomSlider> createState() => CustomSliderState();
}

class CustomSliderState extends State<CustomSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();

    _value = widget.value ?? 0.5;
  }

  @override
  void didUpdateWidget(CustomSlider oldWidget) {
    if (oldWidget.value != widget.value) _value = widget.value ?? 0.5;
    super.didUpdateWidget(oldWidget);
  }

  void _onChangedValue(dynamic value) {
    if (value! is double) return;

    setState(() {
      _value = value as double;
    });
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: SfSliderTheme(
        data: const SfSliderThemeData(
          overlayRadius: 8,
          activeTrackHeight: 8,
          inactiveTrackHeight: 8,
          trackCornerRadius: 8,
          thumbRadius: 4,
        ),
        child: SfSlider(
          activeColor: lightColorScheme.yellowLight,
          inactiveColor: lightColorScheme.onSurface,
          value: _value == 0 ? 0.01 : _value,
          onChanged: _onChangedValue,
        ),
      ),
    );
  }
}
