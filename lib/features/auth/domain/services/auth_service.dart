import 'package:get/get.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/auth/domain/models/signup_body_model.dart';
import 'package:sixam_mart/features/auth/domain/models/social_log_in_body.dart';
import 'package:sixam_mart/features/auth/domain/reposotories/auth_repository_interface.dart';
import 'package:sixam_mart/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class AuthService implements AuthServiceInterface{
  final AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  bool isSharedPrefNotificationActive() {
    return authRepositoryInterface.isSharedPrefNotificationActive();
  }

  @override
  Future<ResponseModel> registration(SignUpBodyModel signUpBody, bool isCustomerVerificationOn) async {
    ResponseModel responseModel = await authRepositoryInterface.registration(signUpBody);
    if(responseModel.isSuccess) {
      if(!isCustomerVerificationOn) {
        authRepositoryInterface.saveUserToken(responseModel.message!);
        await authRepositoryInterface.updateToken();
        authRepositoryInterface.clearSharedPrefGuestId();
      }
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> login({String? phone, String? password, required bool isCustomerVerificationOn}) async {
    Response response = await authRepositoryInterface.login(phone: phone, password: password);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if(isCustomerVerificationOn && response.body['is_phone_verified'] == 0) {

      }else {
        authRepositoryInterface.saveUserToken(response.body['token']);
        await authRepositoryInterface.updateToken();
        authRepositoryInterface.clearSharedPrefGuestId();
      }
      responseModel = ResponseModel(true, '${response.body['is_phone_verified']}${response.body['token']}', isPhoneVerified: response.body['is_phone_verified'] == 1);
    } else {
      responseModel = ResponseModel(false, response.statusText, isPhoneVerified: response.body['is_phone_verified'] == 1);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> guestLogin() async {
    return await authRepositoryInterface.guestLogin();
  }

  @override
  Future<bool> loginWithSocialMedia(SocialLogInBody socialLogInBody, int timeout, bool isCustomerVerificationOn) async {
    bool canNavigateToLocation = false;
    Response response = await authRepositoryInterface.loginWithSocialMedia(socialLogInBody, timeout);
    if (response.statusCode == 200) {
      String? token = response.body['token'];
      if(token != null && token.isNotEmpty) {
        if(isCustomerVerificationOn && response.body['is_phone_verified'] == 0) {
          Get.toNamed(RouteHelper.getVerificationRoute(response.body['phone'] ?? socialLogInBody.email, token, RouteHelper.signUp, ''));
        }else {
          authRepositoryInterface.saveUserToken(response.body['token']);
          await authRepositoryInterface.updateToken();
          authRepositoryInterface.clearSharedPrefGuestId();
          canNavigateToLocation = true;
        }
      }else {
        Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInBody));
      }
    }else if(response.statusCode == 403 && response.body['errors'][0]['code'] == 'email'){
      Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInBody));
    } else {
      showCustomSnackBar(response.statusText);
    }
    return canNavigateToLocation;
  }

  @override
  Future<bool> registerWithSocialMedia(SocialLogInBody socialLogInBody, bool isCustomerVerificationOn) async {
    bool canNavigateToLocation = false;
    Response response = await authRepositoryInterface.registerWithSocialMedia(socialLogInBody);
    if (response.statusCode == 200) {
      String? token = response.body['token'];
      if(isCustomerVerificationOn && response.body['is_phone_verified'] == 0) {
        Get.toNamed(RouteHelper.getVerificationRoute(socialLogInBody.phone, token, RouteHelper.signUp, ''));
      }else {
        authRepositoryInterface.saveUserToken(response.body['token']);
        await authRepositoryInterface.updateToken();
        authRepositoryInterface.clearSharedPrefGuestId();
        canNavigateToLocation = true;
      }
    } else {
      showCustomSnackBar(response.statusText);
    }
    return canNavigateToLocation;
  }

  @override
  Future<void> updateToken() async {
    await authRepositoryInterface.updateToken();
  }

  @override
  bool isLoggedIn() {
    return authRepositoryInterface.isLoggedIn();
  }

  @override
  bool isGuestLoggedIn() {
    return authRepositoryInterface.isGuestLoggedIn();
  }

  @override
  String getSharedPrefGuestId() {
    return authRepositoryInterface.getSharedPrefGuestId();
  }

  @override
  bool clearSharedData() {
    return authRepositoryInterface.clearSharedData();
  }

  @override
  Future<bool> clearSharedAddress() async {
    return await authRepositoryInterface.clearSharedAddress();
  }

  @override
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    await authRepositoryInterface.saveUserNumberAndPassword(number, password, countryCode);
  }

  @override
  String getUserNumber() {
    return authRepositoryInterface.getUserNumber();
  }

  @override
  String getUserCountryCode() {
    return authRepositoryInterface.getUserCountryCode();
  }

  @override
  String getUserPassword() {
    return authRepositoryInterface.getUserPassword();
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    return await authRepositoryInterface.clearUserNumberAndPassword();
  }

  @override
  String getUserToken() {
    return authRepositoryInterface.getUserToken();
  }

  @override
  Future updateZone() async {
    await authRepositoryInterface.updateZone();
  }

  @override
  Future<bool> saveGuestContactNumber(String number) async {
    return authRepositoryInterface.saveGuestContactNumber(number);
  }

  @override
  String getGuestContactNumber() {
    return authRepositoryInterface.getGuestContactNumber();
  }

  ///Todo:
  @override
  Future<bool> saveDmTipIndex(String index) async {
    return await authRepositoryInterface.saveDmTipIndex(index);
  }

  @override
  String getDmTipIndex() {
    return authRepositoryInterface.getDmTipIndex();
  }

  @override
  Future<bool> saveEarningPoint(String point) async {
    return await authRepositoryInterface.saveEarningPoint(point);
  }

  @override
  String getEarningPint() {
    return authRepositoryInterface.getEarningPint();
  }

  @override
  void setNotificationActive(bool isActive) {
    authRepositoryInterface.setNotificationActive(isActive);
  }
}