import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

abstract class BaseRouter {
  const BaseRouter(this.stackRouter);
  final StackRouter stackRouter;

  T? getObserver<T extends AutoRouteObserver>(BuildContext context) {
    return RouterScope.of(context).firstObserverOfType<T>();
  }

  void popToRoot() => stackRouter.popUntilRoot();

  Future<void> pushByPath(String path) => stackRouter.pushNamed(path);

  Future<void> pop() => stackRouter.maybePop();

  void popUntilPath(String path) => stackRouter.popUntilRouteWithName(path);

  Future<T?> push<T>(PageRouteInfo<dynamic> route) async {
    return stackRouter.push<T>(route);
  }

  Future<void> replace(PageRouteInfo<dynamic> route) =>
      stackRouter.replace(route);

  Future<void> replacePath(String path) => stackRouter.replaceNamed(path);

  Future<void> pushAndClearStack(PageRouteInfo<dynamic> route) {
    return stackRouter.pushAndPopUntil(route, predicate: (_) => false);
  }
}
