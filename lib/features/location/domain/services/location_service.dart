import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/features/location/domain/models/prediction_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/features/location/domain/repositories/location_repository_interface.dart';
import 'package:sixam_mart/features/location/domain/services/location_service_interface.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';
import 'package:sixam_mart/features/location/widgets/permission_dialog_widget.dart';
import 'package:sixam_mart/features/parcel/domain/models/place_details_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class LocationService implements LocationServiceInterface{
  final LocationRepositoryInterface locationRepoInterface;
  LocationService({required this.locationRepoInterface});


  @override
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    return await locationRepoInterface.getAddressFromGeocode(latLng);
  }

  @override
  Future<ZoneResponseModel> getZone(String? lat, String? lng, {bool handleError = false}) async {
    return await locationRepoInterface.getZone(lat, lng, handleError: handleError);
  }

  @override
  Future<Position> getPosition(LatLng? defaultLatLng, LatLng configLatLng) async {
    Position myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      myPosition = newLocalData;
    }catch(e) {
      myPosition = Position(
        latitude: defaultLatLng != null ? defaultLatLng.latitude : configLatLng.latitude,
        longitude: defaultLatLng != null ? defaultLatLng.longitude : configLatLng.longitude,
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1,
      );
    }
    return myPosition;
  }

  @override
  void handleMapAnimation(GoogleMapController? mapController, Position myPosition) {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 17),
      ));
    }
  }

  @override
  Map<String, String> prepareHeader(List<int>? zoneIds) {
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.zoneId: zoneIds != null ? jsonEncode(zoneIds) : '',
    };
    return header;
  }

  @override
  void configureFirebaseMessaging(AddressModel address) {
    if(!GetPlatform.isWeb) {
      if (AddressHelper.getUserAddressFromSharedPref() != null) {
        if(AddressHelper.getUserAddressFromSharedPref()!.zoneIds != null) {
          for(int zoneID in AddressHelper.getUserAddressFromSharedPref()!.zoneIds!) {
            FirebaseMessaging.instance.unsubscribeFromTopic('zone_${zoneID}_customer');
          }
        }else {
          FirebaseMessaging.instance.unsubscribeFromTopic('zone_${AddressHelper.getUserAddressFromSharedPref()!.zoneId}_customer');
        }
      } else {
        FirebaseMessaging.instance.subscribeToTopic('zone_${address.zoneId}_customer');
      }
      if(address.zoneIds != null) {
        for(int zoneID in address.zoneIds!) {
          FirebaseMessaging.instance.subscribeToTopic('zone_${zoneID}_customer');
        }
      }else {
        FirebaseMessaging.instance.subscribeToTopic('zone_${address.zoneId}_customer');
      }
    }
  }

  @override
  void handleRoute(bool fromSignUp, String? route, bool canRoute) {
    if(fromSignUp) {
      Get.offAllNamed(RouteHelper.getInterestRoute());
    }else {
      if(route != null && canRoute) {
        Get.offAllNamed(route);
      }else {
        Get.offAllNamed(RouteHelper.getInitialRoute());
      }
    }
  }

  @override
  Future<LatLng> getLatLng(String? id) async {
    LatLng latLng = const LatLng(0, 0);
    Response? response = await locationRepoInterface.get(id);
    if(response?.statusCode == 200) {
      PlaceDetailsModel placeDetails = PlaceDetailsModel.fromJson(response?.body);
      if(placeDetails.status == 'OK') {
        latLng = LatLng(placeDetails.result!.geometry!.location!.lat!, placeDetails.result!.geometry!.location!.lng!);
      }
    }
    return latLng;
  }

  @override
  Future<List<PredictionModel>> searchLocation(String text) async {
    List<PredictionModel> predictionList = [];
    Response response = await locationRepoInterface.searchLocation(text);
    if (response.statusCode == 200 && response.body['status'] == 'OK') {
      predictionList = [];
      response.body['predictions'].forEach((prediction) => predictionList.add(PredictionModel.fromJson(prediction)));
    } else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return predictionList;
  }

  @override
  void checkLocationPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialogWidget());
    } else {
      onTap();
    }
  }

  @override
  Future<void> authorizeNavigation(String page, List<AddressModel>? addressList, GoogleMapController? mapController, {bool offNamed = false, bool offAll = false}) async {
    if(addressList != null && addressList.isEmpty) {
      if(ResponsiveHelper.isDesktop(Get.context)) {
        showGeneralDialog(context: Get.context!, pageBuilder: (_,__,___) {
          return SizedBox(
            height: 300, width: 300,
            child: PickMapScreen(fromSignUp: (page == RouteHelper.signUp), canRoute: false, fromAddAddress: false, route: null, googleMapController: mapController),
          );
        });
      } else {
        Get.toNamed(RouteHelper.getPickMapRoute(page, false));
      }
    } else {
      if(offNamed) {
        Get.offNamed(RouteHelper.getAccessLocationRoute(page));
      } else if(offAll) {
        Get.offAllNamed(RouteHelper.getAccessLocationRoute(page));
      } else {
        Get.toNamed(RouteHelper.getAccessLocationRoute(page));
      }
    }
  }

  @override
  void defaultNavigation(String page, GoogleMapController? mapController) {
    if(ResponsiveHelper.isDesktop(Get.context)) {
      showGeneralDialog(context: Get.context!, pageBuilder: (_,__,___) {
        return SizedBox(
          height: Get.context!.height * 0.75, width: 300,
          child: PickMapScreen(
            fromSignUp: (page == RouteHelper.signUp),
            canRoute: false, fromAddAddress: false, route: null,
            googleMapController: mapController,
          ),
        );
      });
    } else {
      Get.toNamed(RouteHelper.getPickMapRoute(page, false));
    }
  }

}