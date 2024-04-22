import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/api/api_checker.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/parcel/domain/models/place_details_model.dart';
import 'package:sixam_mart/features/taxi_booking/models/trip_model.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/features/taxi_booking/models/rider_model.dart';
import 'package:sixam_mart/features/taxi_booking/repo/rider_repo.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/rider_type.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class RiderController extends GetxController implements GetxService {
  final RiderRepo riderRepo;
  RiderController({required this.riderRepo});

  LatLng _initialPosition = LatLng(
    double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
    double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
  );

  GoogleMapController? _mapController;
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> _polyLines = {};
  RiderType? _rideStatus;
  AddressModel? _fromAddress;
  AddressModel? _toAddress;
  bool _isLoading = false;
  double? _carDistance;
  RiderModel? _assignedRider;
  double? _carTime;
  int _riderRating = 0;
  bool _isReturnSameLocation = false;
  String? _tripDate;
  String? _tripTime;
  int _carType = 0;
  double? _distance = -1;
  double? _duration = -1;

  List<String> banners = [Images.banner1, Images.banner2];
  int _activeBanner = 0;
  VehicleModel? _topRatedVehicleModel;
  TripModel? _runningTrip;

  final MarkerId _myMarkerId = const MarkerId('my_marker');
  final MarkerId _fromMarkerId = const MarkerId('from_marker');
  final MarkerId _toMarkerId = const MarkerId('to_marker');
  final TextEditingController _formTextEditingController = TextEditingController();
  final TextEditingController _toTextEditingController = TextEditingController();


  LatLng get initialPosition => _initialPosition;
  GoogleMapController? get mapController => _mapController;
  Map<MarkerId, Marker> get markers => _markers;
  Map<PolylineId, Polyline> get polyLines => _polyLines;
  RiderType? get rideStatus => _rideStatus;
  AddressModel? get fromAddress => _fromAddress;
  AddressModel? get toAddress => _toAddress;
  bool get isLoading => _isLoading;
  double? get carDistance => _carDistance;
  RiderModel? get assignedRider => _assignedRider;
  double? get carTime => _carTime;
  int get riderRating => _riderRating;
  bool get isReturnSameLocation => _isReturnSameLocation;
  int get activeBanner => _activeBanner;
  String? get tripDate => _tripDate;
  String? get tripTime => _tripTime;
  int get carType => _carType;
  double? get distance => _distance;
  double? get duration => _duration;
  VehicleModel? get topRatedVehicleModel => _topRatedVehicleModel;
  TripModel? get runningTrip => _runningTrip;
  TextEditingController get formTextEditingController => _formTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;

  void clearAddress(bool isFrom){
    if(isFrom){
      _formTextEditingController.text = '';
    }else{
      _toTextEditingController.text = '';
    }
    update();
  }

  void initSetup(){
    _tripDate = DateConverter.dateToReadableDate(DateTime.now());
    _tripTime = DateConverter.convertTimeToTimeDate(DateTime.now());
  }

  void setCarType(int index) {
    _carType = index;
    update();
  }

  Future<void> setDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101)
    );

    if(pickedDate != null ){
      _tripDate = DateConverter.dateToReadableDate(pickedDate);
    }else{
      debugPrint("Date is not selected");
    }
    update();
  }

  Future<void> setTime(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
      context: context, initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: Get.find<SplashController>().configModel!.timeformat == '24',
          ),
          child: child!,
        );
      },
    );
    if(time != null) {
      _tripTime = DateConverter.convertTimeToTimeDate(DateTime(DateTime.now().year, 1, 1, time.hour, time.minute));
    }
    update();
  }

  void changeBanner(int index){
    _activeBanner = index;
    update();
  }

  void initializeData(String? riderType, AddressModel? address) {
    if (kDebugMode) {
      print("riderType_initializeData:$riderType");
    }
    _fromAddress = address ?? AddressHelper.getUserAddressFromSharedPref();
    _formTextEditingController.text = _fromAddress!.address!;
    _toAddress = null;
    _toTextEditingController.text = '';
    _markers = {};
    _polyLines = {};
    _rideStatus = RiderType.values.where((element) => element.name == riderType).first;
    _assignedRider = null;
    _carDistance = -1;
    _carTime = -1;
    _isLoading = false;
    _riderRating = 0;
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  Future<void> getRunningTripList(int offset, {bool isUpdate = false}) async{
    if(offset == 1) {
      _runningTrip = null;
      if(isUpdate) {
        update();
      }
    }
    Response response = await riderRepo.getRunningTripList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _runningTrip = TripModel.fromJson(response.body);
      }else {
        _runningTrip = TripModel.fromJson(response.body);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getTopRatedVehiclesList(int offset, {bool isUpdate = false}) async{
    if(offset == 1) {
      _topRatedVehicleModel = null;
      if(isUpdate) {
        update();
      }
    }
    Response response = await riderRepo.getTopRatedVehiclesList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _topRatedVehicleModel = VehicleModel.fromJson(response.body);
      }else {
        _topRatedVehicleModel = VehicleModel.fromJson(response.body);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<Position?> getInitialLocation(AddressModel? address) async {
    Position? position;
    try {
      if(address == null){
        await Geolocator.requestPermission();
        position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        _initialPosition = LatLng(position.latitude, position.longitude);
      }else{
        _initialPosition = LatLng(double.parse(address.latitude!), double.parse(address.longitude!));
      }
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_initialPosition, 16));
      // _markers[_fromMarkerId] = Marker(markerId: _fromMarkerId, visible: false, position: _initialPosition);
      final Uint8List liveMarkerIcon = await Get.find<RiderController>().getBytesFromAsset(Images.liveMarker, 70);
      Marker marker = Marker(
        markerId: _myMarkerId,
        position: _initialPosition,
        icon: BitmapDescriptor.fromBytes(liveMarkerIcon),
      );
      _markers[_myMarkerId] = marker;
      update();
    }catch(_){}
    return position;
  }

  void clearRideData() {
    _markers.clear();
    _polyLines.clear();
    Future.delayed(const Duration(seconds: 2),(){

    });
  }

  void setRideStatus(RiderType rideStatus,{bool shouldUpdate = true}) {
    _rideStatus = rideStatus;
    if(shouldUpdate){
      update();
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void toggleIsReturnSameLocation(bool value){
    _isReturnSameLocation = value;
    update();
  }

  void setLocationFromPlace(String? placeID, String? address, bool isFrom) async {
    Response response = await riderRepo.getPlaceDetails(placeID);
    if(response.statusCode == 200) {
      PlaceDetailsModel placeDetails = PlaceDetailsModel.fromJson(response.body);
      if(placeDetails.status == 'OK') {
        AddressModel address0 = AddressModel(
          address: address, addressType: 'others', latitude: placeDetails.result!.geometry!.location!.lat.toString(),
          longitude: placeDetails.result!.geometry!.location!.lng.toString(),
          contactPersonName: AddressHelper.getUserAddressFromSharedPref()!.contactPersonName,
          contactPersonNumber: AddressHelper.getUserAddressFromSharedPref()!.contactPersonNumber,
        );
        ZoneResponseModel response0 = await Get.find<LocationController>().getZone(address0.latitude, address0.longitude, false);
        if (response0.isSuccess) {
          if(AddressHelper.getUserAddressFromSharedPref()!.zoneIds!.contains(response0.zoneIds[0])) {
            address0.zoneId =  response0.zoneIds[0];
            address0.zoneIds = [];
            address0.zoneIds!.addAll(response0.zoneIds);
            address0.zoneData = [];
            address0.zoneData!.addAll(response0.zoneData);
            if(isFrom) {
              _formTextEditingController.text = address0.address!;
              setFromAddress(address0);
            }else {
              _toTextEditingController.text = address0.address!;
              setToAddress(address0);
            }
          }else {
            showCustomSnackBar('your_selected_location_is_from_different_zone_store'.tr);
          }
        } else {
          showCustomSnackBar(response0.message);
        }
      }
    }
    update();
  }

  Future<void> setFromAddress(AddressModel addressModel) async {
    _fromAddress = addressModel;
    LatLng from = LatLng(double.parse(_fromAddress!.latitude!), double.parse(_fromAddress!.longitude!));
    _markers[_myMarkerId] = Marker(markerId: _myMarkerId, visible: false, position: from);

    final Uint8List fromMarkerIcon = await getBytesFromAsset(Images.liveMarker, 70);
    Marker fromMarker = Marker(
      markerId: _fromMarkerId, position: from, visible: true,
      icon: BitmapDescriptor.fromBytes(fromMarkerIcon),
    );
    _markers[_fromMarkerId] = fromMarker;
    update();
  }

  Future<void> setToAddress(AddressModel addressModel) async {
    _toAddress = addressModel;
    setFromToMarker(
      from: LatLng(double.parse(_fromAddress!.latitude!), double.parse(_fromAddress!.longitude!)),
      to: LatLng(double.parse(_toAddress!.latitude!), double.parse(_toAddress!.longitude!)),
    );
    update();
  }

  void setFromToMarker({required LatLng from, required LatLng to}) async {
    _markers[_myMarkerId] = Marker(markerId: _myMarkerId, visible: false, position: from);
    final Uint8List fromMarkerIcon = await getBytesFromAsset(Images.liveMarker, 70);
    final Uint8List toMarkerIcon = await getBytesFromAsset(Images.toMarker, 70);

    Marker fromMarker = Marker(
      markerId: _fromMarkerId, position: from, visible: true,
      icon: BitmapDescriptor.fromBytes(fromMarkerIcon),
    );
    _markers[_fromMarkerId] = fromMarker;
    Marker toMarker = Marker(
      markerId: _toMarkerId, position: to,
      icon: BitmapDescriptor.fromBytes(toMarkerIcon),
    );
    _markers[_toMarkerId] = toMarker;
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(boundsFromLatLngList([from, to]), 100));

    generatePolyLines(from: from, to: to);
    _distance = await Get.find<CheckoutController>().getDistanceInKM(from, to);
    _duration = await Get.find<CheckoutController>().getDistanceInKM(from, to, isDuration: true);
    if (kDebugMode) {
      print('--------------distance------ : $_distance');
      print('--------------duration------ : $_duration');
    }
    update();
  }

  Future<List<LatLng>> generatePolyLines({required LatLng from, required LatLng to}) async {
    List<LatLng> polylineCoordinates = [];
    List<LatLng> results = await getRouteBetweenCoordinates(from, to);
    if (results.isNotEmpty) {
      polylineCoordinates.addAll(results);
    } else {
      showCustomSnackBar('route_not_found'.tr);
    }
    PolylineId polyId = const PolylineId('my_polyline');
    Polyline polyline = Polyline(
      polylineId: polyId,
      points: polylineCoordinates,
      width: 5,
      color: Theme.of(Get.context!).primaryColor,
    );
    _polyLines[polyId] = polyline;
    update();
    return polylineCoordinates;
  }

  Future<List<LatLng>> getRouteBetweenCoordinates(LatLng origin, LatLng destination) async {
    List<LatLng> coordinates = [];
    Response response = await riderRepo.getRouteBetweenCoordinates(origin, destination);
    if (response.body["status"]?.toLowerCase() == 'ok' && response.body["routes"] != null && response.body["routes"].isNotEmpty) {
      coordinates.addAll(decodeEncodedPolyline(response.body["routes"][0]["overview_polyline"]["points"]));
    }
    return coordinates;
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > (x1 ?? 0)) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > (y1 ?? 0)) y1 = latLng.longitude;
        if (latLng.longitude < (y0 ?? 0)) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}