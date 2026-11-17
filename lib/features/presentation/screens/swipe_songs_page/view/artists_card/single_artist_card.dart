import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/single_artist/single_artist_view.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/cubit/swipe_songs_page_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/cubit/genres_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artists_card/artist_card_details_view.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artists_card/artist_card_image_view.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/offer_cards/native_ad_card.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/offer_cards/premium_card.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/offer_cards/product_card.dart';
import 'package:kingfishertom/features/widgets/carusel_artist_dialog/carusel_artist_dialog.dart';

enum OnCardDetailsTapType {
  image,
  title,
  content,
}

class SingleArtistCard extends StatefulWidget {
  const SingleArtistCard({
    required this.artist,
    required this.onOrganizeArtistTap,
    required this.isTrailSubscription,
    required this.exploreSubgenre,
    this.isNextCard = true,
    super.key,
  });

  final ArtistChartDto artist;
  final bool isNextCard;
  final ValueSetter<ArtistChartDto> onOrganizeArtistTap;
  final bool isTrailSubscription;
  final Function(String genre, String subgenre) exploreSubgenre;

  @override
  State<SingleArtistCard> createState() => _SingleArtistCardState();
}

class _SingleArtistCardState extends State<SingleArtistCard> {
  SwipeSongsPageCubit get cubit => context.read();
  late Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    cubit.setSwipeCardType(
      cardId: widget.artist.id,
      productLink: widget.artist.productLink,
      productEventName: widget.artist.productEventName,
    );

    return BlocProvider<GenresCubit>(
      key: ValueKey<String>(widget.artist.id),
      create: (_) => GenresCubit.create()
        ..init(
          widget.artist.subgenres,
          widget.artist.id,
        ),
      child: widget.isNextCard
          ? _nextCard
          : GestureDetector(
              onPanStart: cubit.startPosition,
              onPanUpdate: (DragUpdateDetails details) =>
                  cubit.updatePosition(details, screenSize),
              onPanEnd: (_) => cubit.endPosition(
                screenSize,
                widget.artist.subgenres,
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final Offset position = cubit.state.position;

                  final Offset center =
                      constraints.smallest.center(Offset.zero);

                  final Matrix4 rotatedMatrix = Matrix4.identity()
                    ..translate(center.dx, center.dy)
                    ..translate(-center.dx, -center.dy);

                  return RepaintBoundary(
                    child: AnimatedContainer(
                      duration: Duration(
                          milliseconds: cubit.state.dragging ? 0 : 400),
                      curve: Curves.easeInOut,
                      transform: rotatedMatrix
                        ..translate(position.dx, position.dy),
                      child: switch (cubit.state.swipeCardViewType) {
                        SwipeCardViewType.artist => _artistCard(position.dx),
                        SwipeCardViewType.premium => PremiumCard(
                            isTrailSubscription: widget.isTrailSubscription,
                            dx: position.dx,
                          ),
                        SwipeCardViewType.product => ProductCard(
                            dx: position.dx,
                            data: widget.artist,
                            screenSize: screenSize,
                          ),
                        SwipeCardViewType.ads =>
                          NativeAdWidget(dx: position.dx),
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget get _nextCard => switch (cubit.state.swipeCardViewType) {
        SwipeCardViewType.artist => _artistCard(0),
        SwipeCardViewType.premium => PremiumCard(
            isTrailSubscription: widget.isTrailSubscription,
            dx: 0,
          ),
        SwipeCardViewType.product => ProductCard(
            dx: 0,
            data: widget.artist,
            screenSize: screenSize,
          ),
        SwipeCardViewType.ads => const NativeAdWidget(dx: 0),
      };

  Widget _artistCard(double dx) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: ColoredBox(
            color: lightColorScheme.onPrimary,
            child: Column(
              children: <Widget>[
                ArtistCardImageView(
                  constraints: constraints,
                  dx: dx,
                  image: widget.artist.image,
                  onCardDetailsTap: (OnCardDetailsTapType type) =>
                      _showDetailsPage(
                    context: context,
                    type: type,
                  ),
                ),
                ArtistCardDetailsView(
                  exploreSubgenre: widget.exploreSubgenre,
                  artist: widget.artist,
                  onOrganizeArtistTap: widget.onOrganizeArtistTap,
                  screenSize: screenSize,
                  constraints: constraints,
                  onCardDetailsTap: (OnCardDetailsTapType type) =>
                      _showDetailsPage(
                    context: context,
                    type: type,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///To show the Artist Details Dialogue view
  void _showDetailsPage(
          {required BuildContext context,
          required OnCardDetailsTapType type}) =>
      showDialog<void>(
        context: context,
        builder: (_) {
          return CarouselArtistDialog(
              onPageChanged: (int index) {
                context.read<TrackAudioPlayerCubit>().playTrack(
                      widget.artist,
                      fullSong: true,
                    );
              },
              initialIndex: 0,
              artists: <Widget>[
                SingleArtistView(
                  artist: widget.artist,
                  exploreSubgenre: widget.exploreSubgenre,
                  showCollectionButton: false,
                  onCardDetailsTapType: type,
                  like: getIt<UserModelStream>()
                          .model
                          ?.likes
                          .contains(widget.artist.id) ??
                      false,
                  collections: getIt<UserModelStream>()
                          .model
                          ?.collections
                          .map((Map<String, dynamic> item) {
                        return ArtistCollectionDto.fromJson(
                          item,
                        );
                      }).toList() ??
                      <ArtistCollectionDto>[],
                  unlikeArtist: () {
                    context
                        .read<SwipeSongsPageCubit>()
                        .unlikeArtist(widget.artist, screenSize);
                  },
                  editArtistInCollections: (List<String> collect) {
                    context.read<SwipeSongsPageCubit>().editArtistCollections(
                        widget.artist, collect, screenSize);
                  },
                  addArtistInCollections: (List<String> collect) {
                    context
                        .read<SwipeSongsPageCubit>()
                        .likeArtist(widget.artist, collect, screenSize);
                  },
                ),
              ]);
        },
      );
}
