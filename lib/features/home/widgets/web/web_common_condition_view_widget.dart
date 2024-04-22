import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/home/widgets/web/web_basic_medicine_nearby_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/medicine_item_card.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class WebCommonConditionViewWidget extends StatefulWidget {
  const WebCommonConditionViewWidget({super.key});

  @override
  State<WebCommonConditionViewWidget> createState() => _WebCommonConditionViewWidgetState();
}

class _WebCommonConditionViewWidgetState extends State<WebCommonConditionViewWidget> {

  ScrollController scrollController = ScrollController();
  bool showBackButton = false;
  bool showForwardButton = false;
  bool isFirstTime = true;

  @override
  void initState() {

    if(Get.find<ItemController>().commonConditions!.isNotEmpty) {
      Get.find<ItemController>().getConditionsWiseItem(Get.find<ItemController>().commonConditions![0].id!, true);
    }

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

      if(itemController.conditionWiseProduct != null && itemController.conditionWiseProduct!.length > 4 && isFirstTime){
        showForwardButton = true;
        isFirstTime = false;
      }

      return (itemController.commonConditions != null && itemController.commonConditions!.isNotEmpty) ? Container(
        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge, horizontal: Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('common_condition'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(width: Dimensions.radiusExtraLarge),

                Flexible(
                  child: SizedBox(
                    height: 20,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemController.commonConditions!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        bool isSelected = itemController.selectedCommonCondition == index;
                        return InkWell(
                          hoverColor: Colors.transparent,
                          onTap: () => itemController.selectCommonCondition(index),
                          child: Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                            child: Text(
                              '${itemController.commonConditions![index].name}',
                              style: robotoMedium.copyWith(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]),
            ),

          Stack(children: [
              SizedBox(
                height: 250, width: Get.width,
                child: itemController.conditionWiseProduct != null ? itemController.conditionWiseProduct!.isNotEmpty ? ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                  itemCount: itemController.conditionWiseProduct!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                      child: MedicineItemCard(item: itemController.conditionWiseProduct![index]),
                    );
                  },
                ) : Center(child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Text('no_product_available'.tr),
                )) : const MedicineCardShimmer(),
              ),

              if(showBackButton)
                Positioned(
                  top: 100, left: 0,
                  child: ArrowIconButton(
                    isRight: false,
                    onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                  ),
                ),

              if(showForwardButton)
                Positioned(
                  top: 100, right: 0,
                  child: ArrowIconButton(
                    onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                  ),
                ),

            ]),

        ]),
      ) : const SizedBox();
    });
  }
}

