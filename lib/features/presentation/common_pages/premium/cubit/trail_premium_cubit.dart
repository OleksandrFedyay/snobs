import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/start_trial.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';

part 'trail_premium_state.dart';

@injectable
class TrailPremiumCubit extends BaseCubit<TrailPremiumState> {
  TrailPremiumCubit(
    this.startTrialUseCase,
  ) : super(const TrailPremiumState());

  static TrailPremiumCubit create() {
    return GetIt.I<TrailPremiumCubit>();
  }

  final StartTrialUseCase startTrialUseCase;

  Future<void> startTrial(String pageName) async {
    if (!kIsWeb) {
      invokeClicksEvents(pageName);
      await performSafeAction(() async {
        await getIt<PurchasesCat>().getOfferAndShowDialog();
        await getIt<PurchasesCat>()
            .isActiveOffer()
            .then((bool isActiveOffer) async {
          if (isActiveOffer) {
            invokeConversionsEvents(pageName);
            await startTrialUseCase();
            //Todo(Issa): Need to show tool tip when the User got the premium account on the Library page
            /*  if (pageName == StringsRes.libraryPage) {
            }*/
          }
        });
      });
    }
  }

  void invokeClicksEvents(String pageName) {
    if (pageName == StringsRes.libraryPage) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'trial_30_day_library_click',
        parameters: <String, Object>{
          'source_page': StringsRes.libraryPage,
        },
      ));
    } else if (pageName == StringsRes.settingsPage) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'trial_30_day_settings_click',
        parameters: <String, Object>{
          'source_page': StringsRes.settingsPage,
        },
      ));
    } else if (pageName == StringsRes.profilePage) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'trial_30_day_profile_click',
        parameters: <String, Object>{
          'source_page': StringsRes.profilePage,
        },
      ));
    }
  }

  void invokeConversionsEvents(String pageName) {
    if (pageName == StringsRes.libraryPage) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'trial_30_day_library_converted',
        parameters: <String, Object>{
          'source_page': StringsRes.libraryPage,
        },
      ));
    } else if (pageName == StringsRes.settingsPage) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'trial_30_day_settings_converted',
        parameters: <String, Object>{
          'source_page': StringsRes.settingsPage,
        },
      ));
    } else if (pageName == StringsRes.profilePage) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'trial_30_day_profile_converted',
        parameters: <String, Object>{
          'source_page': StringsRes.profilePage,
        },
      ));
    }
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        errorMessage: errorMessage,
      ),
    );
  }
}
