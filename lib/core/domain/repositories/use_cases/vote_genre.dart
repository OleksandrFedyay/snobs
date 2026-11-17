// ignore_for_file: implementation_imports
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/vote_genre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/src/entities/problem.dart';

@injectable
class GetVotesUseCase extends BaseExceptionService {
  GetVotesUseCase(this.remoteArtistChartDataSource);

  final RemoteArtistChartDataSource remoteArtistChartDataSource;

  Future<List<VoteGenre>> call(String artistId) async {
    return makeErrorParsedCall(() async {
      return remoteArtistChartDataSource.getVotes(artistId);
    });
  }
}

@injectable
class UpvoteGenreUseCase extends BaseExceptionService {
  UpvoteGenreUseCase(
    this.remoteArtistChartDataSource,
  );

  final RemoteArtistChartDataSource remoteArtistChartDataSource;

  Future<VoteGenre> call(
    String genre,
    ArtistChartDto artist,
  ) async {
    return makeErrorParsedCall(() async {
      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      final Future<VoteGenre> res =
          remoteArtistChartDataSource.upvoteGenreChart(genre, artist.id);

      const String username = 'hellosnobs@gmail.com';
      const String password = 'jeje vddd abxp aqwm';
      final SmtpServer smtpServer = gmail(username, password);

      final Message message = Message()
        ..from = const Address(username)
        ..recipients.add('tom.hickey@kingfishergo.com')
        ..subject = 'upvoting a subgenre'
        ..text = '''
Artist  - ${artist.name}

User - ${user?.toEmailJson()}

Genre - $genre ''';

      try {
        final SendReport sendReport = await send(message, smtpServer);
        log('Message sent: $sendReport');
      } on MailerException catch (e) {
        log('Message not sent.');
        for (final Problem p in e.problems) {
          log('Problem: ${p.code}: ${p.msg}');
        }
      }

      return res;
    });
  }
}

@injectable
class DownvoteGenreUseCase extends BaseExceptionService {
  DownvoteGenreUseCase(
    this.remoteArtistChartDataSource,
    this.localAppInfoDataSource,
  );

  final RemoteArtistChartDataSource remoteArtistChartDataSource;
  final LocalAppInfoDataSource localAppInfoDataSource;

  Future<VoteGenre> call(
    String genre,
    ArtistChartDto artist,
  ) async {
    return makeErrorParsedCall(() async {
      final Future<VoteGenre> res =
          remoteArtistChartDataSource.downVoteGenreChart(genre, artist.id);
      final UserModel? user = await getIt<UserModelStream>().getUserModel();

      const String username = 'hellosnobs@gmail.com';
      const String password = 'jeje vddd abxp aqwm';
      final SmtpServer smtpServer = gmail(username, password);

      final Message message = Message()
        ..from = const Address(username)
        ..recipients.add('tom.hickey@kingfishergo.com')
        ..subject = 'downvoting a subgenre'
        ..text = '''
Artist  - ${artist.name}

User - ${user?.toEmailJson()}

Genre - $genre ''';

      try {
        final SendReport sendReport = await send(message, smtpServer);
        log('Message sent: $sendReport');
      } on MailerException catch (e) {
        log('Message not sent.');
        for (final Problem p in e.problems) {
          log('Problem: ${p.code}: ${p.msg}');
        }
      }

      return res;
    });
  }
}

@injectable
class RemoveVoteGenreUseCase extends BaseExceptionService {
  RemoveVoteGenreUseCase(
    this.remoteArtistChartDataSource,
  );

  final RemoteArtistChartDataSource remoteArtistChartDataSource;

  Future<VoteGenre> call(
    String genre,
    ArtistChartDto artist,
  ) async {
    return makeErrorParsedCall(() async {
      final Future<VoteGenre> res =
          remoteArtistChartDataSource.removeVoteGenreChart(genre, artist.id);

      return res;
    });
  }
}
