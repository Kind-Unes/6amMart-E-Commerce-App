import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/wallet/controllers/wallet_controller.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebBonusBannerWidget extends StatelessWidget {
  const WebBonusBannerWidget ({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return GetBuilder <WalletController> (
      builder: (walletController) {
        return Container(
          padding: const EdgeInsets.symmetric( horizontal: 0, vertical: Dimensions.paddingSizeSmall),
          alignment: Alignment.center,
          child: SizedBox(width: 1210, height: 130, child: walletController.fundBonusList != null ? Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall),
                child: PageView.builder(

                  controller: pageController,
                  itemCount: (walletController.fundBonusList!.length/2).ceil(),
                  itemBuilder: (context, index) {
                    int index1 = index * 2;
                    int index2 = (index * 2) + 1;
                    bool hasSecond = index2 < walletController.fundBonusList!.length;

                    // String? baseUrl1 = bannerController.bannerDataList![index1] is BasicCampaignModel ? Get.find<SplashController>()
                    //     .configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl;
                    // String? baseUrl2 = hasSecond ? bannerController.bannerDataList![index2] is BasicCampaignModel ? Get.find<SplashController>()
                    //     .configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl : '';

                    return Row(children: [
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: Theme.of(context).primaryColor),
                          color: Theme.of(context).primaryColor.withOpacity(0.03),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(
                              walletController.fundBonusList![index1].title!,
                              maxLines: 1,
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor, overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Text(
                              '${'valid_till'.tr} ${DateConverter.stringToReadableString(walletController.fundBonusList![index1].endDate!)}',
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Text(
                              '${'add_fund_to_wallet_minimum'.tr} ${PriceConverter.convertPrice(walletController.fundBonusList![index1].minimumAddAmount)} ${'and_enjoy'.tr} ${walletController.fundBonusList![index1].bonusAmount} '
                                  '${walletController.fundBonusList![index1].bonusType == 'amount' ? Get.find<SplashController>().configModel!.currencySymbol : '%'} ${'bonus'.tr}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                            ),
                          ])),

                          Image.asset(Images.walletBonus, height: 65, width: 65,),
                        ]),
                        )
                      ),

                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Expanded(child: hasSecond ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: Theme.of(context).primaryColor),
                          color: Theme.of(context).primaryColor.withOpacity(0.03),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(
                              walletController.fundBonusList![index2].title!,
                              maxLines: 1,
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor, overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Text(
                              '${'valid_till'.tr} ${DateConverter.stringToReadableString(walletController.fundBonusList![index2].endDate!)}',
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Text(
                              '${'add_fund_to_wallet_minimum'.tr} ${PriceConverter.convertPrice(walletController.fundBonusList![index2].minimumAddAmount)} ${'and_enjoy'.tr} ${walletController.fundBonusList![index2].bonusAmount} '
                                  '${walletController.fundBonusList![index2].bonusType == 'amount' ? Get.find<SplashController>().configModel!.currencySymbol : '%'} ${'bonus'.tr}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                            ),
                          ])),

                          Image.asset(Images.walletBonus, height: 65, width: 65,),
                        ]),
                      ) : const SizedBox()),

                    ]);
                  },
                  onPageChanged: (int index) => walletController.setCurrentIndex(index, true),
                ),
              ),

              walletController.currentIndex != 0 ? Positioned(
                top: 0, bottom: 0, left: 0,
                child: InkWell(
                  onTap: () => pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut),
                  child: Container(
                    height: 40, width: 40, alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Theme.of(context).cardColor,
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ) : const SizedBox(),

              walletController.currentIndex != ((walletController.fundBonusList!.length/2).ceil()-1) ? Positioned(
                top: 0, bottom: 0, right: 0,
                child: InkWell(
                  onTap: () => pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut),
                  child: Container(
                    height: 40, width: 40, alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Theme.of(context).cardColor,
                    ),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ) : const SizedBox(),

            ],
          ) : WebBannerShimmer(walletController: walletController)),
        );
      }
    );
  }

  // void _onTap(int index, BuildContext context) async {
  //   if(bannerController.bannerDataList![index] is Item) {
  //     Item? item = bannerController.bannerDataList![index];
  //     Get.find<ItemController>().navigateToItemPage(item, context);
  //   }else if(bannerController.bannerDataList![index] is Store) {
  //     Store store = bannerController.bannerDataList![index];
  //     Get.toNamed(
  //       RouteHelper.getStoreRoute(id: store.id, page: 'banner', moduleId: Get.find<SplashController>().module!.id, fromShare: false),
  //       arguments: StoreScreen(store: store, fromModule: false, moduleId: Get.find<SplashController>().module!.id!, fromShare: false),
  //     );
  //   }else if(bannerController.bannerDataList![index] is BasicCampaignModel) {
  //     BasicCampaignModel campaign = bannerController.bannerDataList![index];
  //     Get.toNamed(RouteHelper.getBasicCampaignRoute(campaign));
  //   }else {
  //     String url = bannerController.bannerDataList![index];
  //     if (await canLaunchUrlString(url)) {
  //       await launchUrlString(url, mode: LaunchMode.externalApplication);
  //     }else {
  //       showCustomSnackBar('unable_to_found_url'.tr);
  //     }
  //   }
  // }
}

class WebBannerShimmer extends StatelessWidget {
  final WalletController walletController;
  const WebBannerShimmer({super.key, required this.walletController});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: walletController.fundBonusList == null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
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
      ),
    );
  }
}

