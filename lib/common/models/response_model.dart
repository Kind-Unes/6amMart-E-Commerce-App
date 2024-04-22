class ResponseModel {
  final bool _isSuccess;
  final String? _message;
  final bool? isPhoneVerified;
  List<int>? zoneIds;
  ResponseModel(this._isSuccess, this._message, {this.isPhoneVerified = false, this.zoneIds});

  String? get message => _message;
  bool get isSuccess => _isSuccess;
}