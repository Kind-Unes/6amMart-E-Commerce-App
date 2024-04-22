import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/auth/domain/models/signup_body_model.dart';
import 'package:sixam_mart/features/auth/domain/models/social_log_in_body.dart';
import 'package:sixam_mart/interfaces/repository_interface.dart';

abstract class AuthRepositoryInterface extends RepositoryInterface{
  bool isSharedPrefNotificationActive();
  Future<ResponseModel> registration(SignUpBodyModel signUpBody);
  Future<Response> login({String? phone, String? password});
  Future<bool> saveUserToken(String token);
  Future<Response> updateToken({String notificationDeviceToken = ''});
  Future<bool> saveSharedPrefGuestId(String id);
  String getSharedPrefGuestId();
  Future<bool> clearSharedPrefGuestId();
  bool isGuestLoggedIn();
  bool clearSharedData();
  Future<ResponseModel> guestLogin();
  Future<Response> loginWithSocialMedia(SocialLogInBody socialLogInBody, int timeout);
  Future<Response> registerWithSocialMedia(SocialLogInBody socialLogInBody);
  bool isLoggedIn();
  Future<bool> clearSharedAddress();
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode);
  String getUserNumber();
  String getUserCountryCode();
  String getUserPassword();
  Future<bool> clearUserNumberAndPassword();
  String getUserToken();
  Future<Response> updateZone();
  Future<bool> saveGuestContactNumber(String number);
  String getGuestContactNumber();
  ///Todo:
  Future<bool> saveDmTipIndex(String index);
  String getDmTipIndex();
  Future<bool> saveEarningPoint(String point);
  String getEarningPint();
  void setNotificationActive(bool isActive);
}