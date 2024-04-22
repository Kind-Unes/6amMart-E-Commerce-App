class BrandModel {
  int? id;
  int? moduleId;
  String? name;
  String? logo;
  String? description;
  bool? status;
  String? createdAt;
  String? updatedAt;

  BrandModel(
      {this.id,
        this.moduleId,
        this.name,
        this.logo,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt});

  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleId = json['module_id'];
    name = json['name'];
    logo = json['logo'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['module_id'] = moduleId;
    data['name'] = name;
    data['logo'] = logo;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}