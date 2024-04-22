import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';

class WebRecommendedStoreView extends StatelessWidget {
  const WebRecommendedStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isFood = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.food;

    return GetBuilder<StoreController>(builder: (storeController) {
      return storeController.recommendedStoreList != null ? Container(
        margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        width: Get.width, height: 302,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 2),
        ),
        child: Column(children: [
          Text(isFood ? 'recommended_restaurants'.tr : 'recommended_stores'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: storeController.recommendedStoreList!.isNotEmpty ? GridView.builder(
              itemCount: storeController.recommendedStoreList!.length > 9 ? 9 : storeController.recommendedStoreList!.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: Dimensions.paddingSizeDefault,
                mainAxisSpacing: Dimensions.paddingSizeDefault,
                mainAxisExtent: 60,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Get.toNamed(RouteHelper.getStoreRoute(id: storeController.recommendedStoreList![index].id, page: 'store'),
                      arguments: StoreScreen(store: storeController.recommendedStoreList![index], fromModule: false),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}'
                            '/${storeController.recommendedStoreList![index].logo}',
                        fit: BoxFit.cover, height: 60, width: double.infinity,
                      ),
                    ),
                  ),
                );
              },
            ) : Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Text(isFood ? 'currently_no_recommended_restaurant_available'.tr : 'currently_no_recommended_store_available'.tr),
            )),
          ),
        ]),
      ) : WebRecommendedStoreShimmerView(isFood: isFood);
    });
  }
}

class WebRecommendedStoreShimmerView extends StatelessWidget {
  final bool isFood;
  const WebRecommendedStoreShimmerView({super.key, required this.isFood});

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
        /*child: Column(children: [
          Text(isFood ? 'recommended_restaurants'.tr : 'recommended_stores'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: GridView.builder(
              itemCount: 9,
              shrinkWrap: true,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: Dimensions.paddingSizeDefault,
                mainAxisSpacing: Dimensions.paddingSizeDefault,
                mainAxisExtent: 60,
              ),
              itemBuilder: (context, index) {
                return Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),*/
      ),
    );
  }
}
