import 'package:sixam_mart/features/item/domain/models/item_model.dart';

class CartSuggestItemModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Item>? items;

  CartSuggestItemModel({this.totalSize, this.limit, this.offset, this.items});

  CartSuggestItemModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['items'] != null) {
      items = <Item>[];
      json['items'].forEach((v) {
        items!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
