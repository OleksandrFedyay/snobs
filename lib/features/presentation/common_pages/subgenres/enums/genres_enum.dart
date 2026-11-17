import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/icons/snobs_icons.dart';
import 'package:kingfishertom/gen/assets.gen.dart';

enum GenrePageType {
  genre,
  subgenre,
}

enum ChosenResource {
  myLiked,
  global,
}

enum SortByMethod {
  topArtist('Top Artist'),
  aToZ('A-Z'),
  /*dateAdded('Date added')*/;

  const SortByMethod(this.title);

  final String title;
}

enum SubgenrePageStatus {
  initial,
  error,
  loading,
  unlikeArtist,
}

enum SubgenreFansPageStatus {
  initial,
  error,
  loading,
}

enum SubgenreChartsSongsPageStatus {
  initial,
  error,
  loading,
}

enum GenreEnum {
  rnb,
  blues,
  classical,
  country,
  electronic,
  hipHop,
  jazz,
  metal,
  punk,
  rock,
  latin,
  worldMusic;

  static GenreEnum fromString(String value) {
    if (value == 'r&b') return GenreEnum.rnb;

    try {
      return GenreEnum.values.byName(value.toCamelCase());
    } catch (e) {
      return GenreEnum.classical;
    }
  }

  Widget getGenreIcon([double? size, Color? color]) {
    switch (this) {
      case GenreEnum.rnb:
        return Icon(
          SnobsIcons.rnb,
          size: size,
          color: color,
        );

      case GenreEnum.blues:
        return Icon(
          SnobsIcons.blues,
          size: size,
          color: color,
        );
      case GenreEnum.classical:
        return Icon(
          SnobsIcons.classical,
          size: size,
          color: color,
        );
      case GenreEnum.country:
        return Icon(
          SnobsIcons.country,
          size: size,
          color: color,
        );
      case GenreEnum.electronic:
        return SvgPicture.asset(
          Assets.icons.electronic,
          height: size,
          colorFilter: ColorFilter.mode(
            color ?? Colors.white,
            BlendMode.srcIn,
          ),
        );

      case GenreEnum.hipHop:
        return SvgPicture.asset(
          Assets.icons.hipHop,
          height: size,
          colorFilter: ColorFilter.mode(
            color ?? Colors.white,
            BlendMode.srcIn,
          ),
        );
      case GenreEnum.jazz:
        return Icon(
          SnobsIcons.jazz,
          size: size,
          color: color,
        );
      case GenreEnum.metal:
        return Icon(
          SnobsIcons.metal,
          size: size,
          color: color,
        );
      case GenreEnum.punk:
        return Icon(
          SnobsIcons.punk,
          size: size,
          color: color,
        );
      case GenreEnum.rock:
        return Icon(
          SnobsIcons.rock,
          size: size,
          color: color,
        );
      case GenreEnum.worldMusic:
        return Icon(
          SnobsIcons.word,
          size: size,
          color: color,
        );
      case GenreEnum.latin:
        return Icon(
          SnobsIcons.word,
          size: size,
          color: color,
        );
    }
  }

  List<Color> getColors([double opacity = 1]) {
    switch (this) {
      case GenreEnum.rnb:
        return <Color>[
          const Color(0xFFCB0255).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
      case GenreEnum.blues:
        return <Color>[
          const Color(0xFF2F74BD).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
      case GenreEnum.classical:
        return <Color>[
          const Color(0xFFF3F1EB).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
      case GenreEnum.country:
        return <Color>[
          const Color(0xFFAE4E31).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
      case GenreEnum.electronic:
        return <Color>[
          const Color(0xFF8C3276).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
      case GenreEnum.hipHop:
        return <Color>[
          const Color(0xFFF9850F).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
      case GenreEnum.jazz:
        return <Color>[
          const Color(0xFFE8A32D).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
      case GenreEnum.metal:
        return <Color>[
          const Color(0xFF161616).withValues(alpha: opacity),
          const Color(0xFF2E2E2E),
        ];
      case GenreEnum.punk:
        return <Color>[
          const Color(0xFF88C808).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];

      case GenreEnum.rock:
        return <Color>[
          const Color(0xFFEC1A23).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
      case GenreEnum.worldMusic:
        return <Color>[
          const Color(0xFF102F5E).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
      case GenreEnum.latin:
        return <Color>[
          const Color(0xFF102F5E).withValues(alpha: opacity),
          const Color(0xFF102F5E).withValues(alpha: .1),
        ];
    }
  }
}
