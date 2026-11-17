// ignore_for_file: implementation_imports

import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/src/entities/problem.dart';

@injectable
class RequestSubgenreUseCase extends BaseExceptionService {
  RequestSubgenreUseCase();

  Future<void> call(
    String subgenre,
    String artistExamples,
    UserModel? user,
  ) async {
    await makeErrorParsedCall(() async {
      const String username = 'hellosnobs@gmail.com';
      const String password = 'jeje vddd abxp aqwm';
      final SmtpServer smtpServer = gmail(username, password);

      final Message message = Message()
        ..from = const Address(username)
        ..recipients.add('tom.hickey@kingfishergo.com')
        ..subject = 'Request Subgenre'
        ..text = '''
Subgenre name  - $subgenre

Example artist names - $artistExamples

User - ${user?.toEmailJson()}
''';

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
