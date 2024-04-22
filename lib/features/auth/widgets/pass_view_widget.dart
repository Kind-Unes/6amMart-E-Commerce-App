import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:sixam_mart/features/auth/controllers/store_registration_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
class PassViewWidget extends StatelessWidget {
  final bool forStoreRegistration;
  const PassViewWidget({super.key, this.forStoreRegistration = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreRegistrationController>(
      builder: (storeRegController) {
        return GetBuilder<DeliverymanRegistrationController>(
          builder: (deliveryRegController) {
            return Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Wrap(children: [

                view('8_or_more_character'.tr, forStoreRegistration ? storeRegController.lengthCheck : deliveryRegController.lengthCheck),

                view('1_number'.tr, forStoreRegistration ? storeRegController.numberCheck : deliveryRegController.numberCheck),

                view('1_upper_case'.tr, forStoreRegistration ? storeRegController.uppercaseCheck : deliveryRegController.uppercaseCheck),

                view('1_lower_case'.tr, forStoreRegistration ? storeRegController.lowercaseCheck : deliveryRegController.lowercaseCheck),

                view('1_special_character'.tr, forStoreRegistration ? storeRegController.spatialCheck : deliveryRegController.spatialCheck),

              ]),
            );
          }
        );
      }
    );
  }

  Widget view(String title, bool done){
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(done ? Icons.check : Icons.clear, color: done ? Colors.green : Colors.red, size: 12),
        Text(title, style: robotoRegular.copyWith(color: done ? Colors.green : Colors.red, fontSize: 12))
      ]),
    );
  }
}
