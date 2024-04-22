import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/features/location/widgets/serach_location_widget.dart';

class PickMapScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String? route;
  final GoogleMapController? googleMapController;
  final Function(AddressModel address)? onPicked;
  final bool fromLandingPage;
  const PickMapScreen({super.key,
    required this.fromSignUp, required this.fromAddAddress, required this.canRoute,
    required this.route, this.googleMapController, this.onPicked, this.fromLandingPage = false,
  });

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    if(widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }
    _initialPosition = LatLng(
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: SafeArea(child: Center(child: Container(
        height:  ResponsiveHelper.isDesktop(context) ? 600 : null,
        width: ResponsiveHelper.isDesktop(context) ? 700 : Dimensions.webMaxWidth,
        // width: Dimensions.webMaxWidth,
        decoration: context.width > 700 ? BoxDecoration(
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ) : null,

        child: GetBuilder<LocationController>(builder: (locationController) {

          return ResponsiveHelper.isDesktop(context) ?
          Padding(
            padding: const  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.clear),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Text('type_your_address_here_to_pick_form_map'.tr, style: robotoBold),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SearchLocationWidget(mapController: _mapController, pickedAddress: locationController.pickAddress, isEnabled: null, fromDialog: true),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SizedBox(
                  height: 350,
                  child:  Stack(children: [
                    ClipRRect(
                      borderRadius:BorderRadius.circular(Dimensions.radiusDefault),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: widget.fromAddAddress ? LatLng(locationController.position.latitude, locationController.position.longitude)
                              : _initialPosition,
                          zoom: 16,
                        ),
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController mapController) {
                          _mapController = mapController;
                          if(!widget.fromAddAddress) {
                            Get.find<LocationController>().getCurrentLocation(false, mapController: mapController);
                          }
                        },
                        scrollGesturesEnabled: !Get.isDialogOpen!,
                        zoomControlsEnabled: false,
                        onCameraMove: (CameraPosition cameraPosition) {
                          _cameraPosition = cameraPosition;
                        },
                        onCameraMoveStarted: () {
                          locationController.disableButton();
                        },
                        onCameraIdle: () {
                          Get.find<LocationController>().updatePosition(_cameraPosition, false);
                        },
                      ),
                    ),

                    Center(child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50)
                        : const CircularProgressIndicator()),

                    Positioned(
                      bottom: 30, right: Dimensions.paddingSizeLarge,
                      child: FloatingActionButton(
                        mini: true, backgroundColor: Theme.of(context).cardColor,
                        onPressed: () => Get.find<LocationController>().checkPermission(() {
                          Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                        }),
                        child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                CustomButton(
                  isBold: false,
                  radius: Dimensions.radiusSmall,
                  buttonText: locationController.inZone ? widget.fromAddAddress ? 'pick_address'.tr : 'pick_location'.tr
                      : 'service_not_available_in_this_area'.tr,
                  isLoading: locationController.isLoading,
                  onPressed: locationController.isLoading ? (){} : (locationController.buttonDisabled || locationController.loading) ? null : () {
                    if(locationController.pickPosition.latitude != 0 && locationController.pickAddress!.isNotEmpty) {
                      if(widget.onPicked != null) {
                        AddressModel address = AddressModel(
                          latitude: locationController.pickPosition.latitude.toString(),
                          longitude: locationController.pickPosition.longitude.toString(),
                          addressType: 'others', address: locationController.pickAddress,
                          contactPersonName: AddressHelper.getUserAddressFromSharedPref()!.contactPersonName,
                          contactPersonNumber: AddressHelper.getUserAddressFromSharedPref()!.contactPersonNumber,
                        );
                        widget.onPicked!(address);
                        Get.back();
                      }else if(widget.fromAddAddress) {
                        if(widget.googleMapController != null) {
                          widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                            locationController.pickPosition.latitude, locationController.pickPosition.longitude,
                          ), zoom: 16)));
                          locationController.setAddAddressData();
                        }
                        Get.back();
                      }else {
                        AddressModel address = AddressModel(
                          latitude: locationController.pickPosition.latitude.toString(),
                          longitude: locationController.pickPosition.longitude.toString(),
                          addressType: 'others', address: locationController.pickAddress,
                        );

                        if(widget.fromLandingPage) {
                          if(!AuthHelper.isGuestLoggedIn() && !AuthHelper.isLoggedIn()) {
                            Get.find<AuthController>().guestLogin().then((response) {
                              if(response.isSuccess) {
                                Get.find<ProfileController>().setForceFullyUserEmpty();
                                Get.back();
                                locationController.saveAddressAndNavigate(
                                  address, widget.fromSignUp, widget.route, widget.canRoute, ResponsiveHelper.isDesktop(context),
                                );
                              }
                            });
                          } else {
                            // if(Get.isDialogOpen!) {
                            //   Get.back();
                            // }
                            Get.back();
                            locationController.saveAddressAndNavigate(
                              address, widget.fromSignUp, widget.route, widget.canRoute, ResponsiveHelper.isDesktop(context),
                            );
                          }
                        }else {
                          locationController.saveAddressAndNavigate(
                            address, widget.fromSignUp, widget.route, widget.canRoute, ResponsiveHelper.isDesktop(context),
                          );
                        }
                      }
                    }else {
                      showCustomSnackBar('pick_an_address'.tr);
                    }
                  },
                ),

              ],
            ),
          ):
          Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.fromAddAddress ? LatLng(locationController.position.latitude, locationController.position.longitude)
                    : _initialPosition,
                zoom: 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
                if(!widget.fromAddAddress) {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: mapController);
                }
              },
              scrollGesturesEnabled: !Get.isDialogOpen!,
              zoomControlsEnabled: false,
              onCameraMove: (CameraPosition cameraPosition) {
                _cameraPosition = cameraPosition;
              },
              onCameraMoveStarted: () {
                locationController.disableButton();
              },
              onCameraIdle: () {
                Get.find<LocationController>().updatePosition(_cameraPosition, false);
              },
            ),

            Center(child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50)
                : const CircularProgressIndicator()),

            Positioned(
              top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
              child: SearchLocationWidget(mapController: _mapController, pickedAddress: locationController.pickAddress, isEnabled: null),
            ),

            Positioned(
              bottom: 80, right: Dimensions.paddingSizeLarge,
              child: FloatingActionButton(
                mini: true, backgroundColor: Theme.of(context).cardColor,
                onPressed: () => Get.find<LocationController>().checkPermission(() {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                }),
                child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
              ),
            ),

            Positioned(
              bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
              child: CustomButton(
                buttonText: locationController.inZone ? widget.fromAddAddress ? 'pick_address'.tr : 'pick_location'.tr
                    : 'service_not_available_in_this_area'.tr,
                isLoading: locationController.isLoading,
                onPressed: locationController.isLoading ? (){} : (locationController.buttonDisabled || locationController.loading) ? null : () {
                  if(locationController.pickPosition.latitude != 0 && locationController.pickAddress!.isNotEmpty) {
                    if(widget.onPicked != null) {
                      AddressModel address = AddressModel(
                        latitude: locationController.pickPosition.latitude.toString(),
                        longitude: locationController.pickPosition.longitude.toString(),
                        addressType: 'others', address: locationController.pickAddress,
                        contactPersonName: AddressHelper.getUserAddressFromSharedPref()!.contactPersonName,
                        contactPersonNumber: AddressHelper.getUserAddressFromSharedPref()!.contactPersonNumber,
                      );
                      widget.onPicked!(address);
                      Get.back();
                    }else if(widget.fromAddAddress) {
                      if(widget.googleMapController != null) {
                        widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                          locationController.pickPosition.latitude, locationController.pickPosition.longitude,
                        ), zoom: 16)));
                        locationController.setAddAddressData();
                      }
                      Get.back();
                    }else {
                      AddressModel address = AddressModel(
                        latitude: locationController.pickPosition.latitude.toString(),
                        longitude: locationController.pickPosition.longitude.toString(),
                        addressType: 'others', address: locationController.pickAddress,
                      );
                      locationController.saveAddressAndNavigate(
                        address, widget.fromSignUp, widget.route, widget.canRoute, ResponsiveHelper.isDesktop(context),
                      );
                    }
                  }else {
                    showCustomSnackBar('pick_an_address'.tr);
                  }
                },
              ),
            ),
          ]);

        }),
      ))),
    );
  }
}
