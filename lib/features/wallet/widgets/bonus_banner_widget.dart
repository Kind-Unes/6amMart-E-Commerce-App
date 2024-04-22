import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/wallet/controllers/wallet_controller.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
class BonusBannerWidget extends StatelessWidget {
  const BonusBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (walletController) {
        return walletController.fundBonusList != null && walletController.fundBonusList!.isNotEmpty && Get.find<SplashController>().configModel!.addFundStatus! ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: ResponsiveHelper.isDesktop(context) ? 110 : 105,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction: 0.8,
                  autoPlayInterval: const Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    walletController.setCurrentIndex(index, true);
                  },
                ),
                itemCount: walletController.fundBonusList!.length,
                itemBuilder: (context, index, _) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).primaryColor),
                      color: Theme.of(context).primaryColor.withOpacity(0.03),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                        Text(
                          walletController.fundBonusList![index].title!, maxLines: 1,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(
                          '${'valid_till'.tr} ${DateConverter.stringToReadableString(walletController.fundBonusList![index].endDate!)}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(
                          '${'add_fund_to_wallet_minimum'.tr} ${PriceConverter.convertPrice(walletController.fundBonusList![index].minimumAddAmount)} ${'and_enjoy'.tr} ${walletController.fundBonusList![index].bonusAmount} '
                              '${walletController.fundBonusList![index].bonusType == 'amount' ? Get.find<SplashController>().configModel!.currencySymbol : '%'} ${'bonus'.tr}',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                      ])),

                      Image.asset(Images.walletBonus, height: 65, width: 65),
                    ]),
                  );
                },
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: walletController.fundBonusList!.map((bnr) {
                int index = walletController.fundBonusList!.indexOf(bnr);
                return TabPageSelectorIndicator(
                  backgroundColor: index == walletController.currentIndex ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.5),
                  borderColor: Theme.of(context).colorScheme.background,
                  size: index == walletController.currentIndex ? 10 : 7,
                );
              }).toList(),
            ),

          ],
        ) : const SizedBox();
      }
    );
  }
}
