// ignore_for_file: implementation_imports
import 'dart:developer';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback.dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.feedback.data_source.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/src/entities/problem.dart';

@injectable
class CreateFeedbackUseCase extends BaseExceptionService {
  CreateFeedbackUseCase(
    this.remoteFeedbackDataSource,
  );

  final RemoteFeedbackDataSource remoteFeedbackDataSource;

  Future<void> call(
    FeedbackDto feedbackDto,
    List<File> files, {
    required ArtistChartDto? artist,
  }) async {
    await makeErrorParsedCall(() async {
      await remoteFeedbackDataSource.createFeedback(feedbackDto, files);

      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      const String username = 'hellosnobs@gmail.com';
      const String password = 'jeje vddd abxp aqwm';
      final SmtpServer smtpServer = gmail(username, password);

      String additionalInfo = '';
      if (feedbackDto.artistName?.isNotEmpty ?? false) {
        additionalInfo += '\n\n Artist Name - ${feedbackDto.artistName}';
      }
      if (feedbackDto.subgenre?.isNotEmpty ?? false) {
        additionalInfo += '\n\n Subgenre - ${feedbackDto.subgenre}';
      }
      if (feedbackDto.email?.isNotEmpty ?? false) {
        additionalInfo += '\n\n Email - ${feedbackDto.email}';
      }

      final Message message = Message()
        ..from = const Address(username)
        ..recipients.add('tom.hickey@kingfishergo.com')
        ..subject = artist == null ? 'General Feedback' : 'Artist Feedback'
        ..attachments = files.map(FileAttachment.new).toList()
        ..text = artist == null
            ? '''
Update Category  - ${feedbackDto.type.name}

User - ${user?.toEmailJson()}

Details - ${feedbackDto.text}
$additionalInfo'''
            : '''
Update category - ${artist.toJson()}

User - ${user?.toEmailJson()}

Details - ${feedbackDto.text}

Selected - ${feedbackDto.needUpdate}''';

      try {
        final SendReport sendReport = await send(message, smtpServer);
        log('Message sent: $sendReport');
      } on MailerException catch (e) {
        log('Message not sent.');
        for (final Problem p in e.problems) {
          log('Problem: ${p.code}: ${p.msg}');
        }
      }
    });
  }
}
