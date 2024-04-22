import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/auth/controllers/store_registration_controller.dart';
import 'package:sixam_mart/features/auth/widgets/module_view_widget.dart';
import 'package:sixam_mart/features/location/widgets/location_search_dialog_widget.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_dropdown.dart';

class SelectLocationViewWidget extends StatefulWidget {
  final bool fromView;
  final bool mapView;
  final bool zoneModuleView;
  final GoogleMapController? mapController;
  const SelectLocationViewWidget({super.key, required this.fromView, this.mapController, this.mapView = false, this.zoneModuleView = false});

  @override
  State<SelectLocationViewWidget> createState() => _SelectLocationViewWidgetState();
}

class _SelectLocationViewWidgetState extends State<SelectLocationViewWidget> {
  late CameraPosition _cameraPosition;
  final Set<Polygon> _polygons = HashSet<Polygon>();
  GoogleMapController? _mapController;
  GoogleMapController? _screenMapController;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreRegistrationController>(builder: (storeRegController) {
      List<int> zoneIndexList = [];
      List<DropdownItem<int>> zoneList = [];
      if(storeRegController.zoneList != null && storeRegController.zoneIds != null) {
        for(int index=0; index<storeRegController.zoneList!.length; index++) {
          zoneIndexList.add(index);
          zoneList.add(DropdownItem<int>(value: index, child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${storeRegController.zoneList![index].name}'),
            ),
          )));
        }
      }

      return SizedBox(width: Dimensions.webMaxWidth, child: Padding(
        padding: EdgeInsets.all(widget.fromView ? 0 : Dimensions.paddingSizeSmall),
        child: SingleChildScrollView(
          child: ResponsiveHelper.isDesktop(context)? webView(storeRegController, zoneList): Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(children: [
              Expanded(child: zoneSection(storeRegController, zoneList)),
              SizedBox(width: storeRegController.moduleList != null ? Dimensions.paddingSizeSmall : 0),

              const Expanded(child: ModuleViewWidget()),

            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            mapView(storeRegController),
            SizedBox(height: !widget.fromView ? Dimensions.paddingSizeSmall : 0),

            !widget.fromView ? CustomButton(
              buttonText: 'set_location'.tr,
              onPressed: () {
                try{
                  widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                  Get.back();
                }catch(_){
                  Get.back();
                }
              },
            ) : const SizedBox()

          ]),
        ),
      ));
    });
  }

  Widget webView(StoreRegistrationController storeRegController, List<DropdownItem<int>> zoneList) {
    return Row(children: [
      (widget.fromView && widget.zoneModuleView) ?  Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Expanded(
          child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('module'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              storeRegController.moduleList != null ? const ModuleViewWidget() : const SizedBox(),
              SizedBox(height: storeRegController.moduleList != null ? Dimensions.paddingSizeLarge : 0),
            ],
          ),
        ),

        (widget.fromView && widget.zoneModuleView) ? const SizedBox(width: Dimensions.paddingSizeLarge)  : const SizedBox(),
        Expanded(
          child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('zone'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              zoneSection(storeRegController, zoneList),
            ],
          ),
        ),

      ])) :  const SizedBox(),

      (widget.fromView && widget.zoneModuleView) ?  const SizedBox() : const SizedBox(width: Dimensions.paddingSizeLarge),

      (widget.fromView && widget.mapView) ?  Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Dimensions.paddingSizeLarge),
          mapView(storeRegController),
        ],
      )) : const SizedBox(),
    ]);
  }

  Widget zoneSection(StoreRegistrationController storeRegController, List<DropdownItem<int>> zoneList) {
    return storeRegController.zoneIds != null ?  Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
      ),
      child: CustomDropdown<int>(
        onChange: (int? value, int index) {
          storeRegController.setZoneIndex(value);
        },
        dropdownButtonStyle: DropdownButtonStyle(
          height: 45,
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall,
            horizontal: Dimensions.paddingSizeExtraSmall,
          ),
          primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        dropdownStyle: DropdownStyle(
          elevation: 10,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        ),
        items: zoneList,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(storeRegController.selectedZoneIndex == -1 ? 'select_zone'.tr : storeRegController.zoneList![storeRegController.selectedZoneIndex!].name.toString()),
        ),
      ),
    ) : Center(child: Text('service_not_available_in_this_area'.tr));
  }

  Widget mapView(StoreRegistrationController storeRegController) {
    return storeRegController.zoneList!.isNotEmpty ? Center(
      child: Container(
        height: ResponsiveHelper.isDesktop(context) ? widget.fromView ? 180 : 300 : widget.fromView ? 125 : (context.height * 0.55),
        width: Dimensions.webMaxWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: Stack(clipBehavior: Clip.none, children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
                  double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
                ), zoom: 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              zoomControlsEnabled: false,
              compassEnabled: false,
              indoorViewEnabled: true,
              mapToolbarEnabled: false,
              myLocationEnabled: false,
              zoomGesturesEnabled: true,
              polygons: _polygons,
              onCameraIdle: () {
                storeRegController.setLocation(_cameraPosition.target);
                if(!widget.fromView) {
                  widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                }
              },
              onCameraMove: ((position) => _cameraPosition = position),
              onMapCreated: (GoogleMapController controller) {
                if(widget.fromView) {
                  _mapController = controller;
                }else {
                  _screenMapController = controller;
                }
              },
            ),
            Center(child: Image.asset(Images.pickMarker, height: 50, width: 50)),

             Positioned(top: 10, left: 10,
              child: InkWell(
                onTap: () async {
                  var p = await Get.dialog(LocationSearchDialogWidget(mapController: widget.fromView ? _mapController : _screenMapController));
                  Position? position = p;
                  if(position != null) {
                    _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
                    if(!widget.fromView) {
                      widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                      storeRegController.setLocation(_cameraPosition.target);
                    }
                  }
                },
                child: Container(
                  height: 30, width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                  ),
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text('search'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                ),
              ),
            ),

            widget.fromView ? Positioned(
              top: 10, right: 0,
              child: InkWell(
                onTap: () {
                    Get.to(() => Scaffold(
                      appBar: CustomAppBar(title: 'set_your_store_location'.tr),
                      body: SelectLocationViewWidget(fromView: false, mapController: _mapController),
                    ));
                },
                child: Container(
                  width: 30, height: 30,
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                  child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                ),
              ),
            ) : const SizedBox(),
          ]),
        ),
      ),
    ) : const SizedBox();
  }
}
