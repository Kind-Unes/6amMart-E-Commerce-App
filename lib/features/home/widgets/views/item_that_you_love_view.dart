import 'dart:math';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/components/item_that_you_love_card_widget.dart';
import 'package:sixam_mart/features/home/widgets/components/review_item_card_widget.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';

class ItemThatYouLoveView extends StatefulWidget {
  final bool forShop ;
  const ItemThatYouLoveView({super.key, required this.forShop});

  @override
  State<ItemThatYouLoveView> createState() => _ItemThatYouLoveViewState();
}

class _ItemThatYouLoveViewState extends State<ItemThatYouLoveView> {
  final SwiperController swiperController = SwiperController();

  late PageController _pageController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    if(Get.find<ItemController>().recommendedItemList != null){
      _currentPage = Get.find<ItemController>().recommendedItemList!.length > 1 ? 1: 0;
    }
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {

      List<Item>? recommendItems = itemController.recommendedItemList;

      return recommendItems != null ? recommendItems.isNotEmpty ? Column(children: [

        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
          child: Align(
            alignment: widget.forShop ? Alignment.center : Alignment.centerLeft,
            child: Text('item_that_you_love'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ),
        ),

        widget.forShop ? Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: Stack(
            children: [
              SizedBox(
                height: 300, width: Get.width,
                child: Swiper(
                  controller: swiperController,
                  itemBuilder: (BuildContext context, int index) {
                    return ReviewItemCard(item: recommendItems[index]);
                  },
                  itemCount: recommendItems.length,
                  itemWidth: 250,
                  itemHeight: 300,
                  layout: SwiperLayout.TINDER,
                ),
              ),

              Positioned(
                top: 150, right: 10,
                child: InkWell(
                  onTap: () => swiperController.next(),
                  child: Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
                ),
              ),

              Positioned(
                top: 150, left: 10,
                child: InkWell(
                  onTap: () => swiperController.previous(),
                  child: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ) : AspectRatio(
          aspectRatio: ResponsiveHelper.isTab(context) ? 2.5 : 1.0,
          child: PageView.builder(
            itemCount: recommendItems.length,
            allowImplicitScrolling: true,
            physics: const ClampingScrollPhysics(),
            controller: _pageController,
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.zero,
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 0.0;
                      if (_pageController.position.haveDimensions) {
                        value = index.toDouble() - (_pageController.page ?? 0);
                        value = (value * 0.038).clamp(-1, 1);
                      }
                      return Transform.rotate(
                        angle: pi * value,
                        child: carouselCard(index, recommendItems[index]),
                      );
                    },
                  ),
              );
            },
          ),
        ),
      ]) : const SizedBox() : ItemThatYouLoveShimmerView( forShop: widget.forShop);
      }
    );
  }

  Widget carouselCard(int index, Item item) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Hero(
        tag: "image$index",
        child: ItemThatYouLoveCard(item: item),
      ),
    );
  }
}

class ItemThatYouLoveShimmerView extends StatefulWidget {
  final bool forShop ;
  const ItemThatYouLoveShimmerView({super.key, required this.forShop});

  @override
  State<ItemThatYouLoveShimmerView> createState() => _ItemThatYouLoveShimmerViewState();
}

class _ItemThatYouLoveShimmerViewState extends State<ItemThatYouLoveShimmerView> {

  late PageController pageController;
  final int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
        child: widget.forShop ? Text('item_that_you_love'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))
            : TitleWidget(
          title: 'item_that_you_love'.tr,
        ),
      ),

      widget.forShop ? Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        child: Stack(
          children: [
            SizedBox(
              height: 300, width: Get.width,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 5,
                itemWidth: 250,
                itemHeight: 300,
                layout: SwiperLayout.TINDER,
              ),
            ),

          ],
        ),
      ) : AspectRatio(
        aspectRatio: 1.05,
        child: PageView.builder(
          controller: pageController,
          itemCount: 6,
          allowImplicitScrolling: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.zero,
              child: AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double value = 0.0;
                  return Transform.rotate(
                    angle: pi * value,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Hero(
                        tag: "image$index",
                        child: GestureDetector(
                          child:  Shimmer(
                            duration: const Duration(seconds: 2),
                            enabled: true,
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
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: Text("add".tr, style: robotoBold.copyWith(color: Theme.of(context).cardColor)),
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
                                        height: 5, width: 100,
                                        color: Theme.of(context).cardColor,
                                      ),

                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                                        Icon(Icons.star, size: 15, color: Theme.of(context).primaryColor),
                                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                        Container(
                                          height: 5, width: 100,
                                          color: Theme.of(context).cardColor,
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                        Container(
                                          height: 5, width: 100,
                                          color: Theme.of(context).cardColor,
                                        ),

                                      ]),

                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                                        Container(
                                          height: 5, width: 100,
                                          color: Theme.of(context).cardColor,
                                        ),
                                      ]),
                                    ]),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    ]);
  }
}