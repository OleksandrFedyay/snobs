import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/home/home_content_wrapper.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/components/bottom_nav_bar_item.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/track_view.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/cubit/library_page_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/cubit/profile_page_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/search_page/cubit/search_page_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/cubit/swipe_songs_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:provider/single_child_widget.dart';

@RoutePage()
class HomePage extends StatefulWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<HomeCubit>(create: (_) => HomeCubit.create()),
        BlocProvider<LibraryPageCubit>(
            create: (_) => LibraryPageCubit.create()),
        BlocProvider<SwipeSongsPageCubit>(
            create: (_) => SwipeSongsPageCubit.create()),
        BlocProvider<SearchPageCubit>(create: (_) => SearchPageCubit.create()),
        BlocProvider<ProfilePageCubit>(
            create: (_) => ProfilePageCubit.create()),
      ],
      child: this,
    );
  }
}

class _HomePageState extends State<HomePage> {
  List<ConnectivityResult> _connectionStatus = <ConnectivityResult>[];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  int index = 0;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log("Couldn't check connectivity status", error: e);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  List<Color> colors = <ui.Color>[
    lightColorScheme.surfaceContainerHighest,
    lightColorScheme.surfaceContainerHighest,
    lightColorScheme.surfaceContainerHighest,
    lightColorScheme.surfaceContainerHighest,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<HomeCubit>().isTrialOrSubscriptionActive;
  }

  Widget get child => HomeContentWrapper(
        index: index,
        changeIndex: (int i) {
          setState(() {
            index = i;
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    final List<ui.Color> gradientColors = <ui.Color>[...colors]..[index] =
        const Color(0xFF221A29);

    return Scaffold(
      backgroundColor: lightColorScheme.surfaceContainerHighest,
      body: _connectionStatus.contains(ConnectivityResult.none)
          ? Center(
              child: Text(context.i10n.noInternetConnection),
            )
          : child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: 68,
              color: lightColorScheme.onPrimary,
              child: BottomTrackView(
                exploreSubgenre: (String genre, String subgenre) {
                  setState(() {
                    index = 0;
                  });
                  context.read<HomeCubit>().setGenre(genre, subgenre);
                },
              )),
          Container(
            height: 1,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
              ),
            ),
          ),
          ColoredBox(
            color: lightColorScheme.onPrimary,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                bottomBarItem(
                  activeIcon: Assets.tab.activeCardSwipe,
                  inactiveIcon: Assets.tab.inactiveCardSwipe,
                ),
                bottomBarItem(
                  activeIcon: Assets.tab.activeLibrary,
                  inactiveIcon: Assets.tab.inactiveLibrary,
                ),
                bottomBarItem(
                  activeIcon: Assets.tab.searchIcon,
                  inactiveIcon: Assets.tab.searchIcon,
                ),
                bottomBarItem(
                  activeIcon: Assets.tab.activeProfile,
                  inactiveIcon: Assets.tab.inactiveProfile,
                ),
              ],
              currentIndex: index,
              onTap: (int i) {
                setState(() {
                  index = i;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
