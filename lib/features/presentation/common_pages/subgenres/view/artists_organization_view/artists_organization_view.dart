import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/presentation/common_pages/create_collection/create_collection_page.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/artists_organization_view/cubit/artists_organization_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:kingfishertom/features/widgets/search_field.dart';
import 'package:kingfishertom/features/widgets/user_avatar.dart';

const String key = 'Key';

//Note: This page is opening when clicks on the artist item and then clicks the [Icons.add_to_photos_outlined]
class ArtistsOrganizationView extends StatefulWidget {
  const ArtistsOrganizationView._({
    required this.artists,
    required this.user,
  });

  final List<ArtistChartDto> artists;
  final UserModel? user;

  static Widget create({
    required List<ArtistChartDto> artists,
    required UserModel? user,
  }) {
    return BlocProvider<ArtistsOrganizationCubit>(
      create: (_) => ArtistsOrganizationCubit.create()
        ..init(
          artists,
          user?.collections.map(ArtistCollectionDto.fromJson).toList() ??
              <ArtistCollectionDto>[],
        ),
      child: ArtistsOrganizationView._(
        artists: artists,
        user: user,
      ),
    );
  }

  @override
  State<ArtistsOrganizationView> createState() =>
      _ArtistsOrganizationViewState();
}

class _ArtistsOrganizationViewState extends State<ArtistsOrganizationView> {
  ArtistsOrganizationCubit get cubit => context.read();

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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: lightColorScheme.onPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<ArtistsOrganizationCubit, ArtistsOrganizationState>(
      builder: (BuildContext context, ArtistsOrganizationState state) {
        if (state.status == ArtistsOrganizationStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildTopInfo(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SearchField(
                            hintText: context.i10n.search,
                            onChanged: cubit.setQuery,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            context.i10n.collections,
                            style: context.textStyle.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildCollectionsAndSubgenres(state),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppButton(
              loading: state.status == ArtistsOrganizationStatus.loadingButton,
              onPressed: () => cubit.update(widget.artists),
              withArrow: false,
              style: AppThemeModel.instance.getWelcomeButtonTheme().style,
              text: context.i10n.confirm.toUpperCase(),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 24,
            ),
          ],
        );
      },
      listener: (BuildContext context, ArtistsOrganizationState state) {
        switch (state.status) {
          case ArtistsOrganizationStatus.success:
            Navigator.of(context).pop();

          case ArtistsOrganizationStatus.loadingButton:
          case ArtistsOrganizationStatus.initial:
          case ArtistsOrganizationStatus.error:
          case ArtistsOrganizationStatus.loading:
        }
      },
    );
  }

  Widget _buildTopInfo() {
    final int length = widget.artists.length > 4 ? 4 : widget.artists.length;
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
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox(
                height: 44,
                width: 140,
                child: Stack(
                  children: <Widget>[
                    for (int i = 0; i < length; i++)
                      Positioned(
                        left: i * 30,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: lightColorScheme.onSurface,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(20),
                              child: CachedNetworkImage(
                                imageUrl: widget.artists[i].image,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                    const SizedBox.shrink(),
                                placeholder:
                                    (BuildContext context, String url) =>
                                        const CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (widget.artists.length > 4)
                      Positioned(
                        left: 90,
                        child: Container(
                          height: 44,
                          width: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: lightColorScheme.onSurface,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '+${widget.artists.length - 4}',
                            style: context.textStyle.bodySmall,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: context.i10n.amountArtists(widget.artists.length),
                  style: context.textStyle.headlineMedium?.copyWith(
                    color: lightColorScheme.yellowLight,
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: context.i10n.willBeUpdated,
                      style: context.textStyle.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCollectionsAndSubgenres(ArtistsOrganizationState state) {
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
                _buildUserCollections(context, state),
                if (state.query.trim().isNotEmpty)
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
                      final bool selected = state.subgenres.contains(sub.genre);
                      final GenreEnum genre = sub.genre.genreStingToEnum;
                      return GestureDetector(
                        onTap: () {
                          if (selected) {
                            cubit.removeSubgenre(sub.genre);
                          } else {
                            cubit.setSubgenres(
                                <String>[...state.subgenres, sub.genre]);
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
                                    style:
                                        context.textStyle.titleSmall?.copyWith(
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
                  )
                else
                  ...state.genreSubgenres.map((GenreSubgenresTotal g) {
                    return _buildGenreSubgenres(
                      context,
                      state,
                      g,
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCollections(
    BuildContext context,
    ArtistsOrganizationState state,
  ) {
    if (state.query.trim().isNotEmpty) {
      return Column(
        children: <Widget>[
          ...state.artistCollections.where((ArtistCollectionDto collect) {
            if (collect.name.toLowerCase().contains(
                  state.query.toLowerCase().trim(),
                )) {
              return true;
            }

            return false;
          }).map(
            (ArtistCollectionDto collect) {
              final bool selected =
                  state.selectedArtistCollections.contains(collect.name);
              return GestureDetector(
                onTap: () => cubit.selectCollection(collect.name),
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
                            user: widget.user,
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
          ),
        ],
      );
    }

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
            user: widget.user,
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
          onTap: () {
            CreateCollectionPage.showModalDialog(context, (String name) {
              Navigator.of(context).pop();
              cubit.addCollection(name);
            });
          },
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
        ...state.artistCollections.map(
          (ArtistCollectionDto collect) {
            final bool selected =
                state.selectedArtistCollections.contains(collect.name);
            return GestureDetector(
              onTap: () => cubit.selectCollection(collect.name),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 12, 12, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      collect.name,
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
    ArtistsOrganizationState state,
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
          final bool selected = state.subgenres.contains(sub.subGenre);
          return GestureDetector(
            onTap: () {
              if (selected) {
                cubit.removeSubgenre(sub.subGenre);
              } else {
                cubit.setSubgenres(<String>[...state.subgenres, sub.subGenre]);
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

class LikedGenreSubgenreDto {
  const LikedGenreSubgenreDto({
    required this.genre,
    required this.subgenre,
  });

  final SubgenreLiked subgenre;
  final String genre;
}
