import 'package:flutter/material.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/snackbar/snack_bar_service.dart';
import 'package:kingfishertom/features/presentation/resources/routing/app.router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/dark.theme.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/l10n/generated/snobs_app_localizations.dart';

class Snobs extends StatefulWidget {
  const Snobs({super.key});

  @override
  State<Snobs> createState() => _SnobsState();
}

class _SnobsState extends State<Snobs> {
//  final Smartlook smartLook = Smartlook.instance;
  final AppAutoRouter appAutoRouter = getIt<AppAutoRouter>();

  @override
  void initState() {
    super.initState();
    //Todo(Issa): [Dynamic Links] We will revisit sharing when we develop snobs with friends
/*    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await DynamicLinkProvider().initDynamicLink();
      });
     // smartLook.start();
   //   smartLook.preferences.setProjectKey(StringsRes.smartLookApiKey);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    //Todo(Issa): need to remove this if no needed more!
    // SmartlookRecordingWidget()
    return MaterialApp.router(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData mediaQueryData = MediaQuery.of(context);

        // Calculate the scaled text factor using the clamp function to ensure it stays within a specified range.
        final TextScaler scale = mediaQueryData.textScaler.clamp(
          minScaleFactor: 1, // Minimum scale factor allowed.
          maxScaleFactor: 1.5, // Maximum scale factor allowed.
        );

        // Create a new MediaQueryData with the updated text scaling factor.
        // This will override the existing text scaling factor in the MediaQuery.
        // This ensures that text within this subtree is scaled according to the calculated scale factor.
        //Todo(Issa): need to use flutter_screenutil instead of MediaQuery!!! The MediaQuery is used for web size to be = 500
        return MediaQuery(
          // Copy the original MediaQueryData and replace the textScaler with the calculated scale.
          data: mediaQueryData.copyWith(
            textScaler: scale,
          ),
          // Pass the original child widget to maintain the widget hierarchy.
          child: Scaffold(
            backgroundColor: lightColorScheme.onPrimary,
            body: Center(
              child: SizedBox(
                width: context.width,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
      debugShowCheckedModeBanner: false,
      localizationsDelegates: SnobsAppLocalizations.localizationsDelegates,
      supportedLocales: SnobsAppLocalizations.supportedLocales,
      routeInformationParser: appAutoRouter.defaultRouteParser(),
      routeInformationProvider: appAutoRouter.routeInfoProvider(),
      routerDelegate: appAutoRouter.delegate(),
      theme: darkTheme,
      scaffoldMessengerKey: getIt<SnackBarService>().scaffoldMessengerKey,
      // debugShowMaterialGrid: true,
    );
  }
}
