import 'package:injectable/injectable.dart';
import 'package:kingfishertom/features/presentation/resources/routing/app.router.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';

@module
abstract class RouterModule {
  @singleton
  AppAutoRouter snobsAppAutoRouter() {
    return AppAutoRouter();
  }

  @singleton
  SnobsRouter snobsRouter(AppAutoRouter router) {
    return SnobsRouter(router);
  }
}
