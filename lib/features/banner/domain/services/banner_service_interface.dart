import 'package:sixam_mart/features/banner/domain/models/banner_model.dart';
import 'package:sixam_mart/features/banner/domain/models/others_banner_model.dart';
import 'package:sixam_mart/features/banner/domain/models/promotional_banner_model.dart';

abstract class BannerServiceInterface {
  Future<BannerModel?> getBannerList();
  Future<BannerModel?> getTaxiBannerList();
  Future<BannerModel?> getFeaturedBannerList();
  Future<ParcelOtherBannerModel?> getParcelOtherBannerList();
  Future<PromotionalBanner?> getPromotionalBannerList();
  List<int?> moduleIdList();
}
