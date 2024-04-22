import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class BottomSheetViewWidget extends StatelessWidget {
  const BottomSheetViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius : const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
          topRight : Radius.circular(Dimensions.paddingSizeExtraLarge),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.3),
          borderRadius : ResponsiveHelper.isDesktop(context) ? BorderRadius.circular(Dimensions.radiusSmall)
              : const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
            topRight : Radius.circular(Dimensions.paddingSizeExtraLarge),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          ResponsiveHelper.isDesktop(context) ? const SizedBox() : Center(
            child: Container(
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              height: 3, width: 40,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault),
            child: Row(children: [
              const Icon(Icons.error_outline, size: 16),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text('how_it_works'.tr , style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center),
            ]),
          ),

          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppConstants.dataList.length,
              itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(5) ,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.grey[400]!, blurRadius: 5)]
                  ),
                  child: Text('${index+1}'),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Text(AppConstants.dataList[index].tr, style: robotoRegular),

              ]),
            );
          })
        ]),
      ),
    );
  }
}
