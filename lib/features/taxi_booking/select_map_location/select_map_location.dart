import 'dart:async';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/rider_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/rider_type.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/rider_address_input_field.dart';
import 'widgets/available_service_info.dart';
import 'widgets/car_will_arrived_info.dart';

class SelectMapLocation extends StatefulWidget {
  final String? riderType;
  final AddressModel? address;
  final Vehicles? vehicle;
  const SelectMapLocation({super.key,required this.riderType, required this.address, this.vehicle});

  @override
  State<SelectMapLocation> createState() => _SelectMapLocationState();
}

class _SelectMapLocationState extends State<SelectMapLocation> {
  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print('-------rider type : ${widget.riderType}/ ${widget.address}');
    }

    Get.find<RiderController>().initializeData(widget.riderType, widget.address);
    Get.find<RiderController>().getInitialLocation(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:ResponsiveHelper.isDesktop(context) ? null : CustomAppBar(title: 'location'.tr),
      body: GetBuilder<RiderController>(
        builder: (riderController){
          Completer<GoogleMapController> mapCompleter = Completer<GoogleMapController>();
          if(riderController.mapController != null){
            mapCompleter.complete(riderController.mapController);
          }
          return ExpandableBottomSheet(
              background: Stack(
                children: [
                  Animarker(
                    curve: Curves.easeIn,
                    rippleRadius: 0.2,
                    useRotation: true,
                    duration: const Duration(milliseconds: 2300),
                    mapId: mapCompleter.future.then<int>((value) => value.mapId),
                    markers: riderController.markers.values.toSet(),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(target: riderController.initialPosition,zoom: 15),
                      onMapCreated: (controller) {
                        riderController.setMapController(controller);
                        riderController.getInitialLocation(widget.address);
                      },
                      polylines: Set<Polyline>.of(riderController.polyLines.values),
                    ),
                  ),


                  (riderController.rideStatus == RiderType.initial) ?
                  Positioned(
                    right: 10, bottom: 120,
                    child: Column(
                      children: [
                        Container(
                          height: 30, width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).cardColor,
                          ),
                          child: InkWell(
                            onTap: () => riderController.mapController!.animateCamera(CameraUpdate.zoomIn()),
                            child: Icon(Icons.add, size: 20,color: Theme.of(context).primaryColor,),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                        Container(
                          height: 30, width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).cardColor,
                          ),
                          child: InkWell(
                            onTap: () => riderController.mapController!.animateCamera(CameraUpdate.zoomOut()),
                            child: Icon(Icons.remove, size: 20,color:Theme.of(context).primaryColor),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        InkWell(
                          onTap: () => riderController.getInitialLocation(null),
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))],
                            ),
                            child: Icon(Icons.my_location, size: 28, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ) :
                  const SizedBox(),

                  Positioned(
                    top: Dimensions.paddingSizeSmall,
                    left: Dimensions.paddingSizeLarge,
                    right: Dimensions.paddingSizeLarge,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      riderController.rideStatus == RiderType.initial ?
                      const Column(mainAxisSize: MainAxisSize.min, children: [

                        RiderAddressInputField(isFormAddress: true),
                        SizedBox(height: Dimensions.paddingSizeSmall),

                        RiderAddressInputField(isFormAddress: false),

                      ]) :
                      const SizedBox(),

                    ]),
                  ),
                ],
              ),
            persistentContentHeight: 310,
            expandableContent: riderController.rideStatus.isBlank! ? const SizedBox() : expandableContent(riderController.rideStatus!, riderController, widget.vehicle),
          );
        },
      ),
    );
  }


  Widget expandableContent(RiderType riderType, RiderController riderController, Vehicles? vehicle){
    if (kDebugMode) {
      print("===----- rider type name : ${riderType.name}");
    }
    switch (riderType) {
      case RiderType.availableCar:
        return AvailableServiceInfo(vehicle: vehicle);
      case RiderType.willArrived:
        return const CarWillArrivedInfo();

      default:
        return GetBuilder<RiderController>(
          builder: (riderController) {
            if (kDebugMode) {
              print('-----------= : ${riderController.toAddress == null} / ${riderController.toTextEditingController.text == ''}');
            }
            return Container(
              height: 85,
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  onPressed: riderController.toAddress == null && riderController.toTextEditingController.text == '' ? null : (){
                    riderController.setRideStatus(RiderType.availableCar);
                  },
                  buttonText: 'confirm'.tr,
                ),
              ),
            );
          }
        );

    }
  }
}
