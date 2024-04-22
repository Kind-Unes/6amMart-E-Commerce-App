import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/new_tag.dart';
import 'package:sixam_mart/common/widgets/not_available_widget.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';

class StoreCardWithDistance extends StatelessWidget {
  final Store store;
  final bool fromAllStore;
  final bool? isNewStore;
  const StoreCardWithDistance({super.key, required this.store, this.fromAllStore = false, this.isNewStore = false});

  @override
  Widget build(BuildContext context) {
    bool isPharmacy = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.pharmacy;
    double distance = Get.find<StoreController>().getRestaurantDistance(
      LatLng(double.parse(store.latitude!), double.parse(store.longitude!)),
    );
    return Stack(
      children: [
        Container(
          width: fromAllStore ? double.infinity : 260,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],
          ),
          child: CustomInkWell(
            onTap: () {
              if(Get.find<SplashController>().moduleList != null) {
                for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                  if(module.id == store.moduleId) {
                    Get.find<SplashController>().setModule(module);
                    break;
                  }
                }
              }
              Get.toNamed(
                RouteHelper.getStoreRoute(id: store.id, page: 'store'),
                arguments: StoreScreen(store: store, fromModule: false),
              );
            },
            radius: Dimensions.radiusDefault,
            child: Column(children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                  child: Stack(clipBehavior: Clip.none, children: [
                    CustomImage(
                      image: '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}'
                          '/${store.coverPhoto}',
                      fit: BoxFit.cover, height: double.infinity, width: double.infinity,
                    ),

                    DiscountTag(
                      discount: Get.find<StoreController>().getDiscount(store),
                      discountType: Get.find<StoreController>().getDiscountType(store),
                      freeDelivery: store.freeDelivery,
                    ),

                    Get.find<StoreController>().isOpenNow(store) ? const SizedBox()
                        : const NotAvailableWidget(isStore: true),

                   /* AddFavouriteView(
                      item: Item(id: store.id),
                    ),*/

                    Positioned(
                      top: 15,
                      left: Get.find<LocalizationController>().isLtr ? null : 15,
                      right: Get.find<LocalizationController>().isLtr ? 15 : null,
                      child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                        bool isWished = favouriteController.wishStoreIdList.contains(store.id);
                        return InkWell(
                          onTap: () {
                            if(AuthHelper.isLoggedIn()) {
                              isWished ? favouriteController.removeFromFavouriteList(store.id, true)
                                  : favouriteController.addToFavouriteList(null, store, true);
                            }else {
                              showCustomSnackBar('you_are_not_logged_in'.tr);
                            }
                          },
                          child: Icon(
                            isWished ? Icons.favorite : Icons.favorite_border,  size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      }),
                    ),

                    isNewStore! ? const NewTag() : const SizedBox(),
                  ]),
                ),
              ),

              Expanded(
                flex: 1,
                child: Column(children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 95),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Flexible(child: Text(store.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium)),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(children: [
                          Icon(Icons.location_on_outlined, color: isPharmacy ? Colors.blue : Theme.of(context).primaryColor, size: 15),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Expanded(child: Text(
                            store.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(
                              color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall,
                            ),
                          )),
                        ]),
                      ]),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                            boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)],
                          ),
                          child: Row(children: [

                            Image.asset(Images.distanceLine, height: 15, width: 15),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Text(
                              '${distance > 100 ? '100+' : distance.toStringAsFixed(2)} ${'km'.tr}',
                              style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Text('from_you'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall)),
                          ]),
                        ),

                        CustomButton(
                          height: 30, width: fromAllStore? 70 : 65,
                          radius: Dimensions.radiusSmall,
                          onPressed: () {
                            if(Get.find<SplashController>().moduleList != null) {
                              for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                                if(module.id == store.moduleId) {
                                  Get.find<SplashController>().setModule(module);
                                  break;
                                }
                              }
                            }
                            Get.toNamed(
                              RouteHelper.getStoreRoute(id: store.id, page: 'store'),
                              arguments: StoreScreen(store: store, fromModule: false),
                            );
                          },
                          buttonText: 'visit'.tr,
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).cardColor,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ]),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),

        Positioned(
          top: 60, left: 15,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 65, width: 65,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImage(
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${store.logo}',
                    fit: BoxFit.cover, height: double.infinity, width: double.infinity,
                  ),
                ),
              ),

              Positioned(
                bottom: -5, right: 5, left: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(store.avgRating!.toStringAsFixed(1), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(width: 3),

                    Icon(Icons.star, color: Theme.of(context).primaryColor, size: 15),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
