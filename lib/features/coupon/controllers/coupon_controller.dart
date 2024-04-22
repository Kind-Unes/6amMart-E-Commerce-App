import 'package:sixam_mart/features/coupon/domain/models/coupon_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/coupon/domain/services/coupon_service_interface.dart';

class CouponController extends GetxController implements GetxService {
  final CouponServiceInterface couponServiceInterface;
  CouponController({required this.couponServiceInterface});

  List<CouponModel>? _couponList;
  List<CouponModel>? get couponList => _couponList;

  List<CouponModel>? _taxiCouponList;
  List<CouponModel>? get taxiCouponList => _taxiCouponList;

  CouponModel? _coupon;
  CouponModel? get coupon => _coupon;

  double? _discount = 0.0;
  double? get discount => _discount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _freeDelivery = false;
  bool get freeDelivery => _freeDelivery;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> getCouponList() async {
    List<CouponModel>? couponList = await couponServiceInterface.getCouponList();
    if (couponList != null) {
      _couponList = [];
      _couponList!.addAll(couponList);
    }
    update();
  }

  Future<void> getTaxiCouponList() async {
    List<CouponModel>? taxiCouponList = await couponServiceInterface.getTaxiCouponList();
    if (taxiCouponList != null) {
      _taxiCouponList = [];
      _taxiCouponList!.addAll(taxiCouponList);
    }
    update();
  }

  Future<double?> applyCoupon(String coupon, double order, double? deliveryCharge, int? storeID) async {
    _isLoading = true;
    _discount = 0;
    update();
    CouponModel? couponModel = await couponServiceInterface.applyCoupon(coupon, storeID);
    if (couponModel != null) {
      _coupon = couponModel;
      if(_coupon!.couponType == 'free_delivery') {
        _processFreeDeliveryCoupon(deliveryCharge!, order);
      }else {
        _processCoupon(order);
      }
    } else {
      _discount = 0.0;
    }
    _isLoading = false;
    update();
    return _discount;
  }

  _processFreeDeliveryCoupon(double deliveryCharge, double order) {
    if(deliveryCharge > 0) {
      if (_coupon!.minPurchase! <= order) {
        _discount = 0;
        _freeDelivery = true;
      } else {
        showCustomSnackBar('${'the_minimum_item_purchase_amount_for_this_coupon_is'.tr} '
            '${PriceConverter.convertPrice(_coupon!.minPurchase)} '
            '${'but_you_have'.tr} ${PriceConverter.convertPrice(order)}');
        _coupon = null;
        _discount = 0;
      }
    }else {
      showCustomSnackBar('invalid_code_or'.tr);
    }
  }

  _processCoupon(double order) {
    if (_coupon!.minPurchase != null && _coupon!.minPurchase! <= order) {
      if (_coupon!.discountType == 'percent') {
        if (_coupon!.maxDiscount != null && _coupon!.maxDiscount! > 0) {
          _discount = (_coupon!.discount! * order / 100) < _coupon!.maxDiscount! ? (_coupon!.discount! * order / 100) : _coupon!.maxDiscount;
        } else {
          _discount = _coupon!.discount! * order / 100;
        }
      } else {
        _discount = _coupon!.discount;
      }
    } else {
      _discount = 0.0;
      showCustomSnackBar('${'the_minimum_item_purchase_amount_for_this_coupon_is'.tr} '
          '${PriceConverter.convertPrice(_coupon!.minPurchase)} '
          '${'but_you_have'.tr} ${PriceConverter.convertPrice(order)}');
    }
  }

  Future<double?> applyTaxiCoupon(String coupon, double orderAmount, int? providerId) async {
    _isLoading = true;
    _discount = 0;
    update();
    CouponModel? taxiCouponModel = await couponServiceInterface.applyTaxiCoupon(coupon, providerId);
    if (taxiCouponModel != null) {
      _coupon = taxiCouponModel;
      if (_coupon!.minPurchase != null && _coupon!.minPurchase! < orderAmount) {
        if (_coupon!.discountType == 'percent') {
          if (_coupon!.maxDiscount != null && _coupon!.maxDiscount! > 0) {
            _discount = (_coupon!.discount! * orderAmount / 100) < _coupon!.maxDiscount! ? (_coupon!.discount! * orderAmount / 100) : _coupon!.maxDiscount;
          } else {
            _discount = _coupon!.discount! * orderAmount / 100;
          }
        } else {
          _discount = _coupon!.discount;
        }
      } else {
        _discount = 0.0;
      }
    }
    _isLoading = false;
    update();
    return _discount;
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    _freeDelivery = false;
    if(notify) {
      update();
    }
  }

}