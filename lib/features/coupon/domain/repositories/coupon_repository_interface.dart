import 'package:sixam_mart/interfaces/repository_interface.dart';

abstract class CouponRepositoryInterface extends RepositoryInterface{
  @override
  Future getList({int? offset, bool couponList = false, bool taxiCouponList = false});
  Future<dynamic> applyCoupon(String couponCode, int? storeID);
  Future<dynamic> applyTaxiCoupon(String couponCode, int? providerId);
}