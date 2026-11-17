import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback.dto.dart';

const String _feedbackCollectionName = 'feedbacks';

@LazySingleton()
class RemoteFeedbackDataSource {
  RemoteFeedbackDataSource(this._firebaseFireStore);

  final FirebaseFirestore _firebaseFireStore;

  Future<void> createFeedback(
    FeedbackDto feedbackDto,
    List<File> files,
  ) async {
    final FeedbackDto feedback =
        feedbackDto.copyWith(files: await _uploadPhotoUrl(files));

    await _firebaseFireStore.collection(_feedbackCollectionName).doc().set(
          feedback.toJson(),
        );
  }

  Future<List<String>> _uploadPhotoUrl(List<File> files) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? id = user?.uid;

    final List<String> result = <String>[];

    for (final File file in files) {
      final Reference ref = FirebaseStorage.instance.ref().child(
            '$id.feedback${file.path}',
          );
      await ref.putFile(file);

      result.add(await ref.getDownloadURL());
    }

    return result;
  }
}
