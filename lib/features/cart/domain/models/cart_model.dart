import 'package:sixam_mart/features/item/domain/models/item_model.dart';

class CartModel {
  int? _id;
  double? _price;
  double? _discountedPrice;
  List<Variation>? _variation;
  List<List<bool?>>? _foodVariations;
  double? _discountAmount;
  int? _quantity;
  List<AddOn>? _addOnIds;
  List<AddOns>? _addOns;
  bool? _isCampaign;
  int? _stock;
  Item? _item;
  int? _quantityLimit;
  bool? _isLoading;

  CartModel(
    int? id,
    double? price,
    double discountedPrice,
    List<Variation> variation,
    List<List<bool?>> foodVariations,
    double discountAmount,
    int? quantity,
    List<AddOn> addOnIds,
    List<AddOns> addOns,
    bool isCampaign,
    int? stock,
    Item? item,
    int? quantityLimit,
    {bool isLoading = false}) {
    _id = id;
    _price = price;
    _discountedPrice = discountedPrice;
    _variation = variation;
    _foodVariations = foodVariations;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _addOnIds = addOnIds;
    _addOns = addOns;
    _isCampaign = isCampaign;
    _stock = stock;
    _item = item;
    _quantityLimit = quantityLimit;
    _isLoading = isLoading;
  }

  int? get id => _id;
  double? get price => _price;
  double? get discountedPrice => _discountedPrice;
  List<Variation>? get variation => _variation;
  List<List<bool?>>? get foodVariations => _foodVariations;
  double? get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int? get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int? qty) => _quantity = qty;
  List<AddOn>? get addOnIds => _addOnIds;
  List<AddOns>? get addOns => _addOns;
  bool? get isCampaign => _isCampaign;
  int? get stock => _stock;
  Item? get item => _item;
  int? get quantityLimit => _quantityLimit;
  // ignore: unnecessary_getters_setters
  bool? get isLoading => _isLoading;
  set isLoading(bool? status) => _isLoading = status;

  CartModel.fromJson(Map<String, dynamic> json) {
    _id = json['cart_id'];
    _price = json['price'].toDouble();
    _discountedPrice = json['discounted_price']?.toDouble();
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation!.add(Variation.fromJson(v));
      });
    }
    if (json['food_variations'] != null) {
      _foodVariations = [];
      for (int index = 0; index < json['food_variations'].length; index++) {
        _foodVariations!.add([]);
        for (int i = 0; i < json['food_variations'][index].length; i++) {
          _foodVariations![index].add(json['food_variations'][index][i]);
        }
      }
    }
    _discountAmount = json['discount_amount']?.toDouble();
    _quantity = json['quantity'];
    _stock = json['stock'];
    if (json['add_on_ids'] != null) {
      _addOnIds = [];
      json['add_on_ids'].forEach((v) {
        _addOnIds!.add(AddOn.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns!.add(AddOns.fromJson(v));
      });
    }
    _isCampaign = json['is_campaign'];
    if (json['item'] != null) {
      _item = Item.fromJson(json['item']);
    }
    if (json['quantity_limit'] != null) {
      _quantityLimit = int.parse(json['quantity_limit']);
    }
    _isLoading = json['is_loading'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = _id;
    data['price'] = _price;
    data['discounted_price'] = _discountedPrice;
    if (_variation != null) {
      data['variation'] = _variation!.map((v) => v.toJson()).toList();
    }
    data['food_variations'] = _foodVariations;
    data['discount_amount'] = _discountAmount;
    data['quantity'] = _quantity;
    if (_addOnIds != null) {
      // data['add_on_ids'] = addOnIds;
      data['add_on_ids'] = _addOnIds!.map((v) => v.toJson()).toList();
    }
    if (_addOns != null) {
      data['add_ons'] = _addOns!.map((v) => v.toJson()).toList();
    }
    data['is_campaign'] = _isCampaign;
    data['stock'] = _stock;
    data['item'] = _item!.toJson();
    data['quantity_limit'] = _quantityLimit?.toString();
    // data['is_loading'] = _isLoading?? false;
    return data;
  }
}

class AddOn {
  int? id;
  int? quantity;

  AddOn({this.id, this.quantity});

  AddOn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    return data;
  }
}
