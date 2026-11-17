// ignore_for_file: use_string_buffers
// ignore_for_file: implementation_imports
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/dtos/user_subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.like_genre.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/src/entities/problem.dart';

@injectable
class GenerateGenresReports extends BaseExceptionService {
  GenerateGenresReports(
    this.getSubgenreReportUseCase,
    this.getTotalGenreSubgenreByUserUseCase,
    this.remoteLikeGenreDataSource,
  );

  final GetTotalGenreSubgenreByUserUseCase getTotalGenreSubgenreByUserUseCase;
  final GetSubgenreReportUseCase getSubgenreReportUseCase;
  final RemoteLikeGenreDataSource remoteLikeGenreDataSource;

  Future<void> call() async {
    final List<UserSubgenreLiked> subgenres =
        await remoteLikeGenreDataSource.getUsersGenreChart();

    await getSubgenreReportUseCase(subgenres);
    await getTotalGenreSubgenreByUserUseCase(subgenres);
  }
}

@injectable
class GetSubgenreReportUseCase extends BaseExceptionService {
  GetSubgenreReportUseCase();

  Future<void> call(List<UserSubgenreLiked> subgenres) async {
    return makeErrorParsedCall(() async {
      log('Subgenre Report Start');

      final List<SubenreReport> report = <SubenreReport>[];

      for (final UserSubgenreLiked s in subgenres) {
        final int swipe = s.likes + s.unlikes;

        final int index = indexOfSwipe(report, swipe, s.genre);
        if (index != -1) {
          final SubenreReport oldReport = report[index];
          report[index] = SubenreReport(
            subgenre: s.genre,
            swipe: swipe,
            userCount: oldReport.userCount + 1,
          );
        } else {
          report.add(
            SubenreReport(
              subgenre: s.genre,
              swipe: swipe,
              userCount: 1,
            ),
          );
        }
      }

      final List<int> swipes =
          report.map((SubenreReport e) => e.swipe).toSet().toList()..sort();
      final List<String> genres =
          report.map((SubenreReport e) => e.subgenre).toSet().toList();

      String html = '''
Subgenre Report


<table>
<tr><th> </th>''';

      for (final int s in swipes) {
        html += '<th> $s </th>';
      }

      html += '</tr>';
      for (final String g in genres) {
        html += '<tr> <td> $g </td>';
        for (final int s in swipes) {
          html +=
              '<th> ${report.where((SubenreReport e) => e.swipe == s && g == e.subgenre).firstOrNull?.userCount ?? 0} </th>';
        }

        html += '</tr>';
      }

      const String username = 'hellosnobs@gmail.com';
      const String password = 'jeje vddd abxp aqwm';
      final SmtpServer smtpServer = gmail(username, password);

      final Message message = Message()
        ..from = const Address(username)
        ..recipients.addAll(
            <String>['tom.hickey@kingfishergo.com', 'chervinska777@gmail.com'])
        ..subject = 'Subenre Report'
        ..text = "Distribution of users base's total swipes by subgenre"
        ..html = '$html</table>';

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

int indexOfSwipe(List<SubenreReport> reports, int swipe, String genre) {
  for (int i = 0; i < reports.length; i++) {
    if (reports[i].swipe == swipe && reports[i].subgenre == genre) return i;
  }
  return -1;
}

@injectable
class GetTotalGenreSubgenreByUserUseCase extends BaseExceptionService {
  GetTotalGenreSubgenreByUserUseCase(
    this.getGenreSubgenreUseCase,
    this.getGenresUseCase,
  );

  final GetGenreSubgenreUseCase getGenreSubgenreUseCase;
  final GetGenresUseCase getGenresUseCase;

  Future<void> call(List<UserSubgenreLiked> subgenres) async {
    return makeErrorParsedCall(() async {
      log('genre Report Start');
      final List<Genre> genres = await getGenresUseCase();
      final List<GenreSubgenresUserTotal> list = <GenreSubgenresUserTotal>[];
      final List<String> users =
          subgenres.map((UserSubgenreLiked e) => e.userId).toSet().toList();

      for (final String u in users) {
        for (final Genre g in genres) {
          final List<Subgenre> s = await getGenreSubgenreUseCase(g.name);

          list.add(
            GenreSubgenresUserTotal(
              genre: g.name,
              subgenres: s.map((Subgenre g) {
                return subgenres.where((UserSubgenreLiked sub) {
                      return sub.genre == g.name && u == sub.userId;
                    }).firstOrNull ??
                    UserSubgenreLiked(genre: g.name);
              }).toList(),
            ),
          );
        }
      }

      final List<GenreReport> report = <GenreReport>[];

      for (final GenreSubgenresUserTotal l in list) {
        final int level = l.level();

        final int index = indexOfReport(report, level, l.genre);
        if (index != -1) {
          final GenreReport oldReport = report[index];
          report[index] = GenreReport(
            level: level,
            genre: l.genre,
            userCount: oldReport.userCount + 1,
          );
        } else {
          report.add(
            GenreReport(
              level: level,
              genre: l.genre,
              userCount: 1,
            ),
          );
        }
      }

      final List<int> levels =
          report.map((GenreReport e) => e.level).toSet().toList();

      const String username = 'hellosnobs@gmail.com';
      const String password = 'jeje vddd abxp aqwm';
      final SmtpServer smtpServer = gmail(username, password);

      String html = '<table><tr><th> </th>';

      for (final int l in levels) {
        html += '<th> $l </th>';
      }

      html += '</tr>';

      for (final Genre g in genres) {
        html += '<tr> <td> $g </td>';

        for (final int l in levels) {
          html +=
              '<th> ${report.where((GenreReport e) => e.level == l && g.name == e.genre).firstOrNull?.userCount ?? 0} </th>';
        }

        html += '</tr>';
      }

      final Message message = Message()
        ..from = const Address(username)
        ..recipients.addAll(
            <String>['tom.hickey@kingfishergo.com', 'chervinska777@gmail.com'])
        ..subject = 'Genre Report'
        ..text = '''
Count of users who arvhieved each genre level

'''
        ..html = '$html</table>';

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

int indexOfReport(List<GenreReport> reports, int level, String genre) {
  for (int i = 0; i < reports.length; i++) {
    if (reports[i].level == level && reports[i].genre == genre) return i;
  }
  return -1;
}

class GenreSubgenresUserTotal {
  const GenreSubgenresUserTotal({
    required this.genre,
    required this.subgenres,
  });

  final String genre;
  final List<UserSubgenreLiked> subgenres;

  int get swipesCount => subgenres.fold<int>(
        0,
        (int previousValue, UserSubgenreLiked sub) =>
            previousValue + sub.likes + sub.unlikes,
      );

  int level() {
    if (swipesCount > 3800) return 20;
    if (swipesCount > 3420) return 19;
    if (swipesCount > 3060) return 18;
    if (swipesCount > 2720) return 17;
    if (swipesCount > 2400) return 16;
    if (swipesCount > 2100) return 15;
    if (swipesCount > 1820) return 14;
    if (swipesCount > 1560) return 13;
    if (swipesCount > 1320) return 12;
    if (swipesCount > 1100) return 11;
    if (swipesCount > 900) return 10;
    if (swipesCount > 720) return 9;
    if (swipesCount > 560) return 8;
    if (swipesCount > 420) return 7;
    if (swipesCount > 300) return 6;
    if (swipesCount > 200) return 5;
    if (swipesCount > 120) return 4;
    if (swipesCount > 60) return 3;
    if (swipesCount > 20) return 2;
    return 0;
  }
}

class GenreReport {
  const GenreReport({
    required this.level,
    required this.genre,
    required this.userCount,
  });

  final int userCount;
  final String genre;
  final int level;
}

class SubenreReport {
  const SubenreReport({
    required this.swipe,
    required this.subgenre,
    required this.userCount,
  });

  final int userCount;
  final String subgenre;
  final int swipe;
}

@injectable
class GetArtistsReportUseCase extends BaseExceptionService {
  GetArtistsReportUseCase(this.remoteArtistChartDataSource);

  final RemoteArtistChartDataSource remoteArtistChartDataSource;

  Future<void> call() async {
    return makeErrorParsedCall(() async {
      log('Artist Report Start');
      final List<ArtistChartDto> artists =
          await remoteArtistChartDataSource.getAllArtists();

      String html = '''
<table>
<tr><th> Artist Name </th><th> Saves </th><th> Skips </th></tr>''';

      for (final ArtistChartDto a in artists) {
        html +=
            '<tr> <td> ${a.name} </td><td> ${a.likes} </td><td> ${a.unlikes} </td></tr>';
      }

      const String username = 'hellosnobs@gmail.com';
      const String password = 'jeje vddd abxp aqwm';
      final SmtpServer smtpServer = gmail(username, password);

      final Message message = Message()
        ..from = const Address(username)
        ..recipients.addAll(
            <String>['tom.hickey@kingfishergo.com', 'chervinska777@gmail.com'])
        ..subject = 'Artist Report'
        ..text = 'Total saves and skips by artist'
        ..html = '$html</table>';

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

@injectable
class GetUsersReportUseCase extends BaseExceptionService {
  GetUsersReportUseCase(
    this.remoteUserDataSource,
    this.getGenresUseCase,
    this.getTotalGenreSubgenreUseCase,
    this.remoteLikeGenreDataSource,
  );

  final RemoteUserDataSource remoteUserDataSource;
  final GetGenresUseCase getGenresUseCase;
  final GetTotalGenreSubgenreUseCase getTotalGenreSubgenreUseCase;
  final RemoteLikeGenreDataSource remoteLikeGenreDataSource;

  Future<void> call() async {
    return makeErrorParsedCall(() async {
      log('User Report Start');
      final List<Genre> genres = await getGenresUseCase();
      final List<UserModel> users = await remoteUserDataSource.getAllUsers();

      String html = '''
<table>
<tr><th> User </th><th> Total Swipes </th>''';

      for (final Genre g in genres) {
        html += '<th> $g Saves </th>';
      }

      html += '</tr>';

      for (final UserModel u in users) {
        log(u.id);
        html += '<tr><td> ${u.id} </td><td> ${u.swipesCount}</td>';
        final List<SubgenreLiked> subgenres =
            await remoteLikeGenreDataSource.getUserLikeGenreDto(u.id);
        final List<String> genreName = genres.map((Genre e) => e.name).toList();
        final List<GenreSubgenresTotal> list =
            await getTotalGenreSubgenreUseCase(genreName, subgenres);

        for (final Genre g in genres) {
          final int swipes = list
                  .where(
                      (GenreSubgenresTotal element) => element.genre == g.name)
                  .firstOrNull
                  ?.swipesCount ??
              0;
          html += '<th> $swipes </th>';
        }
        html += '</tr>';
      }

      const String username = 'hellosnobs@gmail.com';
      const String password = 'jeje vddd abxp aqwm';
      final SmtpServer smtpServer = gmail(username, password);

      final Message message = Message()
        ..from = const Address(username)
        ..recipients.addAll(
            <String>['tom.hickey@kingfishergo.com', 'chervinska777@gmail.com'])
        ..subject = 'User Report'
        ..text = 'Swipes per user'
        ..html = '$html</table>';

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
