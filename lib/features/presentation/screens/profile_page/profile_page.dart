import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kingfishertom/core/data/api/models/dtos/badge.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/dtos/tasks_dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/local_data/local.genres_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/feedback_view.dart';
import 'package:kingfishertom/features/presentation/common_pages/premium/trail_premium_view.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/badges/badges_enum.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/cubit/profile_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/icons/snobs_icons.dart';
import 'package:kingfishertom/features/widgets/badge_view.dart';
import 'package:kingfishertom/features/widgets/custom_slider.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.genres,
    required this.onGetPremium,
    required this.onExploreSubgenre,
    super.key,
  });

  final List<GenreSubgenresTotal> genres;
  final VoidCallback onGetPremium;
  final void Function(String genre, String subgenre) onExploreSubgenre;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String getDescription(
    BuildContext context, {
    required UserModel? user,
    required TasksDto task,
    required int exploredSubgenres,
  }) {
    if (task.id == 'explore30subgenres') {
      return context.i10n.swipe10xInSubgenres(30 - exploredSubgenres);
    }
    if (task.id == '1000totalswipes') {
      return context.i10n.swipeMoreTimes(1000 - (user?.swipesCount ?? 0));
    }
    if (task.id == '50totalswipes') {
      return context.i10n.swipeMoreTimes(50 - (user?.swipesCount ?? 0));
    }
    if (task.id == 'explore100subgenres') {
      return context.i10n.swipe10xInSubgenres(100 - exploredSubgenres);
    }
    if (task.id == '5000totalswipes') {
      return context.i10n.swipeMoreTimes(5000 - (user?.swipesCount ?? 0));
    }
    if (task.id == 'explore50subgenres') {
      return context.i10n.swipe10xInSubgenres(50 - exploredSubgenres);
    }
    if (task.id == '2500totalswipes') {
      return context.i10n.swipeMoreTimes(2500 - (user?.swipesCount ?? 0));
    }
    if (task.id == 'explore10subgenres') {
      return context.i10n.swipe10xInSubgenres(10 - exploredSubgenres);
    }
    if (task.id == '300totalswipes') {
      return context.i10n.swipeMoreTimes(300 - (user?.swipesCount ?? 0));
    }

    return task.description;
  }

  void _onFilePick(BuildContext context, ValueSetter<File> onComplete) {
    context.read<ProfilePageCubit>().pickProfilePhoto(
      onComplete: onComplete,
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          hideBottomControls: true,
          toolbarColor: lightColorScheme.main,
        ),
        IOSUiSettings(
          doneButtonTitle: context.i10n.done,
          cancelButtonTitle: context.i10n.cancel,
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProfilePageCubit>().isTrialOrSubscriptionActive;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: _buildContent());
  }

  Widget _buildContent() {
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
      builder: (BuildContext context, ProfilePageState state) {
        final List<String> labels = <String>[
          context.i10n.quest,
          context.i10n.genreLevels,
          context.i10n.badges,
        ];

        if (state.status == MenuStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              _buildTopInfo(context, state),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightColorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        for (int i = 0; i < labels.length; i++)
                          CupertinoButton(
                            padding: const EdgeInsets.only(left: 8),
                            onPressed: () =>
                                context.read<ProfilePageCubit>().setIndex(i),
                            child: _buildLabel(
                              context,
                              labels[i],
                              i == state.index,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (state.index == 0)
                      _buildQuestView(context, state)
                    else if (state.index == 1)
                      _buildLevelsView(context, state)
                    else if (state.index == 2)
                      if (state.badges.isNotEmpty)
                        GridView.count(
                          crossAxisCount: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 3 / 1,
                          children: state.badges
                              .where((BadgeDto test) =>
                                  //Todo(Issa): When will a new data base need to change/remove [test.type == BadgesType.golden]
                                  test.type == BadgesType.golden)
                              .map((BadgeDto badge) {
                            return BadgeView(
                              onExploreSubgenre: widget.onExploreSubgenre,
                              genre: BadgesType.getGenreFromSubgenre(
                                  widget.genres, badge.subgenre),
                              number: badge.type.getNumber(),
                              subgenre: badge.subgenre.toLowerCase(),
                            );
                          }).toList(),
                        )
                      else
                        _buildEmptyBadgeView(context),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    showMaterialModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => FeedbackView.create(),
                    );
                  },
                  child: Text(
                    context.i10n.giveFeedback,
                    style: context.textStyle.labelMedium?.copyWith(
                      color: lightColorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment(-0.15, 0),
                child: Icon(
                  SnobsIcons.snobsLogoGrey,
                  size: 30,
                  color: Colors.white24,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(BuildContext context, String title, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? lightColorScheme.yellowLight : Colors.white,
        ),
      ),
      child: Text(
        title,
        style: context.textStyle.bodySmall?.copyWith(
          color: active ? lightColorScheme.yellowLight : Colors.white,
        ),
      ),
    );
  }

  Widget _buildTopInfo(BuildContext context, ProfilePageState state) {
    final String? name = state.user?.name;
    final String imageUrl = state.user?.imageUrl ?? '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(width: 24),
        Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _onFilePick(
                    context, context.read<ProfilePageCubit>().updatePhoto);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: imageUrl.isNotEmpty
                    ? Container(
                        key: ValueKey<String>(imageUrl),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: lightColorScheme.yellowLight,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(40),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) =>
                                  const SizedBox.shrink(),
                              placeholder: (BuildContext context, String url) =>
                                  const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: lightColorScheme.yellowLight,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: lightColorScheme.yellowLight,
                          ),
                        ),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: lightColorScheme.onSurface,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  state.level?.name ?? '',
                  style: context.textStyle.displaySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (name != null)
                Text(
                  name,
                  style: context.textStyle.headlineLarge?.copyWith(
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.fade,
                ),
              const SizedBox(height: 16),
              if (!state.isTrialOrSubscriptionActive)
                _buildSnobPremium(context, state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSnobPremium(BuildContext context, ProfilePageState state) {
    return Container(
      height: 38,
      width: 148,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        gradient: LinearGradient(
          stops: <double>[0.03, 0.15, 0.27, 0.55, 0.82, 1],
          colors: <Color>[
            Color(0xFFEDC45B),
            Color(0xFFF7D274),
            Color(0xFFE9BE50),
            Color(0xFFF7D274),
            Color(0xFFD0A841),
            Color(0xFFF7D274),
          ],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: lightColorScheme.fieldText,
          alignment: Alignment.center,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          textStyle: context.textStyle.labelMedium?.copyWith(
            color: lightColorScheme.fieldText,
          ),
        ),
        onPressed: () async {
          unawaited(FirebaseAnalytics.instance.logEvent(
            name: 'trial_30_day_profile_impression',
            parameters: <String, Object>{
              'source_page': StringsRes.profilePage,
            },
          ));
          await TrailPremiumViewDialog.showDialog(
            context: context,
            isTrail: state.user?.daysLeft == null,
            pageName: StringsRes.profilePage,
          );
          await getIt<PurchasesCat>()
              .isActiveOffer()
              .then((bool isActive) async {
            if (isActive) {
              widget.onGetPremium();
              //Todo(Issa): Need to show tool tip when the User got the premium account from Profile Page on the Library page
              // final LibraryTabCubit cubit = context.read<LibraryTabCubit>();
              // await cubit.updateStatus();
            }
          });
        },
        child: Text(context.i10n.getPremium.toUpperCase()),
      ),
    );
  }

  Widget _buildQuestView(BuildContext context, ProfilePageState state) {
    final double value = (state.user?.levelXp ?? 0) / (state.level?.xp ?? 1);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _ranksPanel(context.i10n.currentRank, state.level?.name ?? ''),
            _ranksPanel(
              context.i10n.nextRank,
              state.level?.xp.rankNextLevel ?? '',
              true,
            ),
          ],
        ),
        CustomSlider(
          value: value == 0 ? 0.01 : value,
          padding: EdgeInsets.zero,
          onChanged: (_) {},
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              '${(state.level?.xp ?? 0) - (state.user?.levelXp ?? 0)} ${context.i10n.xp} ${context.i10n.toLevelUp}',
              style: context.textStyle.bodySmall,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.i10n.completeObjectivesToEarnXP,
          style: context.textStyle.titleMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        ...state.level?.tasks.map(
              (TasksDto task) {
                return _buildTask(
                  context,
                  state.user,
                  task,
                  state.user?.completedTasks.contains(task.id) ?? false,
                );
              },
            ) ??
            <Widget>[],
      ],
    );
  }

  Widget _buildLevelsView(BuildContext context, ProfilePageState state) {
    return Column(
      children: widget.genres
          .sorted((GenreSubgenresTotal a, GenreSubgenresTotal b) =>
              b.swipesCount.compareTo(a.swipesCount))
          .map((GenreSubgenresTotal g) {
        final int swipesCount = g.swipesCount;
        final int level = g.level;
        final int nextLevel = level * (level + 1) * 10;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(width: 16),
                Text(
                  g.genre.toTitleCase(),
                  style: context.textStyle.titleLarge,
                ),
                const SizedBox(width: 20),
                Text(
                  '${context.i10n.level} ${level > 20 ? 20 : level}',
                  style: context.textStyle.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomSlider(
              value: swipesCount / nextLevel,
              onChanged: (_) {},
            ),
            Row(
              children: <Widget>[
                const SizedBox(width: 16),
                Text(
                  '$swipesCount ${context.i10n.swipes}',
                  style: context.textStyle.bodySmall?.copyWith(
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (level < 20)
                  Text(
                    '${context.i10n.levelUpAt} $nextLevel ${context.i10n.swipes}',
                    style: context.textStyle.bodySmall,
                  ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTask(
    BuildContext context,
    UserModel? user,
    TasksDto task,
    bool completed,
  ) {
    final List<SubgenreLiked> subgenres =
        getIt<LocalGenresInfoDataSourceImpl>().getSubgenres();
    final Iterable<SubgenreLiked> exploredSubgenres =
        subgenres.where((SubgenreLiked g) => g.likes + g.unlikes > 10);

    return Column(
      children: <Widget>[
        if (completed)
          Row(
            children: <Widget>[
              Icon(
                Icons.check_circle_rounded,
                color: lightColorScheme.yellowLight,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      task.title,
                      style: context.textStyle.titleMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: lightColorScheme.onSecondary,
                        decorationThickness: 3,
                        color: lightColorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      '${task.xp} ${context.i10n.claimed} ${context.i10n.xp}',
                      style: context.textStyle.bodySmall,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          )
        else
          Row(
            children: <Widget>[
              Icon(
                Icons.circle_outlined,
                color: lightColorScheme.greyTextColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      task.title,
                      style: context.textStyle.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      getDescription(
                        context,
                        user: user,
                        task: task,
                        exploredSubgenres: exploredSubgenres.length,
                      ),
                      style: context.textStyle.bodySmall,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${task.xp} ${context.i10n.xp}',
                style: context.textStyle.displaySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        Container(
          color: Colors.white10,
          height: 1,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildEmptyBadgeView(BuildContext context) {
    return Stack(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2 / 1,
          children: <Widget>[
            _buildContainerWithOpacity(.7),
            _buildContainerWithOpacity(.7),
            _buildContainerWithOpacity(.5),
            _buildContainerWithOpacity(.5),
            _buildContainerWithOpacity(.2),
            _buildContainerWithOpacity(.2),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                context.i10n.earnBadges,
                style: context.textStyle.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                context.i10n.swipe100timesInAnySubgenreToEarn,
                style: context.textStyle.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContainerWithOpacity(double opacity) {
    return Container(
      decoration: BoxDecoration(
        color: lightColorScheme.onPrimary.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _ranksPanel(String levelState, String rankTitle,
          [bool isRight = false]) =>
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 12),
        child: Column(
          crossAxisAlignment:
              isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              levelState,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: lightColorScheme.onSecondary,
                fontFamily: FontFamily.nunitoSans,
              ),
            ),
            Text(
              rankTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: FontFamily.nunitoSans,
              ),
            ),
          ],
        ),
      );
}
