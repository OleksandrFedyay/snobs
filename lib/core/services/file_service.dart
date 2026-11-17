import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

@injectable
class FileService extends BaseExceptionService {
  Future<void> pickProfilePhoto({
    required ValueSetter<File> onComplete,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    await makeErrorParsedCall(() async {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

      final String? filePath = result?.files.firstOrNull?.path;
      if (filePath == null) return;

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatio: const CropAspectRatio(ratioX: 10, ratioY: 10),
        uiSettings: uiSettings,
      );

      final String? croppedFilePath = croppedFile?.path;
      if (croppedFilePath == null) return;

      onComplete(File(croppedFilePath));
    });
  }

  Future<void> pickFile(ValueSetter<List<File>> onComplete) async {
    await makeErrorParsedCall(() async {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      final Iterable<File> files = result?.files.map((PlatformFile file) => File(file.path ?? '')) ?? <File>[];

      onComplete(files.where((File file) => file.path.isNotEmpty).toList());
    });
  }
}
