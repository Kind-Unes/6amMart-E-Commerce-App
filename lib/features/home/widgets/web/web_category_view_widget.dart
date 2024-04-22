import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';

class WebCategoryViewWidget extends StatefulWidget {
  final CategoryController categoryController;
  const WebCategoryViewWidget({super.key, required this.categoryController});

  @override
  State<WebCategoryViewWidget> createState() => _WebCategoryViewWidgetState();
}

class _WebCategoryViewWidgetState extends State<WebCategoryViewWidget> {
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
    bool isPharmacy = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.pharmacy;
    bool isFood = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.food;

    if(widget.categoryController.categoryList != null && widget.categoryController.categoryList!.length > 9 && isFirstTime){
      showForwardButton = true;
      isFirstTime = false;
    }

    return isPharmacy ? PharmacyCategoryView(categoryController: widget.categoryController) : isFood ? FoodCategoryView(categoryController: widget.categoryController) : Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        SizedBox(
          height: 190, width: Get.width,
          child: widget.categoryController.categoryList != null ? ListView.builder(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
            itemCount: widget.categoryController.categoryList!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeExtremeLarge),
                child: InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () => Get.toNamed(RouteHelper.getCategoryItemRoute(
                    widget.categoryController.categoryList![index].id, widget.categoryController.categoryList![index].name!,
                  )),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: TextHover(
                    builder: (hovered) {
                      return Container(
                        width: 108,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
                        ),
                        child: Column(children: [

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: Theme.of(context).disabledColor.withOpacity(0.3),
                              border: Border.all(color: hovered ? Theme.of(context).primaryColor : Theme.of(context).cardColor, width: hovered ? 1 : 0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: CustomImage(
                                image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${widget.categoryController.categoryList![index].image}',
                                height: 80, width: double.infinity, fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Expanded(child: Text(
                            widget.categoryController.categoryList![index].name!,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color),
                            maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                          )),
                        ]),
                      );
                    }
                  ),
                ),
              );
            },
          ) : WebCategoryShimmer(categoryController: widget.categoryController),
        ),
      ]),

      if(showForwardButton)
      Positioned(
        top: 80, right: 0,
        child: ArrowIconButton(
          onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
              duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
        ),
      ),

      if(showBackButton)
      Positioned(
        top: 80, left: 0,
        child: ArrowIconButton(
          onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
              duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
          isRight: false,
        ),
      ),
    ]);
  }
}

class PharmacyCategoryView extends StatefulWidget {
  final CategoryController categoryController;
  const PharmacyCategoryView({super.key, required this.categoryController});

  @override
  State<PharmacyCategoryView> createState() => _PharmacyCategoryViewState();
}

class _PharmacyCategoryViewState extends State<PharmacyCategoryView> {

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

    if(widget.categoryController.categoryList != null && widget.categoryController.categoryList!.length > 9 && isFirstTime){
      showForwardButton = true;
      isFirstTime = false;
    }

    return Stack(children: [

        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            SizedBox(
              height: 170, width: Get.width,
              child: widget.categoryController.categoryList != null ? ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.categoryController.categoryList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeSmall,
                      left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                      right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                    ),
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      onTap: () => Get.toNamed(RouteHelper.getCategoryItemRoute(
                        widget.categoryController.categoryList![index].id, widget.categoryController.categoryList![index].name!,
                      )),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.3),
                              Theme.of(context).cardColor.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Column(children: [

                          ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${widget.categoryController.categoryList![index].image}',
                              height: 80, width: double.infinity, fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Expanded(child: Text(
                            widget.categoryController.categoryList![index].name!,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color),
                            maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                          )),
                        ]),
                      ),
                    ),
                  );
                },
              ) : WebPharmacyShimmerView(categoryController: widget.categoryController),
            ),
          ]),
        ),

      if(showForwardButton)
        Positioned(
          top: 75, right: 0,
          child: ArrowIconButton(
            onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
          ),
        ),

      if(showBackButton)
        Positioned(
          top: 75, left: 0,
          child: ArrowIconButton(
            onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            isRight: false,
          ),
        ),

    ]);
  }
}

class FoodCategoryView extends StatefulWidget {
  final CategoryController categoryController;
  const FoodCategoryView({super.key, required this.categoryController});

  @override
  State<FoodCategoryView> createState() => _FoodCategoryViewState();
}

class _FoodCategoryViewState extends State<FoodCategoryView> {

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

    if(widget.categoryController.categoryList != null && widget.categoryController.categoryList!.length > 8 && isFirstTime){
      showForwardButton = true;
      isFirstTime = false;
    }

    return Stack(children: [

        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          SizedBox(
            height: 205, width: Get.width,
            child: widget.categoryController.categoryList != null ? ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.categoryController.categoryList!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeLarge,
                    left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                    right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                  ),
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () => Get.toNamed(RouteHelper.getCategoryItemRoute(
                      widget.categoryController.categoryList![index].id, widget.categoryController.categoryList![index].name!,
                    )),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: SizedBox(
                      width: 120,
                      child: Column(children: [

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                            color: Theme.of(context).cardColor,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${widget.categoryController.categoryList![index].image}',
                              height: 120, width: double.infinity, fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Expanded(child: Text(
                          widget.categoryController.categoryList![index].name!,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color),
                          maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                        )),
                      ]),
                    ),
                  ),
                );
              },
            ) : WebFoodCategoryShimmer(categoryController: widget.categoryController),
          ),
        ]),

      if(showForwardButton)
        Positioned(
          top: 60, right: 0,
          child: ArrowIconButton(
            onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
          ),
        ),

      if(showBackButton)
        Positioned(
          top: 60, left: 0,
          child: ArrowIconButton(
            onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            isRight: false,
          ),
        ),
    ]);
  }
}

class WebFoodCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const WebFoodCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeSmall,
            left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
            right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 120,
              child: Column(children: [

                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey[300]),
                  height: 120, width: 120,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Container(
                    height: 15, width: 150, color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class WebCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const WebCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
            child: Container(
              width: 108,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                enabled: categoryController.categoryList == null,
                child: Column(children: [

                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
                    height: 80, width: 70,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(height: 15, width: 150, color: Colors.grey[300]),

                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WebPharmacyShimmerView extends StatelessWidget {
  final CategoryController categoryController;
  const WebPharmacyShimmerView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 12,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
            left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
            right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 100,
              child: Column(children: [

                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                    color: Colors.grey[300],
                  ),
                  height: 80, width: 100,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Container(
                    height: 15, width: 150, color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
