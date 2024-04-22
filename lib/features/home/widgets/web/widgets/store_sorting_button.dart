import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StoreSortingButton extends StatelessWidget {
  final String storeType;
  final String storeTypeText;
  const StoreSortingButton({super.key, required this.storeType, required this.storeTypeText});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: storeController.storeType == storeType ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: storeController.storeType == storeType ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
        ),
        child: Row(children: [
          Icon(storeController.storeType == storeType ? Icons.check_circle : Icons.circle_outlined, color: storeController.storeType == storeType ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 16),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(storeTypeText, style: robotoMedium.copyWith(color: storeController.storeType == storeType ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)),
        ]),
      );
    }
    );
  }
}