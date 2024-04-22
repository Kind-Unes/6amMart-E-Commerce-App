class StoreBannerModel {
  int? id;
  String? title;
  String? type;
  String? image;
  bool? status;
  int? data;
  String? createdAt;
  String? updatedAt;
  int? zoneId;
  int? moduleId;
  bool? featured;
  String? defaultLink;
  String? createdBy;

  StoreBannerModel({
    this.id,
    this.title,
    this.type,
    this.image,
    this.status,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.zoneId,
    this.moduleId,
    this.featured,
    this.defaultLink,
    this.createdBy,
  });

  StoreBannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    image = json['image'];
    status = json['status'];
    data = json['data'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zoneId = json['zone_id'];
    moduleId = json['module_id'];
    featured = json['featured'];
    defaultLink = json['default_link'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['image'] = image;
    data['status'] = status;
    data['data'] = data;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['zone_id'] = zoneId;
    data['module_id'] = moduleId;
    data['featured'] = featured;
    data['default_link'] = defaultLink;
    data['created_by'] = createdBy;
    return data;
  }
}