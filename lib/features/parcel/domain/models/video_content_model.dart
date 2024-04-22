class VideoContentModel {
  String? promotionalBannerUrl;
  String? bannerVideoContentUrl;
  List<BannerContents>? bannerContents;
  String? sectionTitle;
  String? bannerType;
  String? bannerVideo;
  String? bannerImage;
  String? bannerVideoContent;

  VideoContentModel(
      {this.promotionalBannerUrl,
        this.bannerVideoContentUrl,
        this.bannerContents,
        this.sectionTitle,
        this.bannerType,
        this.bannerVideo,
        this.bannerImage,
        this.bannerVideoContent,
      });

  VideoContentModel.fromJson(Map<String, dynamic> json) {
    promotionalBannerUrl = json['promotional_banner_url'];
    bannerVideoContentUrl = json['banner_video_content_url'];
    if (json['banner_contents'] != null) {
      bannerContents = <BannerContents>[];
      json['banner_contents'].forEach((v) {
        bannerContents!.add(BannerContents.fromJson(v));
      });
    }
    sectionTitle = json['section_title'];
    bannerType = json['banner_type'];
    bannerVideo = json['banner_video'];
    bannerImage = json['banner_image'];
    bannerVideoContent = json['banner_video_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotional_banner_url'] = promotionalBannerUrl;
    data['banner_video_content_url'] = bannerVideoContentUrl;
    if (bannerContents != null) {
      data['banner_contents'] =
          bannerContents!.map((v) => v.toJson()).toList();
    }
    data['section_title'] = sectionTitle;
    data['banner_type'] = bannerType;
    data['banner_video'] = bannerVideo;
    data['banner_image'] = bannerImage;
    data['banner_video_content'] = bannerVideoContent;
    return data;
  }
}

class BannerContents {
  int? id;
  int? moduleId;
  String? key;
  String? value;
  String? type;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Translations>? translations;

  BannerContents(
      {this.id,
        this.moduleId,
        this.key,
        this.value,
        this.type,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.translations});

  BannerContents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleId = json['module_id'];
    key = json['key'];
    value = json['value'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['module_id'] = moduleId;
    data['key'] = key;
    data['value'] = value;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  Translations(
      {this.id,
        this.translationableType,
        this.translationableId,
        this.locale,
        this.key,
        this.value,
        this.createdAt,
        this.updatedAt});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
