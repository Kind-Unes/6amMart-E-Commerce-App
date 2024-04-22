import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/address_widget.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/no_data_screen.dart';

class AddressDialogWidget extends StatelessWidget {
  final Function(AddressModel address) onTap;
  const AddressDialogWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: context.width * 0.8, height: context.height * 0.7,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(children: [
          Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.clear), onPressed: () => Get.back())),

          Expanded(
            child: SingleChildScrollView(
              child: GetBuilder<AddressController>(builder: (addressController) {
                // List<AddressModel> _addressList = [];
                // if(locationController.addressList != null) {
                //   for(int index=0; index<locationController.addressList.length; index++) {
                //     if(locationController.getUserAddress().zoneIds.contains(locationController.addressList[index].zoneId)) {
                //       _addressList.add(locationController.addressList);
                //     }
                //   }
                // }
                return AuthHelper.isLoggedIn() ? addressController.addressList != null ? addressController.addressList!.isNotEmpty ? ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  itemCount: addressController.addressList!.length,
                  itemBuilder: (context, index) {
                    if(AddressHelper.getUserAddressFromSharedPref()!.zoneIds!.contains(addressController.addressList![index].zoneId)) {
                      return Center(child: SizedBox(width: 700, child: AddressWidget(
                        address: addressController.addressList![index],
                        fromAddress: false,
                        onTap: () {

                          onTap(addressController.addressList![index]);

                          AddressModel address = AddressModel(
                            address: addressController.addressList![index].address,
                            additionalAddress: addressController.addressList![index].additionalAddress,
                            addressType: addressController.addressList![index].addressType,
                            contactPersonName: addressController.addressList![index].contactPersonName,
                            contactPersonNumber: addressController.addressList![index].contactPersonNumber,
                            latitude: addressController.addressList![index].latitude,
                            longitude: addressController.addressList![index].longitude,
                            method: addressController.addressList![index].method,
                            zoneId: addressController.addressList![index].zoneId,
                            id: addressController.addressList![index].id,
                          );
                          if(Get.find<ParcelController>().isSender){
                            Get.find<ParcelController>().setPickupAddress(address, true);
                            Get.back();
                          }else{
                            Get.find<ParcelController>().setDestinationAddress(address);
                            Get.back();
                          }
                        },
                      )));
                    }else {
                      return const SizedBox();
                    }
                  },
                ) : NoDataScreen(text: 'no_saved_address_found'.tr) : const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(child: CircularProgressIndicator()),
                ) : const SizedBox();
              }),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
