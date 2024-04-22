import 'package:get/get_connect/connect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/order/domain/models/order_cancellation_body.dart';
import 'package:sixam_mart/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/features/order/domain/models/refund_model.dart';
import 'package:sixam_mart/features/order/domain/repositories/order_repository_interface.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class OrderRepository implements OrderRepositoryInterface {
  final ApiClient apiClient;
  OrderRepository({required this.apiClient});

  @override
  Future<Response> submitRefundRequest(Map<String, String> body, XFile? data) async {
    return apiClient.postMultipartData(AppConstants.refundRequestUri, body,  [MultipartBody('image[]', data)]);
  }

  @override
  Future<Response> trackOrder(String? orderID, String? guestId, {String? contactNumber}) async {
    return await apiClient.getData(
      '${AppConstants.trackUri}$orderID${guestId != null ? '&guest_id=$guestId' : ''}'
          '${contactNumber != null ? '&contact_number=$contactNumber' : ''}',
    );
  }

  @override
  Future<Response> switchToCOD(String? orderID) async {
    Map<String, String> data = {'_method': 'put', 'order_id': orderID!};
    if(AuthHelper.isGuestLoggedIn()) {
      data.addAll({'guest_id': AuthHelper.getGuestId()});
    }
    return await apiClient.postData(AppConstants.codSwitchUri, data);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future<bool> cancelOrder(String orderID, String? reason) async {
    bool success = false;
    Map<String, String> data = {'_method': 'put', 'order_id': orderID, 'reason': reason!};
    if(AuthHelper.isGuestLoggedIn()){
      data.addAll({'guest_id': AuthHelper.getGuestId()});
    }
    Response response = await apiClient.postData(AppConstants.orderCancelUri, data);
    if (response.statusCode == 200) {
      success = true;
      showCustomSnackBar(response.body['message'], isError: false);
    }
    return success;
  }

  @override
  Future get(String? id, {String? guestId}) async {
    return await _getOrderDetails(id!, guestId);
  }

  Future<List<OrderDetailsModel>?> _getOrderDetails(String orderID, String? guestId) async {
    List<OrderDetailsModel>? orderDetails;
    Response response = await apiClient.getData('${AppConstants.orderDetailsUri}$orderID${guestId != null ? '&guest_id=$guestId' : ''}');
    if (response.statusCode == 200) {
      orderDetails = [];
      response.body.forEach((orderDetail) => orderDetails!.add(OrderDetailsModel.fromJson(orderDetail)));
    }
    return orderDetails;
  }

  @override
  Future getList({int? offset, bool isRunningOrder = false, bool isHistoryOrder = false, bool isCancelReasons = false, bool isRefundReasons = false}) async {
    if(isRunningOrder) {
      return await _getRunningOrderList(offset!);
    } else if(isHistoryOrder) {
      return await _getHistoryOrderList(offset!);
    } else if(isCancelReasons) {
      return await _getCancelReasons();
    } else if(isRefundReasons) {
      return await _getRefundReasons();
    }
  }

  Future<PaginatedOrderModel?> _getRunningOrderList(int offset) async {
    PaginatedOrderModel? runningOrderModel;
    Response response = await apiClient.getData('${AppConstants.runningOrderListUri}?offset=$offset&limit=${50}');
    if (response.statusCode == 200) {
      runningOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return runningOrderModel;
  }

  Future<PaginatedOrderModel?> _getHistoryOrderList(int offset) async {
    PaginatedOrderModel? historyOrderModel;
    Response response = await apiClient.getData('${AppConstants.historyOrderListUri}?offset=$offset&limit=10');
    if (response.statusCode == 200) {
      historyOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return historyOrderModel;
  }

  Future<List<CancellationData>?> _getCancelReasons() async {
    List<CancellationData>? orderCancelReasons;
    Response response = await apiClient.getData('${AppConstants.orderCancellationUri}?offset=1&limit=30&type=customer');
    if (response.statusCode == 200) {
      OrderCancellationBody orderCancellationBody = OrderCancellationBody.fromJson(response.body);
      orderCancelReasons = [];
      for (var element in orderCancellationBody.reasons!) {
        orderCancelReasons.add(element);
      }
    }
    return orderCancelReasons;
  }

  Future<List<String?>?> _getRefundReasons() async {
    List<String?>? refundReasons;
    Response response = await apiClient.getData(AppConstants.refundReasonUri);
    if (response.statusCode == 200) {
      RefundModel refundModel = RefundModel.fromJson(response.body);
      refundReasons = [];
      refundReasons.insert(0, 'select_an_option');
      for (var element in refundModel.refundReasons!) {
        refundReasons.add(element.reason);
      }
    }
    return refundReasons;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
  
}