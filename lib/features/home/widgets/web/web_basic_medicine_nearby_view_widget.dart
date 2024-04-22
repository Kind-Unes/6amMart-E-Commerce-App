import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/medicine_item_card.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class WebBasicMedicineNearbyViewWidget extends StatefulWidget {
  const WebBasicMedicineNearbyViewWidget({super.key});

  @override
  State<WebBasicMedicineNearbyViewWidget> createState() => _WebBasicMedicineNearbyViewWidgetState();
}

class _WebBasicMedicineNearbyViewWidgetState extends State<WebBasicMedicineNearbyViewWidget> {

  int selectedCategory = 0;
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
      List<Categories>? categories = [];
      List<Item>? products = [];

      if(itemController.basicMedicineModel != null){
        categories.add(Categories(name: 'all'.tr, id: 0));
        for (var category in itemController.basicMedicineModel!.categories!) {
          categories.add(category);
        }
        for (var product in itemController.basicMedicineModel!.products!) {
          if(selectedCategory == 0) {
            products.add(product);
          }
          if(categories[selectedCategory].id == product.categoryId){
            products.add(product);
          }
        }
      }

      if(itemController.basicMedicineModel != null && products.length > 4 && isFirstTime){
        showForwardButton = true;
        isFirstTime = false;
      }

      return products.isNotEmpty ? Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('basic_medicine_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Flexible(
              child: Container(
                height: 20, color: Theme.of(context).cardColor,
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedCategory == index;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedCategory = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: Text('${categories[index].name}', style: robotoMedium.copyWith(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)),
                          ),
                        ),
                      ],
                    );

                  },
                ),
              ),
            ),
          ]),
        ),

        Stack(children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            child: SizedBox(
              height: 250, width: Get.width,
              child: itemController.basicMedicineModel != null ?  ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                    child: MedicineItemCard(item: products[index]),
                  );
                },
              ) : const MedicineCardShimmer(),
            ),
          ),

          if(showBackButton)
            Positioned(
              top: 110, left: 0,
              child: ArrowIconButton(
                isRight: false,
                onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                    duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
              ),
            ),

          if(showForwardButton)
            Positioned(
              top: 110, right: 0,
              child: ArrowIconButton(
                onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                    duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
              ),
            ),

        ]),

      ]) : const SizedBox();
    });
  }
}


class MedicineCardShimmer extends StatelessWidget {
  const MedicineCardShimmer({super.key,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                width: ResponsiveHelper.isDesktop(context) ? 200 : 160, height: ResponsiveHelper.isDesktop(context) ? 250 : 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                ),
                child: Column(children: [
                  Container(
                    height: ResponsiveHelper.isDesktop(context) ? 150 : 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSmall), topRight: Radius.circular(Dimensions.radiusSmall)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10, width: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Container(
                            height: 10, width: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Container(
                            height: 10, width: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}



