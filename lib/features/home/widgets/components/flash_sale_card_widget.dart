import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/flash_sale/controllers/flash_sale_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/flash_sale/domain/models/flash_sale_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/cart_count_view.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/organic_tag.dart';

class FlashSaleCard extends StatefulWidget {
  final List<ActiveProducts> activeProducts;
  final bool soldOut;
  const FlashSaleCard({super.key, required this.activeProducts, required this.soldOut});

  @override
  State<FlashSaleCard> createState() => _FlashSaleCardState();
}

class _FlashSaleCardState extends State<FlashSaleCard> {

  late PageController _pageController;
  int _currentPage = 1 ;
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.activeProducts.length > 1 ? 1: 0;
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.8);

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });

  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        AspectRatio(
          aspectRatio: ResponsiveHelper.isTab(context) ? 2.5 : ResponsiveHelper.isDesktop(context) ? 2 : 1.6,
          child: PageView.builder(
              itemCount: widget.activeProducts.length,
              allowImplicitScrolling: true,
              physics: const ClampingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int pageIndex) {
                Get.find<FlashSaleController>().setPageIndex(pageIndex);
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.zero,
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 0.0;
                      if(_pageController.position.haveDimensions){
                        value = index.toDouble() - (_pageController.page ?? 0);
                        value = (value * 0.038).clamp(-1, 1);
                      }
                      return Transform.rotate(
                          angle: pi * value,
                          child: carouselCard(index, widget.activeProducts[index])
                      );
                    },
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget carouselCard(int index, ActiveProducts activeProduct) {
    double? discount = activeProduct.item!.storeDiscount == 0 ? activeProduct.item!.discount : activeProduct.item!.storeDiscount;
    String? discountType = activeProduct.item!.storeDiscount == 0 ? activeProduct.item!.discountType : 'percent';
    return Column(children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
              vertical: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
            ),
            child: Hero(
              tag: "image$index",
              child: InkWell(
                hoverColor: Colors.transparent,
                onTap: widget.soldOut ? null : () => Get.find<ItemController>().navigateToItemPage(activeProduct.item, context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: CustomImage(
                          image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl!}/${activeProduct.item!.image}',
                          fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                        ),
                      ),

                      DiscountTag(
                        discount: discount,
                        discountType: discountType,
                        freeDelivery: false,
                        isFloating: true,
                      ),

                      OrganicTag(item: activeProduct.item!, placeInImage: false),

                      ResponsiveHelper.isMobile(context) ? Positioned(
                        bottom: -15, left: 0, right: 0,
                        child: widget.soldOut ? Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: 80, height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(112),
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
                            ),
                            child: Text('sold_out'.tr, style: robotoMedium.copyWith(color: Colors.red)),
                          ),
                        ) : CartCountView(
                          item: activeProduct.item!,
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 65, height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(112),
                                color: Theme.of(context).cardColor,
                                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
                              ),
                              child: Text("add".tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                            ),
                          ),
                        ),
                      ) : Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: widget.soldOut ? Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: 80, height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(112),
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
                            ),
                            child: Text('sold_out'.tr, style: robotoMedium.copyWith(color: Colors.red)),
                          ),
                        ) : CartCountView(
                          item: activeProduct.item!,
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 65, height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(112),
                                color: Theme.of(context).cardColor,
                                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
                              ),
                              child: Text("add".tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
