import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/rider_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'price_stack_tag.dart';

class TopRatedCars extends StatelessWidget {
  const TopRatedCars({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Text(
          'top_rated_cars'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        GetBuilder<RiderController>(
          builder: (riderController) {
            return riderController.topRatedVehicleModel != null && riderController.topRatedVehicleModel!.vehicles!.isNotEmpty ? SizedBox(
              height: 177,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: riderController.topRatedVehicleModel!.vehicles!.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 5),
                  child: InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getSelectRideMapLocationRoute("initial", null, riderController.topRatedVehicleModel!.vehicles![index])),
                    child: Container(
                      width: Get.width / 2.6,
                      decoration: BoxDecoration(
                        color:Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200]!, offset: const Offset(0, 3.75), blurRadius: 9.29)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Stack(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                          child: CustomImage(
                                              image: '${Get.find<SplashController>().configModel!.baseUrls!.vehicleImageUrl}/${riderController.topRatedVehicleModel!.vehicles![index].carImages!.isNotEmpty
                                                  ? riderController.topRatedVehicleModel!.vehicles![index].carImages![0] : ''}',
                                              height: 130,width: Get.width),
                                        ),
                                        ReviewStackTag(value: "${riderController.topRatedVehicleModel!.vehicles![index].avgRating}, (${riderController.topRatedVehicleModel!.vehicles![index].ratingCount} ${'review'.tr})")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    riderController.topRatedVehicleModel!.vehicles![index].name!,
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                                      child: CustomImage(height: 18, width: 18, image: '${Get.find<SplashController>().configModel!.baseUrls!.vehicleImageUrl}/'
                                          '${riderController.topRatedVehicleModel!.vehicles![index].provider != null ? riderController.topRatedVehicleModel!.vehicles![index].provider!.logo : ''}'),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text(
                                      riderController.topRatedVehicleModel!.vehicles![index].provider != null ? riderController.topRatedVehicleModel!.vehicles![index].provider!.name! : '',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                  )
                                ],
                              )
                            ]),
                      ),
                    ),
                  ),
                );
              }),
            ) : const SizedBox();
          }
        )


      ],
    );
  }
}
