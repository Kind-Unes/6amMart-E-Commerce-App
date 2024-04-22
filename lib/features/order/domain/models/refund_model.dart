class RefundModel {
  List<RefundReasons>? refundReasons;

  RefundModel({this.refundReasons});

  RefundModel.fromJson(Map<String, dynamic> json) {
    if (json['refund_reasons'] != null) {
      refundReasons = <RefundReasons>[];
      json['refund_reasons'].forEach((v) {
        refundReasons!.add(RefundReasons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (refundReasons != null) {
      data['refund_reasons'] =
          refundReasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RefundReasons {
  int? id;
  String? reason;
  int? status;
  String? createdAt;
  String? updatedAt;

  RefundReasons(
      {this.id, this.reason, this.status, this.createdAt, this.updatedAt});

  RefundReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}