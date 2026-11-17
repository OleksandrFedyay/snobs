import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:kingfishertom/gen/assets.gen.dart';


@RoutePage()
class GetMusicPage extends StatelessWidget {
  const GetMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: Column(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xFF0D0A2C),
                      Color(0xFF0D0A2C),
                      Color(0xFF9613AD),
                    ],
                  ),
                ),
                child: Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: router.pop,
                            icon: Icon(
                              Icons.adaptive.arrow_back,
                              color: Colors.white,
                            ),
                            iconSize: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            context.i10n.getYourMusicHeard,
                            style: context.textStyle.headlineMedium?.copyWith(
                              fontSize: 36,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            context.i10n.ourCommunityOfNewExplorers,
                            style: context.textStyle.bodyLarge,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Assets.images.artists.image(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.i10n.claimYourArtistProfileToSeeHowMany,
              style: context.textStyle.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              style: AppThemeModel.instance.getWelcomeButtonTheme().style,
              withArrow: false,
              onPressed: () {},
              text: context.i10n.setUpYourFreeAccount.toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }
}
