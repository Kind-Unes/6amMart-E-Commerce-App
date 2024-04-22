import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderShimmerWidget extends StatelessWidget {
  final OrderController orderController;
  const OrderShimmerWidget({super.key, required this.orderController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtremeLarge : Dimensions.paddingSizeLarge,
            mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtremeLarge : 0.01,
            childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 3.7,
            crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Container(
                  decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1)],
                  ) : const BoxDecoration(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: orderController.runningOrderModel == null,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                      Row(children: [
                        Container(
                          height: ResponsiveHelper.isDesktop(context) ? 80 : 60, width: ResponsiveHelper.isDesktop(context) ? 80 : 60,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(height: 15, width: 100, color: Colors.grey[300]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Container(height: 15, width: 150, color: Colors.grey[300]),
                        ])),
                        Column(children: [
                          !ResponsiveHelper.isDesktop(context) ? Container(
                            height: 20, width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: Colors.grey[300],
                            ),
                          ) : const SizedBox(),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Container(
                            height: 20, width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: Colors.grey[300],
                            ),
                          )
                        ]),
                      ]),

                      !ResponsiveHelper.isDesktop(context) ? Divider(
                        color: Theme.of(context).disabledColor, height: Dimensions.paddingSizeLarge,
                      ) : const SizedBox(),

                    ]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
