import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/item/domain/models/basic_campaign_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/item/domain/repositories/campaign_repository_interface.dart';
import 'package:sixam_mart/util/app_constants.dart';

class CampaignRepository implements CampaignRepositoryInterface {
  final ApiClient apiClient;
  CampaignRepository({required this.apiClient});

  @override
  Future getList({int? offset, bool isBasicCampaign = false, bool isItemCampaign = false}) async {
    if(isBasicCampaign) {
      return await _getBasicCampaignList();
    } else if(isItemCampaign) {
      return await _getItemCampaignList();
    }
  }

  Future<List<BasicCampaignModel>?> _getBasicCampaignList() async {
    List<BasicCampaignModel>? basicCampaignList;
    Response response = await apiClient.getData(AppConstants.basicCampaignUri);
    if (response.statusCode == 200) {
      basicCampaignList = [];
      response.body.forEach((campaign) => basicCampaignList!.add(BasicCampaignModel.fromJson(campaign)));
    }
    return basicCampaignList;
  }

  Future<List<Item>?> _getItemCampaignList() async {
    List<Item>? itemCampaignList;
    Response response = await apiClient.getData(AppConstants.itemCampaignUri);
    if (response.statusCode == 200) {
      itemCampaignList = [];
      response.body.forEach((camp) => itemCampaignList!.add(Item.fromJson(camp)));
    }
    return itemCampaignList;
  }

  @override
  Future<BasicCampaignModel?> get(String? id) async {
    BasicCampaignModel? basicCampaign;
    Response response = await apiClient.getData('${AppConstants.basicCampaignDetailsUri}$id');
    if (response.statusCode == 200) {
      basicCampaign = BasicCampaignModel.fromJson(response.body);
    }
    return basicCampaign;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}