import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/domain/models/user_information_body.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'widgets/car_cost.dart';
import 'widgets/car_info.dart';
import 'widgets/provider_details.dart';

class CarDetailsScreen extends StatelessWidget {
  final Vehicles vehicle;
  final UserInformationBody filterBody;
  const CarDetailsScreen({super.key, required this.vehicle, required this.filterBody});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'car_details'.tr),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                        child: CustomImage(
                            height: 200,
                            width: double.infinity,
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.vehicleImageUrl}/${vehicle.carImages!.isNotEmpty ? vehicle.carImages![0] : ''}')),
                    const SizedBox(height: 170)
                  ],
                ),
                CarInfo(vehicle: vehicle),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            CarCost(vehicle: vehicle, fareCategory: filterBody.fareCategory),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            ProviderDetails(vehicle: vehicle),
            const SizedBox(height: 100)
          ],
        ),
      ),
      bottomSheet: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: kElevationToShadow[4],
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: context.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${'total'.tr}: ',
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.4),
                          ),),
                        Text(
                          '${filterBody.distance}km',
                          style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.4)),
                        ),

                      ],
                    ),
                    Text(
                      PriceConverter.convertPrice(filterBody.distance! * (filterBody.fareCategory == 'hourly' ? vehicle.insidePerHourCharge! : vehicle.insidePerKmCharge!)),
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              CustomButton(
                width: 140,
                fontSize: Dimensions.fontSizeDefault,
                onPressed: () => Get.toNamed(RouteHelper.getBookingCheckoutScreen(vehicle, filterBody)),
                buttonText: 'rent_this_car'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }


}
