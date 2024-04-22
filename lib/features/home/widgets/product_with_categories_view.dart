import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/item/controllers/campaign_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BasicCampaignView extends StatelessWidget {
  final CampaignController campaignController;
  const BasicCampaignView({super.key, required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
          child: TitleWidget(title: 'basic_campaigns'.tr),
        ),
        SizedBox(
          height: 80,
          child: campaignController.basicCampaignList != null ? ListView.builder(
            itemCount: campaignController.basicCampaignList!.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getBasicCampaignRoute(
                    campaignController.basicCampaignList![index],
                  )),
                  child: Container(
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}'
                            '/${campaignController.basicCampaignList![index].image}',
                        width: 200, height: 80, fit: BoxFit.cover,
                      ),
                    ),
                  )
              );
            },
          ) : CampaignShimmer(campaignController: campaignController),
        ),
      ],
    );
  }
}

class CampaignShimmer extends StatelessWidget {
  final CampaignController campaignController;
  const CampaignShimmer({super.key, required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemBuilder: (context, index) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          enabled: campaignController.basicCampaignList == null,
          child: Container(
            width: 200, height: 80,
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
        );
      },
    );
  }
}

