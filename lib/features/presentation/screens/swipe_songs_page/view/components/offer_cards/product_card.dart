import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/cubit/swipe_songs_page_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/disliked_container.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/liked_container.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/offer_cards/product_card_content.dart';
import 'package:kingfishertom/gen/assets.gen.dart';

///For product need [id, image, title, link, desc]
class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.dx,
    required this.data,
    required this.screenSize,
    super.key,
  });

  final double dx;
  final ArtistChartDto data;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: ColoredBox(
            color: lightColorScheme.onPrimary,
            child: Column(
              children: <Widget>[
                _productImage(context, constraints),
                ProductCardContent(
                  data: data,
                  constraints: constraints,
                  screenSize: screenSize,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _productImage(BuildContext context, BoxConstraints constraints) =>
      GestureDetector(
        onTap: () => context
            .read<SwipeSongsPageCubit>()
            .goToProductStore(data.productLink, data.productEventName),
        child: SizedBox(
          height: constraints.maxHeight / 1.75,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: SizedBox.fromSize(
              size: Size.fromRadius(constraints.maxWidth / 2),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  ColoredBox(
                    color: Colors.white,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Positioned(
                          top: 45,
                          bottom: 45,
                          left: 10,
                          right: 10,
                          child: Image.asset(
                            data.image,
                            fit: BoxFit.contain,
                            width: constraints.maxWidth,
                            height: constraints.maxWidth,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: SvgPicture.asset(
                            Assets.images.recommendedBanner,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Shadow effect
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.transparent,
                            lightColorScheme.onPrimary,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(child: LikedContainer(dx: dx)),
                  Center(child: DislikedContainer(dx: dx)),
                ],
              ),
            ),
          ),
        ),
      );
}
