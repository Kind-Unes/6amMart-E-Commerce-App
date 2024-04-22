class NotificationModel {
  int? id;
  Data? data;
  String? createdAt;
  String? updatedAt;

  NotificationModel({this.id, this.data, this.createdAt, this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Data {
  String? title;
  String? description;
  String? image;
  String? type;

  Data({this.title, this.description, this.image, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'].toString();
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['type'] = type;
    return data;
  }
}
