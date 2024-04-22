import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/organic_tag.dart';
import 'package:sixam_mart/common/widgets/rating_bar.dart';

class ItemTitleViewWidget extends StatelessWidget {
  final Item? item;
  final bool inStorePage;
  final bool isCampaign;
  final bool inStock;
  const ItemTitleViewWidget({super.key, required this.item,  this.inStorePage = false, this.isCampaign = false, required this.inStock});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(inStock ? 'out_of_stock'.tr : 'in_stock'.tr);
    }
    final bool isLoggedIn = AuthHelper.isLoggedIn();
    double? startingPrice;
    double? endingPrice;
    if(item!.variations!.isNotEmpty) {
      List<double?> priceList = [];
      for (var variation in item!.variations!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
      if(priceList[0]! < priceList[priceList.length-1]!) {
        endingPrice = priceList[priceList.length-1];
      }
    }else {
      startingPrice = item!.price;
    }

    double? discount = (Get.find<ItemController>().item!.availableDateStarts != null || Get.find<ItemController>().item!.storeDiscount == 0) ? Get.find<ItemController>().item!.discount : Get.find<ItemController>().item!.storeDiscount;
    String? discountType = (Get.find<ItemController>().item!.availableDateStarts != null || Get.find<ItemController>().item!.storeDiscount == 0) ? Get.find<ItemController>().item!.discountType : 'percent';

    return ResponsiveHelper.isDesktop(context) ? GetBuilder<ItemController>(builder: (itemController){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      item?.name ?? '',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  ((Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item!.unitType != null)
                  || (Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!)) ? Text(
                    Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! ? '(${item!.unitType})'
                        : item!.veg == 0 ? '(${'non_veg'.tr})' : '(${'veg'.tr})',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                  ) : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            item!.availableTimeStarts != null ? const SizedBox() : Container(
              padding: const EdgeInsets.all(8), alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: GetBuilder<FavouriteController>(
                  builder: (favouriteController) {
                    return InkWell(
                      onTap: () {
                        if(AuthHelper.isLoggedIn()){
                          if(favouriteController.wishItemIdList.contains(itemController.item!.id)) {
                            favouriteController.removeFromFavouriteList(itemController.item!.id, false);
                          }else {
                            favouriteController.addToFavouriteList(itemController.item, null, false);
                          }
                        }else {
                          showCustomSnackBar('you_are_not_logged_in'.tr);
                        }
                      },
                      child: Icon(
                        favouriteController.wishItemIdList.contains(itemController.item!.id) ? Icons.favorite : Icons.favorite_border, size: 25,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }
              ),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                color: inStock ? Colors.red.shade50 : Colors.green.shade50, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Text(inStock ? 'out_of_stock'.tr : 'in_stock'.tr, style: robotoRegular.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeExtraSmall,
              )),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            OrganicTag(item: item!, fromDetails: true),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          InkWell(
            onTap: () {
              if(inStorePage) {
                Get.back();
              }else {
                Get.offNamed(RouteHelper.getStoreRoute(id: item!.storeId, page: 'item'));
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
              child: Text(
                item!.storeName!,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          RatingBar(rating: item!.avgRating, ratingCount: item!.ratingCount, size: 18),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(children: [
            discount! > 0 ? Flexible(
              child: Text(
                '${PriceConverter.convertPrice(startingPrice)}'
                    '${endingPrice!= null ? ' - ${PriceConverter.convertPrice(endingPrice)}' : ''}',
                textDirection: TextDirection.ltr,
                style: robotoRegular.copyWith(
                  color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough,
                  fontSize: Dimensions.fontSizeExtraSmall,
                ),
              ),
            ) : const SizedBox(),
            const SizedBox(width: 10),

            Text(
              '${PriceConverter.convertPrice(startingPrice, discount: discount, discountType: discountType)}'
                  '${endingPrice!= null ? ' - ${PriceConverter.convertPrice(endingPrice, discount: discount, discountType: discountType)}' : ''}',
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge), textDirection: TextDirection.ltr,
            ),
          ]),

        ],);
    }) : Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: GetBuilder<ItemController>(
        builder: (itemController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [
              Expanded(child: Text(
                item!.name ?? '',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              )),

              item!.availableTimeStarts != null ? const SizedBox() : GetBuilder<FavouriteController>(
                  builder: (favouriteController) {
                    return Row(
                      children: [
                        // Text(
                        //   favouriteController.localWishes.contains(item.id) ? (item.wishlistCount+1).toString() : favouriteController.localRemovedWishes
                        //       .contains(item.id) ? (item.wishlistCount-1).toString() : item.wishlistCount.toString(),
                        //   style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                        // ),
                        // SizedBox(width: 5),

                        InkWell(
                          onTap: () {
                            if(isLoggedIn){
                              if(favouriteController.wishItemIdList.contains(item!.id)) {
                                favouriteController.removeFromFavouriteList(item!.id, false);
                              }else {
                                favouriteController.addToFavouriteList(item, null, false);
                              }
                            }else {
                              showCustomSnackBar('you_are_not_logged_in'.tr);
                            }
                          },
                          child: Icon(
                            favouriteController.wishItemIdList.contains(item!.id) ? Icons.favorite : Icons.favorite_border, size: 25,
                            color: favouriteController.wishItemIdList.contains(item!.id) ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ]),
            const SizedBox(height: 5),

            InkWell(
              onTap: () {
                if(inStorePage) {
                  Get.back();
                }else {
                  Get.offNamed(RouteHelper.getStoreRoute(id: item!.storeId, page: 'item'));
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                child: Text(
                  item!.storeName!,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${PriceConverter.convertPrice(startingPrice, discount: discount, discountType: discountType)}'
                      '${endingPrice!= null ? ' - ${PriceConverter.convertPrice(endingPrice, discount: discount, discountType: discountType)}' : ''}',
                  style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge), textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 5),

                discount! > 0 ? Text(
                  '${PriceConverter.convertPrice(startingPrice)}'
                      '${endingPrice!= null ? ' - ${PriceConverter.convertPrice(endingPrice)}' : ''}', textDirection: TextDirection.ltr,
                  style: robotoRegular.copyWith(color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough),
                ) : const SizedBox(),
                SizedBox(height: discount > 0 ? 5 : 0),

                !isCampaign ? Row(children: [
                  Text(item!.avgRating!.toStringAsFixed(1), style: robotoRegular.copyWith(
                    color: Theme.of(context).hintColor,
                    fontSize: Dimensions.fontSizeLarge,
                  )),
                  const SizedBox(width: 5),

                  RatingBar(rating: item!.avgRating, ratingCount: item!.ratingCount),

                ]) : const SizedBox(),
              ])),

              Column(children: [

                ((Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item!.unitType != null)
                || (Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!)) ? Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: Text(
                    Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! ? item!.unitType ?? ''
                        : item!.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                  ),
                ) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                OrganicTag(item: item!, fromDetails: true),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: inStock ? Colors.red : Colors.green, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(inStock ? 'out_of_stock'.tr : 'in_stock'.tr, style: robotoRegular.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.fontSizeSmall,
                  )),
                ),
              ]),

            ]),

          ]);
        },
      ),
    );
  }
}
