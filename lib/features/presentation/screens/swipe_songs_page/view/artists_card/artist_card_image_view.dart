import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artists_card/single_artist_card.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/disliked_container.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/liked_container.dart';
import 'package:kingfishertom/features/widgets/empty_view.dart';

class ArtistCardImageView extends StatelessWidget {
  const ArtistCardImageView({
    required this.image,
    required this.constraints,
    required this.dx,
    required this.onCardDetailsTap,
    super.key,
  });

  final String image;
  final BoxConstraints constraints;
  final double dx;
  final ValueSetter<OnCardDetailsTapType> onCardDetailsTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCardDetailsTap(OnCardDetailsTapType.image),
      child: SizedBox(
        height: constraints.maxHeight / 1.7,
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
                CachedNetworkImage(
                  imageUrl: image,
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) {
                    return EmptyView(constraints);
                  },
                  placeholder: (_, __) {
                    return EmptyView(constraints);
                  },
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
                        stops: const <double>[0.0, 0.8],
                        colors: <Color>[
                          Colors.transparent,
                          lightColorScheme.onPrimary,
                        ],
                      ),
                    ),
                  ),
                ),
                LikedContainer(dx: dx),
                DislikedContainer(dx: dx),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
