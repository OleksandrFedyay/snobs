import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/services/di/injection.config.dart';

GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureGitItDependencies() async => getIt.init();
