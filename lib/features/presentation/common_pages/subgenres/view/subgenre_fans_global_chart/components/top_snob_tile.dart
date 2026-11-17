import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/dtos/user_like_dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_fans_global_chart/components/no_image_container.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

class TopSnobTile extends StatelessWidget {
  const TopSnobTile({
    required this.snobUserData,
    super.key,
  });

  final UserLikeDto snobUserData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: snobUserData.user.imageUrl?.trim() ?? '',
                maxHeightDiskCache: 240,
                imageBuilder: (BuildContext context,
                        ImageProvider<Object> imageProvider) =>
                    Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget:
                    (BuildContext context, String error, Object stackTrace) {
                  return NoImageContainer(
                    name: snobUserData.user.name,
                    lastName: snobUserData.user.lastName,
                  );
                },
                placeholder: (
                  BuildContext context,
                  String url,
                ) {
                  return NoImageContainer(
                    name: snobUserData.user.name,
                    lastName: snobUserData.user.lastName,
                  );
                },
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ///TODO add to the localization if approved
                      '${snobUserData.user.name ?? 'Anonymous Snob'} ${snobUserData.user.lastName ?? ''}',
                      style: context.textStyle.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(snobUserData.levelDto.name),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: lightColorScheme.onSecondaryContainer,
          height: 1,
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
