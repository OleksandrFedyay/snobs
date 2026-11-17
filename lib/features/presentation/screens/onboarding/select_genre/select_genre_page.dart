import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/presentation/screens/onboarding/select_genre/cubit/select_genre_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';

@RoutePage()
class SelectGenrePage extends StatelessWidget implements AutoRouteWrapper {
  const SelectGenrePage({
    required this.name,
    super.key,
  });

  final String? name;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<SelectGenreCubit>(
      create: (_) => SelectGenreCubit.create(),
      child: this,
    );
  }

  SelectGenreCubit cubit(BuildContext context) => context.read();

  void _onGenreChanged(BuildContext context, String genre) {
    cubit(context).setGenre(genre);
  }

  void _onStateChanged(BuildContext context, SelectGenreState state) {
    switch (state.status) {
      case SelectGenreStatus.error:
        state.errorMessage.showSnackBarInfo;
      case SelectGenreStatus.success:
        router.pushAndClearStackHomeRoute();

      case SelectGenreStatus.initial:
      case SelectGenreStatus.loading:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: SafeArea(
        child: BlocConsumer<SelectGenreCubit, SelectGenreState>(
          listener: _onStateChanged,
          builder: _buildBody,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SelectGenreState state) {
    if (state.status == SelectGenreStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: IconButton(
                onPressed: router.pop,
                icon: Icon(
                  Icons.adaptive.arrow_back,
                  color: Colors.white,
                ),
                iconSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${context.i10n.hi} ' '$name!',
              style: context.textStyle.bodyLarge?.copyWith(
                color: lightColorScheme.onSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.i10n.whatGenreWouldYouLikeToExploreFirst,
            style: context.textStyle.headlineSmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: state.genres.map(
              (Genre g) {
                final GenreEnum genre = g.name.genreStingToEnum;
                final bool selectedGenre = g == state.genre;

                final double width =
                    (MediaQuery.of(context).size.width - 80) / 4;
                return GestureDetector(
                  onTap: () => _onGenreChanged(context, g.name),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: width * 1.1,
                        width: width,
                        decoration: BoxDecoration(
                          color: lightColorScheme.onPrimaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: lightColorScheme.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: selectedGenre
                                ? Border.all(
                                    color: lightColorScheme.yellowLight,
                                  )
                                : null,
                            gradient: selectedGenre
                                ? LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: <Color>[
                                      ...genre.getColors(.6),
                                      lightColorScheme.backgroundGrey.withValues(alpha: 0.5),
                                    ],
                                  )
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              genre.getGenreIcon(36, Colors.white),
                              const SizedBox(height: 4),
                              Text(
                                g.name.toTitleCase(),
                                style: context.textStyle.labelSmall?.copyWith(
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (selectedGenre)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: lightColorScheme.yellowLight,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
          const Spacer(),
          AppButton(
            width: 160,
            style: AppThemeModel.instance.getWelcomeButtonTheme().style,
            enabled: state.genre.name.isNotEmpty,
            withArrow: false,
            onPressed: cubit(context).saveGenre,
            text: context.i10n.continueTitle.toUpperCase(),
          ),
        ],
      ),
    );
  }
}
