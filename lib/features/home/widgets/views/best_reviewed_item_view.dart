import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/components/review_item_card_widget.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';

class BestReviewItemView extends StatefulWidget {
  const BestReviewItemView({super.key});

  @override
  State<BestReviewItemView> createState() => _BestReviewItemViewState();
}

class _BestReviewItemViewState extends State<BestReviewItemView> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Item>? reviewItemList = itemController.reviewedItemList;

      return Column(children: [

        Padding(
          padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
          child: TitleWidget(
            title: 'best_reviewed_item'.tr,
            onTap: () => Get.toNamed(RouteHelper.getPopularItemRoute(false, false)),
          ),
        ),

        SizedBox(
          height: 285, width: Get.width,
          child: reviewItemList != null ? ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
            itemCount: reviewItemList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                child: CustomInkWell(
                  onTap: () => Get.find<ItemController>().navigateToItemPage(reviewItemList[index], context),
                  child: ReviewItemCard(
                    item: itemController.reviewedItemList![index],
                  ),
                ),
              );
            },
          ) : const BestReviewItemShimmer(),
        ),
      ]);
    });
  }
}

class BestReviewItemShimmer extends StatelessWidget {
  const BestReviewItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
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
                      top: 10, right: 10,
                      child: Icon(Icons.favorite, size: 20, color: Theme.of(context).cardColor),
                    ),


                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 100, width: double.infinity,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                  color: Theme.of(context).cardColor
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                Container(
                                  width: 100, height: 10,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Container(
                                  width: 100, height: 10,
                                  color: Colors.grey[300],
                                ),
                              ]),
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
        );
      },
    );
  }
}
