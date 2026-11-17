import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/notifications/cubit/notification_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

@RoutePage()
class NotificationPage extends StatefulWidget implements AutoRouteWrapper {
  const NotificationPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<NotificationCubit>(
      create: (_) => NotificationCubit.create(),
      child: this,
    );
  }

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationCubit _getCubit(BuildContext context) => context.read();

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 4, top: padding.top),
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
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: router.pop,
                      icon: Icon(
                        Icons.adaptive.arrow_back,
                        color: Colors.white54,
                      ),
                      iconSize: 20,
                    ),
                    const Spacer(flex: 2),
                    Text(
                      context.i10n.notifications,
                      style: context.textStyle.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: _buildContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, NotificationState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: lightColorScheme.onSurface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    context.i10n.notifications,
                    style: context.textStyle.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  CupertinoSwitch(
                    activeTrackColor: lightColorScheme.surfaceContainerHighest,
                    inactiveTrackColor:
                        lightColorScheme.surfaceContainerHighest,
                    thumbColor: state.notificationTurn ? null : Colors.white54,
                    value: state.notificationTurn,
                    onChanged: (bool value) async {
                      if (value) {
                        await _getCubit(context).turnOnNotification();

                        return;
                      }
                      await _getCubit(context).turnOffNotification();
                    },
                  ),
                ],
              ),
              Text(
                context.i10n.getRealTimeNotificationsAndAlerts,
                style: context.textStyle.displaySmall?.copyWith(
                  color: lightColorScheme.onSecondary,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}
