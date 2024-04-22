import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';

class AddressConfirmDialogue extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  final Function onYesPressed;
  const AddressConfirmDialogue({super.key, required this.icon, this.title, required this.description, required this.onYesPressed});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              ResponsiveHelper.isDesktop(context) ? Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.clear),
                ),
              ) : const SizedBox(),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Image.asset(icon, width: isDesktop ? 90 : 50, height: isDesktop ? 90 : 50),
              ),

              title != null ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  title!, textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: isDesktop ? Theme.of(context).textTheme.titleSmall!.color :Colors.red),
                ),
              ) : const SizedBox(),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Text(description, style: isDesktop ? robotoRegular.copyWith(fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeLarge, color: Theme.of(context).hintColor) :
                       robotoMedium.copyWith(fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeLarge, color: Theme.of(context).hintColor), textAlign: TextAlign.center),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              GetBuilder<LocationController>(builder: (locationController) {
                return !locationController.isLoading ? Row( children: [
                  SizedBox(width: isDesktop ? Dimensions.paddingSizeExtremeLarge : 0),
                  Expanded(child: TextButton(
                    onPressed: () => onYesPressed(),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error, minimumSize: const Size(Dimensions.webMaxWidth, 50), padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                      //fixedSize: Size(115, 45),
                    ),
                    child: Text(
                      'delete'.tr, textAlign: TextAlign.center,
                      style: robotoBold.copyWith(color: Theme.of(context).cardColor),
                    ),
                  )),
                  SizedBox(width: isDesktop ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeLarge),

                  Expanded(child: CustomButton(
                    buttonText:  'cancel'.tr, textColor: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                    onPressed: () => Get.back(),
                    radius: Dimensions.radiusSmall, height: 50, color: Theme.of(context).disabledColor.withOpacity(0.4),
                  )),
                  SizedBox(width: isDesktop ? Dimensions.paddingSizeExtremeLarge : 0),
                ]) : const Center(child: CircularProgressIndicator());
              }),

              SizedBox(height: isDesktop ? Dimensions.paddingSizeExtremeLarge : 0),

            ]),
          ),
        ),
      ),
    );
  }
}
