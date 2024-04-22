import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/coupon/controllers/coupon_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class PromoCodeBannerView extends StatefulWidget {
  const PromoCodeBannerView({super.key});

  @override
  State<PromoCodeBannerView> createState() => _PromoCodeBannerViewState();
}

class _PromoCodeBannerViewState extends State<PromoCodeBannerView> {
  final CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(builder: (couponController) {

      return couponController.couponList != null ? couponController.couponList!.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
        child: Column(children: [

            CarouselSlider.builder(
              carouselController: carouselController,
              itemCount: couponController.couponList!.length,
              options: CarouselOptions(
                height: 135,
                autoPlay: true,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: 0.95,
                onPageChanged: (index, reason) {
                  couponController.setCurrentIndex(index, true);
                },
              ),
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                return Container(
                  height: 135, width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    image: const DecorationImage(
                      image: AssetImage(Images.promoCodeBg),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Image.asset(Images.couponOfferIcon, height: 92, width: 115),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      flex: 2,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(
                          '${couponController.couponList![itemIndex].title ?? ''} ${'min_order_of'.tr} ${PriceConverter.convertPrice(couponController.couponList![itemIndex].minPurchase)}',
                            textAlign: TextAlign.center,
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8)),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        DottedBorder(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 1,
                          strokeCap: StrokeCap.butt,
                          dashPattern: const [5, 5],
                          padding: const EdgeInsets.all(0),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(50),
                          child: Container(
                            height: 35, width: 130,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(50)),
                            child: CustomInkWell(
                              onTap: () {
                                if(couponController.couponList![itemIndex].code != null){
                                  Clipboard.setData(ClipboardData(text: couponController.couponList![itemIndex].code ?? ''));
                                  showCustomSnackBar('coupon_code_copied'.tr, isError: false);
                                }
                              },
                              radius: 50,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.copy, color: Theme.of(context).primaryColor, size: 16),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Text(couponController.couponList![itemIndex].code ?? '', style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                              ]),
                            ),
                          ),
                        ),

                      ]),
                    ),

                  ]),
                );
              },
            ),

            SizedBox(height: Dimensions.fontSizeSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: couponController.couponList!.map((bnr) {
                int index = couponController.couponList!.indexOf(bnr);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: index == couponController.currentIndex ? Container(
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
      ) : const SizedBox() : const PromoCodeShimmerView();
    });
  }
}

class PromoCodeShimmerView extends StatelessWidget {
  const PromoCodeShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
      child: Column(children: [

        CarouselSlider.builder(
          itemCount: 5,
          options: CarouselOptions(
            height: 135,
            enlargeCenterPage: true,
            disableCenter: true,
            viewportFraction: 0.95,
          ),
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            return Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                height: 135, width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
