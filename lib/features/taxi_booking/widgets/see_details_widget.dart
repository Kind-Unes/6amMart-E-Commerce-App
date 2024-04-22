import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/rider_controller.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/dotted_line.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/pick_and_destination_address_info.dart';
class SeeDetailsWidget extends StatefulWidget {
  const SeeDetailsWidget({super.key});

  @override
  State<SeeDetailsWidget> createState() => _SeeDetailsWidgetState();
}

class _SeeDetailsWidgetState extends State<SeeDetailsWidget> {
  @override
  void initState() {
    super.initState();
    Get.find<RiderController>().setFromToMarker(
      from: LatLng(double.parse(Get.find<RiderController>().fromAddress!.latitude!), double.parse(Get.find<RiderController>().fromAddress!.longitude!)),
      to: LatLng(double.parse(Get.find<RiderController>().toAddress!.latitude!), double.parse(Get.find<RiderController>().toAddress!.longitude!)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<RiderController>(
        builder: (riderController) {
          Completer<GoogleMapController> mapCompleter = Completer<GoogleMapController>();
          if(riderController.mapController != null){
            mapCompleter.complete(riderController.mapController);
          }
          return Column(mainAxisSize: MainAxisSize.min, children: [

            const SizedBox(height: Dimensions.paddingSizeDefault),
            Center(
              child: Container(
                height: 5, width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue,
              child: Animarker(
                curve: Curves.easeIn,
                rippleRadius: 0.2,
                useRotation: true,
                duration: const Duration(milliseconds: 2300),
                mapId: mapCompleter.future.then<int>((value) => value.mapId),
                markers: riderController.markers.values.toSet(),
                child: GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(target: riderController.initialPosition,zoom: 15),
                  onMapCreated: (controller) {
                    riderController.setMapController(controller);
                  },
                  polylines: Set<Polyline>.of(riderController.polyLines.values),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('trip_info'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),),
                // Image.asset(Images.edit, width: 16.0, height: 16.0),
                const SizedBox()
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            ///pick up and destination address
            SizedBox(
              height: 90,
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 33, width: 33,
                        alignment: Alignment.center,
                        decoration: riderContainerDecoration,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              height: 18, width: 18,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.all(Radius.circular(2)),
                              ),
                            ),
                            Container(
                              height: 4,
                              width: 4,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DottedLine(
                        lineLength: 20,
                        direction: Axis.vertical,
                        dashLength: 3,
                        dashGapLength: 1  ,
                        dashColor: Theme.of(context).primaryColor,
                      ),
                      Container(
                        height: 33,
                        width: 33, alignment: Alignment.center,
                        decoration: riderContainerDecoration,
                        child: Icon(Icons.location_on_sharp,color: Theme.of(context).primaryColor,),
                      ),
                    ],
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: RideAddressInfo(
                            title: riderController.fromAddress!.address,
                            subTitle: '${riderController.fromAddress!.streetNumber != null ? '${riderController.fromAddress!.streetNumber!}, ' : '' }'
                                '${riderController.fromAddress!.house ?? ''}',
                            isInsideCity:true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: RideAddressInfo(
                            title: riderController.toAddress!.address,
                            subTitle: '${riderController.toAddress!.streetNumber != null ? '${riderController.toAddress!.streetNumber!}, ' : '' }'
                                '${riderController.toAddress!.house ?? ''}',
                            isInsideCity:true,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(
              children: [
                Container(
                  height: 33, width: 33, alignment: Alignment.center,
                  decoration: riderContainerDecoration,
                  child: Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('date'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          Text(
                            riderController.tripDate ?? 'not set yet',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                                color: riderController.tripDate != null ? Theme.of(context).textTheme.bodyMedium!.color : Colors.red),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => riderController.setDate(),
                        child: Image.asset(Images.edit, width: 16.0, height: 16.0),
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(
              children: [
                Container(
                  height: 33, width: 33, alignment: Alignment.center,
                  decoration: riderContainerDecoration,
                  child: Icon(Icons.access_time, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('time'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          Text(
                            riderController.tripTime != null ? DateConverter.convertTimeToTime(riderController.tripTime!) : 'not set yet',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                                color: riderController.tripTime != null ? Theme.of(context).textTheme.bodyMedium!.color : Colors.red),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => riderController.setTime(context),
                        child: Image.asset(Images.edit, width: 16.0, height: 16.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(
              children: [
                Container(
                  height: 33, width: 33, alignment: Alignment.center,
                  decoration: riderContainerDecoration,
                  child: Icon(Icons.timer, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('rent_type'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          Text(
                              riderController.carType == 0 ? 'hourly'.tr : 'distance_wise'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                                color: riderController.tripTime != null ? Theme.of(context).textTheme.bodyMedium!.color : Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(
              children: [
                Container(
                  height: 33, width: 33, alignment: Alignment.center,
                  decoration: riderContainerDecoration,
                  child: Icon(Icons.keyboard_return_rounded, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('return'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          Text(
                              'N/A',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyMedium!.color),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ]);
        }
      ),
    );
  }
}
