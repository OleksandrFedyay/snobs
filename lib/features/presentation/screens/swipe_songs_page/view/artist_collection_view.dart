import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/create_collection/create_collection_page.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/cubit/genres_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/subgenre_artist_view.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';

class ArtistCollectionView extends StatefulWidget {
  const ArtistCollectionView({
    required this.artist,
    required this.artistCollections,
    required this.onEnd,
    required this.initialArtistCollections,
    super.key,
  });

  final ArtistChartDto artist;
  final List<ArtistCollectionDto> artistCollections;
  final ValueSetter<List<String>> onEnd;
  final List<String> initialArtistCollections;

  @override
  State<ArtistCollectionView> createState() => _ArtistCollectionViewState();
}

class _ArtistCollectionViewState extends State<ArtistCollectionView> {
  List<String> artistCollections = <String>[];

  @override
  void initState() {
    super.initState();
    artistCollections.addAll(widget.initialArtistCollections);
  }

  List<String> get actionsCollections => <String>[
        context.i10n.wakeup,
        context.i10n.workout,
        context.i10n.travel,
        context.i10n.focus,
        context.i10n.party,
        context.i10n.relax,
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          40,
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: lightColorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: _buildContent(context),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              withArrow: false,
              style: AppThemeModel.instance.getWelcomeButtonTheme().style,
              onPressed: () => widget.onEnd(artistCollections),
              text: context.i10n.confirm,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTopInfo(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocProvider<GenresCubit>(
              create: (_) => GenresCubit.create()
                ..init(
                  widget.artist.subgenres,
                  widget.artist.id,
                ),
              child: SubgenreArtistView(
                artist: widget.artist,
                artistCollections: artistCollections,
                allCollections: <String>{
                  context.i10n.favorites,
                  context.i10n.checkoutLater,
                  ...actionsCollections,
                  ...widget.artistCollections
                      .map((ArtistCollectionDto collect) => collect.name),
                }.toList(),
                onCollectTap: (String name) {
                  setState(() {
                    if (artistCollections.contains(name)) {
                      artistCollections.remove(name);
                    } else {
                      artistCollections.add(name);
                    }
                  });
                },
                onCreateCollect: () => CreateCollectionPage.showModalDialog(
                  context,
                  (String name) {
                    Navigator.of(context).pop();
                    setState(() {
                      widget.artistCollections.add(
                        ArtistCollectionDto(name: name),
                      );
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopInfo() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.all(24),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  lightColorScheme.primaryContainer,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CupertinoButton(
              onPressed: Navigator.of(context).pop,
              child: Text(
                context.i10n.goBack.toUpperCase(),
                style: context.textStyle.labelMedium,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                const SizedBox(width: 24),
                CachedNetworkImage(
                  imageUrl: widget.artist.image,
                  width: 56,
                  height: 56,
                  alignment: Alignment.topCenter,
                  maxHeightDiskCache: 240,
                  fit: BoxFit.cover,
                  errorWidget:
                      (BuildContext context, String error, Object stackTrace) {
                    return Container(
                      width: 56,
                      height: 56,
                      color: lightColorScheme.surfaceContainerHighest,
                    );
                  },
                  placeholder: (BuildContext context, String url) {
                    return Container(
                      width: 56,
                      height: 56,
                      color: lightColorScheme.surfaceContainerHighest,
                    );
                  },
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.i10n.artist,
                      style: context.textStyle.bodyLarge,
                    ),
                    Text(
                      widget.artist.name,
                      style: context.textStyle.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(width: 24),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
