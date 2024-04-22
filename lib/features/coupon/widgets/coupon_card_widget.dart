import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/features/coupon/domain/models/coupon_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class CouponCardWidget extends StatelessWidget {
  final CouponModel coupon;
  final int index;
  const CouponCardWidget({super.key, required this.coupon, required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [

      ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: Transform.rotate(
          angle: Get.find<LocalizationController>().isLtr ? 0 : pi,
          child: Image.asset(
            Get.find<ThemeController>().darkTheme ? Images.couponBgDark : Images.couponBgLight,
            height: ResponsiveHelper.isMobilePhone() ? 120 : 140, width: size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),

      Container(
        height: ResponsiveHelper.isMobilePhone() ? 110 : 140,
        alignment: Alignment.center,
        child: Row(children: [

          SizedBox(
            width: ResponsiveHelper.isDesktop(context) ? 150 : size.width * 0.3,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                coupon.discountType == 'percent' ? Images.percentCouponOffer : coupon.couponType
                    == 'free_delivery' ? Images.freeDelivery : Images.money,
                height: 25, width: 25,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                '${coupon.discount}${coupon.discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol} ${'off'.tr}',
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              coupon.store == null ?  Flexible(child: Text(
                coupon.couponType == 'store_wise' ? '${'on'.tr} ${coupon.data}' : 'on_all_store'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              )) : Flexible(child: Text(
                coupon.couponType == 'default' ? '${coupon.store!.name}' : '',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              )),
            ]),
          ),

          const SizedBox(width: 40),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

              Text(
                '${coupon.title}',
                style: robotoRegular, textDirection: TextDirection.ltr,
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                '${DateConverter.stringToReadableString(coupon.startDate!)} ${'to'.tr} ${DateConverter.stringToReadableString(coupon.expireDate!)}',
                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),

              Row(children: [
                Text(
                  '*${'min_purchase'.tr} ',
                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  PriceConverter.convertPrice(coupon.minPurchase),
                  style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall),
                  maxLines: 1, overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,
                ),
              ]),
            ]),
          ),
        ]),
      ),


      ResponsiveHelper.isDesktop(context) ? Positioned(
        top: Dimensions.paddingSizeSmall,
        right: Dimensions.paddingSizeSmall,
        child: JustTheTooltip(
          backgroundColor: Theme.of(context).cardColor,
          controller: coupon.toolTip,
          preferredDirection: AxisDirection.up,
          tailLength: 14,
          tailBaseWidth: 20,
          triggerMode: TooltipTriggerMode.manual,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('code_copied'.tr,style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
          ),
          child: InkWell(
            onTap: () async {
              coupon.toolTip?.showTooltip();
              Clipboard.setData(ClipboardData(text: coupon.code!));

              Future.delayed(const Duration(milliseconds: 750), () {
                coupon.toolTip?.hideTooltip();
              });
            },
            child: Image.asset(Images.copyCoupon, height: 20, width: 20),
          ),
        ),
      ) : const SizedBox(),

    ]);
  }
}
