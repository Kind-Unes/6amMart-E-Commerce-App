import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/features/cart/domain/models/online_cart_model.dart';
import 'package:sixam_mart/features/checkout/domain/models/place_order_body_model.dart';

abstract class CartServiceInterface {
  int availableSelectedIndex(int selectedIndex, int index);
  ModuleModel? forcefullySetModule(ModuleModel? module, List<ModuleModel>? moduleList, int moduleId);
  List<AddOns> prepareAddonList(CartModel cartModel);
  double calculateAddonPrice(double addOns, List<AddOns> addOnList, CartModel cartModel);
  double calculateVariationPrice(bool isFoodVariation, CartModel cartModel, double? discount, String? discountType, double variationPrice);
  double calculateVariationWithoutDiscountPrice(bool isFoodVariation, CartModel cartModel, double variationWithoutDiscount);
  bool checkVariation(bool isFoodVariation, CartModel cartModel);
  Future<void> addSharedPrefCartList(List<CartModel> cartProductList);
  int? getCartId(int cartIndex, List<CartModel> cartList);
  int decideItemQuantity(bool isIncrement, List<CartModel> cartList, int cartIndex, int? stock, int ? quantityLimit, bool moduleStock);
  double calculateDiscountedPrice(CartModel cartModel, int quantity, bool isFoodVariation);
  Future<bool> updateCartQuantityOnline(int cartId, double price, int quantity);
  Future<List<OnlineCartModel>?> getCartDataOnline();
  List<CartModel> formatOnlineCartToLocalCart({required List<OnlineCartModel> onlineCartModel});
  Future<List<OnlineCartModel>?> updateCartOnline(OnlineCart cart);
  Future<List<OnlineCartModel>?> addToCartOnline(OnlineCart cart);
  Future<bool> removeCartItemOnline(int cartId);
  Future<bool> clearCartOnline();
  int isExistInCart(List<CartModel> cartList, int? itemID, String variationType, bool isUpdate, int? cartIndex);
  bool existAnotherStoreItem(int? storeID, int? moduleId, List<CartModel> cartList);
  int cartQuantity(int itemId, List<CartModel> cartList);
  String cartVariant(int itemId, List<CartModel> cartList);
}