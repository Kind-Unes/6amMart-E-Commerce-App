import 'package:get/get.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/favourite/domain/repositories/favourite_repository_interface.dart';
import 'package:sixam_mart/features/favourite/domain/services/favourite_service_interface.dart';
import 'package:sixam_mart/helper/address_helper.dart';

class FavouriteService implements FavouriteServiceInterface {
  final FavouriteRepositoryInterface favouriteRepositoryInterface;
  FavouriteService({required this.favouriteRepositoryInterface});

  @override
  Future<Response> getFavouriteList() async {
    return await favouriteRepositoryInterface.getList();
  }

  @override
  Future<ResponseModel> addFavouriteList(int? id, bool isStore) async {
    return await favouriteRepositoryInterface.add(null, isStore: isStore, id: id);
  }

  @override
  Future<ResponseModel> removeFavouriteList(int? id, bool isStore) async {
    return await favouriteRepositoryInterface.delete(id, isStore: isStore);
  }

  @override
  List<Item?> wishItemList(Item item) {
    List<Item?> wishItemList = [];
    for (var zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      for (var module in zone.modules!) {
        if(module.id == item.moduleId){
          if(module.pivot!.zoneId == item.zoneId){
            wishItemList.add(item);
          }
        }
      }
    }
    return wishItemList;
  }

  @override
  List<int?> wishItemIdList (Item item) {
    List<int?> wishItemIdList = [];
    for (var zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      for (var module in zone.modules!) {
        if(module.id == item.moduleId){
          if(module.pivot!.zoneId == item.zoneId){
            wishItemIdList.add(item.id);
          }
        }
      }
    }
    return wishItemIdList;
  }

  @override
  List<Store?> wishStoreList(dynamic store) {
    List<Store?> wishStoreList = [];
    for (var zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      for (var module in zone.modules!) {
        if(module.id == Store.fromJson(store).moduleId){
          if(module.pivot!.zoneId == Store.fromJson(store).zoneId){
            wishStoreList.add(Store.fromJson(store));
          }
        }
      }
    }
    return wishStoreList;
  }

  @override
  List<int?> wishStoreIdList(dynamic store) {
    List<int?> wishStoreIdList = [];
    for (var zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      for (var module in zone.modules!) {
        if(module.id == Store.fromJson(store).moduleId){
          if(module.pivot!.zoneId == Store.fromJson(store).zoneId){
            wishStoreIdList.add(Store.fromJson(store).id);
          }
        }
      }
    }
    return wishStoreIdList;
  }

}