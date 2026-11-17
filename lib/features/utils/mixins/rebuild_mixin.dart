import 'package:flutter/material.dart';

mixin RebuildMixin<T extends StatefulWidget> on State<T> {
  void setStateIfMounted([VoidCallback? fn]) {
    if (mounted) setState(fn ?? () {});
  }
}
