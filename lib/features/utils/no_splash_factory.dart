import 'package:flutter/material.dart';

class NoSplashFactory extends InteractiveInkFeatureFactory {
  const NoSplashFactory();

  @override
  InteractiveInkFeature create({
    required Color color,
    required MaterialInkController controller,
    required Offset position,
    required RenderBox referenceBox,
    required TextDirection textDirection,
    bool containedInkWell = false,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    VoidCallback? onRemoved,
    double? radius,
    RectCallback? rectCallback,
  }) {
    return NoSplash(
      controller: controller,
      referenceBox: referenceBox,
    );
  }
}

class NoSplash extends InteractiveInkFeature {
  NoSplash({
    required super.controller,
    required super.referenceBox,
  }) : super(
          color: Colors.transparent,
          onRemoved: () {},
        );

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}
