import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/add_favourite_view.dart';
import 'package:sixam_mart/common/widgets/card_design/store_card.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';

class WebBestStoreNearbyViewWidget extends StatefulWidget {
  const WebBestStoreNearbyViewWidget({super.key});

  @override
  State<WebBestStoreNearbyViewWidget> createState() => _WebBestStoreNearbyViewWidgetState();
}

class _WebBestStoreNearbyViewWidgetState extends State<WebBestStoreNearbyViewWidget> {

  ScrollController scrollController = ScrollController();
  bool showBackButton = false;
  bool showForwardButton = false;
  bool isFirstTime = true;

  @override
  void initState() {
    scrollController.addListener(_checkScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _checkScrollPosition() {
    setState(() {
      if (scrollController.position.pixels <= 0) {
        showBackButton = false;
      } else {
        showBackButton = true;
      }

      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        showForwardButton = false;
      } else {
        showForwardButton = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPharmacy = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.pharmacy;

    return Container(
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: isPharmacy ? null : Theme.of(context).disabledColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isPharmacy ? 0 : Dimensions.radiusSmall),
      ),
      child: Column(children: [

        isPharmacy ? Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: TitleWidget(
            title: 'featured_store'.tr,
            onTap: () => Get.toNamed(RouteHelper.getAllStoreRoute('featured')),
          ),
        ) : Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtremeLarge, left: Dimensions.paddingSizeExtraLarge, right: Dimensions.paddingSizeExtraLarge),
          child: FittedBox(
            child: Row(children: [

              Container(
                height: 2, width: ResponsiveHelper.isDesktop(context) ? Dimensions.webMaxWidth * 0.88 : Get.width * 0.75,
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

        Stack(children: [
          GetBuilder<StoreController>(builder: (storeController) {
            List<Store>? storeList = isPharmacy ? storeController.featuredStoreList : storeController.popularStoreList;

            if(storeList != null && storeList.length > 3 && isFirstTime){
              showForwardButton = true;
              isFirstTime = false;
            }

            return SizedBox(
              height: 190, width: Get.width,
              child: storeList != null && storeList.isNotEmpty ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !isPharmacy ? const SizedBox(width: Dimensions.paddingSizeExtraLarge) : const SizedBox(),
                  !isPharmacy ? RotatedBox(
                    quarterTurns: 3,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeExtremeLarge : 0, left: 25),
                      child: Text('best_store_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ),
                  ) : const SizedBox(),

                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: storeList.length,
                      itemBuilder: (context, index) {
                        double distance = Get.find<StoreController>().getRestaurantDistance(
                          LatLng(double.parse(storeList[index].latitude!), double.parse(storeList[index].longitude!)),
                        );

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: Dimensions.paddingSizeExtremeLarge, top: Dimensions.paddingSizeExtremeLarge,
                            left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                            right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                          ),
                          child: OnHover(
                            isItem: true,
                            child: isPharmacy ? StoreCard(store: storeList[index]) : InkWell(
                              hoverColor: Colors.transparent,
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
                              child: Stack(children: [

                                Container(
                                  height: 160, width: 275,
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    border: isPharmacy ? null : Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2),
                                    boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)],
                                  ),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    Expanded(
                                      flex: 6,
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                        Container(
                                          height: 70, width: 70,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            border: isPharmacy ? null : Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2),
                                          ),
                                          child: Stack(children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                              child: CustomImage(
                                                image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}'
                                                    '/${storeList[index].logo}',
                                                fit: BoxFit.cover, height: double.infinity, width: double.infinity,
                                              ),
                                            ),

                                            DiscountTag(
                                              discount: storeController.getDiscount(storeList[index]),
                                              discountType: storeController.getDiscountType(storeList[index]),
                                              freeDelivery: storeList[index].freeDelivery,
                                            ),

                                          ]),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                        Expanded(
                                          flex: 9,
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                            Row(children: [

                                              Text('start_from'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                              Text(PriceConverter.convertPrice(storeList[index].minimumOrder), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),

                                            ]),

                                            Row(children: [

                                              Icon(Icons.star, size: 15, color: Theme.of(context).primaryColor),
                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                              Text(storeList[index].avgRating!.toStringAsFixed(1), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                              Text("(${storeList[index].ratingCount.toString()})", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

                                            ]),

                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)],
                                              ),
                                              child: Row(children: [

                                                Image.asset(Images.distanceLine, height: 15, width: 15),
                                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                                Text('${distance > 10 ? '10+' : distance.toStringAsFixed(1)} ${'km'.tr}', style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall)),
                                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                                Text('from_you'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall)),
                                              ]),
                                            ),

                                          ]),
                                        ),

                                      ]),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    Expanded(
                                      flex: 2,
                                      child: Text(storeList[index].name!, style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ),
                                  ]),
                                ),

                                AddFavouriteView(
                                  left: Get.find<LocalizationController>().isLtr ? null : 15,
                                  right: Get.find<LocalizationController>().isLtr ? 15 : null,
                                  item: Item(id: storeList[index].id),
                                ),

                              ]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]) : WebBestStoreNearbyShimmerView(storeController: storeController),
            );
          }),

          if(showBackButton)
            Positioned(
              top: 70, left: isPharmacy ? 0 : Get.find<LocalizationController>().isLtr ? 45 : 0,
              child: ArrowIconButton(
                isRight: false,
                onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                    duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
              ),
            ),

          if(showForwardButton)
            Positioned(
              top: 70, right: Get.find<LocalizationController>().isLtr ? 0 : 45,
              child: ArrowIconButton(
                onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                    duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
              ),
            ),

        ]),
      ]),
    );
  }
}

class WebBestStoreNearbyShimmerView extends StatelessWidget {
  final StoreController storeController;
  const WebBestStoreNearbyShimmerView({super.key, required this.storeController});

  @override
  Widget build(BuildContext context) {
    final bool isPharmacy = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == 'pharmacy';

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: isPharmacy ? 0 : Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
          child: Container(
            height: 160, width: 275,
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            margin: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)],
            ),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Expanded(
                  flex: 6,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Container(
                      height: 70, width: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: Container(
                            height: double.infinity, width: double.infinity,
                            color: Colors.grey[300],
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      flex: 9,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        isPharmacy ? Container(height: 10, width: 100, color: Colors.grey[300]) : Row(children: [

                          Container(height: 10, width: 50, color: Colors.grey[300]),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Container(height: 10, width: 20, color: Colors.grey[300]),

                        ]),

                        isPharmacy ? Row(children: [

                          Icon(Icons.storefront, size: 15, color: Theme.of(context).disabledColor),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Expanded(
                            child: Container(height: 10, width: 100, color: Colors.grey[300]),
                          ),
                        ]) : Row(children: [

                          Icon(Icons.star, size: 15, color: Theme.of(context).disabledColor),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Container(height: 10, width: 20, color: Colors.grey[300]),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Container(height: 10, width: 20, color: Colors.grey[300]),

                        ]),

                        isPharmacy ? Container(height: 10, width: 20, color: Colors.grey[300]) : Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)],
                          ),
                          child: Row(children: [
                              Container(height: 10, width: 20, color: Colors.grey[300]),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Container(height: 10, width: 20, color: Colors.grey[300]),
                          ]),
                        ),

                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Expanded(
                  flex: 2,
                  child: isPharmacy ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)],
                    ),
                    child: Row(children: [
                      Container(height: 10, width: 20, color: Colors.grey[300]),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Container(height: 10, width: 20, color: Colors.grey[300]),
                    ]),
                  ) : Container(height: 10, width: 100, color: Colors.grey[300]),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
