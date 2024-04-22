import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/add_favourite_view.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/common/widgets/rating_bar.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';


class WebNewOnMartViewWidget extends StatefulWidget {
  const WebNewOnMartViewWidget({super.key});

  @override
  State<WebNewOnMartViewWidget> createState() => _WebNewOnMartViewWidgetState();
}

class _WebNewOnMartViewWidgetState extends State<WebNewOnMartViewWidget> {

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
    return GetBuilder<StoreController>(builder: (storeController) {
      List<Store>? storeList = storeController.latestStoreList;

      if(storeList != null && storeList.length > 5 && isFirstTime){
        showForwardButton = true;
        isFirstTime = false;
      }

      return (storeList != null && storeList.isEmpty) ? const SizedBox() : Stack(children: [
          Column(children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child: TitleWidget(
                title: '${'new_on'.tr} ${AppConstants.appName}',
                onTap: () => Get.toNamed(RouteHelper.getAllStoreRoute('latest')),
              ),
            ),

            SizedBox(
              height: 160, width: Get.width,
              child: storeList != null ? ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: storeList.length,
                itemBuilder: (context, index){
                  double distance = Get.find<StoreController>().getRestaurantDistance(
                    LatLng(double.parse(storeList[index].latitude!), double.parse(storeList[index].longitude!)),
                  );
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
                      left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                      right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                    ),
                    child: InkWell(
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
                          arguments: StoreScreen(store: storeList[index], fromModule: false),
                        );
                      },
                      child: Stack(
                        children: [

                          OnHover(
                            isItem: true,
                            child: Container(
                              height: 160, width: 300,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Column(children: [

                                Expanded(
                                    flex: 6,
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        child: CustomImage(
                                          image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}''/${storeList[index].logo}',
                                          height: 90, width: 90, fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      Expanded(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                          SizedBox(
                                            width: 150,
                                            child: Text(storeList[index].name ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                              maxLines: 1, overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          RatingBar(
                                            rating: storeList[index].avgRating,
                                            ratingCount: storeList[index].ratingCount,
                                            size: 12,
                                          ),

                                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                                            Image.asset(Images.clockIcon, height: 15, width: 15, color: storeController.isOpenNow(storeList[index]) ? const Color(0xffECA507) : Theme.of(context).colorScheme.error),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                            Text(storeController.isOpenNow(storeList[index]) ? 'open_now'.tr : 'closed_now'.tr, style: robotoRegular.copyWith(color: storeController.isOpenNow(storeList[index]) ? const Color(0xffECA507) : Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall)),
                                          ]),

                                          Row(children: [

                                            Icon(Icons.storefront, size: 15, color: Theme.of(context).primaryColor),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                            Expanded(
                                              child: Text(storeList[index].address ?? '',
                                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ]),

                                        ]),
                                      ),

                                    ]),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

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

                                        Text(
                                          '${distance > 100 ? '100+' : distance.toStringAsFixed(2)} ${'km'.tr}',
                                          style: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                        Text('from_you'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
                                      ]),
                                    ),
                                  ]),
                                ),
                              ]),
                            ),
                          ),

                          Positioned(
                            top: 7, left: Get.find<LocalizationController>().isLtr ? 0 : null,
                            right: Get.find<LocalizationController>().isLtr ? null : 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text('new'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                            ),
                          ),

                          AddFavouriteView(
                            left: Get.find<LocalizationController>().isLtr ? null : 15,
                            right: Get.find<LocalizationController>().isLtr ? 15 : null,
                            item: Item(id: storeList[index].id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ) : WebNewOnMartShimmer(storeController: storeController),
            ),
          ]),

        if(showBackButton)
          Positioned(
            top: 110, left: 0,
            child: ArrowIconButton(
              isRight: false,
              onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            ),
          ),

        if(showForwardButton)
          Positioned(
            top: 110, right: 0,
            child: ArrowIconButton(
              onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            ),
          ),

      ]);
    });
  }
}

class WebNewOnMartShimmer extends StatelessWidget {
  final StoreController storeController;
  const WebNewOnMartShimmer({super.key, required this.storeController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.only(
            bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
            left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
            right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
          ),
          child: Container(
            height: 150, width: 300,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(
                color: Colors.grey[Get.find<ThemeController>().darkTheme ? 400 : 300]!, blurRadius: 3, spreadRadius: 0.1,
              )],
            ),
            child: Column(children: [

              Expanded(
                flex: 5,
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true,
                      direction: const ShimmerDirection.fromLTRB(),
                      child: Container(
                        height: 90, width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Container(
                          height: 10, width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ),

                      Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Container(
                          height: 10, width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ),

                      Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Container(
                          height: 10, width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ),

                      Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Container(
                          height: 10, width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Icon(
                          Icons.favorite_border,  size: 20,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Expanded(
                flex: 2,
                child: Row(children: [

                  Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    direction: const ShimmerDirection.fromLTRB(),
                    child: Container(
                      height: 10, width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}

