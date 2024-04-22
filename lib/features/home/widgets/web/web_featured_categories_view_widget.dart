import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/components/review_item_card_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_basic_medicine_nearby_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class WebFeaturedCategoriesViewWidget extends StatefulWidget {
  const WebFeaturedCategoriesViewWidget({super.key});

  @override
  State<WebFeaturedCategoriesViewWidget> createState() => _WebFeaturedCategoriesViewWidgetState();
}

class _WebFeaturedCategoriesViewWidgetState extends State<WebFeaturedCategoriesViewWidget> {

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
          List<Categories> categoryList = [];
          List<Item>? products = [];
          categoryList.add(Categories(id: 0, name: 'all'.tr));
          if(itemController.featuredCategoriesItem != null) {
            for(Categories category in itemController.featuredCategoriesItem!.categories!) {
              categoryList.add(category);
            }
            for (Item product in itemController.featuredCategoriesItem!.items!) {
              if(itemController.selectedCategory == 0) {
                products.add(product);
              }
              if(categoryList[itemController.selectedCategory].id == product.categoryId){
                products.add(product);
              }
            }
          }


          if(products.length >= 6 && isFirstTime){
            showForwardButton = true;
            isFirstTime = false;
          }

          return itemController.featuredCategoriesItem != null ? itemController.featuredCategoriesItem!.items!.isNotEmpty ? Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
                  child: Column(children: [
                    Text('featured_categories'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    SizedBox(
                      height: 35,
                      child: ListView.builder(
                        itemCount: categoryList.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          bool isSelected = itemController.selectedCategory == index;
                          double width = double.parse(categoryList[index].name!.length.toString()) * 5;
                          return Column(children: [
                            InkWell(
                              onTap: () {
                                itemController.selectCategory(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: Text('${categoryList[index].name}', style: robotoMedium.copyWith(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)),
                              ),
                            ),

                            isSelected ? Container(
                              margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                              height: 2, width: width,
                              color: Theme.of(context).primaryColor,
                            ) : const SizedBox(),
                          ]);

                        },
                      ),
                    ),

                  ]),
                ),

                Stack(
                  children: [
                    SizedBox(
                      height: 285, width: Get.width,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                            child: ReviewItemCard(
                              isFeatured: true,
                              item: products[index],
                            ),
                          );
                        },
                      ),
                    ),

                    if(showForwardButton)
                      Positioned(
                        top: 90, right: 0,
                        child: ArrowIconButton(
                          onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                              duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                        ),
                      ),

                    if(showBackButton)
                      Positioned(
                        top: 90, left: 0,
                        child: ArrowIconButton(
                          onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                              duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                          isRight: false,
                        ),
                      ),

                  ],
                ),

              ]),
            ),
          ) : const SizedBox() : const WebFeaturedCategoriesShimmerView();
        }
    );
  }
}

class WebFeaturedCategoriesShimmerView extends StatelessWidget {
  const WebFeaturedCategoriesShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
            child: Column(children: [
              Text('featured_categories'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              const SizedBox(
                height: 35,
              ),
            ]),
          ),

          const MedicineCardShimmer()
        ]),
      ),
    );
  }
}
