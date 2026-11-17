import 'dart:async';

import 'package:auto_route/auto_route.dart' show AutoRouteWrapper, RoutePage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/splash/cubit/splash_page_cubit.dart';
import 'package:kingfishertom/features/utils/preload_images.dart';
import 'package:kingfishertom/features/widgets/something_went_wrong.widget.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:upgrader/upgrader.dart';

@RoutePage()
class SplashPage extends StatefulWidget implements AutoRouteWrapper {
  const SplashPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<SplashPageCubit>(
      create: (_) => SplashPageCubit.create()..init(),
      child: this,
    );
  }

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final StreamSubscription<SplashPageState> _cubitStreamSubscription;

  SplashPageCubit get cubit => context.read();

  @override
  void initState() {
    super.initState();

    _cubitStreamSubscription = cubit.stream.listen(
      _listener,
      cancelOnError: true,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    preloadPNGJPG(context);
    preloadSVG(context);
  }

  @override
  void dispose() {
    _cubitStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      dialogStyle: UpgradeDialogStyle.cupertino,
      cupertinoButtonTextStyle: const TextStyle(color: Colors.white),
      child: Scaffold(
        backgroundColor: lightColorScheme.deepPurpleBackground,
        body: BlocBuilder<SplashPageCubit, SplashPageState>(
          builder: (BuildContext context, SplashPageState state) {
            if (state is SplashPageStateInitError) {
              return const SomethingWentWrongWidget();
            }

            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    lightColorScheme.deepPurple,
                    lightColorScheme.deepPurple.withValues(alpha: .6),
                    lightColorScheme.deepPurple,
                  ],
                ),
              ),
              child: Align(
                child: SvgPicture.asset(
                  Assets.logos.snobsLogoImage,
                  height: 80,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _listener(SplashPageState state) {
    if (state is SplashPageStateGoToApp) {
      router.pushAndClearStackHomeRoute();
    } else if (state is SplashPageSelectGenre) {
      router.pushAndClearStackSelectGenreRoute('');
    } else if (state is SplashPageStateNotSignedIn) {
      router.pushAndClearStackLoginRoute();
    }
  }
}
