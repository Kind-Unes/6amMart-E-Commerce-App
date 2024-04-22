import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/online_payment/domain/repositories/online_payment_repo_interface.dart';

class OnlinePaymentRepo implements OnlinePaymentRepoInterface {
  final ApiClient apiClient;

  OnlinePaymentRepo({required this.apiClient});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}
