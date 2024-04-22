import 'package:sixam_mart/features/item/controllers/campaign_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/basic_campaign_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebMostPopularItemBannerViewWidget extends StatelessWidget {
  final CampaignController campaignController;
  const WebMostPopularItemBannerViewWidget({super.key, required this.campaignController});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(width: Dimensions.webMaxWidth, height: 220, child: campaignController.basicCampaignList != null ? Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [

              PageView.builder(
                controller: pageController,
                itemCount: (campaignController.basicCampaignList!.length/2).ceil(),
                itemBuilder: (context, index) {
                  int index1 = index * 2;
                  int index2 = (index * 2) + 1;
                  bool hasSecond = index2 < campaignController.basicCampaignList!.length;

                  String? baseUrl1 = Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl;
                  String? baseUrl2 = hasSecond ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl : '';

                  return Row(children: [

                    Expanded(child: InkWell(
                      onTap: () => _onTap(index1, context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImage(
                          image: '$baseUrl1/${campaignController.basicCampaignList![index1].image}', fit: BoxFit.cover, height: 220,
                        ),
                      ),
                    )),

                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Expanded(child: hasSecond ? InkWell(
                      onTap: () => _onTap(index2, context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImage(
                          image: '$baseUrl2/${campaignController.basicCampaignList![index2].image}', fit: BoxFit.cover, height: 220,
                        ),
                      ),
                    ) : const SizedBox()),

                  ]);
                },
                onPageChanged: (int index) => campaignController.setCurrentIndex(index, true),
              ),

              campaignController.currentIndex != 0 ? Positioned(
                top: 0, bottom: 0, left: 0,
                child: ArrowIconButton(
                  isRight: false,
                  onTap: () => pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut),
                ),
              ) : const SizedBox(),

              campaignController.currentIndex != ((campaignController.basicCampaignList!.length/2).ceil()-1) ? Positioned(
                top: 0, bottom: 0, right: 0,
                child: ArrowIconButton(
                  onTap: () => pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut),
                ),
              ) : const SizedBox(),

            ],
          ) : WebBannerShimmer(campaignController: campaignController)),

          const SizedBox(height: Dimensions.paddingSizeLarge),
          campaignController.basicCampaignList != null ? Builder(
              builder: (context) {
                List finalBanner = [];
                for(int i=0; i<campaignController.basicCampaignList!.length; i++){
                  if(i%2==0){
                    finalBanner.add(campaignController.basicCampaignList![i]);
                  }
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: finalBanner.map((bnr) {
                    int index = finalBanner.indexOf(bnr);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: index == campaignController.currentIndex ? Container(
                        height: 5, width: 6,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                      ) : Container(
                        height: 4, width: 4,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                      ),
                    );
                  }).toList(),
                );
              }
          ) : const SizedBox(),
        ],
      ),
    );
  }

  void _onTap(int index, BuildContext context) async {
    BasicCampaignModel campaign = campaignController.basicCampaignList![index];
    Get.toNamed(RouteHelper.getBasicCampaignRoute(campaign));
    }
}

class WebBannerShimmer extends StatelessWidget {
  final CampaignController campaignController;
  const WebBannerShimmer({super.key, required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: campaignController.basicCampaignList == null,
      child: Row(children: [

        Expanded(child: Container(
          height: 220,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
        )),

        const SizedBox(width: Dimensions.paddingSizeLarge),

        Expanded(child: Container(
          height: 220,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
        )),

      ]),
    );
  }
}

