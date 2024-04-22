import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/rating_bar.dart';
import 'package:flutter/material.dart';

class ItemShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isStore;
  final bool hasDivider;
  const ItemShimmer({super.key, required this.isEnabled, required this.hasDivider, this.isStore = false});

  @override
  Widget build(BuildContext context) {
    bool desktop = ResponsiveHelper.isDesktop(context);

    return Container(
      padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
        boxShadow: ResponsiveHelper.isDesktop(context) ? [const BoxShadow(
          color: Colors.black12, spreadRadius: 1, blurRadius: 5,
        )] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
              child: Row(children: [

                Container(
                  height: desktop ? 120 : 65, width: desktop ? 120 : 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                    Container(height: desktop ? 20 : 10, width: double.maxFinite, color: Colors.grey[300]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Container(
                      height: desktop ? 15 : 10, width: double.maxFinite, color: Colors.grey[300],
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                    ),
                    SizedBox(height: isStore ? Dimensions.paddingSizeSmall : 0),

                    !isStore ? RatingBar(rating: 0, size: desktop ? 15 : 12, ratingCount: 0) : const SizedBox(),
                    isStore ? RatingBar(
                      rating: 0, size: desktop ? 15 : 12,
                      ratingCount: 0,
                    ) : Row(children: [
                      Container(height: desktop ? 20 : 15, width: 30, color: Colors.grey[300]),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Container(height: desktop ? 15 : 10, width: 20, color: Colors.grey[300]),
                    ]),

                  ]),
                ),

                Column(mainAxisAlignment: isStore ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [
                  const SizedBox(),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                    child: Icon(
                      Icons.favorite_border,  size: desktop ? 30 : 25,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ]),

              ]),
            ),
          ),
          desktop ? const SizedBox() : Padding(
            padding: EdgeInsets.only(left: desktop ? 130 : 90),
            child: Divider(color: hasDivider ? Theme.of(context).disabledColor : Colors.transparent),
          ),
        ],
      ),
    );
  }
}
