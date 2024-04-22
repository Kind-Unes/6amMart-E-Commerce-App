import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/item/domain/models/common_condition_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';

abstract class ItemServiceInterface {
  Future<List<Item>?> getPopularItemList(String type);
  Future<ItemModel?> getReviewedItemList(String type);
  Future<ItemModel?> getFeaturedCategoriesItemList();
  Future<List<Item>?> getRecommendedItemList(String type);
  Future<List<Item>?> getDiscountedItemList(String type);
  Future<Item?> getItemDetails(int? itemID);
  Future<BasicMedicineModel?> getBasicMedicine();
  Future<List<CommonConditionModel>?> getCommonConditions();
  Future<List<Item>?> getConditionsWiseItems(int id);
  List<bool> initializeCartAddonActiveList(List<AddOn>? addOnIds, List<AddOns>? addOns);
  List<int?> initializeCartAddonsQtyList(List<AddOn>? addOnIds, List<AddOns>? addOns);
  List<bool> collapseVariation(List<FoodVariation>? foodVariations);
  List<int> initializeCartVariationIndexes(List<Variation>? variation, List<ChoiceOptions>? choiceOptions);
  List<List<bool?>> initializeSelectedVariation(List<FoodVariation>? foodVariations);
  List<bool> initializeCollapseVariation(List<FoodVariation>? foodVariations);
  List<int> initializeVariationIndexes(List<ChoiceOptions>? choiceOptions);
  List<bool> initializeAddonActiveList(List<AddOns>? addOns);
  List<int> initializeAddonQtyList(List<AddOns>? addOns);
  String prepareVariationType(List<ChoiceOptions>? choiceOptions, List<int>? variationIndex);
  int setAddOnQuantity(bool isIncrement, int addOnQty);
  int setQuantity(bool isIncrement, bool moduleStock, int? stock, int qty, int? quantityLimit, {bool getxSnackBar = false});
  List<List<bool?>> setNewCartVariationIndex(int index, int i, List<FoodVariation>? foodVariations, List<List<bool?>> selectedVariations);
  int selectedVariationLength(List<List<bool?>> selectedVariations, int index);
  double? getStartingPrice(Item item);
}