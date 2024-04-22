import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/coupon/controllers/coupon_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/no_data_screen.dart';
import 'package:sixam_mart/common/widgets/not_logged_in_screen.dart';
class TaxiCouponScreen extends StatefulWidget {
  const TaxiCouponScreen({super.key});

  @override
  State<TaxiCouponScreen> createState() => _TaxiCouponScreenState();
}

class _TaxiCouponScreenState extends State<TaxiCouponScreen> {
  bool _isLoggedIn = AuthHelper.isLoggedIn();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  initCall(){
    if(_isLoggedIn) {
      Get.find<CouponController>().getTaxiCouponList();
    }
  }
  @override
  Widget build(BuildContext context) {
    _isLoggedIn = AuthHelper.isLoggedIn();
    return Scaffold(
      appBar: CustomAppBar(title: 'taxi_coupon'.tr),
      endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
      body: _isLoggedIn ? GetBuilder<CouponController>(builder: (couponController) {
        return couponController.taxiCouponList != null ? couponController.taxiCouponList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await couponController.getTaxiCouponList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(child: FooterView(
              child: SizedBox(width: Dimensions.webMaxWidth, child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                  mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall,
                  childAspectRatio: ResponsiveHelper.isMobile(context) ? 2.6 : 2.4,
                ),
                itemCount: couponController.taxiCouponList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: couponController.taxiCouponList![index].code!));
                      showCustomSnackBar('coupon_code_copied'.tr, isError: false);
                    },
                    child: Stack(children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: Transform.rotate(
                          angle: Get.find<LocalizationController>().isLtr ? 0 : pi,
                          child: Image.asset(
                            Images.couponBgLight,
                            height: ResponsiveHelper.isMobilePhone() ? 130 : 140, width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).primaryColor, fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Container(
                        height: ResponsiveHelper.isMobilePhone() ? 125 : 140,
                        alignment: Alignment.center,
                        child: Row(children: [

                          const SizedBox(width: 30),
                          Image.asset(Images.coupon, height: 50, width: 50, color: Theme.of(context).cardColor),

                          const SizedBox(width: 40),

                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                              Text(
                                '${couponController.taxiCouponList![index].code} (${couponController.taxiCouponList![index].title})',
                                style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text(
                                '${couponController.taxiCouponList![index].discount}${couponController.taxiCouponList![index].discountType == 'percent' ? '%'
                                    : Get.find<SplashController>().configModel!.currencySymbol} off',
                                style: robotoMedium.copyWith(color: Theme.of(context).cardColor),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Row(children: [
                                Text(
                                  '${'valid_until'.tr}:',
                                  style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  couponController.taxiCouponList![index].expireDate!,
                                  style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ]),

                              Row(children: [
                                Text(
                                  '${'type'.tr}:',
                                  style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Flexible(child: Text(
                                  '${couponController.taxiCouponList![index].couponType!.tr}${couponController.taxiCouponList![index].couponType
                                      == 'store_wise' ? ' (${couponController.taxiCouponList![index].data})' : ''}',
                                  style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                )),
                              ]),

                              Row(children: [
                                Text(
                                  '${'min_purchase'.tr}:',
                                  style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  PriceConverter.convertPrice(couponController.taxiCouponList![index].minPurchase),
                                  style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ]),

                              Row(children: [
                                Text(
                                  '${'max_discount'.tr}:',
                                  style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  PriceConverter.convertPrice(couponController.taxiCouponList![index].maxDiscount),
                                  style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ]),

                            ]),
                          ),

                        ]),
                      ),

                    ]),
                  );
                },
              )),
            )),
          ),
        ) : NoDataScreen(text: 'no_coupon_found'.tr, showFooter: true) : const Center(child: CircularProgressIndicator());
      }) : NotLoggedInScreen(callBack: (value){
        initCall();
        setState(() {});
      }),
    );
  }
}
