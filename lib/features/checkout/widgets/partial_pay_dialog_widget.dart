import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';

class PartialPayDialogWidget extends StatelessWidget {
  final bool isPartialPay;
  final double totalPrice;
  const PartialPayDialogWidget({super.key, required this.isPartialPay, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Align(alignment: Alignment.topRight, child: InkWell(
            onTap: ()=> Get.back(),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.clear, size: 24),
            ),
          )),

          Image.asset(Images.note, width: 35, height: 35),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            'note'.tr, textAlign: TextAlign.center,
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Text(
              isPartialPay ? 'you_do_not_have_sufficient_balance_to_pay_full_amount_via_wallet'.tr
                  : 'you_can_pay_the_full_amount_with_your_wallet'.tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,
            ),
          ),

          Text(
            isPartialPay ? 'want_to_pay_partially_with_wallet'.tr : 'want_to_pay_via_wallet'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor), textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Image.asset(Images.partialWallet, height: 35, width: 35),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            PriceConverter.convertPrice(Get.find<ProfileController>().userInfoModel!.walletBalance!),
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).primaryColor),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Text(
              isPartialPay ? 'can_be_paid_via_wallet'.tr
                  : '${'remaining_wallet_balance'.tr}: ${PriceConverter.convertPrice(Get.find<ProfileController>().userInfoModel!.walletBalance! - totalPrice)}',
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Row(children: [
              Expanded(child: CustomButton(buttonText: 'no'.tr, color: Theme.of(context).disabledColor,
                onPressed: (){
                Get.find<CheckoutController>().setPaymentMethod(-1);
                if(Get.find<CheckoutController>().isPartialPay){
                  Get.find<CheckoutController>().changePartialPayment();
                }
                Get.back();
                },
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: CustomButton(buttonText: 'yes_pay'.tr, onPressed: (){
                if(isPartialPay){
                  if(!Get.find<CheckoutController>().isPartialPay){
                    Get.find<CheckoutController>().changePartialPayment();
                  }
                }else{
                  Get.find<CheckoutController>().setPaymentMethod(1);
                }
                Get.back();
              })),
            ]),
          ),
        ]),
      ),
    );
  }
}
