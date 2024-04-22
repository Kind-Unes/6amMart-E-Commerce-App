import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/common/models/config_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/not_available_widget.dart';
import 'package:sixam_mart/common/widgets/organic_tag.dart';
import 'package:sixam_mart/common/widgets/rating_bar.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebItemWidget extends StatelessWidget {
  final Item? item;
  final Store? store;
  final bool isStore;
  final int index;
  final int? length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  final bool fromCartSuggestion;
  const WebItemWidget({super.key, required this.item, required this.isStore, required this.store, required this.index,
    required this.length, this.inStore = false, this.isCampaign = false, this.isFeatured = false, this.fromCartSuggestion = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    if(isStore) {
      discount = store!.discount != null ? store!.discount!.discount : 0;
      discountType = store!.discount != null ? store!.discount!.discountType : 'percent';
      isAvailable = store!.open == 1 && store!.active!;
    }else {
      discount = (item!.storeDiscount == 0 || isCampaign) ? item!.discount : item!.storeDiscount;
      discountType = (item!.storeDiscount == 0 || isCampaign) ? item!.discountType : 'percent';
      isAvailable = DateConverter.isAvailable(item!.availableTimeStarts, item!.availableTimeEnds);
    }

    return InkWell(
      onTap: () {
        if(isStore) {
          if(store != null) {
            if(isFeatured && Get.find<SplashController>().moduleList != null) {
              for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                if(module.id == store!.moduleId) {
                  Get.find<SplashController>().setModule(module);
                  break;
                }
              }
            }
            Get.toNamed(
              RouteHelper.getStoreRoute(id: store!.id, page: isFeatured ? 'module' : 'item'),
              arguments: StoreScreen(store: store, fromModule: isFeatured),
            );
          }
        }else {
          if(isFeatured && Get.find<SplashController>().moduleList != null) {
            for(ModuleModel module in Get.find<SplashController>().moduleList!) {
              if(module.id == item!.moduleId) {
                Get.find<SplashController>().setModule(module);
                break;
              }
            }
          }
          Get.find<ItemController>().navigateToItemPage(item, context, inStore: inStore, isCampaign: isCampaign);
        }
      },
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      child: OnHover(
        isItem: true,
        child: Stack(
          children: [
            Container(
              margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.1)),
              ),
              padding: const EdgeInsets.all(1),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                Expanded(child: Column(children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSmall), topRight: Radius.circular(Dimensions.radiusSmall)),
                      child: CustomImage(
                        image: '${isCampaign ? baseUrls!.campaignImageUrl : isStore ? baseUrls!.storeImageUrl
                            : baseUrls!.itemImageUrl}'
                            '/${isStore ? store != null ? store!.logo : '' : item!.image}',
                        height: desktop ? 160 : length == null ? 100 : 65, width: desktop ? isStore ? 275 : 300 : 80, fit: BoxFit.cover,
                      ),
                    ),

                    DiscountTag(
                      discount: discount, discountType: discountType,
                      freeDelivery: isStore ? store!.freeDelivery : false,
                    ),

                    !isStore ? OrganicTag(item: item!, placeInImage: false, placeTop: false) : const SizedBox(),

                    isAvailable ? const SizedBox() : NotAvailableWidget(isStore: isStore),
                  ]),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: SizedBox(
                        width: desktop ? isStore ? 275 :219 : 80,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max ,mainAxisAlignment: MainAxisAlignment.center, children: [

                          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                            Text(
                              isStore ? store!.name! : item!.name!,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                              maxLines: desktop ? 1 : 1, overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            (Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                                ? Image.asset(item != null && item!.veg == 0 ? Images.nonVegImage : Images.vegImage,
                                height: 10, width: 10, fit: BoxFit.contain) : const SizedBox(),
                          ]),
                          SizedBox(height: isStore ? Dimensions.paddingSizeExtraSmall : 0),

                          (isStore ? store!.address != null : item!.storeName != null) ? Text(
                            isStore ? store!.address ?? '' : item!.storeName ?? '',
                            style: robotoRegular.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: Dimensions.fontSizeOverSmall,
                              color: isStore ? Theme.of(context).disabledColor : Theme.of(context).primaryColor,
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ) : const SizedBox(),
                          SizedBox(height: ((desktop || isStore) && (isStore ? store!.address != null : item!.storeName != null)) ? 5 : 0),

                          isStore ? RatingBar(
                            rating: isStore ? store!.avgRating : item!.avgRating, size: desktop ? 15 : 12,
                            ratingCount: isStore ? store!.ratingCount : item!.ratingCount,
                          ) : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  PriceConverter.convertPrice(item!.price, discount: discount, discountType: discountType),
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall), textDirection: TextDirection.ltr,
                                ),
                                SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                                discount > 0 ? Text(
                                  PriceConverter.convertPrice(item!.price),
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeOverSmall,
                                    color: Theme.of(context).disabledColor,
                                    decoration: TextDecoration.lineThrough,
                                  ), textDirection: TextDirection.ltr,
                                ) : const SizedBox(),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(50)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 12),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    item!.ratingCount.toString(),
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeOverSmall, color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                            )


                          ]),
                        ]),
                      ),
                    ),
                  ),

                ])),

              ]),
            ),

          ],
        ),
      ),
    );
  }
}