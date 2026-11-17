import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/components/artist_image_top.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/confirm_unlike_dialog.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/cubit/genres_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/genres_view.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artist_collection_view.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/artists_card/single_artist_card.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/liked_tracks_view.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/bio_view.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SingleArtistView extends StatefulWidget {
  const SingleArtistView({
    required this.artist,
    required this.like,
    required this.collections,
    required this.addArtistInCollections,
    required this.editArtistInCollections,
    required this.exploreSubgenre,
    super.key,
    this.collectName = '',
    this.unlikeArtist,
    this.showCollectionButton = true,
    this.onCardDetailsTapType = OnCardDetailsTapType.image,
  });

  final ArtistChartDto artist;
  final VoidCallback? unlikeArtist;
  final String collectName;
  final bool like;
  final List<ArtistCollectionDto> collections;
  final ValueSetter<List<String>> addArtistInCollections;
  final ValueSetter<List<String>> editArtistInCollections;
  final Function(String genre, String subgenre) exploreSubgenre;
  final bool showCollectionButton;
  final OnCardDetailsTapType onCardDetailsTapType;

  @override
  State<SingleArtistView> createState() => _SingleArtistViewState();
}

class _SingleArtistViewState extends State<SingleArtistView> {
  final List<String> _artistCollection = <String>[];

  TrackAudioPlayerCubit get _cubit => context.read();
  final GlobalKey _titleKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    /// Wait until the widget tree is built, then scroll to the item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getItemPositionToScroll();
    });

    for (final ArtistCollectionDto collect in widget.collections) {
      if (collect.artists.contains(widget.artist.id)) {
        _artistCollection.add(collect.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          decoration: BoxDecoration(
            color: lightColorScheme.onPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildArtist(constraints),
        );
      },
    );
  }

  Widget _buildArtist(BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          ArtistImageTop(
            image: widget.artist.image,
            constraints: constraints,
          ),
          _nameAndLikeRow,
          const SizedBox(height: 16),
          _genresView,
          const SizedBox(height: 16),
          if (widget.artist.bio?.isNotEmpty ?? false) ...<Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BioView(key: _contentKey, bio: widget.artist.bio ?? '')),
            const SizedBox(height: 16),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.i10n.songs,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: lightColorScheme.onTertiary,
                  fontFamily: FontFamily.nunitoSans,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _tracksView,
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget get _genresView => SizedBox(
        height: 24,
        child: BlocProvider<GenresCubit>(
          key: ValueKey<String>(widget.artist.id),
          create: (_) => GenresCubit.create()
            ..init(
              widget.artist.subgenres,
              widget.artist.id,
            ),
          child: GenresView(
            widget.artist,
            (String genre, String subgenre) {
              widget.exploreSubgenre(genre,subgenre);
              Navigator.of(context).pop();
            },
            onOrganizeArtistTap: () => _editCollection,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
        ),
      );

  Widget get _tracksView => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: LikedTracksView(
            key: ValueKey<List<String>>(widget.artist.tracks),
            likeTrack: _cubit.likeTrackId,
            artistId: widget.artist.id,
            artist: widget.artist),
      );

  //Todo(Issa): Maybe need to show a track view without track like button
/*
  TracksView(
  key: ValueKey<List<String>>(widget.artist.tracks),
  artist: widget.artist,
  ),
*/

  Widget get _nameAndLikeRow => Padding(
        key: _titleKey,
        padding: const EdgeInsets.only(left: 24, right: 28, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.artist.name.toTitleCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: FontFamily.nunitoSans,
              ),
            ),
            GestureDetector(
              onTap: _onLikeTap,
              child: Icon(
                widget.like ? Icons.favorite : Icons.favorite_outline_rounded,
                color: const Color(0xffDDDDDD),
                size: 32,
              ),
            ),
          ],
        ),
      );

  Future<void> _onLikeTap() async {
    if (widget.unlikeArtist != null && widget.like) {
      await showDialog<void>(
        context: context,
        builder: (_) => ConfirmUnlikeDialog(
          artistName: widget.artist.name,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            widget.unlikeArtist?.call();
          },
        ),
      );
      return;
    }

    if (!widget.like) {
      widget.addArtistInCollections(_artistCollection);
      Navigator.of(context).pop();
    }
  }

  Future<void> get _editCollection => showMaterialModalBottomSheet<void>(
        context: context,
        barrierColor:
            lightColorScheme.surfaceContainerHighest.withValues(alpha: .5),
        backgroundColor: Colors.transparent,
        builder: (_) => ArtistCollectionView(
          artist: widget.artist,
          initialArtistCollections: _artistCollection,
          artistCollections: widget.collections,
          onEnd: (List<String> collections) async {
            widget.editArtistInCollections(collections);

            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      );

  /// Get the position of the widget
  void _getItemPositionToScroll() {
    switch (widget.onCardDetailsTapType) {
      case OnCardDetailsTapType.title:
        _scrollToItem(_titleKey.currentContext);
      case OnCardDetailsTapType.content:
        _scrollToItem(_contentKey.currentContext);
      case OnCardDetailsTapType.image:
        return;
    }
  }

  void _scrollToItem(BuildContext? context) {
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
