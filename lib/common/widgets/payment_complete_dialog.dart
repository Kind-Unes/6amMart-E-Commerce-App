import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PaymentCompleteDialog extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  final String shortDescription;
  final Function onYesPressed;
  final bool isLogOut;
  final Function? onNoPressed;
  const PaymentCompleteDialog({super.key, required this.icon, this.title,
    required this.description,
    required this.shortDescription,
    required this.onYesPressed,
    this.isLogOut = false, this.onNoPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(width: 500, child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Image.asset(icon, width: 50, height: 50, ),
            ),

            title != null ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Text(
                title!, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
              ),
            ) : const SizedBox(),

            const SizedBox(height: Dimensions.paddingSizeDefault,),
            Text(description, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Text(shortDescription, style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).primaryColor,
            ),
                textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            GetBuilder<OrderController>(builder: (orderController) {
              return !orderController.isLoading ? CustomButton(
                buttonText: isLogOut ? 'no'.tr : 'ok'.tr,
                onPressed: () => isLogOut ? Get.back() : onYesPressed(),
                radius: Dimensions.radiusSmall, height: 50,
                width: 90,
              ) : const Center(child: CircularProgressIndicator());
            }),

          ]),
        )),
      ),
    );
  }
}
