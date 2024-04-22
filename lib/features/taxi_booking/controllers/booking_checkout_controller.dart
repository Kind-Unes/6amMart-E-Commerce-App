import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/api/api_checker.dart';
import 'package:sixam_mart/features/profile/domain/models/user_information_body.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/features/taxi_booking/repo/rider_repo.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

enum PageState {orderDetails, payment, complete}

enum PaymentMethodName  {digitalPayment, cod}

class BookingCheckoutController extends GetxController implements GetxService{
  final RiderRepo riderRepo;
  BookingCheckoutController({required this.riderRepo});

  PageState currentPage = PageState.orderDetails;
  bool _isLoading = false;
  var selectedPaymentMethod = PaymentMethodName.cod;
  bool showCoupon = false;
  bool cancelPayment = false;

  bool _showCouponSection = false;
  double? _couponDiscount = 0;
  int _paymentMethodIndex = 0;
  int? _tripId;

  bool get showCouponSection => _showCouponSection;
  bool get isLoading => _isLoading;
  double? get couponDiscount => _couponDiscount;
  int get paymentMethodIndex => _paymentMethodIndex;
  int? get tripId => _tripId;

  void setPaymentMethod(int index, {bool isUpdate = true}) {
    _paymentMethodIndex = index;
    if(isUpdate){
      update();
    }
  }

  void showHideCoupon(){
    _showCouponSection = !_showCouponSection;
    update();
  }

  void setCouponDiscount(double? discount){
    _couponDiscount = discount;
    update();
  }

  void cancelPaymentOption(){
    cancelPayment = true;
    update();
  }

  void updateState(PageState currentPage,{bool shouldUpdate = true}){
    if (kDebugMode) {
      print('--------------$currentPage');
    }
    currentPage=currentPage;
    if(shouldUpdate){
      update();
    }
  }

  void updateDigitalPaymentOption(PaymentMethodName paymentMethodName,{bool shouldUpdate = true}){
    selectedPaymentMethod = paymentMethodName;
    if(shouldUpdate){
      update();
    }
  }


  Future<bool> placeTrip({required UserInformationBody filterBody, required Vehicles vehicle}) async {
    _tripId = null;
    bool success = false;
    _isLoading = true;
    update();
    Map<String, String?> body = {
      'start_latitude': filterBody.from!.latitude,
      'start_longitude': filterBody.from!.longitude,
      'end_latitude': filterBody.to!.latitude,
      'end_longitude': filterBody.to!.longitude,
      'fare_category': filterBody.fareCategory,
      'schedule_at': filterBody.rentTime,
      'distance': filterBody.distance.toString(),
      'filter_type': filterBody.filterType,
      'payment_method': _paymentMethodIndex == 0 ? 'cash_on_delivery' : _paymentMethodIndex == 1 ? 'digital_payment' : 'wallet',
      'vehicle_id': vehicle.id.toString(),
      'provider_id': vehicle.providerId.toString(),
    };

    Response response = await riderRepo.placeTrip(body);
    _isLoading = false;
    if (response.statusCode == 200) {
      success = true;
      showCustomSnackBar(response.body['message'], isError: false);
      _tripId = response.body['trip_id'];
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    return success;
  }


}