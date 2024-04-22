import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/api/api_checker.dart';
import 'package:sixam_mart/features/profile/domain/models/user_information_body.dart';
import 'package:sixam_mart/features/taxi_booking/models/brand_model.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/features/taxi_booking/repo/car_selection_repo.dart';


/*receive car list based on hourly and km , also filter car and select car function will be placed here*/
class CarSelectionController extends GetxController implements GetxService {
  final CarSelectionRepo carSelectionRepo;
  CarSelectionController({required this.carSelectionRepo});

  bool _isCarFilterActive = false;
  RangeValues _selectedPriceRange = const RangeValues(0.2, 2.0);
  double _startingPrice = 0.0;
  double _endingPrice = 2000.0;

  VehicleModel? _vehicleModel;
  List<BrandModel>? _brandModels;
  int _selectedBrand = 0;
  int _sortByIndex = 0;

  bool get isCarFilterActive => _isCarFilterActive;
  VehicleModel? get vehicleModel => _vehicleModel;
  RangeValues get selectedPriceRange => _selectedPriceRange;
  double get startingPrice => _startingPrice;
  double get endingPrice => _endingPrice;
  List<BrandModel>? get brandModels => _brandModels;
  int get selectedBrand => _selectedBrand;
  int get sortByIndex => _sortByIndex;

  void carFilter(){
    _isCarFilterActive = !_isCarFilterActive;
    update();
  }

  void setBrandModel(int index){
    _selectedBrand = index;
    update();
  }

  void setSortBy(int index){
    _sortByIndex = index;
    update();
  }

  void selectPriceRange(RangeValues newRange){
    _selectedPriceRange = newRange;
    _startingPrice = _selectedPriceRange.start * 1000;
    _endingPrice = _selectedPriceRange.end * 1000;
    update();
  }

  Future<void> getVehiclesList(UserInformationBody body, int offset, {bool isUpdate = false}) async{
    if(offset == 1) {
      _vehicleModel = null;
      if(isUpdate) {
        update();
      }
    }
    Response response = await carSelectionRepo.getVehiclesList(body, offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _vehicleModel = VehicleModel.fromJson(response.body);
      }else {
        _vehicleModel = VehicleModel.fromJson(response.body);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getBrandList() async {
    Response response = await carSelectionRepo.getBrandList();
    if (response.statusCode == 200) {
      if(response.body != null){
        _brandModels = [];
        response.body.forEach((body) {
          _brandModels!.add(BrandModel.fromJson(body));
        });
      }

    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

}