import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

class ArtistImageTop extends StatelessWidget {
  const ArtistImageTop({
    required this.constraints,
    required this.image,
    super.key,
  });

  final String image;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) {
                return const SizedBox.shrink();
              },
              placeholder: (_, __) {
                return Container(
                  color: lightColorScheme.surfaceContainerHighest,
                );
              },
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 60,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const <double>[0.0, 1],
                    colors: <Color>[
                      Colors.transparent,
                      lightColorScheme.onPrimary,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
