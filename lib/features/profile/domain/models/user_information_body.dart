import 'package:sixam_mart/features/address/domain/models/address_model.dart';

class UserInformationBody{
  AddressModel? from;
  AddressModel? to;
  String? fareCategory;
  double? distance;
  double? duration;
  String? filterType;
  double? minPrice;
  double? maxPrice;
  int? brandModelId;
  String? rentTime;

  UserInformationBody({this.from, this.to, this.fareCategory, this.distance, this.duration, this.filterType, this.minPrice, this.maxPrice, this.brandModelId, this.rentTime});

  UserInformationBody.fromJson(Map<String, dynamic> json) {
    from = json['from'] != null ? AddressModel.fromJson(json['from']) : null;
    to = json['to'] != null ? AddressModel.fromJson(json['to']) : null;
    fareCategory = json['fare_category'];
    distance = json['distance']?.toDouble();
    duration = json['duration'].toDouble();
    filterType = json['filter_type'];
    minPrice = json['filter_min_price'];
    maxPrice = json['filter_max_price'];
    brandModelId = json['filter_brand'];
    rentTime = json['rent_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (from != null) {
      data['from'] = from!.toJson();
    }
    if (to != null) {
      data['to'] = to!.toJson();
    }
    data['fare_category'] = fareCategory;
    data['distance'] = distance;
    data['duration'] = duration;
    data['filter_type'] = filterType;
    data['filter_min_price'] = minPrice;
    data['filter_max_price'] = maxPrice;
    data['filter_brand'] = brandModelId;
    data['rent_time'] = rentTime;
    return data;
  }
}