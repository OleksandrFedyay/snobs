import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

class FilePickerFile extends StatefulWidget {
  const FilePickerFile({
    required this.name,
    required this.onChanged,
    required this.onComplete,
    super.key,
  });

  final String name;
  final VoidCallback onChanged;
  final ValueSetter<ValueSetter<List<File>>> onComplete;

  @override
  State<FilePickerFile> createState() => _FilePickerFileState();
}

class _FilePickerFileState extends State<FilePickerFile> {
  Future<void> _onFilePick(FormFieldState<List<File>?> state) async {
    widget.onComplete((List<File> files) {
      state.didChange(files);
      widget.onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<File>?>(
      name: widget.name,
      builder: (FormFieldState<List<File>?> state) {
        return GestureDetector(
          onTap: () => _onFilePick(state),
          behavior: HitTestBehavior.opaque,
          child: _buildField(state),
        );
      },
    );
  }

  Widget _buildField(FormFieldState<List<File>?> state) {
    final List<File>? files = state.value;
    if (files == null) {
      return _buildFileDownloadStack();
    }

    return Stack(
      children: <Widget>[
        _buildActiveFile(),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightColorScheme.yellowLight,
            ),
            alignment: Alignment.center,
            child: Text(
              files.length.toString(),
              style: context.textStyle.titleSmall,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => state.didChange(null),
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.cancel_outlined,
              color: lightColorScheme.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileDownloadStack() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: lightColorScheme.onSurface,
        borderRadius: BorderRadius.circular(80),
      ),
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: pi / 4,
        child: const Icon(
          Icons.attach_file_rounded,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActiveFile() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: lightColorScheme.onSurface,
        borderRadius: BorderRadius.circular(80),
      ),
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: pi / 4,
        child: const Icon(
          Icons.attach_file_rounded,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}
