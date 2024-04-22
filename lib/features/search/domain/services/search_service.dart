import 'package:get/get.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/search/domain/repositories/search_repository_interface.dart';
import 'package:sixam_mart/features/search/domain/services/search_service_interface.dart';
import 'package:sixam_mart/helper/date_converter.dart';

class SearchService implements SearchServiceInterface {
  final SearchRepositoryInterface searchRepositoryInterface;
  SearchService({required this.searchRepositoryInterface});

  @override
  Future<Response> getSearchData(String? query, bool isStore) async {
    return await searchRepositoryInterface.getList(query: query, isStore: isStore);
  }

  @override
  Future<List<Item>?> getSuggestedItems() async {
    return await searchRepositoryInterface.getList(isSuggestedItems: true);
  }

  @override
  Future<bool> saveSearchHistory(List<String> searchHistories) async {
    return await searchRepositoryInterface.saveSearchHistory(searchHistories);
  }

  @override
  List<String> getSearchAddress() {
    return searchRepositoryInterface.getSearchAddress();
  }

  @override
  Future<bool> clearSearchHistory() async {
    return await searchRepositoryInterface.clearSearchHistory();
  }

  @override
  List<Item>? sortItemSearchList( List<Item>? allItemList, double upperValue, double lowerValue, int rating, bool veg, bool nonVeg, bool isAvailableItems, bool isDiscountedItems, int sortIndex) {
    List<Item>? searchItemList= [];
    searchItemList.addAll(allItemList!);
    if(upperValue > 0) {
      searchItemList.removeWhere((product) => product.price! <= lowerValue || product.price! > upperValue);
    }
    if(rating != -1) {
      searchItemList.removeWhere((product) => product.avgRating! < rating);
    }
    if(!veg && nonVeg) {
      searchItemList.removeWhere((product) => product.veg == 1);
    }
    if(!nonVeg && veg) {
      searchItemList.removeWhere((product) => product.veg == 0);
    }
    if(isAvailableItems || isDiscountedItems) {
      if(isAvailableItems) {
        searchItemList.removeWhere((product) => !DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds));
      }
      if(isDiscountedItems) {
        searchItemList.removeWhere((product) => product.discount == 0);
      }
    }
    if(sortIndex != -1) {
      if(sortIndex == 0) {
        searchItemList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      }else {
        searchItemList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = searchItemList.reversed;
        searchItemList = iterable.toList() as List<Item>?;
      }
    }
    return searchItemList;
  }

  @override
  List<Store>? sortStoreSearchList(List<Store>? allStoreList, int storeRating, bool storeVeg, bool storeNonVeg, bool isAvailableStore, bool isDiscountedStore, int storeSortIndex) {
    List<Store>? searchStoreList = [];
    searchStoreList.addAll(allStoreList!);
    if(storeRating != -1) {
      searchStoreList.removeWhere((store) => store.avgRating! < storeRating);
    }
    if(!storeVeg && storeNonVeg) {
      searchStoreList.removeWhere((product) => product.nonVeg == 0);
    }
    if(!storeNonVeg && storeVeg) {
      searchStoreList.removeWhere((product) => product.veg == 0);
    }
    if(isAvailableStore || isDiscountedStore) {
      if(isAvailableStore) {
        searchStoreList.removeWhere((store) => store.open == 0 || !store.active!);
      }
      if(isDiscountedStore) {
        searchStoreList.removeWhere((store) => store.discount == null);
      }
    }
    if(storeSortIndex != -1) {
      if(storeSortIndex == 0) {
        searchStoreList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      }else {
        searchStoreList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = searchStoreList.reversed;
        searchStoreList = iterable.toList() as List<Store>?;
      }
    }
    return searchStoreList;
  }

}