import 'package:get/get.dart';
import 'package:sixam_mart/features/store/domain/models/cart_suggested_item_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/recommended_product_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_banner_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/features/store/domain/repositories/store_repository_interface.dart';
import 'package:sixam_mart/features/store/domain/services/store_service_interface.dart';
import 'package:sixam_mart/helper/address_helper.dart';

class StoreService implements StoreServiceInterface {
  final StoreRepositoryInterface storeRepositoryInterface;
  StoreService({required this.storeRepositoryInterface});

  @override
  Future<StoreModel?> getStoreList(int offset, String filterBy) async {
    return await storeRepositoryInterface.getList(offset: offset, isStoreList: true, filterBy: filterBy);
  }

  @override
  Future<List<Store>?> getPopularStoreList(String type) async {
    return await storeRepositoryInterface.getList(isPopularStoreList: true, type: type);
  }

  @override
  Future<List<Store>?> getLatestStoreList(String type) async {
    return await storeRepositoryInterface.getList(isLatestStoreList: true, type: type);
  }

  @override
  Future<Response> getFeaturedStoreList() async {
    return await storeRepositoryInterface.getList(isFeaturedStoreList: true);
  }

  @override
  Future<Response> getVisitAgainStoreList() async {
    return await storeRepositoryInterface.getList(isVisitAgainStoreList: true);
  }

  @override
  Future<Store?> getStoreDetails(String storeID, bool fromCart, String slug, String languageCode, ModuleModel? module, int? cacheModuleId, int? moduleId) async {
    return await storeRepositoryInterface.getStoreDetails(storeID, fromCart, slug, languageCode, module, cacheModuleId, moduleId);
  }

  @override
  Future<ItemModel?> getStoreItemList(int? storeID, int offset, int? categoryID, String type) async {
    return await storeRepositoryInterface.getStoreItemList(storeID, offset, categoryID, type);
  }

  @override
  Future<ItemModel?> getStoreSearchItemList(String searchText, String? storeID, int offset, String type, int? categoryID) async {
    return await storeRepositoryInterface.getStoreSearchItemList(searchText, storeID, offset, type, categoryID);
  }

  @override
  Future<RecommendedItemModel?> getStoreRecommendedItemList(int? storeId) async {
    return await storeRepositoryInterface.getList(isStoreRecommendedItemList: true, storeId: storeId);
  }

  @override
  Future<CartSuggestItemModel?> getCartStoreSuggestedItemList(int? storeId, String languageCode, ModuleModel? module, int? cacheModuleId, int? moduleId) async {
    return await storeRepositoryInterface.getCartStoreSuggestedItemList(storeId, languageCode, module, cacheModuleId, moduleId);
  }

  @override
  Future<List<StoreBannerModel>?> getStoreBannerList(int? storeId) async {
    return await storeRepositoryInterface.getList(isStoreBannerList: true, storeId: storeId);
  }

  @override
  Future<List<Store>?> getRecommendedStoreList() async {
    return await storeRepositoryInterface.getList(isRecommendedStoreList: true);
  }

  @override
  List<Modules> moduleList() {
    List<Modules> moduleList = [];
    for (ZoneData zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData ?? []) {
      for (Modules module in zone.modules ?? []) {
        moduleList.add(module);
      }
    }
    return moduleList;
  }

}