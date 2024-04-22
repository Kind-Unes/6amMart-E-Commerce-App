class OfflineMethodModel {
  int? id;
  String? methodName;
  List<MethodFields>? methodFields;
  List<MethodInformations>? methodInformations;
  int? status;
  String? createdAt;
  String? updatedAt;

  OfflineMethodModel({
    this.id,
    this.methodName,
    this.methodFields,
    this.methodInformations,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  OfflineMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    methodName = json['method_name'];
    if (json['method_fields'] != null) {
      methodFields = <MethodFields>[];
      json['method_fields'].forEach((v) {
        methodFields!.add(MethodFields.fromJson(v));
      });
    }
    if (json['method_informations'] != null) {
      methodInformations = <MethodInformations>[];
      json['method_informations'].forEach((v) {
        methodInformations!.add(MethodInformations.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['method_name'] = methodName;
    if (methodFields != null) {
      data['method_fields'] =
          methodFields!.map((v) => v.toJson()).toList();
    }
    if (methodInformations != null) {
      data['method_informations'] = methodInformations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MethodFields {
  String? inputName;
  String? inputData;

  MethodFields({this.inputName, this.inputData});

  MethodFields.fromJson(Map<String, dynamic> json) {
    inputName = json['input_name'];
    inputData = json['input_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['input_name'] = inputName;
    data['input_data'] = inputData;
    return data;
  }
}

class MethodInformations {
  String? customerInput;
  String? customerPlaceholder;
  bool? isRequired;

  MethodInformations({this.customerInput, this.customerPlaceholder, this.isRequired});

  MethodInformations.fromJson(Map<String, dynamic> json) {
    customerInput = json['customer_input'];
    customerPlaceholder = json['customer_placeholder'];
    isRequired = json['is_required'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_input'] = customerInput;
    data['customer_placeholder'] = customerPlaceholder;
    data['is_required'] = isRequired;
    return data;
  }
}