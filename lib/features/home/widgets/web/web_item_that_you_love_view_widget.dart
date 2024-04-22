import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/components/item_that_you_love_card_widget.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/add_favourite_view.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';

class WebItemThatYouLoveViewWidget extends StatefulWidget {
  const WebItemThatYouLoveViewWidget({super.key});

  @override
  State<WebItemThatYouLoveViewWidget> createState() => _WebItemThatYouLoveViewWidgetState();
}

class _WebItemThatYouLoveViewWidgetState extends State<WebItemThatYouLoveViewWidget> {
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    bool isShop = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.ecommerce;
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Item>? recommendItems = itemController.recommendedItemList;

      return recommendItems != null ? recommendItems.isNotEmpty ? Stack(children: [
          Column(children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child: Text('item_that_you_love'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            ),

            !isShop ? CarouselSlider.builder(
              itemCount: recommendItems.length,
              carouselController: carouselController,
              options: CarouselOptions(
                height: 400,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: .25,
                enlargeFactor: 0.2,
                onPageChanged: (index, reason) {},
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: ItemThatYouLoveCard(item: recommendItems[index]),
                );
              },
            ) : SizedBox(
              height: 285,
              child: ListView.builder(
                //controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                itemCount: recommendItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : Dimensions.paddingSizeDefault),
                    child: OnHover(
                      isItem: true,
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () =>  Get.find<ItemController>().navigateToItemPage(recommendItems[index], context),
                        child: Container(
                          width: 210, height: 285,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).colorScheme.error,
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Expanded(
                              child: Stack(children: [
                                Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                                    child: CustomImage(
                                      image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}'
                                          '/${recommendItems[index].image}',
                                      fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                                    ),
                                  ),
                                ),

                                AddFavouriteView(
                                  top: 10, right: 10,
                                  item: Item(id: recommendItems[index].id),
                                ),

                                DiscountTag(
                                  discount: Get.find<ItemController>().getDiscount(recommendItems[index]),
                                  discountType: Get.find<ItemController>().getDiscountType(recommendItems[index]),
                                ),

                                Positioned(
                                  bottom: 0, left: 0, right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                            color: Theme.of(context).cardColor,
                                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1.2))],
                                          ),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Text(recommendItems[index].name!, style: robotoBold, maxLines: 1, overflow: TextOverflow.ellipsis),

                                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              Icon(Icons.star, size: 15, color: Theme.of(context).primaryColor),
                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                              Text(recommendItems[index].avgRating!.toStringAsFixed(1), style: robotoRegular),
                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                              Text("(${recommendItems[index].ratingCount})", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                            ]),


                                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              recommendItems[index].discount! > 0  ? Flexible(child: Text(
                                                  PriceConverter.convertPrice(
                                                    Get.find<ItemController>().getStartingPrice(recommendItems[index]),
                                                  ),
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough,
                                                  ))) : const SizedBox(),
                                              SizedBox(width: recommendItems[index].discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                                              Text(
                                                PriceConverter.convertPrice(
                                                  Get.find<ItemController>().getStartingPrice(recommendItems[index]),
                                                  discount: recommendItems[index].discount,
                                                  discountType: recommendItems[index].discountType,
                                                ),
                                                style: robotoMedium, textDirection: TextDirection.ltr,
                                              ),
                                            ]),
                                          ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ]),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),

        Positioned(
          top: 220, right: 0,
          child: ArrowIconButton(
            onTap: () => carouselController.nextPage(),
          ),
        ),

        Positioned(
          top: 220, left: 0,
          child: ArrowIconButton(
            onTap: () => carouselController.previousPage(),
            isRight: false,
          ),
        ),

      ]) : const SizedBox() : WebItemThatYouLoveShimmerView(itemController: itemController);
    });
  }
}

class WebItemThatYouLoveForShop extends StatefulWidget {
  const WebItemThatYouLoveForShop({super.key});

  @override
  State<WebItemThatYouLoveForShop> createState() => _WebItemThatYouLoveForShopState();
}

class _WebItemThatYouLoveForShopState extends State<WebItemThatYouLoveForShop> {

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
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Item>? recommendItems = itemController.recommendedItemList;

      if(recommendItems != null && recommendItems.length > 5 && isFirstTime){
        showForwardButton = true;
        isFirstTime = false;
      }

      return recommendItems != null ? recommendItems.isNotEmpty ? Stack(children: [
        Column(children: [

          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Text('item_that_you_love'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ),

          Container(
            color: Theme.of(context).cardColor,
            height: 285, width: Get.width,
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              itemCount: recommendItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : Dimensions.paddingSizeDefault),
                  child: OnHover(
                    isItem: true,
                    child: InkWell(
                      onTap: () =>  Get.find<ItemController>().navigateToItemPage(recommendItems[index], context),
                      child: Container(
                        width: 210, height: 285,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Expanded(
                            child: Stack(children: [
                              Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                                  child: CustomImage(
                                    image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}'
                                        '/${recommendItems[index].image}',
                                    fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                                  ),
                                ),
                              ),

                              AddFavouriteView(
                                top: 10, right: 10,
                                item: Item(id: recommendItems[index].id),
                              ),

                              DiscountTag(
                                discount: Get.find<ItemController>().getDiscount(recommendItems[index]),
                                discountType: Get.find<ItemController>().getDiscountType(recommendItems[index]),
                              ),

                              Positioned(
                                bottom: 0, left: 0, right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                          color: Theme.of(context).cardColor,
                                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1.2))],
                                        ),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(recommendItems[index].name!, style: robotoBold, maxLines: 1, overflow: TextOverflow.ellipsis),

                                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(Icons.star, size: 15, color: Theme.of(context).primaryColor),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            Text(recommendItems[index].avgRating!.toStringAsFixed(1), style: robotoRegular),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            Text("(${recommendItems[index].ratingCount})", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                          ]),


                                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            recommendItems[index].discount! > 0  ? Flexible(child: Text(
                                                PriceConverter.convertPrice(
                                                  Get.find<ItemController>().getStartingPrice(recommendItems[index]),
                                                ),
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough,
                                                ))) : const SizedBox(),
                                            SizedBox(width: recommendItems[index].discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                                            Text(
                                              PriceConverter.convertPrice(
                                                Get.find<ItemController>().getStartingPrice(recommendItems[index]),
                                                discount: recommendItems[index].discount,
                                                discountType: recommendItems[index].discountType,
                                              ),
                                              style: robotoMedium, textDirection: TextDirection.ltr,
                                            ),
                                          ]),
                                        ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ]),
                          ),
                        ]),
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
            top: 200, left: 0,
            child: ArrowIconButton(
              isRight: false,
              onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            ),
          ),

        if(showForwardButton)
          Positioned(
            top: 200, right: 0,
            child: ArrowIconButton(
              onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            ),
          ),

      ]) : const SizedBox() : const WebItemThatYouLoveForShopShimmer();
    });
  }
}

class WebItemThatYouLoveForShopShimmer extends StatelessWidget {
  const WebItemThatYouLoveForShopShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [

        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Text('item_that_you_love'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        ),

        Shimmer(
          enabled: true,
          duration: const Duration(seconds: 2),
          child: Container(
            color: Theme.of(context).cardColor,
            height: 285, width: Get.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : Dimensions.paddingSizeDefault),
                  child: Container(
                    width: 210, height: 285,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Colors.grey[300],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Expanded(
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                              child: Container(
                                color: Colors.grey[300],
                                width: 210, height: 285,
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Container(
                                        width: 100, height: 10,
                                        color: Colors.grey[300],
                                      ),

                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Icon(Icons.star, size: 15, color: Theme.of(context).primaryColor),
                                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                        Text('0.0', style: robotoRegular),
                                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                        Text("(0)", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                      ]),

                                      Container(
                                        width: 100, height: 10,
                                        color: Colors.grey[300],
                                      ),

                                    ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ]),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ),
      ]),

    ]);
  }
}


class WebItemThatYouLoveShimmerView extends StatelessWidget {
  final ItemController itemController;
  const WebItemThatYouLoveShimmerView({super.key, required this.itemController});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Column(children: [

        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Text('item_that_you_love'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        ),

        CarouselSlider.builder(
          itemCount: 5,
          options: CarouselOptions(
            height: 400,
            enlargeCenterPage: true,
            disableCenter: true,
            viewportFraction: .25,
            enlargeFactor: 0.2,
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Colors.grey[300],
                ),
                child: Column(children: [

                  Expanded(
                    flex: 7,
                    child: Stack(clipBehavior: Clip.none, children: [

                      Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: Container(
                            height: double.infinity, width: double.infinity,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: -10, left: 0, right: 0,
                        child: Center(
                          child: Container(alignment: Alignment.center,
                            width: 65, height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(112),
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        Container(
                          height: 20, width: 100,
                          color: Theme.of(context).cardColor,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          height: 20, width: 200,
                          color: Theme.of(context).cardColor,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          height: 20, width: 100,
                          color: Theme.of(context).cardColor,
                        ),

                      ]),
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
      ]),
    );
  }
}
