import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/item/controllers/campaign_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';

class WebJustForYouViewWidget extends StatefulWidget {
  const WebJustForYouViewWidget({super.key});

  @override
  State<WebJustForYouViewWidget> createState() => _WebJustForYouViewWidgetState();
}

class _WebJustForYouViewWidgetState extends State<WebJustForYouViewWidget> {

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
    return GetBuilder<CampaignController>(builder: (campaignController) {

      if(campaignController.itemCampaignList != null && campaignController.itemCampaignList!.length > 5 && isFirstTime){
        showForwardButton = true;
        isFirstTime = false;
      }

      return campaignController.itemCampaignList != null ? campaignController.itemCampaignList!.isNotEmpty ? Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Text('just_for_you'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ),

          SizedBox(
            height: 185, width: Get.width,
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: campaignController.itemCampaignList!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
                    left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                    right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                  ),
                  child: OnHover(
                    isItem: true,
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      onTap: () => Get.find<ItemController>().navigateToItemPage(campaignController.itemCampaignList![index], context, isCampaign: true),
                      child: Container(
                        height: 185, width: 185,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: CustomImage(
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}'
                                '/${campaignController.itemCampaignList![index].image}',
                            fit: BoxFit.cover, height: 185, width: 185,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),

        if(showBackButton)
          Positioned(
            top: 130, left: 0,
            child: ArrowIconButton(
              isRight: false,
              onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            ),
          ),

        if(showForwardButton)
          Positioned(
            top: 130, right: 0,
            child: ArrowIconButton(
              onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            ),
          ),

      ]) : const SizedBox() : WebJustForYouShimmerView(campaignController: campaignController);
    });
  }
}

class WebJustForYouShimmerView extends StatelessWidget {
  final CampaignController campaignController;
  const WebJustForYouShimmerView({super.key, required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Text('just_for_you'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        ),

        SizedBox(
          height: 185, width: Get.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
                  left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                  right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                ),
                child: Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(
                    height: 185, width: 185,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    ]);
  }
}
