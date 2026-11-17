import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/kingfishertom_api/kingfishertom_api_client.dart';
import 'package:kingfishertom/core/data/api/rebelation_api/rebelation_api_client.dart';

@module
abstract class ApiModule {
  @lazySingleton
  Dio dio() {
    return Dio()
      ..options.sendTimeout = const Duration(seconds: 10000)
      ..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
  }

  @lazySingleton
  RebelationApiClient apiClient(Dio dio) => RebelationApiClient(dio);

  ///TODO check this kingfishertomApiClient.
  ///New Api client for the DB migration .
  @lazySingleton
  KingfishertomApiClient kingfishertomApiClient(Dio dio) =>
      KingfishertomApiClient(dio);
}
