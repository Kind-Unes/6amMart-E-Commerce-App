import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/features/item/domain/models/common_condition_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/module_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/cart_snackbar.dart';
import 'package:sixam_mart/common/widgets/confirmation_dialog.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/item_bottom_sheet.dart';
import 'package:sixam_mart/features/item/screens/item_details_screen.dart';
import 'package:sixam_mart/features/item/domain/services/item_service_interface.dart';

class ItemController extends GetxController implements GetxService {
  final ItemServiceInterface itemServiceInterface;
  ItemController({required this.itemServiceInterface});
  
  List<Item>? _popularItemList;
  List<Item>? get popularItemList => _popularItemList;
  
  List<Item>? _reviewedItemList;
  List<Item>? get reviewedItemList => _reviewedItemList;
  
  List<Item>? _recommendedItemList;
  List<Item>? get recommendedItemList => _recommendedItemList;
  
  List<Item>? _discountedItemList;
  List<Item>? get discountedItemList => _discountedItemList;
  
  List<Categories>? _reviewedCategoriesList;
  List<Categories>? get reviewedCategoriesList => _reviewedCategoriesList;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  List<int>? _variationIndex;
  List<int>? get variationIndex => _variationIndex;
  
  List<List<bool?>> _selectedVariations = [];
  List<List<bool?>> get selectedVariations => _selectedVariations;
  
  int? _quantity = 1;
  int? get quantity => _quantity;
  
  List<bool> _addOnActiveList = [];
  List<bool> get addOnActiveList => _addOnActiveList;
  
  List<int?> _addOnQtyList = [];
  List<int?> get addOnQtyList => _addOnQtyList;
  
  String _popularType = 'all';
  String get popularType => _popularType;
  
  String _reviewedType = 'all';
  String get reviewType => _reviewedType;

  String _discountedType = 'all';
  String get discountedType => _discountedType;
  
  static final List<String> _itemTypeList = ['all', 'veg', 'non_veg'];
  List<String> get itemTypeList => _itemTypeList;
  
  int _imageIndex = 0;
  int get imageIndex => _imageIndex;
  
  int _cartIndex = -1;
  int get cartIndex => _cartIndex;
  
  Item? _item;
  Item? get item => _item;
  
  int _productSelect = 0;
  int get productSelect => _productSelect;
  
  int _imageSliderIndex = 0;
  int get imageSliderIndex => _imageSliderIndex;
  
  List<bool> _collapseVariation = [];
  List<bool> get collapseVariation => _collapseVariation;
  
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  
  bool _isReadMore = false;
  bool get isReadMore => _isReadMore;
  
  BasicMedicineModel? _basicMedicineModel;
  BasicMedicineModel? get basicMedicineModel => _basicMedicineModel;
  
  List<CommonConditionModel>? _commonConditions;
  List<CommonConditionModel>? get commonConditions => _commonConditions;
  
  int _selectedCommonCondition = 0;
  int get selectedCommonCondition => _selectedCommonCondition;
  
  List<Item>? _conditionWiseProduct;
  List<Item>? get conditionWiseProduct => _conditionWiseProduct;
  
  ItemModel? _featuredCategoriesItem;
  ItemModel? get featuredCategoriesItem => _featuredCategoriesItem;
  
  int _selectedCategory = 0;
  int get selectedCategory => _selectedCategory;

  void selectCategory(int index) {
    _selectedCategory = index;
    update();
  }

  void selectCommonCondition(int index) {
    _selectedCommonCondition = index;
    getConditionsWiseItem(_commonConditions![index].id!, true);
    update();
  }

  void changeReadMore() {
    _isReadMore = !_isReadMore;
    update();
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> getPopularItemList(bool reload, String type, bool notify) async {
    _popularType = type;
    if(reload) {
      _popularItemList = null;
    }
    if(notify) {
      update();
    }
    if(_popularItemList == null || reload) {
      List<Item>? items = await itemServiceInterface.getPopularItemList(type);
      if (items != null) {
        _popularItemList = [];
        _popularItemList!.addAll(items);
        _isLoading = false;
      }
      update();
    }
  }

  Future<void> getReviewedItemList(bool reload, String type, bool notify) async {
    _reviewedType = type;
    if(reload) {
      _reviewedItemList = null;
    }
    if(notify) {
      update();
    }
    if(_reviewedItemList == null || reload) {
      ItemModel? itemModel = await itemServiceInterface.getReviewedItemList(type);
      if (itemModel != null) {
        _reviewedItemList = [];
        _reviewedCategoriesList = [];
        _reviewedItemList!.addAll(itemModel.items!);
        _reviewedCategoriesList!.addAll(itemModel.categories!);
        _isLoading = false;
      }
      update();
    }
  }

  Future<void> getDiscountedItemList(bool reload, bool notify, String type) async {
    _discountedType = type;
    if(reload) {
      _discountedItemList = null;
    }
    if(notify) {
      update();
    }
    if(_discountedItemList == null || reload) {
      List<Item>? items = await itemServiceInterface.getDiscountedItemList(type);
      if (items != null) {
        _discountedItemList = [];
        _discountedItemList!.addAll(items);
        _isLoading = false;
      }
      update();
    }
  }

  Future<void> getFeaturedCategoriesItemList(bool reload, bool notify) async {
    if(reload) {
      _featuredCategoriesItem = null;
    }
    if(notify) {
      update();
    }
    if(_featuredCategoriesItem == null || reload) {
      _featuredCategoriesItem = await itemServiceInterface.getFeaturedCategoriesItemList();
      update();
    }
  }

  Future<void> getRecommendedItemList(bool reload, String type, bool notify) async {
    if(reload) {
      _recommendedItemList = null;
    }
    if(notify) {
      update();
    }
    if(_recommendedItemList == null || reload) {
      List<Item>? items = await itemServiceInterface.getRecommendedItemList(type);
      if (items != null) {
        _recommendedItemList = [];
        _recommendedItemList!.addAll(items);
        _isLoading = false;
      }
      update();
    }
  }

  Future<void> getBasicMedicine(bool reload, bool notify) async {
    if(reload) {
      _basicMedicineModel = null;
    }
    if(notify) {
      update();
    }
    if(_basicMedicineModel == null || reload) {
      _basicMedicineModel = await itemServiceInterface.getBasicMedicine();
      _isLoading = false;
      update();
    }
  }

  Future<void> getConditionsWiseItem(int id, bool notify) async {
    _conditionWiseProduct = null;
    if(notify) {
      update();
    }
    List<Item>? items = await itemServiceInterface.getConditionsWiseItems(id);
    if (items != null) {
      _conditionWiseProduct = [];
      _conditionWiseProduct!.addAll(items);
      _isLoading = false;
    }
    update();
  }

  Future<void> getCommonConditions(bool notify) async {
    _commonConditions = [];
    if(notify) {
      update();
    }
    List<CommonConditionModel>? conditions = await itemServiceInterface.getCommonConditions();
    if (conditions != null) {
      _commonConditions!.addAll(conditions);
      _isLoading = false;
    }
    update();
  }

  Future<void> getProductDetails(Item item) async {
    _item = null;
    if(item.name != null) {
      _item = item;
    }else {
      _item = null;
      _item = await itemServiceInterface.getItemDetails(item.id);
    }
    initData(_item, null);
    setExistInCart(_item, /*notify: !ResponsiveHelper.isDesktop(Get.context)*/);
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void initData(Item? item, CartModel? cart) {
    _variationIndex = [];
    _addOnQtyList = [];
    _addOnActiveList = [];
    _selectedVariations = [];
    _collapseVariation = [];
    if(cart != null) {
      _quantity = cart.quantity;
      _addOnActiveList.addAll(itemServiceInterface.initializeCartAddonActiveList(cart.addOnIds, item!.addOns));
      _addOnQtyList.addAll(itemServiceInterface.initializeCartAddonsQtyList(cart.addOnIds, item.addOns));

      if(ModuleHelper.getModuleConfig(item.moduleType).newVariation!) {
        _selectedVariations.addAll(cart.foodVariations!);
        _collapseVariation.addAll(itemServiceInterface.collapseVariation(item.foodVariations!));
      }else {
        _variationIndex = itemServiceInterface.initializeCartVariationIndexes(cart.variation, item.choiceOptions);
      }
    } else {
      if(ModuleHelper.getModuleConfig(item!.moduleType).newVariation!) {
        _selectedVariations.addAll(itemServiceInterface.initializeSelectedVariation(item.foodVariations));
        _collapseVariation.addAll(itemServiceInterface.initializeCollapseVariation(item.foodVariations));
      } else {
        _variationIndex = itemServiceInterface.initializeVariationIndexes(item.choiceOptions);
      }
      _quantity = 1;
      _addOnActiveList.addAll(itemServiceInterface.initializeAddonActiveList(item.addOns));
      _addOnQtyList.addAll(itemServiceInterface.initializeAddonQtyList(item.addOns));

      setExistInCart(item, notify: false);
    }

  }

  void cartIndexSet() {
    _cartIndex = -1;
  }

  int setExistInCart(Item? item, {bool notify = false}) {
    String variationType = itemServiceInterface.prepareVariationType(item!.choiceOptions, _variationIndex);

    if(ModuleHelper.getModuleConfig(ModuleHelper.getModule() != null ? ModuleHelper.getModule()!.moduleType : ModuleHelper.getCacheModule()!.moduleType).newVariation!) {
      _cartIndex = -1;
    } else {
      _cartIndex = Get.find<CartController>().isExistInCart(item.id, variationType, false, null);
    }

    if(_cartIndex != -1) {
      _quantity = Get.find<CartController>().cartList[_cartIndex].quantity;
      _addOnActiveList = itemServiceInterface.initializeCartAddonActiveList(Get.find<CartController>().cartList[_cartIndex].addOnIds, item.addOns);
      _addOnQtyList = itemServiceInterface.initializeCartAddonsQtyList(Get.find<CartController>().cartList[_cartIndex].addOnIds, item.addOns);
    }
    if(notify) {
      update();
    }
    return _cartIndex;
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    _addOnQtyList[index] = itemServiceInterface.setAddOnQuantity(isIncrement, _addOnQtyList[index]!);
    update();
  }

  void setQuantity(bool isIncrement, int? stock,  int? quantityLimit, {bool getxSnackBar = false}) {
    _quantity = itemServiceInterface.setQuantity(isIncrement, Get.find<SplashController>().configModel!.moduleConfig!.module!.stock!, stock, _quantity!, quantityLimit, getxSnackBar: getxSnackBar);
    update();
  }

  void setCartVariationIndex(int index, int i, Item? item) {
    _variationIndex![index] = i;
    _quantity = 1;
    setExistInCart(item);
    update();
  }

  void showMoreSpecificSection(int index){
    _collapseVariation[index] = !_collapseVariation[index];
    update();
  }

  void setNewCartVariationIndex(int index, int i, Item item) {
    _selectedVariations = itemServiceInterface.setNewCartVariationIndex(index, i, item.foodVariations!, _selectedVariations);
    // if(!item.foodVariations![index].multiSelect!) {
    //   for(int j = 0; j < _selectedVariations[index].length; j++) {
    //     if(item.foodVariations![index].required!){
    //       _selectedVariations[index][j] = j == i;
    //     }else{
    //       if(_selectedVariations[index][j]!){
    //         _selectedVariations[index][j] = false;
    //       }else{
    //         _selectedVariations[index][j] = j == i;
    //       }
    //     }
    //   }
    // } else {
    //   if(!_selectedVariations[index][i]! && selectedVariationLength(_selectedVariations, index) >= item.foodVariations![index].max!) {
    //     showCustomSnackBar(
    //       '${'maximum_variation_for'.tr} ${item.foodVariations![index].name} ${'is'.tr} ${item.foodVariations![index].max}',
    //       getXSnackBar: true,
    //     );
    //   }else {
    //     _selectedVariations[index][i] = !_selectedVariations[index][i]!;
    //   }
    // }
    update();
  }

  int selectedVariationLength(List<List<bool?>> selectedVariations, int index) {
    return itemServiceInterface.selectedVariationLength(selectedVariations, index);
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    update();
  }

  void setImageIndex(int index, bool notify) {
    _imageIndex = index;
    if(notify) {
      update();
    }
  }

  void setSelect(int select, bool notify){
    _productSelect = select;
    if(notify){
      update();
    }
  }

  void setImageSliderIndex(int index) {
    _imageSliderIndex = index;
    update();
  }

  double? getStartingPrice(Item item) {
    return itemServiceInterface.getStartingPrice(item);
  }

  bool isAvailable(Item item) {
    return DateConverter.isAvailable(item.availableTimeStarts, item.availableTimeEnds);
  }

  double? getDiscount(Item item) => item.storeDiscount == 0 ? item.discount : item.storeDiscount;

  String? getDiscountType(Item item) => item.storeDiscount == 0 ? item.discountType : 'percent';

  void navigateToItemPage(Item? item, BuildContext context, {bool inStore = false, bool isCampaign = false}) {
    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! || item!.moduleType == 'food') {
      ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
        ItemBottomSheet(item: item, inStorePage: inStore, isCampaign: isCampaign),
        backgroundColor: Colors.transparent, isScrollControlled: true,
      ) : Get.dialog(
        Dialog(child: ItemBottomSheet(item: item, inStorePage: inStore, isCampaign: isCampaign)),
      );
    }else {
      Get.toNamed(RouteHelper.getItemDetailsRoute(item.id, inStore), arguments: ItemDetailsScreen(item: item, inStorePage: inStore));
    }
  }

  void itemDirectlyAddToCart(Item? item, BuildContext context, {bool inStore = false, bool isCampaign = false}) {

    if (((item!.foodVariations != null && item.foodVariations!.isEmpty) && item.moduleType == AppConstants.food) || (item.variations != null && item.variations!.isEmpty && item.moduleType != AppConstants.food)) {
      double price = item.price!;
      double discount = item.discount!;
      double discountPrice = PriceConverter.convertWithDiscount(price, discount, item.discountType)!;

      CartModel cartModel = CartModel(
        null, price, discount, [], [], (price - discountPrice), 1, [], [], isCampaign,
        item.stock, item, item.quantityLimit,
      );

      OnlineCart onlineCart = OnlineCart(
        null, isCampaign ? null : item.id, isCampaign ? item.id : null, price.toString(),
        '', null, ModuleHelper.getModuleConfig(item.moduleType).newVariation! ? [] : null,
        1, [], [], [], 'Item',
      );
      if(Get.find<SplashController>().configModel!.moduleConfig!.module!.stock! && item.stock! <= 0){
        showCustomSnackBar('out_of_stock'.tr);
      }
      else if (Get.find<CartController>().existAnotherStoreItem(cartModel.item!.storeId, ModuleHelper.getModule() != null
          ? ModuleHelper.getModule()?.id : ModuleHelper.getCacheModule()?.id)) {
        Get.dialog(ConfirmationDialog(
          icon: Images.warning,
          title: 'are_you_sure_to_reset'.tr,
          description: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
              ? 'if_you_continue'.tr : 'if_you_continue_without_another_store'.tr,
          onYesPressed: () {
            Get.find<CartController>().clearCartOnline().then((success) async {
              if (success) {
                await Get.find<CartController>().addToCartOnline(onlineCart);
                Get.back();
                showCartSnackBar();
              }
            });
          },
        ), barrierDismissible: false);
      } else {
        Get.find<CartController>().addToCartOnline(onlineCart);
        showCartSnackBar();
      }
    } else if(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! || item.moduleType == AppConstants.food){
      ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
        ItemBottomSheet(item: item, inStorePage: inStore, isCampaign: isCampaign),
        backgroundColor: Colors.transparent, isScrollControlled: true,
      ) : Get.dialog(
        Dialog(child: ItemBottomSheet(item: item, inStorePage: inStore, isCampaign: isCampaign)),
      );
    } else {
      Get.toNamed(RouteHelper.getItemDetailsRoute(item.id, inStore), arguments: ItemDetailsScreen(item: item, inStorePage: inStore));
    }
  }
  
}
