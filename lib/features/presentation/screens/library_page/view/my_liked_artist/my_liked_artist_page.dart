import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/single_artist/single_artist_view.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/components/artist_tile.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/view/my_liked_artist/cubit/likes_artist_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/view/my_liked_artist/view/delete_collection_dialog.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:kingfishertom/features/widgets/carusel_artist_dialog/carusel_artist_dialog.dart';
import 'package:kingfishertom/features/widgets/search_field.dart';
import 'package:kingfishertom/gen/assets.gen.dart';

enum MenuItem {
  //Todo(Issa): [Dynamic Links] We will revisit sharing when we develop snobs with friends
  // share,
  rename,
  delete,
}

///
/// My Collections Page - the artist page
///
@RoutePage()
class MyLikedArtistPage extends StatelessWidget implements AutoRouteWrapper {
  const MyLikedArtistPage(
    this.currentCollection, {
    required this.delete,
    required this.exploreSubgenre,
    super.key,
    this.userId,
  });

  final ArtistCollectionDto currentCollection;
  final bool delete;
  final String? userId;
  final Function(String genre, String subgenre) exploreSubgenre;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<LikesArtistCubit>(
      create: (_) => LikesArtistCubit.create(currentCollection, userId),
      child: this,
    );
  }

  LikesArtistCubit _getCubit(BuildContext context) => context.read();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LikesArtistCubit, LikesArtistState>(
      listener: (BuildContext context, LikesArtistState state) {
        if (state.status == LikesArtistStatus.unlikeArtist) {
          showSuccessSnackBar(
            context,
            context.i10n.nameRemovedFromList(
              state.artist?.name ?? '',
              context.i10n.allLiked,
            ),
          );
        }
      },
      builder: (BuildContext context, LikesArtistState state) {
        return Scaffold(
          backgroundColor: lightColorScheme.onPrimary,
          body: Column(
            children: <Widget>[
              Container(
                height: 240,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      lightColorScheme.primaryContainer,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: _buildTopInfo(context, state),
                ),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: _buildCollectionList(context, state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopInfo(BuildContext context, LikesArtistState state) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildAppBar(context, state),
        ),
        if (state.showSearch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchField(
              hintText: context.i10n.searchArtistsCollectionsInLibrary,
              onChanged: (String query) {
                _getCubit(context).filterArtists(query, state.sortType);
              },
            ),
          )
        else
          Text(
            '${currentCollection.name} 🎧'.toTitleCase(),
            style: context.textStyle.headlineSmall,
          ),
        if (userId != null)
          Text(
            state.user?.name ?? '',
            style: context.textStyle.bodySmall,
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 180,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<SortType>(
                  dropdownColor: lightColorScheme.onSurface,
                  value: state.sortType,
                  items: SortType.values
                      .map(
                        (SortType type) => DropdownMenuItem<SortType>(
                          value: type,
                          child: Text(
                            type.gteString(context).toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (SortType? sortType) {
                    if (sortType != null) {
                      _getCubit(context).filterArtists(state.query, sortType);
                    }
                  },
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, LikesArtistState state) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: router.pop,
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: Colors.white54,
          ),
          iconSize: 20,
        ),
        const Spacer(),
        IconButton(
          onPressed: _getCubit(context).setShowSearch,
          icon: const Icon(Icons.search),
          color: Colors.white54,
        ),
        if (currentCollection.name != context.i10n.allLiked)
          _buildMenu(context, state),
      ],
    );
  }

  Widget _buildMenu(BuildContext context, LikesArtistState state) {
    return PopupMenuButton<MenuItem>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: lightColorScheme.onSurface,
      onSelected: (MenuItem item) async {
        switch (item) {
          //Todo(Issa): [Dynamic Links] We will revisit sharing when we develop snobs with friends
          /*      case MenuItem.share:
            final i10n = context.i10n;

            await Share.share(
              '${i10n.snobs}'
                  '\n\n${i10n.checkoutMyCollection(currentCollection.name)}'
                  '\n\n${await DynamicLinkProvider().createLink(state.user?.id ?? '', currentCollection.name)}',
              subject: i10n.snobs,
            );
*/
          case MenuItem.rename:
          // TODO: Handle this case.
          case MenuItem.delete:
            await showDialog<void>(
              context: context,
              builder: (_) => DeleteCollectionDialog(
                collectionName: currentCollection.name,
                onPressed: () {
                  Navigator.of(context).pop();
                  _getCubit(context).deleteCollection();
                },
              ),
            );
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<MenuItem>>[
          //Todo(Issa): [Dynamic Links] We will revisit sharing when we develop snobs with friends
          /*         PopupMenuItem<MenuItem>(
            value: MenuItem.share,
            child: Row(
              children: [
                const Icon(
                  Icons.share_outlined,
                  color: Colors.white54,
                ),
                const SizedBox(width: 8),
                Text(
                  context.i10n.share,
                  style: context.textStyle.titleSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),*/
          if (delete)
            PopupMenuItem<MenuItem>(
              value: MenuItem.rename,
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.edit_outlined,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.i10n.rename,
                    style: context.textStyle.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          if (delete)
            PopupMenuItem<MenuItem>(
              value: MenuItem.delete,
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(
                    Assets.icons.trash,
                    colorFilter: ColorFilter.mode(
                      lightColorScheme.error,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.i10n.delete,
                    style: context.textStyle.titleSmall?.copyWith(
                      color: lightColorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
        ];
      },
      child: const Icon(
        Icons.more_vert_outlined,
        color: Colors.white54,
      ),
    );
  }

  Widget _buildCollectionList(BuildContext context, LikesArtistState state) {
    if (state.status == LikesArtistStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < state.filteredArtists.length; i++)
            GestureDetector(
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (_) {
                    return CarouselArtistDialog(
                      onPageChanged: (int index) {
                        context.read<TrackAudioPlayerCubit>().playTrack(
                              state.filteredArtists[index],
                              fullSong: true,
                            );
                      },
                      initialIndex: i,
                      artists:
                          state.filteredArtists.map((ArtistChartDto artist) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: SingleArtistView(
                            artist: artist,
                              exploreSubgenre: (String genre, String subgenre){
                                exploreSubgenre(genre, subgenre);
                                Navigator.of(context).pop();
                              },
                            like:
                                state.user?.likes.contains(artist.id) ?? false,
                            collections: state.user?.collections
                                    .map((Map<String, dynamic> item) {
                                  return ArtistCollectionDto.fromJson(item);
                                }).toList() ??
                                <ArtistCollectionDto>[],
                            showCollectionButton: false,
                            unlikeArtist: () {
                              _getCubit(context).unlikeArtist(artist);
                            },
                            editArtistInCollections: (List<String> collect) {
                              _getCubit(context)
                                  .editArtistCollections(artist, collect);
                            },
                            addArtistInCollections: (List<String> collect) {
                              _getCubit(context)
                                  .addArtistToLiked(artist, collect);
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
              behavior: HitTestBehavior.opaque,
              child: ArtistTile(
                onDelete: () {
                  if (currentCollection.name == context.i10n.allLiked) {
                    _getCubit(context).unlikeArtist(
                      state.filteredArtists[i],
                    );
                    return;
                  }
                  _getCubit(context).removeArtistCollection(
                    state.filteredArtists[i],
                    currentCollection.name,
                  );
                },
                artist: state.filteredArtists[i],
                active: state.filteredArtists[i].id == state.currentArtist,
                setArtistCurrent: _getCubit(context).setCurrentArtist,
              ),
            ),
        ],
      ),
    );
  }
}
