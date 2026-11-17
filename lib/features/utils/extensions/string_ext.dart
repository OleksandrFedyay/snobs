import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/snackbar/snack_bar_service.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/icons/snobs_icons.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';

extension StringExt on String {
  String getSimpleString() {
    return replaceAll(',', '').replaceAll(' ', '').toLowerCase();
  }

  IconData getCollectionIcon(BuildContext context) {
    if (this == context.i10n.wakeup) {
      return SnobsIcons.wakeup;
    }
    if (this == context.i10n.workout) {
      return SnobsIcons.workout;
    }
    if (this == context.i10n.travel) {
      return SnobsIcons.car;
    }
    if (this == context.i10n.focus) {
      return SnobsIcons.brain;
    }
    if (this == context.i10n.party) {
      return SnobsIcons.celebration;
    }
    if (this == context.i10n.relax) {
      return SnobsIcons.chill;
    }

    if (this == context.i10n.favorites) {
      return SnobsIcons.starBorder;
    }

    if (this == context.i10n.checkoutLater) {
      return SnobsIcons.repeat;
    }

    return SnobsIcons.country;
  }

  Future<void> precacheSVG(BuildContext context) async {
    final SvgAssetLoader loader = SvgAssetLoader(this);
    await svg.cache
        .putIfAbsent(loader.cacheKey(context), () => loader.loadBytes(context));
  }

  void get showSnackBarInfo {
    if (isNotEmpty) {
      getIt<SnackBarService>().showMessage(infoSnackBar(this));
    }
  }

  static String fromJson(dynamic json) {
    if (json is String) return json;
    return json.toString();
  }

  String toCapitalized() {
    return length > 0
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '';
  }

  String toCapitalizeAllWords() {
    final List<String> words = split(' ');
    final List<String> capitalizedWords = words.map((String word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      } else {
        return word;
      }
    }).toList();

    return capitalizedWords.join(' ');
  }

  String toTitleCase() {
    if (this == 'synth wave') return 'Synthwave';
    if (this == 'R&B') return this;
    if (this == 'world music') return 'World';
    if (this == 'AC/DC') return 'AC/DC';

    return replaceAll(RegExp(' +'), ' ')
        .split(' ')
        .map((String str) => str.toCapitalized())
        .join(' ')
        .replaceAll('R&b', 'R&B')
        .replaceAll('Rnb', 'R&B');
  }

  String toCamelCase() {
    final String res = replaceAll(RegExp(' +'), ' ')
        .split(' ')
        .map((String str) => str.toCapitalized())
        .join();

    return length > 0 ? '${res[0].toLowerCase()}${res.substring(1)}' : '';
  }

  String get parseHtmlToString => HtmlParser.parseHTML(this).text;

  GenreEnum get genreStingToEnum => GenreEnum.fromString(this);
}
