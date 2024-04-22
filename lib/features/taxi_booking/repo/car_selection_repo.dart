import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/profile/domain/models/user_information_body.dart';
import 'package:sixam_mart/util/app_constants.dart';

class CarSelectionRepo {
  final ApiClient apiClient;

  CarSelectionRepo({required this.apiClient});

  Future<Response> getVehiclesList(UserInformationBody body, int offset) async {
    return await apiClient.getData('${AppConstants.vehicleListUri}?offset=$offset&limit=10&start_latitude=${body.from!.latitude}'
        '&start_longitude=${body.from!.longitude}&end_latitude=${body.to!.latitude}&end_longitude=${body.to!.longitude}'
        '&fare_category=${body.fareCategory}&distance=${body.distance}&duration=${body.duration}&filter_type=${body.filterType}'
        '&filter_min_price=${body.minPrice.toString() == 'null'?'': body.minPrice}'
        '&filter_max_price=${body.maxPrice.toString() == 'null'?'': body.maxPrice}&'
        'filter_brand=${body.brandModelId.toString() == 'null' ?'': body.brandModelId}&search=');
  }

  Future<Response> getBrandList() async {
    return await apiClient.getData(AppConstants.bandListUri);
  }

}