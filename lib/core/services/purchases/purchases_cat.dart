import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat_service.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@lazySingleton
class PurchasesCat extends PurchasesCatService {
  @override
  Future<void> configure() async {
    //Note: We have Android & Apple apiKey only
    if (!kIsWeb) {
      await setLogLevel();
      final String apiKey = defaultTargetPlatform == TargetPlatform.android
          ? StringsRes.purchasesAndroidApiKey
          : StringsRes.purchasesAppleApiKey;
      await Purchases.configure(PurchasesConfiguration(apiKey))
          .onError(_logError);
    }
  }

  @override
  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();

  @override
  Future<void> getOfferAndShowDialog() async {
    await Purchases.getOfferings().then((Offerings offerings) async {
      if (offerings.current != null) {
        /// Display current offering to the user
        final Package package = offerings.current!.availablePackages.first;

        try {
          final CustomerInfo customerInfo =
              await Purchases.purchasePackage(package);

          /// Check if the purchase was successful
          if (customerInfo.entitlements.active.values.firstOrNull?.isActive ??
              false) {
            debugPrint("User successfully subscribed!");
          }
        } on PlatformException catch (e) {
          final PurchasesErrorCode errorCode =
              PurchasesErrorHelper.getErrorCode(e);
          if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
            debugPrint("User dismissed the purchase dialog.");
          } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
            debugPrint("Purchase not allowed on this device.");
          } else {
            debugPrint("An exception occurred: ${e.message}");
          }
        } catch (e) {
          debugPrint("Unexpected exception: $e");
        }
      }
    });
  }

  @override
  Future<void> logIn(String appUserID) => Purchases.logIn(appUserID);

  @override
  Future<void> logOut() => Purchases.logOut();

  @override
  Future<void> setLogLevel() =>
      Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info)
          .onError(_logError);

  @override
  Future<bool> isActiveOffer() async {
    final CustomerInfo? customerInfo = kIsWeb ? null : await getCustomerInfo();
    return customerInfo?.entitlements.active.values.firstOrNull?.isActive ??
        false;
  }

  void _logError(Object? handleError, StackTrace stack) {
    log(
      handleError.toString(),
      name: handleError.runtimeType.toString(),
      error: handleError.toString(),
      stackTrace: stack,
    );
  }
}
