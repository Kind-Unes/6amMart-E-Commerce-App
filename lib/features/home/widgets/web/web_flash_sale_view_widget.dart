import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/flash_sale/controllers/flash_sale_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/components/flash_sale_card_widget.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/flash_sale/widgets/flash_sale_timer_view_widget.dart';

class WebFlashSaleViewWidget extends StatefulWidget {
  const WebFlashSaleViewWidget({super.key});

  @override
  State<WebFlashSaleViewWidget> createState() => _WebFlashSaleViewWidgetState();
}

class _WebFlashSaleViewWidgetState extends State<WebFlashSaleViewWidget> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlashSaleController>(builder: (flashSaleController) {
      Item? item;
      int stock = 0;
      int remaining = 0;
      if(flashSaleController.flashSaleModel != null && flashSaleController.flashSaleModel!.activeProducts != null) {
        item = flashSaleController.flashSaleModel!.activeProducts![flashSaleController.pageIndex].item;
        stock = flashSaleController.flashSaleModel!.activeProducts![flashSaleController.pageIndex].stock!;
        int sold = flashSaleController.flashSaleModel!.activeProducts![flashSaleController.pageIndex].sold!;
        if(stock >= sold) {
          remaining = stock - sold;
        }
      }

      return flashSaleController.flashSaleModel != null ? flashSaleController.flashSaleModel!.activeProducts != null ? Container(
        width: Get.width,
        margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 2),
        ),
        child: Column(children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              InkWell(
                onTap: () => Get.toNamed(RouteHelper.getFlashSaleDetailsScreen(0)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('flash_sale'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                ]),
              ),
              const Spacer(),

              FlashSaleTimerView(eventDuration: flashSaleController.duration),
            ]),
          ),

          flashSaleController.flashSaleModel!.activeProducts != null ? FlashSaleCard(
            activeProducts: flashSaleController.flashSaleModel!.activeProducts!, soldOut: remaining == 0,
          ) : const SizedBox(),

          Text("${item!.name}", style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis,),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          /*(Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item.unitType != null) ? Text(
            '(${ item.unitType ?? ''})',
            style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
          ) : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),*/

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

          /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtremeLarge),
            child: LinearProgressIndicator(
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
              minHeight: 5,
              value: remaining / stock,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.25),
            ),
          ),*/

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('${'available'.tr} : ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
            Text('$remaining ${'item'.tr}', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ]),
      ) : const SizedBox() : const WebFlashSaleShimmerView();
    });
  }
}

class WebFlashSaleShimmerView extends StatelessWidget {
  const WebFlashSaleShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Container(
        margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        width: Get.width, height: 302,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
      ),
    );
  }
}
