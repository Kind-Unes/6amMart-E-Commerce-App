import 'package:sixam_mart/features/banner/domain/models/banner_model.dart';
import 'package:sixam_mart/features/banner/domain/models/others_banner_model.dart';
import 'package:sixam_mart/features/banner/domain/models/promotional_banner_model.dart';
import 'package:sixam_mart/features/banner/domain/repositories/banner_repository_interface.dart';
import 'package:sixam_mart/features/banner/domain/services/banner_service_interface.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';

class BannerService implements BannerServiceInterface {
  final BannerRepositoryInterface bannerRepositoryInterface;
  BannerService({required this.bannerRepositoryInterface});

  @override
  Future<BannerModel?> getBannerList() async {
    return await bannerRepositoryInterface.getList(isBanner: true);
  }

  @override
  Future<BannerModel?> getTaxiBannerList() async {
    return await bannerRepositoryInterface.getList(isTaxiBanner: true);
  }

  @override
  Future<BannerModel?> getFeaturedBannerList() async {
    return await bannerRepositoryInterface.getList(isFeaturedBanner: true);
  }

  @override
  Future<ParcelOtherBannerModel?> getParcelOtherBannerList() async {
    return await bannerRepositoryInterface.getList(isParcelOtherBanner: true);
  }

  @override
  Future<PromotionalBanner?> getPromotionalBannerList() async {
    return await bannerRepositoryInterface.getList(isPromotionalBanner: true);
  }

  @override
  List<int?> moduleIdList() {
    List<int?> moduleIdList = [];
    for (ZoneData zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      for (Modules module in zone.modules ?? []) {
        moduleIdList.add(module.id);
      }
    }
    return moduleIdList;
  }

}