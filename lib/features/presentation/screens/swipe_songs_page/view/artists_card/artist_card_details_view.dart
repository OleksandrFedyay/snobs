import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback_type.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/feedback_view.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/cubit/swipe_songs_page_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/genres_view.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artists_card/single_artist_card.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/single_artist_card_bio.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ArtistCardDetailsView extends StatelessWidget {
  const ArtistCardDetailsView({
    required this.artist,
    required this.screenSize,
    required this.exploreSubgenre,
    required this.onOrganizeArtistTap,
    required this.constraints,
    required this.onCardDetailsTap,
    super.key,
  });

  final ArtistChartDto artist;
  final Size screenSize;
  final BoxConstraints constraints;
  final ValueSetter<ArtistChartDto> onOrganizeArtistTap;
  final ValueSetter<OnCardDetailsTapType> onCardDetailsTap;
  final Function(String genre, String subgenre) exploreSubgenre;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      /// (constraints.maxHeight / 1.7) the Artist image view size
      height: constraints.maxHeight - (constraints.maxHeight / 1.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => onCardDetailsTap(OnCardDetailsTapType.title),
                  child: Text(
                    artist.name.toTitleCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: FontFamily.nunitoSans,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 24,
            child: GenresView(
              artist,
              exploreSubgenre,
              onOrganizeArtistTap: () => onOrganizeArtistTap(artist),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
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
                        .likeTheArtist(screenSize, artist.subgenres),
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
          ),
        ],
      ),
    );
  }

  Widget _artistBio({
    required BuildContext context,
    required BoxConstraints constraints,
  }) =>
      GestureDetector(
        onTap: () => onCardDetailsTap(OnCardDetailsTapType.content),
        child: Container(
          width: constraints.maxWidth / 1.6,
          height: double.infinity,
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 16),
          child: SingleArtistCardBio(
            artist: artist,
            onHereTap: () {
              ///To show the Feedback Dialogue view
              showMaterialModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => FeedbackView.create(FeedbackType.artistIssue),
              );
            },
          ),
        ),
      );
}
