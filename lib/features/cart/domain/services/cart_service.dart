import 'package:get/get_utils/get_utils.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/features/cart/domain/models/online_cart_model.dart';
import 'package:sixam_mart/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:sixam_mart/features/cart/domain/services/cart_service_interface.dart';
import 'package:sixam_mart/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sixam_mart/helper/module_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart' as item_variation;

class CartService implements CartServiceInterface {
  final CartRepositoryInterface cartRepositoryInterface;
  CartService({required this.cartRepositoryInterface});

  @override
  Future<List<OnlineCartModel>?> addToCartOnline(OnlineCart cart) async {
    return await cartRepositoryInterface.add(cart);
  }

  @override
  Future<List<OnlineCartModel>?> updateCartOnline(OnlineCart cart) async {
    return await cartRepositoryInterface.update(cart.toJson(), null);
  }

  @override
  Future<bool> updateCartQuantityOnline(int cartId, double price, int quantity) async {
    return await cartRepositoryInterface.update({}, cartId, price: price, quantity: quantity, isUpdateQty: true);
  }

  @override
  Future<List<OnlineCartModel>?> getCartDataOnline() async {
    return await cartRepositoryInterface.getList();
  }

  @override
  Future<bool> removeCartItemOnline(int cartId) async {
    return await cartRepositoryInterface.delete(cartId);
  }

  @override
  Future<bool> clearCartOnline() async {
    return await cartRepositoryInterface.delete(null, isRemoveAll: true);
  }

  @override
  int availableSelectedIndex(int selectedIndex, int index) {
    int notAvailableIndex = selectedIndex;
    if(notAvailableIndex == index){
      notAvailableIndex = -1;
    }else {
      notAvailableIndex = index;
    }
    return notAvailableIndex;
  }

  @override
  ModuleModel? forcefullySetModule(ModuleModel? selectedModule, List<ModuleModel>? moduleList, int moduleId) {
    ModuleModel? module;
    if(selectedModule == null && moduleList != null){
      for(ModuleModel m in moduleList) {
        if(m.id == moduleId) {
          module = m;
          break;
        }
      }
    }
    return module;
  }

  @override
  List<AddOns> prepareAddonList(CartModel cartModel) {
    List<AddOns> addOnList = [];
    for (var addOnId in cartModel.addOnIds!) {
      for(AddOns addOns in cartModel.item!.addOns!) {
        if(addOns.id == addOnId.id) {
          addOnList.add(addOns);
          break;
        }
      }
    }
    return addOnList;
  }

  @override
  double calculateAddonPrice(double addOns, List<AddOns> addOnList, CartModel cartModel) {
    double addonPrice = addOns;
    for(int index=0; index<addOnList.length; index++) {
      addonPrice = addonPrice + (addOnList[index].price! * cartModel.addOnIds![index].quantity!);
    }
    return addonPrice;
  }

  @override
  double calculateVariationPrice(bool isFoodVariation, CartModel cartModel, double? discount, String? discountType, double variationPrice) {
    double price = variationPrice;
    if(isFoodVariation) {
      for(int index = 0; index< cartModel.item!.foodVariations!.length; index++) {
        for(int i=0; i<cartModel.item!.foodVariations![index].variationValues!.length; i++) {
          if(cartModel.foodVariations![index][i]!) {
            price += (PriceConverter.convertWithDiscount(cartModel.item!.foodVariations![index].variationValues![i].optionPrice!, discount, discountType, isFoodVariation: true)! * cartModel.quantity!);
          }
        }
      }
    } else {

      String variationType = '';
      for(int i=0; i<cartModel.variation!.length; i++) {
        variationType = cartModel.variation![i].type!;
      }

      for (item_variation.Variation variation in cartModel.item!.variations!) {
        if (variation.type == variationType) {
          price = (PriceConverter.convertWithDiscount(variation.price!, discount, discountType)! * cartModel.quantity!);
          break;
        }
      }
    }
    return price;
  }

  @override
  double calculateVariationWithoutDiscountPrice(bool isFoodVariation, CartModel cartModel, double variationWithoutDiscount) {
    double variationWithoutDiscountPrice = variationWithoutDiscount;
    if(!isFoodVariation) {
      String variationType = '';
      for(int i=0; i<cartModel.variation!.length; i++) {
        variationType = cartModel.variation![i].type!;
      }
      for (item_variation.Variation variation in cartModel.item!.variations!) {
        if (variation.type == variationType) {
          variationWithoutDiscountPrice = (variation.price! * cartModel.quantity!);
          break;
        }
      }
    } else {
      for(int index = 0; index< cartModel.item!.foodVariations!.length; index++) {
        for(int i=0; i<cartModel.item!.foodVariations![index].variationValues!.length; i++) {
          if(cartModel.foodVariations![index][i]!) {
            variationWithoutDiscountPrice += (cartModel.item!.foodVariations![index].variationValues![i].optionPrice! * cartModel.quantity!);
          }
        }
      }
    }
    return variationWithoutDiscountPrice;
  }

  @override
  bool checkVariation(bool isFoodVariation, CartModel cartModel) {
    bool haveVariation = false;
    if(!isFoodVariation) {
      String variationType = '';
      for(int i=0; i<cartModel.variation!.length; i++) {
        variationType = cartModel.variation![i].type!;
      }
      for (item_variation.Variation variation in cartModel.item!.variations!) {
        if (variation.type == variationType) {
          haveVariation = true;
          break;
        }
      }
    }
    return haveVariation;
  }

  @override
  Future<void> addSharedPrefCartList(List<CartModel> cartProductList) async {
    await cartRepositoryInterface.addSharedPrefCartList(cartProductList);
  }

  @override
  int? getCartId(int cartIndex, List<CartModel> cartList) {
    if(cartIndex != -1) {
      return cartList[cartIndex].id;
    } else {
      return null;
    }
  }

  @override
  int decideItemQuantity(bool isIncrement, List<CartModel> cartList, int cartIndex, int? stock, int ? quantityLimit, bool moduleStock) {
    int quantity = cartList[cartIndex].quantity!;
    if (isIncrement) {
      if(moduleStock && cartList[cartIndex].quantity! >= stock!) {
        showCustomSnackBar('out_of_stock'.tr);
      }else if(quantityLimit != null){
        if(quantity >= quantityLimit && quantityLimit != 0) {
          showCustomSnackBar('${'maximum_quantity_limit'.tr} $quantityLimit');
        } else {
          quantity = quantity + 1;
        }
      } else {
        quantity = quantity + 1;
      }
    } else {
      quantity = quantity - 1;
    }
    return quantity;
  }

  @override
  double calculateDiscountedPrice(CartModel cartModel, int quantity, bool isFoodVariation) {
    double? discount = cartModel.item!.storeDiscount == 0 ? cartModel.item!.discount : cartModel.item!.storeDiscount;
    String? discountType = cartModel.item!.storeDiscount == 0 ? cartModel.item!.discountType : 'percent';
    double variationPrice = 0;
    double addonPrice = 0;

    if(isFoodVariation) {
      for(int index = 0; index< cartModel.item!.foodVariations!.length; index++) {
        for(int i=0; i<cartModel.item!.foodVariations![index].variationValues!.length; i++) {
          if(cartModel.foodVariations![index][i]!) {
            variationPrice += (PriceConverter.convertWithDiscount(cartModel.item!.foodVariations![index].variationValues![i].optionPrice!, discount, discountType, isFoodVariation: true)! * cartModel.quantity!);
          }
        }
      }

      List<AddOns> addOnList = [];
      for (var addOnId in cartModel.addOnIds!) {
        for(AddOns addOns in cartModel.item!.addOns!) {
          if(addOns.id == addOnId.id) {
            addOnList.add(addOns);
            break;
          }
        }
      }
      for(int index=0; index<addOnList.length; index++) {
        addonPrice = addonPrice + (addOnList[index].price! * cartModel.addOnIds![index].quantity!);
      }
    }
    double discountedPrice = addonPrice + variationPrice + (cartModel.item!.price! * quantity) - PriceConverter.calculation(cartModel.item!.price!, discount, discountType!, quantity);
    return discountedPrice;
  }

  @override
  List<CartModel> formatOnlineCartToLocalCart({required List<OnlineCartModel> onlineCartModel}) {
    List<CartModel> cartList = [];
    for (OnlineCartModel cart in onlineCartModel) {
      double price = cart.item!.price!;
      double? discount = cart.item!.storeDiscount == 0 ? cart.item!.discount! : cart.item!.storeDiscount!;
      String? discountType = (cart.item!.storeDiscount == 0) ? cart.item!.discountType : 'percent';
      double discountedPrice = PriceConverter.convertWithDiscount(price, discount, discountType)!;

      double? discountAmount = price - discountedPrice;
      int? quantity = cart.quantity;
      int? stock = cart.item!.stock ?? 0;

      List<List<bool?>> selectedFoodVariations = [];
      List<bool> collapsVariation = [];

      if(cart.item!.moduleType == 'food') {
        for(int index=0; index<cart.item!.foodVariations!.length; index++) {
          selectedFoodVariations.add([]);
          collapsVariation.add(true);
          for(int i=0; i < cart.item!.foodVariations![index].variationValues!.length; i++) {
            if(cart.item!.foodVariations![index].variationValues![i].isSelected ?? false){
              selectedFoodVariations[index].add(true);
            } else {
              selectedFoodVariations[index].add(false);
            }
          }
        }
      } else {
        String variationType = cart.productVariation != null && cart.productVariation!.isNotEmpty ? cart.productVariation![0].type! : '';
        for (item_variation.Variation variation in cart.item!.variations!) {
          if (variation.type == variationType) {
            discountedPrice = (PriceConverter.convertWithDiscount(variation.price!, discount, discountType)! * cart.quantity!);
            break;
          }
        }
      }

      List<AddOn> addOnIdList = [];
      List<AddOns> addOnsList = [];
      for (int index = 0; index < cart.addOnIds!.length; index++) {
        addOnIdList.add(AddOn(id: cart.addOnIds![index], quantity: cart.addOnQtys![index]));
        for (int i=0; i< cart.item!.addOns!.length; i++) {
          if(cart.addOnIds![index] == cart.item!.addOns![i].id) {
            addOnsList.add(AddOns(id: cart.item!.addOns![i].id, name: cart.item!.addOns![i].name, price: cart.item!.addOns![i].price));
          }
        }
      }

      int? quantityLimit = cart.item!.quantityLimit;

      cartList.add(
        CartModel(
          cart.id, price, discountedPrice, cart.productVariation?? [], selectedFoodVariations, discountAmount, quantity,
          addOnIdList, addOnsList, false, stock, cart.item, quantityLimit,
        ),
      );
    }

    return cartList;
  }

  @override
  int isExistInCart(List<CartModel> cartList, int? itemID, String variationType, bool isUpdate, int? cartIndex) {
    for(int index=0; index<cartList.length; index++) {
      if(cartList[index].item!.id == itemID && (cartList[index].variation!.isNotEmpty
          ? cartList[index].variation![0].type == variationType : true)) {
        if((isUpdate && index == cartIndex)) {
          return -1;
        }else {
          return index;
        }
      }
    }
    return -1;
  }

  @override
  bool existAnotherStoreItem(int? storeID, int? moduleId, List<CartModel> cartList) {
    for(CartModel cartModel in cartList) {
      if(cartModel.item!.storeId != storeID && cartModel.item!.moduleId == moduleId) {
        return true;
      }
    }
    return false;
  }

  @override
  int cartQuantity(int itemId, List<CartModel> cartList) {
    int quantity = 0;
    for(CartModel cart in cartList) {
      if(cart.item!.id == itemId) {
        quantity += cart.quantity!;
      }

    }
    return quantity;
  }

  @override
  String cartVariant(int itemId, List<CartModel> cartList) {
    String variant = '';
    for(CartModel cart in cartList) {
      if(cart.item!.id == itemId) {
        if(!ModuleHelper.getModuleConfig(cart.item!.moduleType).newVariation!) {
          variant = (cart.variation != null && cart.variation!.isNotEmpty) ? cart.variation![0].type! : '';
        }
      }
    }
    return variant;
  }

}