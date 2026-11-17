import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artists_card/single_artist_card.dart';

class ArtistsCard extends StatelessWidget {
  const ArtistsCard({
    required this.onOrganizeArtistTap,
    required this.artists,
    required this.exploreSubgenre,
    required this.isTrailSubscription,
    super.key,
  });

  final List<ArtistChartDto> artists;
  final ValueSetter<ArtistChartDto> onOrganizeArtistTap;
  final Function(String genre, String subgenre) exploreSubgenre;
  final bool isTrailSubscription;

  @override
  Widget build(BuildContext context) {
    if (artists.lastOrNull == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Stack(
        children: <Widget>[
          if (artists.length > 1)
            SingleArtistCard(
              artist: artists[artists.length - 2],
              isTrailSubscription: isTrailSubscription,
              exploreSubgenre: exploreSubgenre,
              onOrganizeArtistTap: (ArtistChartDto artist) {},
            ),
          if (artists.isNotEmpty)
            SingleArtistCard(
              artist: artists[artists.length - 1],
              isTrailSubscription: isTrailSubscription,
              exploreSubgenre: exploreSubgenre,
              isNextCard: false,
              onOrganizeArtistTap: onOrganizeArtistTap,
            ),
        ],
      ),
    );
  }
}
