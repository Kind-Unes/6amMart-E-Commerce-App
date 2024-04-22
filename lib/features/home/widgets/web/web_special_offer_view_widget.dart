import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/common/widgets/card_design/item_card.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';

class WebSpecialOfferView extends StatefulWidget {
  final bool isFood;
  final bool isShop;
  const WebSpecialOfferView({super.key, required this.isFood, required this.isShop});

  @override
  State<WebSpecialOfferView> createState() => _WebSpecialOfferViewState();
}

class _WebSpecialOfferViewState extends State<WebSpecialOfferView> {

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
      List<Item>? discountedItemList = itemController.discountedItemList;

      if(discountedItemList != null && discountedItemList.length > 5 && isFirstTime){
        showForwardButton = true;
        isFirstTime = false;
      }

      return discountedItemList != null ? discountedItemList.isNotEmpty ? Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Column(children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeExtremeLarge),
                  child: TitleWidget(
                    title: 'special_offer'.tr,
                    image: Images.discountOfferIcon,
                    onTap: () => Get.toNamed(RouteHelper.getPopularItemRoute(false, true)),
                  ),
                ),

                SizedBox(
                  height: 285, width: Get.width,
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraLarge),
                    itemCount: discountedItemList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall),
                        child: ItemCard(
                          item: discountedItemList[index],
                          isShop: widget.isShop,
                          isFood: widget.isFood,
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),

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

      ]) : const SizedBox() : WebItemShimmerView(itemController: itemController);
    });
  }
}

class WebItemShimmerView extends StatelessWidget {
  final ItemController itemController;
  final bool isPopularItem;
  const WebItemShimmerView({super.key, required this.itemController, this.isPopularItem = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Stack(children: [

        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeExtremeLarge),
                  child: TitleWidget(
                    title: isPopularItem ? 'most_popular_items'.tr : 'special_offer'.tr,
                    image: isPopularItem ? Images.mostPopularIcon : Images.discountOfferIcon,
                  ),
                ),

                SizedBox(
                  height: 285, width: Get.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraLarge),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall),
                        child: Container(
                          height: 285, width: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                          ),
                          child: Column(children: [

                            Container(
                              height: 150, width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: Column(children: [

                                Container(
                                  height: 20, width: 100,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Container(
                                  height: 20, width: 200,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Container(
                                  height: 20, width: 100,
                                  color: Colors.grey[300],
                                ),

                              ]),
                            ),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
        ),

      ]),
    );
  }
}
