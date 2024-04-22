import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/card_design/store_card.dart';
import 'package:sixam_mart/common/widgets/card_design/store_card_with_distance.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/rating_bar.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';

class BestStoreNearbyView extends StatelessWidget {
  const BestStoreNearbyView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isPharmacy = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.pharmacy;
    bool isFood = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.food;

    return GetBuilder<StoreController>(builder: (storeController) {
      List<Store>? storeList = isPharmacy ? storeController.featuredStoreList : storeController.popularStoreList;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
        child: Container(
          color: isPharmacy ? null : Theme.of(context).disabledColor.withOpacity(0.1),
          child: Column(children: [

            (isPharmacy || isFood) ? Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
              child: TitleWidget(
                title: isPharmacy ? 'featured_store'.tr : 'best_store_nearby'.tr,
                onTap: () => Get.toNamed(RouteHelper.getAllStoreRoute(isPharmacy ? 'featured' : 'popular', isNearbyStore: true)),
              ),
            ) : Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeDefault),
              child: FittedBox(
                child: Row(children: [

                  Container(
                    height: 2, width: context.width * 0.75,
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                  ),
                  Container(transform: Matrix4.translationValues(-5, 0, 0),child: Icon(Icons.arrow_forward, size: 18, color: Theme.of(context).primaryColor.withOpacity(0.5))),


                  InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getAllStoreRoute('popular', isNearbyStore: true)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      child: Text(
                        'see_all'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),

                ]),
              ),
            ),

            storeList != null ? storeList.isNotEmpty ? isPharmacy ? SizedBox(
              height: 130, width: Get.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                itemCount: storeList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                    child: StoreCard(store: storeList[index]),
                  );
                },
              ),
            ) : isFood ? SizedBox(
              height: 215,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
                  itemCount: storeList.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: InkWell(
                        onTap: () {
                          if(Get.find<SplashController>().moduleList != null) {
                            for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                              if(module.id == storeList[index].moduleId) {
                                Get.find<SplashController>().setModule(module);
                                break;
                              }
                            }
                          }
                          Get.toNamed(
                            RouteHelper.getStoreRoute(id: storeList[index].id, page: 'store'),
                            arguments: StoreScreen(store: storeList[index], fromModule: true),
                          );
                        },
                        child: StoreCardWithDistance(store: storeList[index]),
                      ),
                    );
                  }),
            ) : SizedBox(
              height: 170, width: Get.width,
              child:  Row(
                children: [
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text('best_store_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ),

                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                      itemCount: storeList.length,
                      itemBuilder: (context, index) {
                        double distance = Get.find<StoreController>().getRestaurantDistance(
                          LatLng(double.parse(storeList[index].latitude!), double.parse(storeList[index].longitude!)),
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Container(
                              width: 270,
                              margin: const EdgeInsets.only(top: 30),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                              ),
                              child: CustomInkWell(
                                onTap: () {
                                  if(Get.find<SplashController>().moduleList != null) {
                                    for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                                      if(module.id == storeList[index].moduleId) {
                                        Get.find<SplashController>().setModule(module);
                                        break;
                                      }
                                    }
                                  }
                                  Get.toNamed(
                                    RouteHelper.getStoreRoute(id: storeList[index].id, page: 'store'),
                                    arguments: StoreScreen(store: storeList[index], fromModule: true),
                                  );
                                },
                                radius: Dimensions.radiusLarge,
                                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Expanded(
                                    flex: 3,
                                    child: Row(children: [

                                      const Expanded(flex: 3, child: SizedBox()),

                                      Expanded(
                                        flex: 4,
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                            Column(children: [

                                              Text('start_from'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                              Text(PriceConverter.convertPrice(storeList[index].minimumOrder), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),

                                            ]),
                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                            Row(children: [

                                              Icon(Icons.star, size: 15, color: Theme.of(context).primaryColor),
                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                              Text(storeList[index].avgRating!.toStringAsFixed(1), style: robotoRegular),
                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                              Text("(${storeList[index].ratingCount.toString()})", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

                                            ]),
                                          ]),

                                        ]),
                                      ),
                                    ]),
                                  ),

                                  Expanded(
                                    flex: 1,
                                    child: Text(storeList[index].name ?? '', style: robotoMedium),
                                  ),

                                ]),
                              ),
                            ),
                            Positioned(
                              top: -5,
                              left: Get.find<LocalizationController>().isLtr ? 15 : null,
                              right: Get.find<LocalizationController>().isLtr ? null : 15,
                              child: Container(
                                height: 90, width: 95,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 3))],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    child: Stack(children: [

                                      CustomImage(
                                        image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}'
                                            '/${storeList[index].logo}',
                                        fit: BoxFit.cover,
                                        height: double.infinity, width: double.infinity,
                                      ),

                                      DiscountTag(
                                        discount: storeController.getDiscount(storeList[index]),
                                        discountType: storeController.getDiscountType(storeList[index]),
                                      ),

                                      Positioned(
                                        bottom: 0, left: 0,
                                        child: Container(
                                          width: 90,
                                          padding: const EdgeInsets.symmetric(vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                          ),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                                            Text('${distance > 10 ? '10+' : distance.toStringAsFixed(1)} ${'km'.tr}', style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeOverSmall)),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                            Text('from_you'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeOverSmall)),
                                          ]),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),

                           /* AddFavouriteView(
                              top: 40,
                              left: Get.find<LocalizationController>().isLtr ? null : 15,
                              right: Get.find<LocalizationController>().isLtr ? 15 : null,
                              item: Item(id: storeList[index].id),
                            ),*/

                            Positioned(
                              top: 40,
                              left: Get.find<LocalizationController>().isLtr ? null : 15,
                              right: Get.find<LocalizationController>().isLtr ? 15 : null,
                              child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                                bool isWished = favouriteController.wishStoreIdList.contains(storeList[index].id);
                                return InkWell(
                                  onTap: () {
                                    if(AuthHelper.isLoggedIn()) {
                                      isWished ? favouriteController.removeFromFavouriteList(storeList[index].id, true)
                                          : favouriteController.addToFavouriteList(null, storeList[index], true);
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
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ) : const SizedBox() : BestStoreNearbyShimmer(isPharmacy: isPharmacy, isFood: isFood),
          ]),
        ),
      );
    });
  }
}

class BestStoreNearbyShimmer extends StatelessWidget {
  final bool isPharmacy;
  final bool isFood;
  const BestStoreNearbyShimmer({super.key, required this.isPharmacy, required this.isFood});

  @override
  Widget build(BuildContext context) {
    return isPharmacy ? SizedBox(
      height: 130, width: Get.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(children: [

                  Expanded(
                    flex: 5,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: Container(
                          height: 50, width: 50,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Container(
                            height: 10, width: 100,
                            color: Theme.of(context).cardColor,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          !isPharmacy ? const RatingBar(
                            rating: 0,
                            ratingCount: 0,
                            size: 12,
                          ) : Row(children: [

                            Icon(Icons.storefront, size: 15, color: Theme.of(context).primaryColor),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Expanded(
                              child: Container(
                                height: 10, width: 100,
                                color: Theme.of(context).cardColor,
                              ),
                            ),

                          ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          !isPharmacy ? Row(children: [

                            Icon(Icons.storefront, size: 15, color: Theme.of(context).primaryColor),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Expanded(
                              child: Container(
                                height: 10, width: 100,
                                color: Theme.of(context).cardColor,
                              ),
                            ),

                          ]) : Container(
                            height: 10, width: 100,
                            color: Theme.of(context).cardColor,
                          ),

                        ]),
                      ),

                    ]),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(children: [

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                        ),
                        child: Row(children: [

                          Image.asset(Images.distanceLine, height: 15, width: 15),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Container(
                            height: 10, width: 50,
                            color: Theme.of(context).cardColor,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Container(
                            height: 10, width: 50,
                            color: Theme.of(context).cardColor,
                          ),
                        ]),
                      ),
                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                        ),
                        child: Row(children: [

                          Image.asset(Images.clockIcon, height: 15, width: 15),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Container(
                            height: 10, width: 50,
                            color: Theme.of(context).cardColor,
                          ),
                        ]),
                      ),
                    ]),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    ) : isFood ? SizedBox(
      height: 215,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
          itemCount: 6,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Stack(children: [
                Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(
                    width: 260,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Column(children: [
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Container(
                              height: double.infinity, width: double.infinity,
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                            ),

                            Positioned(
                              top: 15, right: 15,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).cardColor.withOpacity(0.8),
                                ),
                                child: Icon(Icons.favorite_border, color: Theme.of(context).primaryColor, size: 20),
                              ),
                            ),
                          ]),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Column(children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 95),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Expanded(
                                  child: Container(
                                    height: 5, width: 100,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                                const SizedBox(height: 2),

                                Row(children: [
                                  const Icon(Icons.location_on_outlined, color: Colors.blue, size: 15),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Expanded(
                                    child: Container(
                                      height: 10, width: 100,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
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
                                  height: 10, width: 70,
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                                  ),
                                ),

                                Container(
                                  height: 20, width: 65,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
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
                      ),
                    ],
                  ),
                ),
              ]),
            );
          }),
    ) : SizedBox(
      height: 160, width: Get.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
            child: Stack(clipBehavior: Clip.none, children: [
              Shimmer(
                duration: const Duration(seconds: 2),
                enabled: true,
                child: Container(
                  height: 155, width: 250,
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Expanded(
                      flex: 3,
                      child: Row(children: [

                        const Expanded(flex: 3, child: SizedBox()),

                        Expanded(
                          flex: 4,
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Row(children: [

                                Container(
                                  height: 10, width: 50,
                                  color: Theme.of(context).cardColor,
                                ),

                              ]),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Row(children: [

                                Icon(Icons.star, size: 15, color: Theme.of(context).primaryColor),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Container(
                                  height: 10, width: 50,
                                  color: Theme.of(context).cardColor,
                                ),

                              ]),
                            ]),
                            const Spacer(),

                            Icon(Icons.favorite_border, color: Theme.of(context).disabledColor, size: 20),

                          ]),
                        ),
                      ]),
                    ),

                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 10, width: 100,
                        color: Theme.of(context).cardColor,
                      ),
                    ),

                  ]),
                ),
              ),
              Positioned(
                top: -5, left: 15,
                child: Container(
                  height: 90, width: 90,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      child: Stack(children: [

                        Container(
                          height: double.infinity, width: double.infinity,
                          color: Colors.grey[300],
                        ),

                        Positioned(
                          bottom: 0, left: 0,
                          child: Container(
                            width: 80,
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Row(children: [

                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10, width: 50,
                                color: Theme.of(context).cardColor,
                              ),
                            ]),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
