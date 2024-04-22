class DeliveryManVehicleModel {
  int? id;
  String? type;

  DeliveryManVehicleModel({this.id, this.type});

  DeliveryManVehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}