import 'dart:convert';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';

class PlaceOrderBodyModel {
  List<OnlineCart>? _cart;
  double? _couponDiscountAmount;
  double? _orderAmount;
  String? _orderType;
  String? _paymentMethod;
  String? _orderNote;
  String? _couponCode;
  int? _storeId;
  double? _distance;
  String? _scheduleAt;
  double? _discountAmount;
  double? _taxAmount;
  String? _address;
  String? _latitude;
  String? _longitude;
  int? _senderZoneId;
  String? _contactPersonName;
  String? _contactPersonNumber;
  AddressModel? _receiverDetails;
  String? _addressType;
  String? _parcelCategoryId;
  String? _chargePayer;
  String? _streetNumber;
  String? _house;
  String? _floor;
  String? _dmTips;
  String? _unavailableItemNote;
  String? _deliveryInstruction;
  int? _cutlery;
  int? _partialPayment;
  int? _guestId;
  int? _isBuyNow;
  String? _guestEmail;

  PlaceOrderBodyModel({
    required List<OnlineCart> cart,
    required double? couponDiscountAmount,
    required String? couponCode,
    required double orderAmount,
    required String? orderType,
    required String paymentMethod,
    required int? storeId,
    required double? distance,
    required String? scheduleAt,
    required double? discountAmount,
    required double taxAmount,
    required String orderNote,
    required String? address,
    required AddressModel? receiverDetails,
    required String? latitude,
    required String? longitude,
    required int? senderZoneId,
    required String contactPersonName,
    required String? contactPersonNumber,
    required String? addressType,
    required String? parcelCategoryId,
    required String? chargePayer,
    required String streetNumber,
    required String house,
    required String floor,
    required String dmTips,
    required String unavailableItemNote,
    required String deliveryInstruction,
    required int cutlery,
    required int partialPayment,
    required int guestId,
    required int isBuyNow,
    required String? guestEmail,
  }) {
    _cart = cart;
    _couponDiscountAmount = couponDiscountAmount;
    _orderAmount = orderAmount;
    _orderType = orderType;
    _paymentMethod = paymentMethod;
    _orderNote = orderNote;
    _couponCode = couponCode;
    _storeId = storeId;
    _distance = distance;
    _scheduleAt = scheduleAt;
    _discountAmount = discountAmount;
    _taxAmount = taxAmount;
    _address = address;
    _receiverDetails = receiverDetails;
    _latitude = latitude;
    _longitude = longitude;
    _senderZoneId = senderZoneId;
    _contactPersonName = contactPersonName;
    _contactPersonNumber = contactPersonNumber;
    _addressType = addressType;
    _parcelCategoryId = parcelCategoryId;
    _chargePayer = chargePayer;
    _streetNumber = streetNumber;
    _house = house;
    _floor = floor;
    _dmTips = dmTips;
    _unavailableItemNote = unavailableItemNote;
    _deliveryInstruction = deliveryInstruction;
    _cutlery = cutlery;
    _partialPayment = partialPayment;
    _guestId = guestId;
    _isBuyNow = isBuyNow;
    _guestEmail = guestEmail;
  }

  List<OnlineCart>? get cart => _cart;
  double? get couponDiscountAmount => _couponDiscountAmount;
  double? get orderAmount => _orderAmount;
  String? get orderType => _orderType;
  String? get paymentMethod => _paymentMethod;
  String? get orderNote => _orderNote;
  String? get couponCode => _couponCode;
  int? get storeId => _storeId;
  double? get distance => _distance;
  String? get scheduleAt => _scheduleAt;
  double? get discountAmount => _discountAmount;
  double? get taxAmount => _taxAmount;
  String? get address => _address;
  AddressModel? get receiverDetails => _receiverDetails;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  int? get senderZoneId => _senderZoneId;
  String? get contactPersonName => _contactPersonName;
  String? get contactPersonNumber => _contactPersonNumber;
  String? get parcelCategoryId => _parcelCategoryId;
  String? get chargePayer => _chargePayer;
  String? get streetNumber => _streetNumber;
  String? get house => _house;
  String? get floor => _floor;
  String? get dmTips => _dmTips;
  String? get unavailableItemNote => _unavailableItemNote;
  String? get deliveryInstruction => _deliveryInstruction;
  int? get cutlery => _cutlery;
  int? get partialPayment => _partialPayment;
  int? get guestId => _guestId;
  int? get isBuyNow => _isBuyNow;
  String? get guestEmail => _guestEmail;

  PlaceOrderBodyModel.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      jsonDecode(json['cart']).forEach((v) {
        _cart!.add(OnlineCart.fromJson(v));
      });
    }
    _couponDiscountAmount = double.parse(json['coupon_discount_amount'] ?? 0.toString());
    _orderAmount = double.parse(json['order_amount'].toString());
    _orderType = json['order_type'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _storeId = json['store_id'] != null ? int.parse(json['store_id'].toString()) : null;
    _distance = double.parse(json['distance'].toString());
    _scheduleAt = json['schedule_at'];
    _discountAmount = double.parse(json['discount_amount'].toString());
    _taxAmount = double.parse(json['tax_amount'].toString());
    _address = json['address'];
    _receiverDetails = json['receiver_details'] != null ? AddressModel.fromJson(json['receiver_details'] is String ? jsonDecode(json['receiver_details'])
        : json['receiver_details']) : null;
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _senderZoneId = json['sender_zone_id'] != null ? int.parse(json['sender_zone_id'].toString()) : null;
    _contactPersonName = json['contact_person_name'];
    _contactPersonNumber = json['contact_person_number'];
    _addressType = json['address_type'];
    _parcelCategoryId = json['parcel_category_id'];
    _chargePayer = json['charge_payer'];
    _streetNumber = json['road'];
    _house = json['apartment'];
    _floor = json['floor'];
    _dmTips = json['dm_tips'];
    _unavailableItemNote = json['unavailable_item_note'];
    _deliveryInstruction = json['delivery_instruction'];
    _cutlery = json['cutlery'] != null ? int.parse(json['cutlery'].toString()) : null;
    _partialPayment = json['partial_payment'] != null ? int.parse(json['partial_payment'].toString()) : null;
    _guestId = json['guest_id'] != null ? int.parse(json['guest_id'].toString()) : null;
    _isBuyNow = int.parse(json['is_buy_now'].toString());
    _guestEmail = json['contact_person_email'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    if (_cart != null) {
      data['cart'] = jsonEncode(_cart!.map((v) => v.toJson()).toList());
    }
    if (_couponDiscountAmount != null) {
      data['coupon_discount_amount'] = _couponDiscountAmount.toString();
    }
    data['order_amount'] = _orderAmount.toString();
    data['order_type'] = _orderType!;
    data['payment_method'] = _paymentMethod!;
    if (_orderNote != null && _orderNote!.isNotEmpty) {
      data['order_note'] = _orderNote!;
    }
    if (_couponCode != null) {
      data['coupon_code'] = _couponCode!;
    }
    if (_storeId != null) {
      data['store_id'] = _storeId.toString();
    }
    data['distance'] = _distance.toString();
    if (_scheduleAt != null) {
      data['schedule_at'] = _scheduleAt!;
    }
    data['discount_amount'] = _discountAmount.toString();
    data['tax_amount'] = _taxAmount.toString();
    data['address'] = _address ?? '';
    if (_receiverDetails != null) {
      data['receiver_details'] = jsonEncode(_receiverDetails!.toJson());
    }
    data['latitude'] = _latitude ?? '';
    data['longitude'] = _longitude ?? '';
    if (_senderZoneId != null) {
      data['sender_zone_id'] = _senderZoneId.toString();
    }
    data['contact_person_name'] = _contactPersonName!;
    data['contact_person_number'] = _contactPersonNumber!;
    data['address_type'] = _addressType ?? '';
    if (_parcelCategoryId != null) {
      data['parcel_category_id'] = _parcelCategoryId!;
    }
    if (_chargePayer != null) {
      data['charge_payer'] = _chargePayer!;
    }
    data['road'] = _streetNumber.toString();
    data['house'] = _house.toString();
    data['floor'] = _floor.toString();
    data['dm_tips'] = _dmTips.toString();
    data['unavailable_item_note'] = _unavailableItemNote.toString();
    data['delivery_instruction'] = _deliveryInstruction.toString();
    if (_cutlery != null) {
      data['cutlery'] = _cutlery.toString();
    }
    data['partial_payment'] = _partialPayment.toString();
    if (_guestId != 0) {
      data['guest_id'] = _guestId.toString();
    }
    data['is_buy_now'] = _isBuyNow.toString();
    if (_guestEmail != null) {
      data['contact_person_email'] = _guestEmail!;
    }
    return data;
  }
}

class OnlineCart {
  int? _cartId;
  int? _itemId;
  int? _itemCampaignId;
  String? _price;
  String? _variant;
  List<Variation>? _variation;
  List<OrderVariation>? _variations;
  int? _quantity;
  List<int?>? _addOnIds;
  List<AddOns>? _addOns;
  List<int?>? _addOnQtys;
  String? _model;
  String? _itemType;

  OnlineCart(
    int? cartId,
    int? itemId,
    int? itemCampaignId,
    String price,
    String variant,
    List<Variation>? variation,
    List<OrderVariation>? variations,
    int? quantity,
    List<int?> addOnIds,
    List<AddOns>? addOns,
    List<int?> addOnQtys,
    String model,
    {String? itemType}){
    _cartId = cartId;
    _itemId = itemId;
    _itemCampaignId = itemCampaignId;
    _price = price;
    _variant = variant;
    _variation = variation;
    _variations = variations;
    _quantity = quantity;
    _addOnIds = addOnIds;
    _addOns = addOns;
    _addOnQtys = addOnQtys;
    _model = model;
    _itemType = itemType;
  }

  int? get cartId => _cartId;
  int? get itemId => _itemId;
  int? get itemCampaignId => _itemCampaignId;
  String? get price => _price;
  String? get variant => _variant;
  List<Variation>? get variation => _variation;
  int? get quantity => _quantity;
  List<int?>? get addOnIds => _addOnIds;
  List<AddOns>? get addOns => _addOns;
  List<int?>? get addOnQtys => _addOnQtys;
  String? get model => _model;
  String? get itemType => _itemType;

  OnlineCart.fromJson(Map<String, dynamic> json) {
    _cartId = json['cart_id'];
    _itemId = json['item_id'];
    _itemCampaignId = json['item_campaign_id'];
    _price = json['price'];
    _variant = json['variant'];
    if (json['variation'] != null && json['variation'].isNotEmpty && json['variation'][0]['price'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation!.add(Variation.fromJson(v));
      });
    } else if (json['variation'] != null) {
      _variations = [];
      json['variation'].forEach((v) {
        _variations!.add(OrderVariation.fromJson(v));
      });
    }
    _quantity = json['quantity'];
    _addOnIds = json['add_on_ids'].cast<int>();
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns!.add(AddOns.fromJson(v));
      });
    }
    _addOnQtys = json['add_on_qtys'].cast<int>();
    _model = json['model'];
    if (json['item_type'] != null && json['item_type'] != 'null') {
      _itemType = json['item_type'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = _itemId;
    data['cart_id'] = _cartId;
    data['item_campaign_id'] = _itemCampaignId;
    data['price'] = _price;
    data['variant'] = _variant;
    if (_variation != null) {
      data['variation'] = _variation!.map((v) => v.toJson()).toList();
    } else if (_variations != null) {
      data['variation'] = _variations!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = _quantity;
    data['add_on_ids'] = _addOnIds;
    if (_addOns != null) {
      data['add_ons'] = _addOns!.map((v) => v.toJson()).toList();
    }
    data['add_on_qtys'] = _addOnQtys;
    data['model'] = _model;
    if (_itemType != null) {
      data['item_type'] = _itemType;
    }
    return data;
  }
}

class OrderVariation {
  String? name;
  OrderVariationValue? values;

  OrderVariation({this.name, this.values});

  OrderVariation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    values = json['values'] != null ? OrderVariationValue.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (values != null) {
      data['values'] = values!.toJson();
    }
    return data;
  }
}

class OrderVariationValue {
  List<String?>? label;

  OrderVariationValue({this.label});

  OrderVariationValue.fromJson(Map<String, dynamic> json) {
    label = json['label'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    return data;
  }
}
