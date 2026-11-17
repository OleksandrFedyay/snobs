import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class SingleArtistCardBio extends StatelessWidget {
  const SingleArtistCardBio({
    required this.artist,
    this.onHereTap,
    super.key,
  });

  final ArtistChartDto artist;
  final VoidCallback? onHereTap;

  @override
  Widget build(BuildContext context) {
    final bool isEmptyBio =
        artist.bio == null || (artist.bio != null && artist.bio!.isEmpty);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// [More] for Artist with Bio
            Visibility(
              visible: !isEmptyBio,
              child: Text(
                (artist.bio ?? '').parseHtmlToString,

                ///To calculate how many lines could be within the widget size
                /// (22) the font size + the line height
                /// (- 1) for the "MORE" line
                maxLines: (constraints.maxHeight / 22).floor() - 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: lightColorScheme.onSecondary,
                  fontFamily: FontFamily.nunitoSans,
                ),
              ),
            ),

            /// [Here] for Artist without Bio
            Visibility(
              visible: isEmptyBio,
              child: RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: artist.artistDefaultBio + context.i10n.haveMoreInfo,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: lightColorScheme.onSecondary,
                        fontFamily: FontFamily.nunitoSans,
                      ),
                    ),
                    TextSpan(
                      text: context.i10n.here.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: lightColorScheme.onSecondary,
                        fontFamily: FontFamily.nunitoSans,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = onHereTap ?? () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
