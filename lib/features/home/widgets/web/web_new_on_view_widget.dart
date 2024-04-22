import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/card_design/store_card_with_distance.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';

class WebNewOnViewWidget extends StatefulWidget {
  final bool isFood;
  const WebNewOnViewWidget({super.key, this.isFood = false});

  @override
  State<WebNewOnViewWidget> createState() => _WebNewOnViewWidgetState();
}

class _WebNewOnViewWidgetState extends State<WebNewOnViewWidget> {

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
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
        child: TitleWidget(
          title: widget.isFood ? 'best_store_nearby'.tr : '${'new_on'.tr} ${AppConstants.appName}',
          onTap: () => Get.toNamed(RouteHelper.getAllStoreRoute('latest', isNearbyStore: widget.isFood ? true : false)),
        ),
      ),

      GetBuilder<StoreController>(builder: (storeController) {
        List<Store>? storeList = storeController.popularStoreList;

        if(storeList != null && storeList.length > 4 && isFirstTime){
          showForwardButton = true;
          isFirstTime = false;
        }

        return storeList != null && storeList.isNotEmpty ? Stack(children: [
          SizedBox(
            height: 215,
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              //padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              itemCount: storeList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
                    left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                    right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                  ),
                  child: StoreCardWithDistance(store: storeList[index]),
                );
              }),
          ),

          if(showBackButton)
            Positioned(
              top: 70, left: 0,
              child: ArrowIconButton(
                isRight: false,
                onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                    duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
              ),
            ),

          if(showForwardButton)
            Positioned(
              top: 70, right: 0,
              child: ArrowIconButton(
                onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                    duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
              ),
            ),

        ]) : const WebNewOnShimmerView();
      }),
    ]);
  }
}

class WebNewOnShimmerView extends StatelessWidget {
  final bool fromAllStore;
  const WebNewOnShimmerView({super.key, this.fromAllStore = false});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: SizedBox(
          height: 215,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: fromAllStore ? Axis.vertical : Axis.horizontal,
              //padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              itemCount: 5,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
                    left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                    right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                  ),
                  child: Stack(children: [
                    Container(
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Column(children: [
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                            child: Stack(clipBehavior: Clip.none, children: [
                              Container(
                                height: double.infinity, width: double.infinity,
                                color: Colors.grey[300],
                              ),

                              Positioned(
                                top: 15, right: 15,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).cardColor.withOpacity(0.8),
                                  ),
                                  child: Icon(Icons.favorite_border, color: Colors.grey[300], size: 20),
                                ),
                              ),
                            ]),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Column(children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 95),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Expanded(
                                    child: Container(
                                      height: 5, width: 100,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),

                                  Row(children: [
                                    Icon(Icons.location_on_outlined, color: Theme.of(context).cardColor, size: 15),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Expanded(
                                      child: Container(
                                        height: 10, width: 100,
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                  ]),
                                ]),
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Container(
                                    height: 10, width: 70,
                                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                                    ),
                                  ),

                                  Container(
                                    height: 20, width: 65,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    ),

                    Positioned(
                      top: 60, left: 15,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 65, width: 65,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                );
              },
          ),
        ),
      ),
    ]);
  }
}

