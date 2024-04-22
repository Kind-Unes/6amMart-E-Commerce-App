
enum DeepLinkType{
  restaurant,
  cuisine,
  category,
}

class DeepLinkBody {
  DeepLinkType? deepLinkType;
  int? id;
  String? name;

  DeepLinkBody({this.deepLinkType, this.id, this.name});

  DeepLinkBody.fromJson(Map<String, dynamic> json) {
    deepLinkType = convertToEnum(json['deepLinkType']);
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deepLinkType'] = deepLinkType.toString();
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  DeepLinkType convertToEnum(String? enumString) {
    if(enumString == DeepLinkType.restaurant.toString()) {
      return DeepLinkType.restaurant;
    }else if(enumString == DeepLinkType.cuisine.toString()) {
      return DeepLinkType.cuisine;
    }else{
      return DeepLinkType.category;
    }
  }

}