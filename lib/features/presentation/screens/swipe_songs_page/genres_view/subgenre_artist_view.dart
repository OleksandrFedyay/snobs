import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/dtos/vote_genre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/artists_organization_view/artists_organization_view.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/confirm_dialog.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/cubit/genres_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/search_field.dart';
import 'package:kingfishertom/features/widgets/user_avatar.dart';

class SubgenreArtistView extends StatelessWidget {
  const SubgenreArtistView({
    required this.artist,
    required this.onCreateCollect,
    required this.allCollections,
    required this.artistCollections,
    required this.onCollectTap,
    super.key,
  });

  final ArtistChartDto artist;
  final VoidCallback onCreateCollect;
  final List<String> artistCollections;
  final List<String> allCollections;
  final ValueSetter<String> onCollectTap;

  GenresCubit _getCubit(BuildContext context) => context.read();

  bool votesContainsGenre(List<VoteGenre> votes, String genre) {
    for (final VoteGenre v in votes) {
      if (v.genre == genre) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenresCubit, GenresState>(
      builder: (BuildContext context, GenresState state) {
        if (state.search) return _buildSearch(context, state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${context.i10n.artistWillBeAddedTo}:',
              style: context.textStyle.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: lightColorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: <Widget>[
                  if (state.status == GenresStatus.loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    ...state.allVotes.where(
                      (VoteGenre v) {
                        return state.votes
                            .map((VoteGenre v) => v.genre)
                            .contains(v.genre);
                      },
                    ).map((VoteGenre v) => _buildSubgenre(context, v, state)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  context.i10n.addToMore,
                  style: context.textStyle.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        size: 20,
                        color: lightColorScheme.onSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.i10n.search,
                        style: context.textStyle.titleSmall?.copyWith(
                          color: lightColorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => _getCubit(context).setSearch(search: true),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: lightColorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: <Widget>[
                  _buildUserCollections(context, state.user),
                  ...state.genreSubgenres.map((GenreSubgenresTotal g) {
                    return _buildGenreSubgenres(context, state, g);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildSearch(BuildContext context, GenresState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SearchField(
          hintText: context.i10n.search,
          onChanged: _getCubit(context).setQuery,
        ),
        const SizedBox(height: 24),
        Text(
          context.i10n.collections,
          style: context.textStyle.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        _buildCollectionsAndSubgenres(context, state),
      ],
    );
  }

  Widget _buildCollectionsAndSubgenres(
    BuildContext context,
    GenresState state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: lightColorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: lightColorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                _buildUserSearchCollections(context, state),
                ...<LikedGenreSubgenreDto>[
                  for (final GenreSubgenresTotal g in state.genreSubgenres)
                    ...g.subgenres.map(
                      (SubgenreLiked s) {
                        return LikedGenreSubgenreDto(
                          subgenre: s,
                          genre: g.genre,
                        );
                      },
                    ),
                ].where((LikedGenreSubgenreDto s) {
                  if (s.subgenre.subGenre.contains(
                    state.query.toLowerCase().trim(),
                  )) {
                    return true;
                  }

                  return false;
                }).map(
                  (LikedGenreSubgenreDto sub) {
                    final GenreEnum genre = sub.genre.genreStingToEnum;
                    final bool selected =
                        votesContainsGenre(state.votes, sub.genre);
                    return GestureDetector(
                      onTap: () {
                        if (selected) {
                          _getCubit(context).updateSubgenres(
                            artist,
                            state.subgenres..remove(sub.genre),
                          );
                        } else {
                          _getCubit(context).updateSubgenres(
                            artist,
                            <String>[...state.subgenres, sub.genre],
                            sub.genre,
                          );
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Row(
                              children: <Widget>[
                                genre.getGenreIcon(20),
                                const SizedBox(width: 12),
                                Text(
                                  sub.subgenre.subGenre.toTitleCase(),
                                  style: context.textStyle.titleSmall?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                if (selected)
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: lightColorScheme.yellow,
                                    size: 24,
                                  )
                                else
                                  const Icon(
                                    Icons.add_circle_outline_outlined,
                                    color: Colors.white54,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white10,
                            height: 1,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSearchCollections(
    BuildContext context,
    GenresState state,
  ) {
    return Column(
      children: <Widget>[
        ...state.user?.collections.map((Map<String, dynamic> item) {
              return ArtistCollectionDto.fromJson(item);
            }).where((ArtistCollectionDto collect) {
              if (collect.name.toLowerCase().contains(
                    state.query.toLowerCase().trim(),
                  )) {
                return true;
              }

              return false;
            }).map(
              (ArtistCollectionDto collect) {
                final bool selected = artistCollections.contains(collect.name);
                return GestureDetector(
                  onTap: () => onCollectTap(collect.name),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: <Widget>[
                            UserAvatar(
                              user: state.user,
                              radius: 12,
                              fontSize: 12,
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              collect.name,
                              style: context.textStyle.titleSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            if (selected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: lightColorScheme.yellow,
                                size: 24,
                              )
                            else
                              const Icon(
                                Icons.add_circle_outline_outlined,
                                color: Colors.white54,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white10,
                        height: 1,
                        width: double.infinity,
                      ),
                    ],
                  ),
                );
              },
            ) ??
            <Widget>[],
      ],
    );
  }

  Widget _buildSubgenre(
    BuildContext context,
    VoteGenre chart,
    GenresState state,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) {
            return ConfirmArtistDialog(
              title: context.i10n.wouldYouLikeToRemove(
                artist.name,
                chart.genre.toTitleCase(),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                _getCubit(context).updateSubgenres(
                  artist,
                  state.subgenres..remove(chart.genre),
                );
              },
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              chart.genre.toTitleCase(),
              style: context.textStyle.bodyMedium,
            ),
            const Icon(
              Icons.clear,
              size: 16,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCollections(BuildContext context, UserModel? user) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      collapsedIconColor: Colors.white54,
      iconColor: Colors.white54,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: <Widget>[
          UserAvatar(
            user: user,
            radius: 12,
            fontSize: 12,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 8),
          Text(
            context.i10n.myCollections,
            style: context.textStyle.displaySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onCreateCollect,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 8, top: 8),
              child: Text(
                context.i10n.createCustom.toUpperCase(),
                style: context.textStyle.labelMedium?.copyWith(
                  color: lightColorScheme.yellowLight,
                ),
              ),
            ),
          ),
        ),
        ...allCollections.map(
          (String collect) {
            final bool selected = artistCollections.contains(collect);
            return GestureDetector(
              onTap: () => onCollectTap(collect),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 12, 12, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      collect,
                      style: context.textStyle.titleSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    if (selected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: lightColorScheme.yellow,
                        size: 24,
                      )
                    else
                      const Icon(
                        Icons.add_circle_outline_outlined,
                        color: Colors.white54,
                        size: 24,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGenreSubgenres(
    BuildContext context,
    GenresState state,
    GenreSubgenresTotal g,
  ) {
    final GenreEnum genre = g.genre.genreStingToEnum;

    return ExpansionTile(
      tilePadding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      collapsedIconColor: Colors.white54,
      iconColor: Colors.white54,
      title: Row(
        children: <Widget>[
          genre.getGenreIcon(20),
          const SizedBox(width: 8),
          Text(
            g.genre.toTitleCase(),
            style: context.textStyle.displaySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
      children: g.subgenres.map(
        (SubgenreLiked sub) {
          final bool selected = votesContainsGenre(state.votes, sub.subGenre);
          return GestureDetector(
            onTap: () {
              if (selected) {
                _getCubit(context).updateSubgenres(
                  artist,
                  state.subgenres..remove(sub.subGenre),
                );
              } else {
                _getCubit(context).updateSubgenres(
                  artist,
                  <String>[...state.subgenres, sub.subGenre],
                  sub.subGenre,
                );
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(36, 12, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    sub.subGenre.toTitleCase(),
                    style: context.textStyle.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  if (selected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: lightColorScheme.yellow,
                      size: 24,
                    )
                  else
                    const Icon(
                      Icons.add_circle_outline_outlined,
                      color: Colors.white54,
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
