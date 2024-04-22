import 'package:flutter/material.dart';
import 'package:sixam_mart/features/profile/domain/models/user_information_body.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'rider_car_card.dart';

class RiderCarList extends StatelessWidget {
  final VehicleModel? vehicleModel;
  final UserInformationBody filterBody;
  const RiderCarList({super.key, required this.vehicleModel, required this.filterBody});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: UniqueKey(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: Dimensions.paddingSizeLarge,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ?
        Dimensions.paddingSizeLarge : 3,
        childAspectRatio: ResponsiveHelper.isMobile(context) ?  1.6 : 6,
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 :2,
        mainAxisExtent:ResponsiveHelper.isMobile(context) ? 245 : 125,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: vehicleModel!.vehicles!.length,
      itemBuilder: (context,index){
        return RiderCarCard(vehicle: vehicleModel!.vehicles![index], filterBody: filterBody);
      },
    );
  }
}
