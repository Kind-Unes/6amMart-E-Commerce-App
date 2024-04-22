import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/flash_sale/domain/models/product_flash_sale.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/add_favourite_view.dart';
import 'package:sixam_mart/common/widgets/cart_count_view.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/organic_tag.dart';

class FlashProductCardWidget extends StatelessWidget {
  final Products product;
  const FlashProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double? discount = product.item!.storeDiscount == 0 ? product.item!.discount : product.item!.storeDiscount;
    String? discountType = product.item!.storeDiscount == 0 ? product.item!.discountType : 'percent';

    int stock = product.stock!;
    int sold = product.sold!;
    int remaining = stock - sold;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 0))],
      ),
      child: CustomInkWell(
        onTap: remaining == 0 ? null : () => Get.find<ItemController>().navigateToItemPage(product.item, context),
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        radius: Dimensions.radiusDefault,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: ResponsiveHelper.isDesktop(context) ? 5 : 1,
            child: Stack(clipBehavior: Clip.none, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: CustomImage(
                  image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl!}/${product.item!.image}',
                  fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                ),
              ),

              DiscountTag(
                discount: discount,
                discountType: discountType,
                freeDelivery: false,
                isFloating: true,
              ),

              OrganicTag(item: product.item!, placeInImage: false),

              AddFavouriteView(
                top: 5, right: 5,
                item: product.item!,
              ),

              ResponsiveHelper.isDesktop(context) ? Positioned(
                bottom: -15, left: 0, right: 0,
                child: remaining == 0 ? Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 80, height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(112),
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
                    ),
                    child: Text('sold_out'.tr, style: robotoMedium.copyWith(color: Colors.red)),
                  ),
                ) : CartCountView(
                  item: product.item!,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 65, height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(112),
                        color: Theme.of(context).cardColor,
                        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
                      ),
                      child: Text("add".tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
              ) : const SizedBox(),
            ]),
          ),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : 0),

          Expanded(
            flex: ResponsiveHelper.isDesktop(context) ? 4 : 1,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.item!.name ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: robotoMedium),

                  (Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && product.item!.unitType != null) ? Text(
                    '(${ product.item!.unitType ?? ''})',
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                  ) : const SizedBox(),

                  Wrap(children: [

                    product.item!.discount != null && product.item!.discount! > 0  ? Text(
                      PriceConverter.convertPrice(Get.find<ItemController>().getStartingPrice(product.item!)),
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                        decoration: TextDecoration.lineThrough,
                      ), textDirection: TextDirection.ltr,
                    ) : const SizedBox(),
                    SizedBox(width: product.item!.discount != null && product.item!.discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                    Text(
                      PriceConverter.convertPrice(
                        Get.find<ItemController>().getStartingPrice(product.item!), discount: product.item!.discount,
                        discountType: product.item!.discountType,
                      ),
                      textDirection: TextDirection.ltr, style: robotoMedium,
                    ),

                  ]),

                  ResponsiveHelper.isMobile(context) ? const SizedBox() : Row(children: [
                    Text('${'available'.tr} : ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                    Text('$remaining ${'item'.tr}', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
                  ]),

                  Stack(
                    children: [
                      SizedBox(
                        width: Get.width,
                        child: LinearProgressIndicator(
                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          minHeight: ResponsiveHelper.isDesktop(context) ? 3 : 12,
                          value: remaining / stock,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.25),
                        ),
                      ),

                      !ResponsiveHelper.isDesktop(context) ? Positioned(
                        top: -1.5, left: 0, right: 0, bottom: 0,
                        child: Text(
                          '${'sold'.tr} $sold/$stock',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).cardColor),
                          textAlign: TextAlign.center,
                        ),
                      ) : const SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}