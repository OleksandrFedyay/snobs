// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:kingfishertom/core/configuration/auth.module.dart' as _i162;
import 'package:kingfishertom/core/configuration/storage.module.dart' as _i338;
import 'package:kingfishertom/core/data/api/kingfishertom_api/kingfishertom_api_client.dart'
    as _i235;
import 'package:kingfishertom/core/data/api/kingfishertom_api/kingfishertom_api_service.dart'
    as _i51;
import 'package:kingfishertom/core/data/api/rebelation_api/rebelation_api_client.dart'
    as _i56;
import 'package:kingfishertom/core/data/api/rebelation_api/rebelation_api_service.dart'
    as _i538;
import 'package:kingfishertom/core/data/auth/auth.repository.impl.dart'
    as _i302;
import 'package:kingfishertom/core/data/auth/local.user_jwt_source.dart'
    as _i923;
import 'package:kingfishertom/core/data/auth/logout.service.impl.dart' as _i862;
import 'package:kingfishertom/core/data/auth/remote.auth.jwt_source.dart'
    as _i75;
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart'
    as _i818;
import 'package:kingfishertom/core/data/data_sources/remote.badge.data_source.dart'
    as _i870;
import 'package:kingfishertom/core/data/data_sources/remote.feedback.data_source.dart'
    as _i309;
import 'package:kingfishertom/core/data/data_sources/remote.level.data_source.dart'
    as _i808;
import 'package:kingfishertom/core/data/data_sources/remote.like_genre.data_source.dart'
    as _i33;
import 'package:kingfishertom/core/data/data_sources/remote.tracks.data_source.dart'
    as _i683;
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart'
    as _i95;
import 'package:kingfishertom/core/data/data_sources/remote.version.data_source.dart'
    as _i96;
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart'
    as _i466;
import 'package:kingfishertom/core/data/local_data/local.genres_info.data_source.impl.dart'
    as _i198;
import 'package:kingfishertom/core/data/local_data/local.levels_info_data_source.impl.dart'
    as _i730;
import 'package:kingfishertom/core/data/local_data/local.swipes.data_source.impl.dart'
    as _i923;
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart'
    as _i368;
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart'
    as _i621;
import 'package:kingfishertom/core/domain/repositories/recommendation_artist_service.dart'
    as _i611;
import 'package:kingfishertom/core/domain/repositories/use_cases/add_artist.use_case.dart'
    as _i288;
import 'package:kingfishertom/core/domain/repositories/use_cases/add_like.use_case.dart'
    as _i576;
import 'package:kingfishertom/core/domain/repositories/use_cases/complete_task.use_case.dart'
    as _i64;
import 'package:kingfishertom/core/domain/repositories/use_cases/create_collection.use_case.dart'
    as _i534;
import 'package:kingfishertom/core/domain/repositories/use_cases/create_feedback.use_case.dart'
    as _i960;
import 'package:kingfishertom/core/domain/repositories/use_cases/delete_acount.dart'
    as _i666;
import 'package:kingfishertom/core/domain/repositories/use_cases/edit_artist_in_collections.use_case.dart'
    as _i694;
import 'package:kingfishertom/core/domain/repositories/use_cases/end_trial.dart'
    as _i311;
import 'package:kingfishertom/core/domain/repositories/use_cases/forget_password.use_case.dart'
    as _i753;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_all_levels.use_case.dart'
    as _i1010;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_app_user_level.use_case.dart'
    as _i237;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_artist_chart.use_case.dart'
    as _i672;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_artist_tracks.dart'
    as _i709;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_badges.use_case.dart'
    as _i541;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_chart_tracks.dart'
    as _i519;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_current_level.use_case.dart'
    as _i943;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genre_subgenres.use_case.dart'
    as _i675;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart'
    as _i1000;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_liked_subgenre_tracks.use_case.dart'
    as _i951;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_liked_tracks.dart'
    as _i546;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_reports.dart'
    as _i244;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_subgenre.use_case.dart'
    as _i631;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_top_snobs_users.use_case.dart'
    as _i73;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart'
    as _i207;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart'
    as _i461;
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user_by_id.use_case.dart'
    as _i824;
import 'package:kingfishertom/core/domain/repositories/use_cases/like_track.use_case.dart'
    as _i349;
import 'package:kingfishertom/core/domain/repositories/use_cases/logout_use_case.dart'
    as _i576;
import 'package:kingfishertom/core/domain/repositories/use_cases/register_via_email.use_case.dart'
    as _i916;
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_all_artist_likes.use_case.dart'
    as _i195;
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_artist_collection.use_case.dart'
    as _i441;
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_collection.use_case.dart'
    as _i293;
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_like.use_case.dart'
    as _i234;
import 'package:kingfishertom/core/domain/repositories/use_cases/request_subgenre.use_case.dart'
    as _i968;
import 'package:kingfishertom/core/domain/repositories/use_cases/search_artist.use_case.dart'
    as _i682;
import 'package:kingfishertom/core/domain/repositories/use_cases/set_fcm_token.dart'
    as _i515;
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_apple.use_case.dart'
    as _i855;
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_google.use_case.dart'
    as _i158;
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_phone.use_case.dart'
    as _i481;
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_social.use_case.dart'
    as _i478;
import 'package:kingfishertom/core/domain/repositories/use_cases/start_trial.dart'
    as _i339;
import 'package:kingfishertom/core/domain/repositories/use_cases/streak.use_case.dart'
    as _i594;
import 'package:kingfishertom/core/domain/repositories/use_cases/unlock_subgenre.dart'
    as _i390;
import 'package:kingfishertom/core/domain/repositories/use_cases/update_photo.use_case.dart'
    as _i785;
import 'package:kingfishertom/core/domain/repositories/use_cases/update_subgenre.use_case.dart'
    as _i234;
import 'package:kingfishertom/core/domain/repositories/use_cases/update_user.use_case.dart'
    as _i1031;
import 'package:kingfishertom/core/domain/repositories/use_cases/user_exist.use_case.dart'
    as _i633;
import 'package:kingfishertom/core/domain/repositories/use_cases/user_jwt_token_bearer.dart'
    as _i6;
import 'package:kingfishertom/core/domain/repositories/use_cases/user_overrides.use_case.dart'
    as _i715;
import 'package:kingfishertom/core/domain/repositories/use_cases/verify_otp.use_case.dart'
    as _i320;
import 'package:kingfishertom/core/domain/repositories/use_cases/vote_genre.dart'
    as _i545;
import 'package:kingfishertom/core/services/clearable.dart' as _i548;
import 'package:kingfishertom/core/services/di/modules/api_module.dart'
    as _i1009;
import 'package:kingfishertom/core/services/di/modules/router_module.dart'
    as _i487;
import 'package:kingfishertom/core/services/file_service.dart' as _i372;
import 'package:kingfishertom/core/services/logout.service.dart' as _i121;
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart'
    as _i1029;
import 'package:kingfishertom/core/services/snackbar/snack_bar_service.dart'
    as _i563;
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart'
    as _i504;
import 'package:kingfishertom/features/presentation/common_pages/create_collection/cubit/create_collection_cubit.dart'
    as _i983;
import 'package:kingfishertom/features/presentation/common_pages/feedback/cubit/feedback_cubit.dart'
    as _i546;
import 'package:kingfishertom/features/presentation/common_pages/premium/cubit/trail_premium_cubit.dart'
    as _i315;
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart'
    as _i103;
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/artists_organization_view/cubit/artists_organization_cubit.dart'
    as _i925;
import 'package:kingfishertom/features/presentation/resources/routing/app.router.dart'
    as _i59;
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart'
    as _i883;
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart'
    as _i121;
import 'package:kingfishertom/features/presentation/screens/auth/code_page/cubit/code_page_cubit.dart'
    as _i73;
import 'package:kingfishertom/features/presentation/screens/auth/email_page/cubit/email_page_cubit.dart'
    as _i10;
import 'package:kingfishertom/features/presentation/screens/auth/login/cubit/login_page_cubit.dart'
    as _i992;
import 'package:kingfishertom/features/presentation/screens/auth/password_page/cubit/password_page_cubit.dart'
    as _i987;
import 'package:kingfishertom/features/presentation/screens/auth/phone_page/cubit/phone_page_cubit.dart'
    as _i976;
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_cubit.dart'
    as _i320;
import 'package:kingfishertom/features/presentation/screens/library_page/cubit/library_page_cubit.dart'
    as _i94;
import 'package:kingfishertom/features/presentation/screens/library_page/view/my_liked_artist/cubit/likes_artist_cubit.dart'
    as _i545;
import 'package:kingfishertom/features/presentation/screens/onboarding/name/cubit/name_page_cubit.dart'
    as _i259;
import 'package:kingfishertom/features/presentation/screens/onboarding/select_genre/cubit/select_genre_cubit.dart'
    as _i434;
import 'package:kingfishertom/features/presentation/screens/profile_page/cubit/profile_page_cubit.dart'
    as _i680;
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/notifications/cubit/notification_cubit.dart'
    as _i785;
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/profile_edit/cubit/profile_edit_cubit.dart'
    as _i370;
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/settings/cubit/settings_cubit.dart'
    as _i505;
import 'package:kingfishertom/features/presentation/screens/search_page/cubit/search_page_cubit.dart'
    as _i1039;
import 'package:kingfishertom/features/presentation/screens/splash/cubit/splash_page_cubit.dart'
    as _i578;
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/cubit/swipe_songs_page_cubit.dart'
    as _i953;
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/cubit/genres_cubit.dart'
    as _i326;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final routerModule = _$RouterModule();
    final authModule = _$AuthModule();
    final storageModule = _$StorageModule();
    final apiModule = _$ApiModule();
    gh.factory<_i244.GetSubgenreReportUseCase>(
        () => _i244.GetSubgenreReportUseCase());
    gh.factory<_i968.RequestSubgenreUseCase>(
        () => _i968.RequestSubgenreUseCase());
    gh.factory<_i372.FileService>(() => _i372.FileService());
    gh.singleton<_i59.AppAutoRouter>(() => routerModule.snobsAppAutoRouter());
    gh.singleton<_i121.AppThemeModel>(() => _i121.AppThemeModel());
    gh.lazySingleton<_i59.FirebaseAuth>(() => authModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
        () => storageModule.firebaseFirestore);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => storageModule.initPref(),
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => storageModule.initSecureStorage());
    gh.lazySingleton<_i361.Dio>(() => apiModule.dio());
    gh.lazySingleton<_i1029.PurchasesCat>(() => _i1029.PurchasesCat());
    gh.lazySingleton<_i563.SnackBarService>(() => _i563.SnackBarService());
    gh.lazySingleton<_i730.LocalLevelsInfoDataSourceImpl>(() =>
        _i730.LocalLevelsInfoDataSourceImpl(
            storage: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i309.RemoteFeedbackDataSource>(
        () => _i309.RemoteFeedbackDataSource(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i96.RemoteVersionDataSource>(
        () => _i96.RemoteVersionDataSource(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i56.RebelationApiClient>(
        () => apiModule.apiClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i235.KingfishertomApiClient>(
        () => apiModule.kingfishertomApiClient(gh<_i361.Dio>()));
    gh.factory<_i960.CreateFeedbackUseCase>(() =>
        _i960.CreateFeedbackUseCase(gh<_i309.RemoteFeedbackDataSource>()));
    gh.factory<_i538.RebelationApiService>(
        () => _i538.RebelationApiService(gh<_i56.RebelationApiClient>()));
    gh.singleton<_i883.SnobsRouter>(
        () => routerModule.snobsRouter(gh<_i59.AppAutoRouter>()));
    gh.lazySingleton<_i923.LocalUserJwtSource>(
        () => _i923.LocalUserJwtSource(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i683.RemoteTracksDataSource>(
        () => _i683.RemoteTracksDataSource(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i95.RemoteUserDataSource>(() => _i95.RemoteUserDataSource(
          gh<_i59.FirebaseAuth>(),
          gh<_i974.FirebaseFirestore>(),
        ));
    gh.factory<_i51.KingfishertomApiService>(
        () => _i51.KingfishertomApiService(gh<_i235.KingfishertomApiClient>()));
    gh.lazySingleton<_i368.UserModelStream>(() => _i368.UserModelStream(
          gh<_i558.FlutterSecureStorage>(),
          gh<_i95.RemoteUserDataSource>(),
        ));
    gh.lazySingleton<_i466.LocalAppInfoDataSource>(
        () => _i466.LocalAppInfoDataSource(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i198.LocalGenresInfoDataSourceImpl>(() =>
        _i198.LocalGenresInfoDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i923.LocalSwipesDataSource>(
        () => _i923.LocalSwipesDataSource(gh<_i460.SharedPreferences>()));
    gh.factory<_i951.GetLikedSubgenreTrackUseCase>(() =>
        _i951.GetLikedSubgenreTrackUseCase(gh<_i683.RemoteTracksDataSource>()));
    gh.factory<_i546.FeedbackCubit>(() => _i546.FeedbackCubit(
          gh<_i960.CreateFeedbackUseCase>(),
          gh<_i372.FileService>(),
        ));
    gh.lazySingleton<_i818.RemoteArtistChartDataSource>(
        () => _i818.RemoteArtistChartDataSource(
              gh<_i974.FirebaseFirestore>(),
              gh<_i59.FirebaseAuth>(),
            ));
    gh.factory<_i709.GetArtistTracksUseCase>(() => _i709.GetArtistTracksUseCase(
          gh<_i683.RemoteTracksDataSource>(),
          gh<_i538.RebelationApiService>(),
        ));
    gh.factory<_i694.EditArtistInCollectionUseCase>(
        () => _i694.EditArtistInCollectionUseCase(
              gh<_i818.RemoteArtistChartDataSource>(),
              gh<_i95.RemoteUserDataSource>(),
            ));
    gh.factory<_i441.RemoveArtistCollectionUseCase>(
        () => _i441.RemoveArtistCollectionUseCase(
              gh<_i818.RemoteArtistChartDataSource>(),
              gh<_i95.RemoteUserDataSource>(),
            ));
    gh.lazySingleton<_i870.RemoteBadgeDataSource>(
        () => _i870.RemoteBadgeDataSource(
              gh<_i974.FirebaseFirestore>(),
              gh<_i59.FirebaseAuth>(),
            ));
    gh.factory<_i694.EditArtistsInCollectionUseCase>(
        () => _i694.EditArtistsInCollectionUseCase(
              gh<_i466.LocalAppInfoDataSource>(),
              gh<_i818.RemoteArtistChartDataSource>(),
              gh<_i95.RemoteUserDataSource>(),
            ));
    gh.factory<_i545.DownvoteGenreUseCase>(() => _i545.DownvoteGenreUseCase(
          gh<_i818.RemoteArtistChartDataSource>(),
          gh<_i466.LocalAppInfoDataSource>(),
        ));
    gh.lazySingleton<_i33.RemoteLikeGenreDataSource>(
        () => _i33.RemoteLikeGenreDataSource(
              gh<_i974.FirebaseFirestore>(),
              gh<_i59.FirebaseAuth>(),
              gh<_i95.RemoteUserDataSource>(),
            ));
    gh.factory<_i715.GetArtistOverridesUseCase>(() =>
        _i715.GetArtistOverridesUseCase(gh<_i33.RemoteLikeGenreDataSource>()));
    gh.factory<_i672.GetAllLikedArtistsUseCase>(() =>
        _i672.GetAllLikedArtistsUseCase(
            gh<_i818.RemoteArtistChartDataSource>()));
    gh.factory<_i244.GetArtistsReportUseCase>(() =>
        _i244.GetArtistsReportUseCase(gh<_i818.RemoteArtistChartDataSource>()));
    gh.factory<_i682.SearchArtistUseCase>(() =>
        _i682.SearchArtistUseCase(gh<_i818.RemoteArtistChartDataSource>()));
    gh.factory<_i545.GetVotesUseCase>(
        () => _i545.GetVotesUseCase(gh<_i818.RemoteArtistChartDataSource>()));
    gh.factory<_i545.UpvoteGenreUseCase>(() =>
        _i545.UpvoteGenreUseCase(gh<_i818.RemoteArtistChartDataSource>()));
    gh.factory<_i545.RemoveVoteGenreUseCase>(() =>
        _i545.RemoveVoteGenreUseCase(gh<_i818.RemoteArtistChartDataSource>()));
    gh.factory<_i631.GetSubgenreUseCase>(() => _i631.GetSubgenreUseCase(
          gh<_i33.RemoteLikeGenreDataSource>(),
          gh<_i198.LocalGenresInfoDataSourceImpl>(),
        ));
    gh.factory<_i541.GetBadgesUseCase>(
        () => _i541.GetBadgesUseCase(gh<_i870.RemoteBadgeDataSource>()));
    gh.factory<_i1000.GetGenresUseCase>(() => _i1000.GetGenresUseCase(
          gh<_i198.LocalGenresInfoDataSourceImpl>(),
          gh<_i51.KingfishertomApiService>(),
        ));
    gh.factory<_i519.GetChartTracksUseCase>(
        () => _i519.GetChartTracksUseCase(gh<_i683.RemoteTracksDataSource>()));
    gh.factory<_i546.GetLikedTracksUseCase>(
        () => _i546.GetLikedTracksUseCase(gh<_i683.RemoteTracksDataSource>()));
    gh.factory<_i349.LikeTrackUseCase>(
        () => _i349.LikeTrackUseCase(gh<_i683.RemoteTracksDataSource>()));
    gh.factory<_i785.NotificationCubit>(
        () => _i785.NotificationCubit(gh<_i466.LocalAppInfoDataSource>()));
    gh.factory<_i234.RemoveLikeUseCase>(() => _i234.RemoveLikeUseCase(
          gh<_i95.RemoteUserDataSource>(),
          gh<_i818.RemoteArtistChartDataSource>(),
        ));
    gh.lazySingleton<_i808.RemoteLevelDataSource>(
        () => _i808.RemoteLevelDataSource(gh<_i51.KingfishertomApiService>()));
    gh.factory<_i715.UpdateUserOverridesUseCase>(
        () => _i715.UpdateUserOverridesUseCase(
              gh<_i33.RemoteLikeGenreDataSource>(),
              gh<_i818.RemoteArtistChartDataSource>(),
            ));
    gh.lazySingleton<_i75.RemoteAuthJwtSource>(() => _i75.RemoteAuthJwtSource(
        kingfishertomApiService: gh<_i51.KingfishertomApiService>()));
    gh.factory<_i534.CreateCollectionUseCase>(
        () => _i534.CreateCollectionUseCase(gh<_i95.RemoteUserDataSource>()));
    gh.factory<_i311.EndTrialUseCase>(
        () => _i311.EndTrialUseCase(gh<_i95.RemoteUserDataSource>()));
    gh.factory<_i824.GetUserByIdUseCase>(
        () => _i824.GetUserByIdUseCase(gh<_i95.RemoteUserDataSource>()));
    gh.factory<_i293.RemoveCollectionUseCase>(
        () => _i293.RemoveCollectionUseCase(gh<_i95.RemoteUserDataSource>()));
    gh.factory<_i515.SetFcmTokenUseCase>(
        () => _i515.SetFcmTokenUseCase(gh<_i95.RemoteUserDataSource>()));
    gh.factory<_i390.UnlockSubgenreUseCase>(
        () => _i390.UnlockSubgenreUseCase(gh<_i95.RemoteUserDataSource>()));
    gh.factory<_i715.UserOverridesUseCase>(
        () => _i715.UserOverridesUseCase(gh<_i33.RemoteLikeGenreDataSource>()));
    gh.factory<_i195.RemoveAllArtistLikesUseCase>(
        () => _i195.RemoveAllArtistLikesUseCase(
              gh<_i95.RemoteUserDataSource>(),
              gh<_i818.RemoteArtistChartDataSource>(),
              gh<_i466.LocalAppInfoDataSource>(),
            ));
    gh.factory<_i461.GetUserStreamUseCase>(() => _i461.GetUserStreamUseCase(
          gh<_i95.RemoteUserDataSource>(),
          gh<_i466.LocalAppInfoDataSource>(),
        ));
    gh.factory<_i339.StartTrialUseCase>(() => _i339.StartTrialUseCase(
          gh<_i95.RemoteUserDataSource>(),
          gh<_i466.LocalAppInfoDataSource>(),
        ));
    gh.factory<_i983.CreateCollectionCubit>(
        () => _i983.CreateCollectionCubit(gh<_i534.CreateCollectionUseCase>()));
    gh.factory<_i675.GetGenreSubgenreUseCase>(
        () => _i675.GetGenreSubgenreUseCase(
              gh<_i198.LocalGenresInfoDataSourceImpl>(),
              gh<_i1000.GetGenresUseCase>(),
            ));
    gh.factory<_i244.GetTotalGenreSubgenreByUserUseCase>(
        () => _i244.GetTotalGenreSubgenreByUserUseCase(
              gh<_i675.GetGenreSubgenreUseCase>(),
              gh<_i1000.GetGenresUseCase>(),
            ));
    gh.factory<_i578.SplashPageCubit>(() => _i578.SplashPageCubit(
          gh<_i1000.GetGenresUseCase>(),
          gh<_i631.GetSubgenreUseCase>(),
          gh<_i675.GetGenreSubgenreUseCase>(),
          gh<_i59.FirebaseAuth>(),
          gh<_i198.LocalGenresInfoDataSourceImpl>(),
          gh<_i96.RemoteVersionDataSource>(),
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i515.SetFcmTokenUseCase>(),
        ));
    gh.factory<_i244.GenerateGenresReports>(() => _i244.GenerateGenresReports(
          gh<_i244.GetSubgenreReportUseCase>(),
          gh<_i244.GetTotalGenreSubgenreByUserUseCase>(),
          gh<_i33.RemoteLikeGenreDataSource>(),
        ));
    gh.factory<_i207.GetTotalGenreSubgenreUseCase>(() =>
        _i207.GetTotalGenreSubgenreUseCase(
            gh<_i675.GetGenreSubgenreUseCase>()));
    gh.factory<_i6.UserJwtTokenBearer>(() => _i6.UserJwtTokenBearer(
          remoteAuthJwtSource: gh<_i75.RemoteAuthJwtSource>(),
          localUserJwtSource: gh<_i923.LocalUserJwtSource>(),
        ));
    gh.factory<_i434.SelectGenreCubit>(() => _i434.SelectGenreCubit(
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i1000.GetGenresUseCase>(),
        ));
    gh.factory<_i1010.GetAllLevelsUseCase>(() => _i1010.GetAllLevelsUseCase(
          remoteLevelDataSource: gh<_i808.RemoteLevelDataSource>(),
          localUserJwtSource: gh<_i923.LocalUserJwtSource>(),
          localLevelsInfoDataSourceImpl:
              gh<_i730.LocalLevelsInfoDataSourceImpl>(),
        ));
    gh.factory<_i315.TrailPremiumCubit>(
        () => _i315.TrailPremiumCubit(gh<_i339.StartTrialUseCase>()));
    gh.factory<_i611.RecommendationArtistService>(
        () => _i611.RecommendationArtistService(
              gh<_i818.RemoteArtistChartDataSource>(),
              gh<_i675.GetGenreSubgenreUseCase>(),
              gh<_i466.LocalAppInfoDataSource>(),
            ));
    gh.factory<_i943.GetCurrentLevelUseCase>(
        () => _i943.GetCurrentLevelUseCase(gh<_i1010.GetAllLevelsUseCase>()));
    gh.factory<_i672.GetArtistChartUseCase>(() => _i672.GetArtistChartUseCase(
          gh<_i818.RemoteArtistChartDataSource>(),
          gh<_i675.GetGenreSubgenreUseCase>(),
          gh<_i466.LocalAppInfoDataSource>(),
        ));
    gh.lazySingleton<_i621.AuthRepository>(() => _i302.AuthRepositoryImpl(
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i95.RemoteUserDataSource>(),
          gh<_i6.UserJwtTokenBearer>(),
        ));
    gh.factory<_i237.GetAppUserLevelUseCase>(() => _i237.GetAppUserLevelUseCase(
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i943.GetCurrentLevelUseCase>(),
        ));
    gh.factory<_i925.ArtistsOrganizationCubit>(
        () => _i925.ArtistsOrganizationCubit(
              gh<_i1000.GetGenresUseCase>(),
              gh<_i207.GetTotalGenreSubgenreUseCase>(),
              gh<_i631.GetSubgenreUseCase>(),
              gh<_i715.UpdateUserOverridesUseCase>(),
              gh<_i59.FirebaseAuth>(),
              gh<_i694.EditArtistsInCollectionUseCase>(),
            ));
    gh.factory<_i244.GetUsersReportUseCase>(() => _i244.GetUsersReportUseCase(
          gh<_i95.RemoteUserDataSource>(),
          gh<_i1000.GetGenresUseCase>(),
          gh<_i207.GetTotalGenreSubgenreUseCase>(),
          gh<_i33.RemoteLikeGenreDataSource>(),
        ));
    gh.factory<_i326.GenresCubit>(() => _i326.GenresCubit(
          gh<_i1000.GetGenresUseCase>(),
          gh<_i207.GetTotalGenreSubgenreUseCase>(),
          gh<_i631.GetSubgenreUseCase>(),
          gh<_i545.GetVotesUseCase>(),
          gh<_i545.DownvoteGenreUseCase>(),
          gh<_i545.UpvoteGenreUseCase>(),
          gh<_i59.FirebaseAuth>(),
          gh<_i715.UserOverridesUseCase>(),
          gh<_i715.UpdateUserOverridesUseCase>(),
          gh<_i545.RemoveVoteGenreUseCase>(),
          gh<_i824.GetUserByIdUseCase>(),
        ));
    gh.factory<_i73.GetSnobsSubgenreTopUsersUseCase>(
        () => _i73.GetSnobsSubgenreTopUsersUseCase(
              gh<_i33.RemoteLikeGenreDataSource>(),
              gh<_i943.GetCurrentLevelUseCase>(),
            ));
    gh.factory<_i666.DeleteAccountUseCase>(() => _i666.DeleteAccountUseCase(
          gh<_i621.AuthRepository>(),
          gh<_i870.RemoteBadgeDataSource>(),
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i6.UserJwtTokenBearer>(),
        ));
    gh.factory<_i64.CompleteTaskUseCase>(() => _i64.CompleteTaskUseCase(
          gh<_i95.RemoteUserDataSource>(),
          gh<_i237.GetAppUserLevelUseCase>(),
        ));
    gh.factory<_i320.HomeCubit>(() => _i320.HomeCubit(
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i1000.GetGenresUseCase>(),
          gh<_i631.GetSubgenreUseCase>(),
          gh<_i207.GetTotalGenreSubgenreUseCase>(),
          gh<_i923.LocalSwipesDataSource>(),
          gh<_i461.GetUserStreamUseCase>(),
          gh<_i311.EndTrialUseCase>(),
          gh<_i390.UnlockSubgenreUseCase>(),
        ));
    gh.factory<_i594.StreakUseCase>(
        () => _i594.StreakUseCase(gh<_i64.CompleteTaskUseCase>()));
    gh.factory<_i234.UpdateSubgenreUseCase>(() => _i234.UpdateSubgenreUseCase(
          gh<_i33.RemoteLikeGenreDataSource>(),
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i870.RemoteBadgeDataSource>(),
          gh<_i198.LocalGenresInfoDataSourceImpl>(),
          gh<_i95.RemoteUserDataSource>(),
          gh<_i64.CompleteTaskUseCase>(),
        ));
    gh.lazySingleton<List<_i548.Clearable>>(
        () => storageModule.clearables(gh<_i621.AuthRepository>()));
    gh.factory<_i94.LibraryPageCubit>(() => _i94.LibraryPageCubit(
          gh<_i461.GetUserStreamUseCase>(),
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i672.GetAllLikedArtistsUseCase>(),
          gh<_i207.GetTotalGenreSubgenreUseCase>(),
          gh<_i1000.GetGenresUseCase>(),
          gh<_i631.GetSubgenreUseCase>(),
          gh<_i715.GetArtistOverridesUseCase>(),
          gh<_i64.CompleteTaskUseCase>(),
        ));
    gh.factory<_i1031.UpdateUserUseCase>(() => _i1031.UpdateUserUseCase(
          gh<_i95.RemoteUserDataSource>(),
          gh<_i621.AuthRepository>(),
        ));
    gh.factory<_i753.ForgetPasswordUseCase>(
        () => _i753.ForgetPasswordUseCase(gh<_i621.AuthRepository>()));
    gh.factory<_i916.RegisterViaEmailUseCase>(
        () => _i916.RegisterViaEmailUseCase(gh<_i621.AuthRepository>()));
    gh.factory<_i855.SignInViaAppleUseCase>(
        () => _i855.SignInViaAppleUseCase(gh<_i621.AuthRepository>()));
    gh.factory<_i158.SignInViaGoogleUseCase>(
        () => _i158.SignInViaGoogleUseCase(gh<_i621.AuthRepository>()));
    gh.factory<_i481.SignInViaPhoneUseCase>(
        () => _i481.SignInViaPhoneUseCase(gh<_i621.AuthRepository>()));
    gh.factory<_i478.SignInViaEmailUseCase>(
        () => _i478.SignInViaEmailUseCase(gh<_i621.AuthRepository>()));
    gh.factory<_i785.UpdatePhotoUseCase>(
        () => _i785.UpdatePhotoUseCase(gh<_i621.AuthRepository>()));
    gh.factory<_i633.UserExistUseCase>(
        () => _i633.UserExistUseCase(gh<_i621.AuthRepository>()));
    gh.factory<_i320.VerifyOtpUseCase>(
        () => _i320.VerifyOtpUseCase(gh<_i621.AuthRepository>()));
    gh.factory<_i576.AddLikeUseCase>(() => _i576.AddLikeUseCase(
          gh<_i95.RemoteUserDataSource>(),
          gh<_i818.RemoteArtistChartDataSource>(),
          gh<_i64.CompleteTaskUseCase>(),
        ));
    gh.factory<_i103.SubgenrePageCubit>(() => _i103.SubgenrePageCubit(
          gh<_i461.GetUserStreamUseCase>(),
          gh<_i672.GetAllLikedArtistsUseCase>(),
          gh<_i576.AddLikeUseCase>(),
          gh<_i694.EditArtistInCollectionUseCase>(),
          gh<_i234.RemoveLikeUseCase>(),
          gh<_i715.GetArtistOverridesUseCase>(),
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i715.UpdateUserOverridesUseCase>(),
          gh<_i672.GetArtistChartUseCase>(),
          gh<_i519.GetChartTracksUseCase>(),
          gh<_i73.GetSnobsSubgenreTopUsersUseCase>(),
          gh<_i675.GetGenreSubgenreUseCase>(),
          gh<_i951.GetLikedSubgenreTrackUseCase>(),
        ));
    gh.factory<_i288.AddArtistUseCase>(() => _i288.AddArtistUseCase(
          gh<_i818.RemoteArtistChartDataSource>(),
          gh<_i95.RemoteUserDataSource>(),
          gh<_i64.CompleteTaskUseCase>(),
        ));
    gh.factory<_i545.LikesArtistCubit>(() => _i545.LikesArtistCubit(
          gh<_i461.GetUserStreamUseCase>(),
          gh<_i672.GetAllLikedArtistsUseCase>(),
          gh<_i234.RemoveLikeUseCase>(),
          gh<_i293.RemoveCollectionUseCase>(),
          gh<_i824.GetUserByIdUseCase>(),
          gh<_i576.AddLikeUseCase>(),
          gh<_i441.RemoveArtistCollectionUseCase>(),
          gh<_i694.EditArtistInCollectionUseCase>(),
        ));
    gh.lazySingleton<_i121.LogoutService>(() => _i862.LogoutServiceImpl(
          gh<List<_i548.Clearable>>(),
          gh<_i621.AuthRepository>(),
        ));
    gh.factory<_i1039.SearchPageCubit>(() => _i1039.SearchPageCubit(
          gh<_i461.GetUserStreamUseCase>(),
          gh<_i234.RemoveLikeUseCase>(),
          gh<_i576.AddLikeUseCase>(),
          gh<_i694.EditArtistInCollectionUseCase>(),
          gh<_i672.GetArtistChartUseCase>(),
          gh<_i207.GetTotalGenreSubgenreUseCase>(),
          gh<_i1000.GetGenresUseCase>(),
          gh<_i631.GetSubgenreUseCase>(),
          gh<_i683.RemoteTracksDataSource>(),
          gh<_i682.SearchArtistUseCase>(),
          gh<_i672.GetAllLikedArtistsUseCase>(),
        ));
    gh.factory<_i259.NamePageCubit>(() => _i259.NamePageCubit(
          gh<_i95.RemoteUserDataSource>(),
          gh<_i1031.UpdateUserUseCase>(),
        ));
    gh.factory<_i680.ProfilePageCubit>(() => _i680.ProfilePageCubit(
          gh<_i461.GetUserStreamUseCase>(),
          gh<_i541.GetBadgesUseCase>(),
          gh<_i923.LocalSwipesDataSource>(),
          gh<_i207.GetTotalGenreSubgenreUseCase>(),
          gh<_i237.GetAppUserLevelUseCase>(),
          gh<_i372.FileService>(),
          gh<_i785.UpdatePhotoUseCase>(),
          gh<_i1031.UpdateUserUseCase>(),
        ));
    gh.factory<_i576.LogoutUseCase>(
        () => _i576.LogoutUseCase(gh<_i121.LogoutService>()));
    gh.factory<_i953.SwipeSongsPageCubit>(() => _i953.SwipeSongsPageCubit(
          gh<_i611.RecommendationArtistService>(),
          gh<_i466.LocalAppInfoDataSource>(),
          gh<_i576.AddLikeUseCase>(),
          gh<_i534.CreateCollectionUseCase>(),
          gh<_i234.UpdateSubgenreUseCase>(),
          gh<_i288.AddArtistUseCase>(),
          gh<_i923.LocalSwipesDataSource>(),
          gh<_i631.GetSubgenreUseCase>(),
          gh<_i1000.GetGenresUseCase>(),
          gh<_i207.GetTotalGenreSubgenreUseCase>(),
          gh<_i195.RemoveAllArtistLikesUseCase>(),
          gh<_i244.GenerateGenresReports>(),
          gh<_i244.GetUsersReportUseCase>(),
          gh<_i594.StreakUseCase>(),
          gh<_i339.StartTrialUseCase>(),
          gh<_i234.RemoveLikeUseCase>(),
          gh<_i694.EditArtistInCollectionUseCase>(),
        ));
    gh.factory<_i987.PasswordPageCubit>(() => _i987.PasswordPageCubit(
          gh<_i478.SignInViaEmailUseCase>(),
          gh<_i916.RegisterViaEmailUseCase>(),
          gh<_i633.UserExistUseCase>(),
          gh<_i753.ForgetPasswordUseCase>(),
        ));
    gh.factory<_i370.ProfileEditCubit>(() => _i370.ProfileEditCubit(
          gh<_i461.GetUserStreamUseCase>(),
          gh<_i1031.UpdateUserUseCase>(),
          gh<_i785.UpdatePhotoUseCase>(),
          gh<_i372.FileService>(),
        ));
    gh.factory<_i73.CodePageCubit>(() => _i73.CodePageCubit(
          gh<_i481.SignInViaPhoneUseCase>(),
          gh<_i320.VerifyOtpUseCase>(),
        ));
    gh.factory<_i10.EmailPageCubit>(() => _i10.EmailPageCubit(
          gh<_i855.SignInViaAppleUseCase>(),
          gh<_i158.SignInViaGoogleUseCase>(),
        ));
    gh.factory<_i992.LoginPageCubit>(() => _i992.LoginPageCubit(
          gh<_i855.SignInViaAppleUseCase>(),
          gh<_i158.SignInViaGoogleUseCase>(),
        ));
    gh.factory<_i976.PhonePageCubit>(() => _i976.PhonePageCubit(
          gh<_i855.SignInViaAppleUseCase>(),
          gh<_i158.SignInViaGoogleUseCase>(),
        ));
    gh.lazySingleton<_i504.TrackAudioPlayerCubit>(
        () => _i504.TrackAudioPlayerCubit(
              gh<_i349.LikeTrackUseCase>(),
              gh<_i461.GetUserStreamUseCase>(),
              gh<_i709.GetArtistTracksUseCase>(),
              gh<_i538.RebelationApiService>(),
              gh<_i683.RemoteTracksDataSource>(),
              gh<_i576.AddLikeUseCase>(),
              gh<_i611.RecommendationArtistService>(),
              gh<_i466.LocalAppInfoDataSource>(),
              gh<_i237.GetAppUserLevelUseCase>(),
              gh<_i576.AddLikeUseCase>(),
              gh<_i694.EditArtistInCollectionUseCase>(),
              gh<_i234.RemoveLikeUseCase>(),
              gh<_i672.GetAllLikedArtistsUseCase>(),
            ));
    gh.factory<_i505.SettingsCubit>(() => _i505.SettingsCubit(
          gh<_i461.GetUserStreamUseCase>(),
          gh<_i576.LogoutUseCase>(),
          gh<_i666.DeleteAccountUseCase>(),
          gh<_i311.EndTrialUseCase>(),
        ));
    return this;
  }
}

class _$RouterModule extends _i487.RouterModule {}

class _$AuthModule extends _i162.AuthModule {}

class _$StorageModule extends _i338.StorageModule {}

class _$ApiModule extends _i1009.ApiModule {}
