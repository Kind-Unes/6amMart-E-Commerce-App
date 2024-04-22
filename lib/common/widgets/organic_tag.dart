import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
class OrganicTag extends StatelessWidget {
  final double? fontSize;
  final Item item;
  final bool placeTop;
  final bool placeInImage;
  final bool fromDetails;
  const OrganicTag({super.key, this.fontSize, required this.item, this.placeTop = false, this.placeInImage = false, this.fromDetails = false});

  @override
  Widget build(BuildContext context) {
    return fromDetails ? item.organic == 1 && item.moduleType == 'grocery' ? Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
      margin: EdgeInsets.only(bottom: fromDetails ? Dimensions.paddingSizeSmall : 0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Text(
        'organic'.tr,
        style: robotoMedium.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: fontSize ?? (ResponsiveHelper.isMobile(context) ? 10 : 12),
        ),
        textAlign: TextAlign.center,
      ),
    ) : const SizedBox() : Positioned(
      top: placeInImage ? null : placeTop ? 10 : 40, left: placeInImage ? 0 : 10, right: placeInImage ? 0 : null, bottom: placeInImage ? 0 : null,
      child: item.organic == 1 && item.moduleType == 'grocery' ? Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
        margin: EdgeInsets.only(bottom: fromDetails ? Dimensions.paddingSizeSmall : 0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: fromDetails ? BorderRadius.circular(Dimensions.radiusSmall) : placeInImage ? const BorderRadius.vertical(
            bottom: Radius.circular(Dimensions.radiusDefault),
          ) : BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Text(
          'organic'.tr,
          style: robotoMedium.copyWith(
            color: Colors.white,
            fontSize: fontSize ?? (ResponsiveHelper.isMobile(context) ? 10 : 12),
          ),
          textAlign: TextAlign.center,
        ),
      ) : const SizedBox(),
    );
  }
}
