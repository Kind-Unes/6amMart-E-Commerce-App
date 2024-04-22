import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';

abstract class SearchServiceInterface {
  Future<Response> getSearchData(String? query, bool isStore);
  Future<List<Item>?> getSuggestedItems();
  Future<bool> saveSearchHistory(List<String> searchHistories);
  List<String> getSearchAddress();
  Future<bool> clearSearchHistory();
  List<Item>? sortItemSearchList( List<Item>? allItemList, double upperValue, double lowerValue, int rating, bool veg, bool nonVeg, bool isAvailableItems, bool isDiscountedItems, int sortIndex);
  List<Store>? sortStoreSearchList(List<Store>? allStoreList, int storeRating, bool storeVeg, bool storeNonVeg, bool isAvailableStore, bool isDiscountedStore, int storeSortIndex);
}