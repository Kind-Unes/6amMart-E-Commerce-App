class FundBonusModel {
  int? id;
  String? title;
  String? description;
  String? bonusType;
  double? bonusAmount;
  double? minimumAddAmount;
  double? maximumBonusAmount;
  String? startDate;
  String? endDate;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Translations>? translations;

  FundBonusModel(
      {this.id,
        this.title,
        this.description,
        this.bonusType,
        this.bonusAmount,
        this.minimumAddAmount,
        this.maximumBonusAmount,
        this.startDate,
        this.endDate,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.translations});

  FundBonusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    bonusType = json['bonus_type'];
    bonusAmount = json['bonus_amount']?.toDouble();
    minimumAddAmount = json['minimum_add_amount']?.toDouble();
    maximumBonusAmount = json['maximum_bonus_amount']?.toDouble();
    startDate = json['start_date'];
    endDate = json['end_date'];
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
    data['description'] = description;
    data['bonus_type'] = bonusType;
    data['bonus_amount'] = bonusAmount;
    data['minimum_add_amount'] = minimumAddAmount;
    data['maximum_bonus_amount'] = maximumBonusAmount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
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