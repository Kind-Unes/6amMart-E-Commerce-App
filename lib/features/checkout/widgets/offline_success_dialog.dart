import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';

class OfflineSuccessDialog extends StatelessWidget {
  final int? orderId;
  const OfflineSuccessDialog({super.key, required this.orderId, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 500,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          ),
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtremeLarge),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
          child: SingleChildScrollView(
            child: Column(children: [
              Icon(Icons.check_circle, size: 60, color: Theme.of(context).primaryColor),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                'order_placed_successfully'.tr ,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              RichText(textAlign: TextAlign.center, text: TextSpan(children: [
                TextSpan(text: 'your_payment_has_been_successfully_processed_and_your_order'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4))),
                TextSpan(text: ' #$orderId ', style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                TextSpan(text: 'has_been_placed'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4))),
              ])),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              GetBuilder<OrderController>(
                builder: (orderController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5)),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: orderController.trackModel != null ? ListView.builder(
                      itemCount: orderController.trackModel!.offlinePayment!.input!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index){
                        Input data = orderController.trackModel!.offlinePayment!.input![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Row(children: [
                          Text('${data.userInput.toString().replaceAll('_', ' ')}: ', style: robotoMedium),
                          Text(data.userData.toString(), style: robotoMedium),
                        ]),
                      );
                    }) : const SizedBox(),
                  );
                }
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              RichText(textAlign: TextAlign.center, text: TextSpan(children: [
                TextSpan(text: '*', style: robotoMedium.copyWith(color: Colors.red)),
                TextSpan(text: 'offline_order_note'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
              ])),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              CustomButton(
                width: 100,
                buttonText: 'ok'.tr,
                onPressed: () {
                  Get.back();
                },
              )

            ]),
          ),
        ),
      ),
    );
  }
}
