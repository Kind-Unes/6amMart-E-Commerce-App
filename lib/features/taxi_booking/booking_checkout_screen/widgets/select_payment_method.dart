import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/booking_checkout_controller.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/taxi_booking/booking_checkout_screen/widgets/taxi_payment_button.dart';

class SelectPaymentMethod extends StatelessWidget {
  const SelectPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingCheckoutController>(
      builder: (bookingCheckoutController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const SizedBox(height: Dimensions.paddingSizeDefault,),


              Image.asset(Images.digitalPay, scale: 2),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //
              //     Text.rich(
              //       TextSpan(
              //         children: [
              //           TextSpan(text: 'you_have_to_pay_minimum'.tr),
              //           TextSpan(text: " ${'booking_fee'.tr}",style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
              //         ],
              //       ),
              //     ),
              //     SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
              //     Text(
              //       '\$10',
              //       style: robotoBold.copyWith(
              //         fontSize: Dimensions.fontSizeExtraLarge,
              //         color: Theme.of(context).primaryColor),
              //     ),
              //     SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),
              //   ],
              // ),

              TaxiPaymentButton(
                icon: Images.cashOnDelivery,
                title: 'cash_on_delivery'.tr,
                subtitle: 'pay_your_payment_after_getting_item'.tr,
                isSelected: bookingCheckoutController.paymentMethodIndex == 0,
                onTap: () => bookingCheckoutController.setPaymentMethod(0),
              ),

              TaxiPaymentButton(
                icon: Images.digitalPayment,
                title: 'digital_payment'.tr,
                subtitle: 'faster_and_safe_way'.tr,
                isSelected: bookingCheckoutController.paymentMethodIndex == 1,
                onTap: () => bookingCheckoutController.setPaymentMethod(1),
              ),

              TaxiPaymentButton(
                icon: Images.wallet,
                title: 'wallet_payment'.tr,
                subtitle: 'pay_from_your_existing_balance'.tr,
                isSelected: bookingCheckoutController.paymentMethodIndex == 2,
                onTap: () => bookingCheckoutController.setPaymentMethod(2),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

            ],
          ),
        );
      }
    );
  }

  Widget taxiPaymentWidget(BuildContext context, {String? icon, String? title, String? subTitle}){
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(Images.paypal,width: 15,height: 18.30),
                const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('paypal'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text('faster_and_safer_way_to_send_money'.tr,style: robotoRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.4),
                        fontSize: Dimensions.fontSizeDefault),),
                  ],
                ),
              ],
            ),

            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            )

          ],
        ),
      ),
    );
  }

  Widget billDetailsItem(String billName,String price,{bool isPrimary = false}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          billName,
          style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color:isPrimary ?Theme.of(Get.context!).primaryColor:Theme.of(Get.context!).textTheme.bodyLarge!.color),
        ),
        Text(
          '\$ $price',
          style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color:isPrimary ?Theme.of(Get.context!).primaryColor:Theme.of(Get.context!).textTheme.bodyLarge!.color),
        ),
      ],
    );
  }
}
