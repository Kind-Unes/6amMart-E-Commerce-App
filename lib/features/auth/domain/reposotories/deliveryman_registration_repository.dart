
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_data_model.dart';
import 'package:sixam_mart/features/auth/domain/models/delivery_man_body.dart';
import 'package:sixam_mart/features/auth/domain/models/delivery_man_vehicles_model.dart';
import 'package:sixam_mart/features/auth/domain/reposotories/deliveryman_registration_repository_interface.dart';
import 'package:sixam_mart/util/app_constants.dart';

class DeliverymanRegistrationRepository implements DeliverymanRegistrationRepositoryInterface{
  final ApiClient apiClient;
  DeliverymanRegistrationRepository({required this.apiClient});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future<bool> registerDeliveryMan(DeliveryManBody deliveryManBody, List<MultipartBody> multiParts) async {
    Response response = await apiClient.postMultipartData(AppConstants.dmRegisterUri, deliveryManBody.toJson(), multiParts);
    return (response.statusCode == 200);
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset, int? zoneId, bool isZone = true, bool isVehicle = false}) async {
    if(isZone) {
      return await _getZoneList();
    } else if(isVehicle) {
      return await _getVehicleList();
    } else {
      return await _getModules(zoneId);
    }
  }

  Future<List<ZoneDataModel>?> _getZoneList() async {
    List<ZoneDataModel>? zoneList;
    Response response = await apiClient.getData(AppConstants.zoneListUri);
    if (response.statusCode == 200) {
      zoneList = [];
      response.body.forEach((zone) => zoneList!.add(ZoneDataModel.fromJson(zone)));
    }
    return zoneList;
  }

  Future<List<ModuleModel>?> _getModules(int? zoneId) async {
    List<ModuleModel>? moduleList;
    Response response = await apiClient.getData('${AppConstants.moduleUri}?zone_id=$zoneId',
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      moduleList = [];
      response.body.forEach((storeCategory) => moduleList!.add(ModuleModel.fromJson(storeCategory)));
    }
    return moduleList;
  }

  Future<List<DeliveryManVehicleModel>?> _getVehicleList() async {
    List<DeliveryManVehicleModel>? vehicles;
    Response response = await apiClient.getData(AppConstants.vehiclesUri);
    if (response.statusCode == 200) {
      vehicles = [];
      response.body.forEach((vehicle) => vehicles!.add(DeliveryManVehicleModel.fromJson(vehicle)));
    }
    return vehicles;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }


}