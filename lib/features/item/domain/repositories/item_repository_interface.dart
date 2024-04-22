import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/interfaces/repository_interface.dart';

abstract class ItemRepositoryInterface implements RepositoryInterface {
  // Future<dynamic> getPopularItemList(String type);
  @override
  Future getList({int? offset, String? type, bool isPopularItem = false, bool isReviewedItem = false, bool isFeaturedCategoryItems = false, bool isRecommendedItems = false, bool isCommonConditions = false, bool isDiscountedItems = false});
  // Future<dynamic> getReviewedItemList(String type);
  // Future<dynamic> getFeaturedCategoriesItemList();
  // Future<dynamic> getRecommendedItemList(String type);
  // Future<dynamic> getDiscountedItemList();
  // Future<dynamic> getItemDetails(int? itemID);
  Future<BasicMedicineModel?> getBasicMedicine();
  @override
  Future get(String? id, {bool isConditionWiseItem = false});
  // Future<dynamic> getCommonConditions();
  // Future<dynamic> getConditionsWiseItem(int id);
}