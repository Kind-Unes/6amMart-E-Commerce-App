import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/components/review_item_card_widget.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class FeaturedCategoriesView extends StatelessWidget {
  const FeaturedCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Categories> categoryList = [];
      List<Item>? products = [];
      categoryList.add(Categories(id: 0, name: 'all'.tr));
      if (itemController.featuredCategoriesItem != null) {
        for (Categories category
            in itemController.featuredCategoriesItem!.categories!) {
          categoryList.add(category);
        }

        for (Item product in itemController.featuredCategoriesItem!.items!) {
          if (itemController.selectedCategory == 0) {
            products.add(product);
          }
          if (categoryList[itemController.selectedCategory].id ==
              product.categoryId) {
            products.add(product);
          }
        }
      }

      return itemController.featuredCategoriesItem != null
          ? itemController.featuredCategoriesItem!.items != null &&
                  itemController.featuredCategoriesItem!.items!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeDefault,
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Column(children: [
                          Text('featured_categories'.tr,
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          SizedBox(
                            height: 35,
                            child: ListView.builder(
                              itemCount: categoryList.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                bool isSelected =
                                    itemController.selectedCategory == index;
                                double width = double.parse(categoryList[index]
                                        .name!
                                        .length
                                        .toString()) *
                                    5;
                                return Column(children: [
                                  InkWell(
                                    onTap: () {
                                      itemController.selectCategory(index);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeDefault),
                                      child: Text('${categoryList[index].name}',
                                          style: robotoMedium.copyWith(
                                              color: isSelected
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .disabledColor)),
                                    ),
                                  ),
                                  isSelected
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              top: Dimensions
                                                  .paddingSizeExtraSmall),
                                          height: 2,
                                          width: width,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : const SizedBox(),
                                ]);
                              },
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: Dimensions.paddingSizeDefault,
                            mainAxisSpacing: Dimensions.paddingSizeDefault,
                            mainAxisExtent: 257,
                          ),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeDefault,
                              right: Dimensions.paddingSizeDefault,
                              bottom: Dimensions.paddingSizeDefault),
                          itemCount: products.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ReviewItemCard(
                              isFeatured: true,
                              item: products[index],
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                )
              : const SizedBox()
          : const FeaturedCategoriesShimmerView();
    });
  }
}

class FeaturedCategoriesShimmerView extends StatelessWidget {
  const FeaturedCategoriesShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeDefault,
                horizontal: Dimensions.paddingSizeDefault),
            child: Column(children: [
              Text('featured_categories'.tr,
                  style:
                      robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              const SizedBox(
                height: 35,
              ),
            ]),
          ),
          SizedBox(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Dimensions.paddingSizeDefault,
                mainAxisSpacing: Dimensions.paddingSizeDefault,
                mainAxisExtent: 250,
              ),
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeDefault,
                  right: Dimensions.paddingSizeDefault,
                  bottom: Dimensions.paddingSizeDefault),
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(
                    width: 160,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Dimensions.radiusSmall)),
                    ),
                    child: Column(children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.2),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radiusSmall),
                              topRight:
                                  Radius.circular(Dimensions.radiusSmall)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
