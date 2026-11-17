// ignore_for_file: implementation_imports
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_subgenres.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.like_genre.data_source.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/src/entities/problem.dart';

@injectable
class GetArtistOverridesUseCase extends BaseExceptionService {
  GetArtistOverridesUseCase(this.remoteLikeGenreDataSource);

  final RemoteLikeGenreDataSource remoteLikeGenreDataSource;

  Future<List<ArtistSubgenres>> call() {
    return makeErrorParsedCall(() async {
      return remoteLikeGenreDataSource.getArtistsOverrides();
    });
  }
}

@injectable
class UserOverridesUseCase extends BaseExceptionService {
  UserOverridesUseCase(
    this.likeGenreDataSource,
  );

  final RemoteLikeGenreDataSource likeGenreDataSource;

  Future<ArtistSubgenres?> call(String artistId) {
    return makeErrorParsedCall(() async {
      return likeGenreDataSource.getArtistSubgenres(artistId);
    });
  }
}

@injectable
class UpdateUserOverridesUseCase extends BaseExceptionService {
  UpdateUserOverridesUseCase(
    this.likeGenreDataSource,
    this.remoteArtistChartDataSource,
  );

  final RemoteLikeGenreDataSource likeGenreDataSource;
  final RemoteArtistChartDataSource remoteArtistChartDataSource;

  Future<void> call(
    ArtistChartDto artist,
    List<String> subgenres, [
    String? addedGenre,
  ]) {
    return makeErrorParsedCall(() async {
      await likeGenreDataSource.updateArtistSubgenres(artist.id, subgenres);

      if (addedGenre != null) {
        await remoteArtistChartDataSource.upvoteGenreChart(
          addedGenre,
          artist.id,
        );

        final UserModel? user = await getIt<UserModelStream>().getUserModel();

        const String username = 'hellosnobs@gmail.com';
        const String password = 'jeje vddd abxp aqwm';
        final SmtpServer smtpServer = gmail(username, password);

        final Message message = Message()
          ..from = const Address(username)
          ..recipients.add('tom.hickey@kingfishergo.com')
          ..subject = 'adding a new subgerne to an artist '
          ..text = '''
           Artist  - ${artist.name}
           User - ${user?.toEmailJson()}
           Genre - $addedGenre ''';

        try {
          final SendReport sendReport = await send(message, smtpServer);
          log('Message sent: $sendReport');
        } on MailerException catch (e) {
          log('Message not sent.');
          for (final Problem p in e.problems) {
            log('Problem: ${p.code}: ${p.msg}');
          }
        }
      }
    });
  }
}
