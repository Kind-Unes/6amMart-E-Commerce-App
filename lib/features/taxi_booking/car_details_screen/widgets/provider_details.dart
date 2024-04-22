import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class ProviderDetails extends StatelessWidget {
  final Vehicles vehicle;
  const ProviderDetails({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('provider_details'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("name".tr, vehicle.provider!.name!),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("contact".tr, vehicle.provider!.phone!),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("email".tr, vehicle.provider!.email!),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("address".tr, vehicle.provider!.address!),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("completed_trip".tr, vehicle.provider!.completedTrip.toString()),
          ],
        ),
      ),
    );
  }

  Widget _providerDetailsItem(String title,String subTitle,){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
        Text(subTitle,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
      ],
    );

  }

}
