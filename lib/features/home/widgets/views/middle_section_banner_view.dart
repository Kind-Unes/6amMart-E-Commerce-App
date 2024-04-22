import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/item/controllers/campaign_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';

class MiddleSectionBannerView extends StatefulWidget {
  const MiddleSectionBannerView({super.key});

  @override
  State<MiddleSectionBannerView> createState() => _MiddleSectionBannerViewState();
}

class _MiddleSectionBannerViewState extends State<MiddleSectionBannerView> {

  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {

    bool isPharmacy = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.pharmacy;

    return GetBuilder<CampaignController>(builder: (campaignController) {
      return campaignController.basicCampaignList != null ? campaignController.basicCampaignList!.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
        child: Column(children: [

            CarouselSlider.builder(
              carouselController: carouselController,
              itemCount: campaignController.basicCampaignList!.length,
              options: CarouselOptions(
                height: isPharmacy ? 187 : 135,
                //autoPlay: true,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: 0.95,
                onPageChanged: (index, reason) {
                  campaignController.setCurrentIndex(index, true);
                },
              ),
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                return InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getBasicCampaignRoute(
                    campaignController.basicCampaignList![itemIndex],
                  )),
                  child: Container(
                    height: isPharmacy ? 187 : 135, width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}'
                            '/${campaignController.basicCampaignList![itemIndex].image}',
                        fit: BoxFit.cover, height: 80, width: double.infinity,
                      ),
                    ),
                  ),
                );
            },
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: campaignController.basicCampaignList!.map((bnr) {
                int index = campaignController.basicCampaignList!.indexOf(bnr);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: index == campaignController.currentIndex ? Container(
                    width: 8, height: 8,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                  ) : Container(
                    height: 5, width: 6,
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                  ),
                );
              }).toList(),
            ),
          ]),
      ) : const SizedBox() : MiddleSectionBannerShimmerView(isPharmacy: isPharmacy);
    });
  }
}

class MiddleSectionBannerShimmerView extends StatelessWidget {
  final bool isPharmacy;
  const MiddleSectionBannerShimmerView({super.key, required this.isPharmacy});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Column(children: [

        Stack(
          children: [
            CarouselSlider.builder(
              itemCount: 3,
              options: CarouselOptions(
                height: isPharmacy ? 187 : 135,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: 0.95,
              ),
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                return Container(
                  height: isPharmacy ? 187 : 135, width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  ),
                );
              },
            ),
          ],
        ),
      ]),
    );
  }
}
