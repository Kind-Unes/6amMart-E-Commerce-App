import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/card_design/visit_again_card.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/home/widgets/components/custom_triangle_shape.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class VisitAgainView extends StatefulWidget {
  final bool? fromFood;
  const VisitAgainView({super.key, this.fromFood = false});

  @override
  State<VisitAgainView> createState() => _VisitAgainViewState();
}

class _VisitAgainViewState extends State<VisitAgainView> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
        List<Store>? stores = storeController.visitAgainStoreList;

      return stores != null ? stores.isNotEmpty ? Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        child: Stack(clipBehavior: Clip.none, children: [

            Container(
              height: 150, width: double.infinity,
              color: Theme.of(context).primaryColor,
            ),

            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Column(children: [

                Text(widget.fromFood! ? "wanna_try_again".tr : "visit_again".tr, style: robotoBold.copyWith(color: Theme.of(context).cardColor)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  'get_your_recent_purchase_from_the_shop_you_recently_visited'.tr,
                  style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CarouselSlider.builder(
                  itemCount: stores.length,
                  options: CarouselOptions(
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    disableCenter: true,
                  ),
                  itemBuilder: (BuildContext context, int index, int realIndex) {
                  return VisitAgainCard(store: stores[index], fromFood: widget.fromFood!);
                  },
                ),
              ]),
            ),

          const Positioned(
            top: 20, left: 10,
            child: TriangleWidget(),
          ),

          const Positioned(
            top: 10, right: 100,
            child: TriangleWidget(),
          ),
        ]),
      ) : const SizedBox() : const VisitAgainShimmerView();
    });
  }
}

class VisitAgainShimmerView extends StatelessWidget {
  const VisitAgainShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Stack(clipBehavior: Clip.none, children: [

        Container(
          height: 150, width: double.infinity,
          color: Theme.of(context).primaryColor,
        ),

        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Column(children: [

              Container(
                height: 10, width: 100,
                color: Colors.grey[300],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                height: 10, width: 200,
                color: Colors.grey[300],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CarouselSlider.builder(
                itemCount: 5,
                options: CarouselOptions(
                  aspectRatio: 2.2,
                  enlargeCenterPage: true,
                  disableCenter: true,
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Colors.grey[300],
                    ),
                  );
                },
              ),
            ]),
          ),
        ),

        const Positioned(
          top: 20, left: 10,
          child: TriangleWidget(),
        ),

        const Positioned(
          top: 10, right: 100,
          child: TriangleWidget(),
        ),
      ]),
    );
  }
}
