import 'package:purchases_flutter/models/customer_info_wrapper.dart';

abstract class PurchasesCatService {
  Future<void> configure();

  Future<void> setLogLevel();

  Future<void> getOfferAndShowDialog();

  Future<void> logIn(String appUserID);

  Future<CustomerInfo> getCustomerInfo();

  Future<bool> isActiveOffer();

  Future<void> logOut();
}
