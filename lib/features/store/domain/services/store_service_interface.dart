import 'package:get/get.dart';
import 'package:sixam_mart/features/store/domain/models/cart_suggested_item_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/recommended_product_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_banner_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';

abstract class StoreServiceInterface {
  Future<StoreModel?> getStoreList(int offset, String filterBy);
  Future<List<Store>?> getPopularStoreList(String type);
  Future<List<Store>?> getLatestStoreList(String type);
  Future<Response> getFeaturedStoreList();
  Future<Response> getVisitAgainStoreList();
  Future<Store?> getStoreDetails(String storeID, bool fromCart, String slug, String languageCode, ModuleModel? module, int? cacheModuleId, int? moduleId);
  Future<ItemModel?> getStoreItemList(int? storeID, int offset, int? categoryID, String type);
  Future<ItemModel?> getStoreSearchItemList(String searchText, String? storeID, int offset, String type, int? categoryID);
  Future<RecommendedItemModel?> getStoreRecommendedItemList(int? storeId);
  Future<CartSuggestItemModel?> getCartStoreSuggestedItemList(int? storeId, String languageCode, ModuleModel? module, int? cacheModuleId, int? moduleId);
  Future<List<StoreBannerModel>?> getStoreBannerList(int? storeId);
  Future<List<Store>?> getRecommendedStoreList();
  List<Modules> moduleList();
}