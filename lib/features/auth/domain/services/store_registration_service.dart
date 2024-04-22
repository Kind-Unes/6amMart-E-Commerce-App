import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_data_model.dart';
import 'package:sixam_mart/features/auth/domain/models/store_body_model.dart';
import 'package:sixam_mart/features/auth/domain/reposotories/deliveryman_registration_repository_interface.dart';
import 'package:sixam_mart/features/auth/domain/reposotories/store_registration_repository_interface.dart';
import 'package:sixam_mart/features/auth/domain/services/store_registration_service_interface.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class StoreRegistrationService implements StoreRegistrationServiceInterface {
  final StoreRegistrationRepositoryInterface storeRegistrationRepoInterface;
  final DeliverymanRegistrationRepositoryInterface deliverymanRegistrationRepositoryInterface;

  StoreRegistrationService({required this.deliverymanRegistrationRepositoryInterface, required this.storeRegistrationRepoInterface});

  @override
  Future<List<ZoneDataModel>?> getZoneList() async {
    return await deliverymanRegistrationRepositoryInterface.getList();
  }

  @override
  int? prepareSelectedZoneIndex(List<int>? zoneIds, List<ZoneDataModel>? zoneList) {
    int? selectedZoneIndex = 0;
    for(int index=0; index<zoneList!.length; index++) {
      if(zoneIds!.contains(zoneList[index].id)) {
        selectedZoneIndex = index;
        break;
      }
    }
    return selectedZoneIndex;
  }

  @override
  Future<List<ModuleModel>?> getModules(int? zoneId) async {
    return await deliverymanRegistrationRepositoryInterface.getList(isZone: false, zoneId: zoneId);
  }

  @override
  Future<void> registerStore(StoreBodyModel store, XFile? logo, XFile? cover) async {
    bool success = await storeRegistrationRepoInterface.registerStore(store, logo, cover);
    if(success) {
      if(ResponsiveHelper.isDesktop(Get.context)){
        Get.offAllNamed(RouteHelper.getInitialRoute());
      }else {
        Get.back();
      }
      showCustomSnackBar('store_registration_successful'.tr, isError: false);
    }
  }

}