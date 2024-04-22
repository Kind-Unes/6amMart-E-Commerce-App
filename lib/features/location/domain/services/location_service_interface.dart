import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/features/location/domain/models/prediction_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';

abstract class LocationServiceInterface{
  Future<Position> getPosition(LatLng? defaultLatLng, LatLng configLatLng);
  void handleMapAnimation(GoogleMapController? mapController, Position myPosition);
  Future<String> getAddressFromGeocode(LatLng latLng);
  Future<ZoneResponseModel> getZone(String? lat, String? lng, {bool handleError = false});
  Map<String, String> prepareHeader(List<int>? zoneIds);
  void configureFirebaseMessaging(AddressModel address);
  void handleRoute(bool fromSignUp, String? route, bool canRoute);
  Future<LatLng> getLatLng(String? id);
  Future<List<PredictionModel>> searchLocation(String text);
  void checkLocationPermission(Function onTap);
  Future<void> authorizeNavigation(String page, List<AddressModel>? addressList, GoogleMapController? mapController, {bool offNamed = false, bool offAll = false});
  void defaultNavigation(String page, GoogleMapController? mapController);
}