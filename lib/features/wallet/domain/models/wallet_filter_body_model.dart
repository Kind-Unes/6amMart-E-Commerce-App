class WalletFilterBodyModel {
  String? title;
  String? value;

  WalletFilterBodyModel({this.title, this.value});

  WalletFilterBodyModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['value'] = value;
    return data;
  }
}