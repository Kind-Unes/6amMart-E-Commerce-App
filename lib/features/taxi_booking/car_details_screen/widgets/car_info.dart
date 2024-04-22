import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/ripple_button.dart';
import 'package:sixam_mart/features/taxi_booking/widgets/cost_variations_dialog.dart';


class CarInfo extends StatelessWidget {
  final Vehicles vehicle;
  const CarInfo({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    List carFeatureList = [
      {'icon': Images.riderSeat, 'name': '${vehicle.seatingCapacity} ${'seat'.tr}'},
      {'icon': Images.petrolIcon, 'name': '${vehicle.fuelType}'},
      {'icon': Images.riderKm, 'name': '${vehicle.engineCapacity}${vehicle.mileageType}'},
      {'icon': Images.carHp, 'name': '${vehicle.engineCapacity}cc'},
      {'icon': Images.riderSeat, 'name': 'Auto'},
      {'icon': Images.acIcon, 'name': vehicle.airCondition == 'yes' ? 'ac'.tr : 'non_ac'.tr},
    ];

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Theme.of(context).cardColor,
      child: SizedBox(
        height: 200,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vehicle.name!, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            color: Theme.of(context).primaryColor.withOpacity(.04),
                            border: Border.all(color: Theme.of(context).primaryColor)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeSmall,
                          ),
                          child: Text('cost_variation'.tr,style: robotoBold.copyWith(color: Theme.of(context).primaryColor),),
                        ),
                      ),
                      Positioned.fill(child: RippleButton(
                        radius: Dimensions.radiusDefault,
                          onTap: () {
                            Get.dialog(CostVariationsDialog(
                              onYesPressed: () {
                              },
                            ));
                          }),
                      )

                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Image.asset(Images.starFill,height: 10,width: 10,),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                  Text('${vehicle.avgRating},',style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                  ),),
                  Text(
                    "(${vehicle.ratingCount} ${'review'.tr})",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    GridView.builder(
                      itemCount: carFeatureList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {

                        return carFeatureItem(
                            carFeatureList.elementAt(index)['icon'],
                            carFeatureList.elementAt(index)['name']);
                      },),

                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),

            ],
          ),
        ),),
    );
  }

  Widget carFeatureItem(String imagePath,String title){
    return Row(
      children: [
        Image.asset(imagePath,height: 15,),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
        Text(title),
      ],
    );
  }
}
