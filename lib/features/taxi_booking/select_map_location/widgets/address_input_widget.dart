import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class AddressInputWidget extends StatelessWidget {
  final String? logo;
  final String? title;
  final Function? onTap;
  final String? address;
  const AddressInputWidget({super.key, this.logo, this.title, this.onTap, this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Row(children: [

        const SizedBox(width: Dimensions.paddingSizeSmall),

        logo != null ? Image.asset(logo!, height: 16, width: 16)
            : Icon(Icons.location_on_rounded, size: 16, color: Theme.of(context).primaryColor),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        SizedBox(
          width: 50,
          child: Text(title!, style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          ),
        ),

        Expanded(
          child: InkWell(
            onTap: onTap as void Function()?,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                // boxShadow: [BoxShadow(color: Col ors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: Text(
                    address!.isNotEmpty ? address! : 'enter_destination'.tr, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                      color: address!.isNotEmpty ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).hintColor,
                    ),
                  ),
                ),

                const Icon(Icons.clear, size: 12),
              ]),
            ),
          ),
        ),

      ]),
    );
  }
}
