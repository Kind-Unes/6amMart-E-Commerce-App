import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class UseCouponSection extends StatelessWidget {
  const UseCouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200]!, blurRadius: 5, spreadRadius: 1)]
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
      child: InkWell(
        onTap: () => Get.toNamed(RouteHelper.getTaxiCouponScreen()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 33, width: 33, alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                  color: Theme.of(context).primaryColor.withOpacity(0.1), shape: BoxShape.rectangle),
              child: Image.asset(
                Images.riderCoupon,
                height: 30, width: 30,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('use_coupon_when_select_your_car'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),),
                Text('collect_coupon_by_inviting_people'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),),
              ],
            ),
            Image.asset(Images.riderUseCoupon),
          ],
        ),
      ),
    );
  }
}
