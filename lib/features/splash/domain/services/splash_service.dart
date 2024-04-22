import 'package:get/get.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/splash/domain/models/landing_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:sixam_mart/features/splash/domain/services/splash_service_interface.dart';

class SplashService implements SplashServiceInterface {
  final SplashRepositoryInterface splashRepositoryInterface;
  SplashService({required this.splashRepositoryInterface});

  @override
  Future<Response> getConfigData() async {
    return await splashRepositoryInterface.getConfigData();
  }

  @override
  Future<LandingModel?> getLandingPageData() async {
    return await splashRepositoryInterface.getLandingPageData();
  }

  @override
  Future<ModuleModel?> initSharedData() async {
    return await splashRepositoryInterface.initSharedData();
  }

  @override
  void disableIntro() {
    splashRepositoryInterface.disableIntro();
  }

  @override
  bool? showIntro() {
    return splashRepositoryInterface.showIntro();
  }

  @override
  Future<void> setStoreCategory(int storeCategoryID) async {
    return await splashRepositoryInterface.setStoreCategory(storeCategoryID);
  }

  @override
  Future<List<ModuleModel>?> getModules({Map<String, String>? headers}) async {
    return await splashRepositoryInterface.getModules(headers: headers);
  }

  @override
  Future<void> setModule(ModuleModel? module) async {
    return await splashRepositoryInterface.setModule(module);
  }

  @override
  Future<void> setCacheModule(ModuleModel? module) async {
    return await splashRepositoryInterface.setCacheModule(module);
  }

  @override
  ModuleModel? getCacheModule() {
    return splashRepositoryInterface.getCacheModule();
  }

  @override
  ModuleModel? getModule() {
    return splashRepositoryInterface.getModule();
  }

  @override
  Future<ResponseModel> subscribeEmail(String email) async {
    return await splashRepositoryInterface.subscribeEmail(email);
  }

  @override
  bool getSavedCookiesData() {
    return splashRepositoryInterface.getSavedCookiesData();
  }

  @override
  Future<void> saveCookiesData(bool data) async {
    return await splashRepositoryInterface.saveCookiesData(data);
  }

  @override
  void cookiesStatusChange(String? data) {
    splashRepositoryInterface.cookiesStatusChange(data);
  }

  @override
  bool getAcceptCookiesStatus(String data) {
    return splashRepositoryInterface.getAcceptCookiesStatus(data);
  }

  @override
  bool getSuggestedLocationStatus() {
    return splashRepositoryInterface.getSuggestedLocationStatus();
  }

  @override
  Future<void> saveSuggestedLocationStatus(bool data) async {
    return await splashRepositoryInterface.saveSuggestedLocationStatus(data);
  }

}