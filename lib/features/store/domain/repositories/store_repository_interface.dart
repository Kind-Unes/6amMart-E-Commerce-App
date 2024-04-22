import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/interfaces/repository_interface.dart';

abstract class StoreRepositoryInterface extends RepositoryInterface {
  @override
  Future getList({int? offset, bool isStoreList = false, String? filterBy, bool isPopularStoreList = false, String? type, bool isLatestStoreList = false,
    bool isFeaturedStoreList = false, bool isVisitAgainStoreList = false, bool isStoreRecommendedItemList = false, int? storeId,
    bool isStoreBannerList = false, bool isRecommendedStoreList = false});
  Future<dynamic> getStoreDetails(String storeID, bool fromCart, String slug, String languageCode, ModuleModel? module, int? cacheModuleId, int? moduleId);
  Future<dynamic> getStoreItemList(int? storeID, int offset, int? categoryID, String type);
  Future<dynamic> getStoreSearchItemList(String searchText, String? storeID, int offset, String type, int? categoryID);
  Future<dynamic> getCartStoreSuggestedItemList(int? storeId, String languageCode, ModuleModel? module, int? cacheModuleId, int? moduleId);
}