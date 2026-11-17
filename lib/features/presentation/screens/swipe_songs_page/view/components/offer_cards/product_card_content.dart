import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/cubit/swipe_songs_page_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/single_artist_card_bio.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class ProductCardContent extends StatelessWidget {
  const ProductCardContent({
    required this.data,
    required this.screenSize,
    required this.constraints,
    super.key,
  });

  final ArtistChartDto data;
  final Size screenSize;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      /// (constraints.maxHeight / 1.75) the Product image view size
      height: constraints.maxHeight - (constraints.maxHeight / 1.75),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 9),
            GestureDetector(
              onTap: () => context
                  .read<SwipeSongsPageCubit>()
                  .goToProductStore(data.productLink, data.productEventName),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    data.name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: FontFamily.nunitoSans,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _productButtons(context),
            const SizedBox(height: 18),
            _content(context),
          ],
        ),
      ),
    );
  }

  Widget _productButtons(BuildContext context) => GestureDetector(
        onTap: () => context
            .read<SwipeSongsPageCubit>()
            .goToProductStore(data.productLink, data.productEventName),
        child: Row(
          spacing: 8,
          children: <Widget>[
            Container(
              height: 32,
              width: 138,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    lightColorScheme.darkBackground,
                    lightColorScheme.backgroundGrey,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  context.i10n.viewPriceAmazon,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: lightColorScheme.onSecondary,
                    fontFamily: FontFamily.nunitoSans,
                  ),
                ),
              ),
            ),
            Assets.images.amazonButton.image(
              height: 32,
            ),
          ],
        ),
      );

  Widget _content(BuildContext context) => Expanded(
        child: Container(
          width: constraints.maxWidth,
          margin: const EdgeInsets.only(bottom: 24, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _artistBio(
                context: context,
                constraints: constraints,
              ),
              GestureDetector(
                onTap: () => context
                    .read<SwipeSongsPageCubit>()
                    .likeTheArtist(screenSize, <String>[]),
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: SvgPicture.asset(
                    Assets.icons.likeButton,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _artistBio({
    required BuildContext context,
    required BoxConstraints constraints,
  }) =>
      GestureDetector(
        onTap: () => context
            .read<SwipeSongsPageCubit>()
            .goToProductStore(data.productLink, data.productEventName),
        child: Container(
          width: constraints.maxWidth / 1.6,
          height: double.infinity,
          alignment: Alignment.topLeft,
          child: SingleArtistCardBio(
            artist: data,
          ),
        ),
      );
}
