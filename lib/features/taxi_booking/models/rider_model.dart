class RiderModel {
  RiderLatLng? latLng;
  String? phone;
  int? id;
  double? ratings;
  String? updatedTime;
  bool? isAvailable;
  double? heading;
  String? name;
  String? image;

  RiderModel(
      {this.latLng,
        this.phone,
        this.id,
        this.ratings,
        this.updatedTime,
        this.isAvailable,
        this.heading,
        this.name,
        this.image,
      });

  RiderModel.fromJson(Map<Object, Object> j) {
    Map<String, dynamic> json = Map.from(j);
    latLng = json['latLng'] != null ? RiderLatLng.fromJson(json['latLng']) : null;
    phone = json['phone'];
    id = json['id'];
    ratings = json['ratings'].toDouble();
    updatedTime = json['updated_time'];
    isAvailable = json['isAvailable'];
    heading = json['heading'].toDouble();
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (latLng != null) {
      data['latLng'] = latLng!.toJson();
    }
    data['phone'] = phone;
    data['id'] = id;
    data['ratings'] = ratings;
    data['updated_time'] = updatedTime;
    data['isAvailable'] = isAvailable;
    data['heading'] = heading;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class RiderLatLng {
  double? lat;
  double? lng;

  RiderLatLng({this.lat, this.lng});

  RiderLatLng.fromJson(List<Object> json) {
    lat = json[0] as double;
    lng = json[1] as double;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['0'] = lat;
    data['1'] = lng;
    return data;
  }
}
