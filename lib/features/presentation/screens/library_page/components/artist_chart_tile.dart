import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/tag_type.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/number_buble.dart';
import 'package:kingfishertom/features/widgets/tag_widget.dart';

class ArtistChartTile extends StatelessWidget {
  const ArtistChartTile({
    required this.index,
    required this.chart,
    required this.onTap,
    required this.useHeart,
    super.key,
  });

  final int index;
  final ArtistChartDto chart;
  final VoidCallback onTap;
  final bool useHeart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
            child: Row(
              children: <Widget>[
                NumberBuble(number: index + 1),
                const SizedBox(width: 20),
                ArtistChartImage(chart: chart, useHeart: useHeart),
                const SizedBox(width: 20),
                Expanded(
                  child: ChartInfo(chart: chart),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 32,
                  color: lightColorScheme.secondary,
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
      ),
    );
  }
}

class ChartInfo extends StatelessWidget {
  const ChartInfo({
    required this.chart,
    super.key,
  });

  final ArtistChartDto chart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          chart.name,
          style: context.textStyle.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TagWidget(
          tag: TagType.getTag(chart.likes, chart.unlikes),
        ),
      ],
    );
  }
}

class ArtistChartImage extends StatelessWidget {
  const ArtistChartImage({
    required this.chart,
    required this.useHeart,
    super.key,
  });

  final ArtistChartDto chart;
  final bool useHeart;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: chart.image,
          width: 64,
          height: 64,
          alignment: Alignment.topCenter,
          maxHeightDiskCache: 192,
          fit: BoxFit.cover,
          errorWidget: (BuildContext context, String error, Object stackTrace) {
            return const SizedBox(
              width: 64,
              height: 64,
            );
          },
          placeholder: (BuildContext context, String url) {
            return Container(
              width: 64,
              height: 64,
              color: lightColorScheme.surfaceContainerHighest,
            );
          },
        ),
        if (useHeart)
          const Positioned(
            bottom: 4,
            left: 4,
            child: Icon(
              Icons.favorite_rounded,
              size: 14,
            ),
          ),
      ],
    );
  }
}
