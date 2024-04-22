class ReviewModel {
  int? id;
  String? comment;
  int? rating;
  String? itemName;
  String? itemImage;
  String? customerName;
  String? createdAt;
  String? updatedAt;

  ReviewModel(
      {this.id,
        this.comment,
        this.rating,
        this.itemName,
        this.itemImage,
        this.customerName,
        this.createdAt,
        this.updatedAt});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    itemName = json['item_name'];
    itemImage = json['item_image'];
    customerName = json['customer_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['rating'] = rating;
    data['item_name'] = itemName;
    data['item_image'] = itemImage;
    data['customer_name'] = customerName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
