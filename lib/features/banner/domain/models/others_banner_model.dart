class ParcelOtherBannerModel {
  String? promotionalBannerUrl;
  List<Banners>? banners;

  ParcelOtherBannerModel({this.promotionalBannerUrl, this.banners});

  ParcelOtherBannerModel.fromJson(Map<String, dynamic> json) {
    promotionalBannerUrl = json['promotional_banner_url'];
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(Banners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotional_banner_url'] = promotionalBannerUrl;
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  int? id;
  int? moduleId;
  String? key;
  String? image;
  String? type;
  int? status;
  String? createdAt;
  String? updatedAt;

  Banners({
    this.id,
    this.moduleId,
    this.key,
    this.image,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleId = json['module_id'];
    key = json['key'];
    image = json['value'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['module_id'] = moduleId;
    data['key'] = key;
    data['value'] = image;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
