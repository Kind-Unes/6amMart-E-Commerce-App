class LandingModel {
  BaseUrls? baseUrls;
  String? fixedHeaderTitle;
  String? fixedHeaderSubTitle;
  String? fixedHeaderImage;
  String? fixedModuleTitle;
  String? fixedModuleSubTitle;
  String? fixedLocationTitle;
  String? joinSellerTitle;
  String? joinSellerSubTitle;
  String? joinSellerButtonName;
  String? joinSellerButtonUrl;
  String? joinDeliveryManTitle;
  String? joinDeliveryManSubTitle;
  String? joinDeliveryManButtonName;
  String? joinDeliveryManButtonUrl;
  String? downloadUserAppTitle;
  String? downloadUserAppSubTitle;
  String? downloadUserAppImage;
  List<SpecialCriterias>? specialCriterias;
  DownloadUserAppLinks? downloadUserAppLinks;

  LandingModel(
      {this.baseUrls,
        this.fixedHeaderTitle,
        this.fixedHeaderSubTitle,
        this.fixedHeaderImage,
        this.fixedModuleTitle,
        this.fixedModuleSubTitle,
        this.fixedLocationTitle,
        this.joinSellerTitle,
        this.joinSellerSubTitle,
        this.joinSellerButtonName,
        this.joinSellerButtonUrl,
        this.joinDeliveryManTitle,
        this.joinDeliveryManSubTitle,
        this.joinDeliveryManButtonName,
        this.joinDeliveryManButtonUrl,
        this.downloadUserAppTitle,
        this.downloadUserAppSubTitle,
        this.downloadUserAppImage,
        this.specialCriterias,
        this.downloadUserAppLinks});

  LandingModel.fromJson(Map<String, dynamic> json) {
    baseUrls = json['base_urls'] != null
        ? BaseUrls.fromJson(json['base_urls'])
        : null;
    fixedHeaderTitle = json['fixed_header_title'];
    fixedHeaderSubTitle = json['fixed_header_sub_title'];
    fixedHeaderImage = json['fixed_header_image'];
    fixedModuleTitle = json['fixed_module_title'];
    fixedModuleSubTitle = json['fixed_module_sub_title'];
    fixedLocationTitle = json['fixed_location_title'];
    joinSellerTitle = json['join_seller_title'];
    joinSellerSubTitle = json['join_seller_sub_title'];
    joinSellerButtonName = json['join_seller_button_name'];
    joinSellerButtonUrl = json['join_seller_button_url'];
    joinDeliveryManTitle = json['join_delivery_man_title'];
    joinDeliveryManSubTitle = json['join_delivery_man_sub_title'];
    joinDeliveryManButtonName = json['join_delivery_man_button_name'];
    joinDeliveryManButtonUrl = json['join_delivery_man_button_url'];
    downloadUserAppTitle = json['download_user_app_title'];
    downloadUserAppSubTitle = json['download_user_app_sub_title'];
    downloadUserAppImage = json['download_user_app_image'];
    if (json['special_criterias'] != null) {
      specialCriterias = <SpecialCriterias>[];
      json['special_criterias'].forEach((v) {
        specialCriterias!.add(SpecialCriterias.fromJson(v));
      });
    }
    downloadUserAppLinks = json['download_user_app_links'] != null
        ? DownloadUserAppLinks.fromJson(json['download_user_app_links'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (baseUrls != null) {
      data['base_urls'] = baseUrls!.toJson();
    }
    data['fixed_header_title'] = fixedHeaderTitle;
    data['fixed_header_sub_title'] = fixedHeaderSubTitle;
    data['fixed_header_image'] = fixedHeaderImage;
    data['fixed_module_title'] = fixedModuleTitle;
    data['fixed_module_sub_title'] = fixedModuleSubTitle;
    data['fixed_location_title'] = fixedLocationTitle;
    data['join_seller_title'] = joinSellerTitle;
    data['join_seller_sub_title'] = joinSellerSubTitle;
    data['join_seller_button_name'] = joinSellerButtonName;
    data['join_seller_button_url'] = joinSellerButtonUrl;
    data['join_delivery_man_title'] = joinDeliveryManTitle;
    data['join_delivery_man_sub_title'] = joinDeliveryManSubTitle;
    data['join_delivery_man_button_name'] = joinDeliveryManButtonName;
    data['join_delivery_man_button_url'] = joinDeliveryManButtonUrl;
    data['download_user_app_title'] = downloadUserAppTitle;
    data['download_user_app_sub_title'] = downloadUserAppSubTitle;
    data['download_user_app_image'] = downloadUserAppImage;
    if (specialCriterias != null) {
      data['special_criterias'] = specialCriterias!.map((v) => v.toJson()).toList();
    }
    if (downloadUserAppLinks != null) {
      data['download_user_app_links'] = downloadUserAppLinks!.toJson();
    }
    return data;
  }
}

class BaseUrls {
  String? fixedHeaderImage;
  String? specialCriteriaImage;
  String? downloadUserAppImage;

  BaseUrls(
      {this.fixedHeaderImage,
        this.specialCriteriaImage,
        this.downloadUserAppImage});

  BaseUrls.fromJson(Map<String, dynamic> json) {
    fixedHeaderImage = json['fixed_header_image'];
    specialCriteriaImage = json['special_criteria_image'];
    downloadUserAppImage = json['download_user_app_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fixed_header_image'] = fixedHeaderImage;
    data['special_criteria_image'] = specialCriteriaImage;
    data['download_user_app_image'] = downloadUserAppImage;
    return data;
  }
}

class SpecialCriterias {
  int? id;
  String? title;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Translations>? translations;

  SpecialCriterias(
      {this.id,
        this.title,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.translations});

  SpecialCriterias.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
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
    data['title'] = title;
    data['image'] = image;
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

class DownloadUserAppLinks {
  String? playstoreUrlStatus;
  String? playstoreUrl;
  String? appleStoreUrlStatus;
  String? appleStoreUrl;

  DownloadUserAppLinks(
      {this.playstoreUrlStatus,
        this.playstoreUrl,
        this.appleStoreUrlStatus,
        this.appleStoreUrl});

  DownloadUserAppLinks.fromJson(Map<String, dynamic> json) {
    playstoreUrlStatus = json['playstore_url_status'];
    playstoreUrl = json['playstore_url'];
    appleStoreUrlStatus = json['apple_store_url_status'];
    appleStoreUrl = json['apple_store_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['playstore_url_status'] = playstoreUrlStatus;
    data['playstore_url'] = playstoreUrl;
    data['apple_store_url_status'] = appleStoreUrlStatus;
    data['apple_store_url'] = appleStoreUrl;
    return data;
  }
}