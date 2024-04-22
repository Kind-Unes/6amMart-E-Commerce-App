import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/flash_sale/controllers/flash_sale_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/components/flash_sale_card_widget.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/flash_sale/widgets/timer_widget.dart';
import 'package:sixam_mart/features/flash_sale/widgets/flash_sale_timer_view_widget.dart';

class FlashSaleViewWidget extends StatefulWidget {
  const FlashSaleViewWidget({super.key});

  @override
  State<FlashSaleViewWidget> createState() => _FlashSaleViewWidgetState();
}

class _FlashSaleViewWidgetState extends State<FlashSaleViewWidget> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlashSaleController>(builder: (flashSaleController) {
      Item? item;
      int stock = 0;
      int remaining = 0;
      int sold = 0;
      if(flashSaleController.flashSaleModel != null && flashSaleController.flashSaleModel!.activeProducts != null) {
        int index = flashSaleController.flashSaleModel!.activeProducts!.length > 1 ? flashSaleController.pageIndex : 0;
        item = flashSaleController.flashSaleModel!.activeProducts![index].item;
        stock = flashSaleController.flashSaleModel!.activeProducts![index].stock!;
        sold = flashSaleController.flashSaleModel!.activeProducts![index].sold!;
        remaining = stock - sold;
      }
      return flashSaleController.flashSaleModel != null ? flashSaleController.flashSaleModel!.activeProducts != null && flashSaleController.duration!.inSeconds > 1 ?  Container(
        width: Get.width,
        margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Column(children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: FittedBox(
              child: CustomInkWell(
                onTap: () => Get.toNamed(RouteHelper.getFlashSaleDetailsScreen(flashSaleController.flashSaleModel!.activeProducts![0].flashSaleId!)),
                radius: Dimensions.paddingSizeSmall,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('flash_sale'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text('limited_time_offer'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                  ]),

                  FlashSaleTimerView(eventDuration: flashSaleController.duration)
                ]),
              ),
            ),
          ),

          flashSaleController.flashSaleModel!.activeProducts != null
            ? FlashSaleCard(
            activeProducts: flashSaleController.flashSaleModel!.activeProducts!,
            soldOut: remaining == 0,
          ) : const SizedBox(),

          SizedBox(
            width: Get.width * 0.7,
            child: Text("${item!.name}", style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          (Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item.unitType != null) ? Text(
            '(${ item.unitType ?? ''})',
            style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
          ) : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            item.discount != null && item.discount! > 0  ? Flexible(child: Text(
              PriceConverter.convertPrice(Get.find<ItemController>().getStartingPrice(item)),
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                decoration: TextDecoration.lineThrough,
              ), textDirection: TextDirection.ltr,
            )) : const SizedBox(),
            SizedBox(width: item.discount != null && item.discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

            Flexible(child: Text(
              PriceConverter.convertPrice(
                Get.find<ItemController>().getStartingPrice(item), discount: item.discount,
                discountType: item.discountType,
              ),
              textDirection: TextDirection.ltr, style: robotoMedium,
            )),

          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          SizedBox(
            width: Get.width * 0.7,
            child: Stack(
              children: [
                Builder(
                  builder: (context) {
                    bool bothZero = remaining == 0 && stock == 0;
                    return LinearProgressIndicator(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                      minHeight: 15,
                      value: bothZero ? 0 : remaining / stock,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.25),
                    );
                  }
                ),

                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    '${'sold'.tr} $sold/$stock',
                    style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          ],
        ),
      ) : const SizedBox() : const FlashSaleShimmerView();
    });
  }
}

class FlashSaleShimmerView extends StatelessWidget {
  const FlashSaleShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width, height: ResponsiveHelper.isDesktop(context) ? 330 : 350,
      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Column(children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('flash_sale'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                ResponsiveHelper.isDesktop(context) ? const SizedBox() : Text('limited_time_offer'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
              ],
              ),
              const Spacer(),

              Row(children: [

                TimerWidget(
                  timeCount: 00,
                  timeUnit: 'days'.tr,
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                TimerWidget(
                  timeCount: 00,
                  timeUnit: 'hours'.tr,
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                TimerWidget(
                  timeCount: 00,
                  timeUnit: 'mins'.tr,
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                TimerWidget(
                  timeCount: 00,
                  timeUnit: 'sec'.tr,
                ),

              ])
            ]),
          ),

          Container(
            height: ResponsiveHelper.isDesktop(context) ? 150 : 170, width: Get.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Container(
            height: 10, width: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Container(
            height: 10, width: 200,
            color: Colors.grey[300],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Container(
            height: 10, width: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
        ),
      ),
    );
  }
}

