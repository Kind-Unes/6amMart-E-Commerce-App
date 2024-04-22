import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/item/controllers/campaign_controller.dart';
import 'package:sixam_mart/features/home/widgets/components/circle_list_view_widget.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';

class JustForYouView extends StatefulWidget {
  const JustForYouView({super.key});

  @override
  State<JustForYouView> createState() => _JustForYouViewState();
}

class _JustForYouViewState extends State<JustForYouView> {
  @override
  Widget build(BuildContext context) {
    //bool isGrocery = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.grocery;

    return GetBuilder<CampaignController>(builder: (campaignController) {
        return campaignController.itemCampaignList != null ? campaignController.itemCampaignList!.isNotEmpty ? Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Column(children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: TitleWidget(
                title: 'just_for_you'.tr,
                onTap: () => Get.toNamed(RouteHelper.getItemCampaignRoute(isJustForYou: true)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: SizedBox(
                width: Get.width,
                child: const Column( children: [
                  /*isGrocery ? Swiper(
                    itemCount: campaignController.itemCampaignList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Get.find<ItemController>().navigateToItemPage(campaignController.itemCampaignList![index], context, isCampaign: true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}'
                                  '/${campaignController.itemCampaignList![index].image}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                    itemWidth: 200,
                    itemHeight: 200,
                    layout: SwiperLayout.STACK,
                    axisDirection: AxisDirection.right,
                    viewportFraction: 9,
                    outer: true,
                  ) : */

                  Directionality(textDirection: TextDirection.ltr, child: CircleListView()),

                  /*const SizedBox(height: Dimensions.paddingSizeDefault),
                  Center(
                    child: Row(children: [
                      // const SizedBox(width: Dimensions.paddingSizeDefault),
                      Icon(Icons.arrow_back, color: Theme.of(context).disabledColor),
                      Text('swipe_left'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                    ]),
                  ),*/
                ]),
              ),
            ),
          ]),
        ) : const SizedBox() : /*const JustForYouShimmerView();*/ const CircleListViewShimmerView();
      }
    );
  }
}

class JustForYouShimmerView extends StatelessWidget {
  const JustForYouShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Column(children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: TitleWidget(
            title: 'just_for_you'.tr,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              height: 200, width: Get.width,
              child: Swiper(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Colors.grey[300],
                    ),
                  );
                },
                itemWidth: 200,
                layout: SwiperLayout.STACK,
                axisDirection: AxisDirection.right,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}


