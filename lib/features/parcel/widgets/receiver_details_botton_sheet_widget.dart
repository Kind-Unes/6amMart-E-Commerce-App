import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/features/parcel/domain/models/parcel_category_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/my_text_field.dart';

class ReceiverDetailsBottomSheetWidget extends StatefulWidget {
  final ParcelCategoryModel category;
  const ReceiverDetailsBottomSheetWidget({super.key, required this.category});

  @override
  State<ReceiverDetailsBottomSheetWidget> createState() => _ReceiverDetailsBottomSheetWidgetState();
}

class _ReceiverDetailsBottomSheetWidgetState extends State<ReceiverDetailsBottomSheetWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _streetNumberController.text = Get.find<ParcelController>().destinationAddress!.streetNumber!;
    _houseController.text = Get.find<ParcelController>().destinationAddress!.house!;
    _floorController.text = Get.find<ParcelController>().destinationAddress!.floor!;
  }

  @override
  void dispose() {
    super.dispose();
    _streetNumberController.dispose();
    _houseController.dispose();
    _floorController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: ResponsiveHelper.isDesktop(context) ? const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

          Center(child: Text('receiver_details'.tr, style: robotoMedium)),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
            ),
            child: MyTextField(
              hintText: 'receiver_name'.tr,
              inputType: TextInputType.name,
              controller: _nameController,
              focusNode: _nameNode,
              nextFocus: _phoneNode,
              capitalization: TextCapitalization.words,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          MyTextField(
            hintText: 'receiver_phone_number'.tr,
            inputType: TextInputType.phone,
            focusNode: _phoneNode,
            nextFocus: _streetNode,
            controller: _phoneController,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          MyTextField(
            hintText: "${'street_number'.tr} (${'optional'.tr})",
            inputType: TextInputType.streetAddress,
            focusNode: _streetNode,
            nextFocus: _houseNode,
            controller: _streetNumberController,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          MyTextField(
            hintText: "${'house'.tr} (${'optional'.tr})",
            inputType: TextInputType.text,
            focusNode: _houseNode,
            nextFocus: _floorNode,
            controller: _houseController,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          MyTextField(
            hintText: "${'floor'.tr} (${'optional'.tr})",
            inputType: TextInputType.text,
            focusNode: _floorNode,
            inputAction: TextInputAction.done,
            controller: _floorController,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          CustomButton(
            buttonText: 'confirm_receiver_details'.tr,
            onPressed: () {
              String name = _nameController.text.trim();
              String phone = _phoneController.text.trim();
              String streetNumber = _streetNumberController.text.trim();
              String house = _houseController.text.trim();
              String floor = _floorController.text.trim();

              // String _additional = _additionalController.text.trim();
              if(name.isEmpty) {
                showCustomSnackBar('enter_receiver_name'.tr);
              }else if(phone.isEmpty) {
                showCustomSnackBar('enter_receiver_phone_number'.tr);
              }else {
                AddressModel address = Get.find<ParcelController>().destinationAddress!;
                address.contactPersonName = name;
                address.contactPersonNumber = phone;
                address.streetNumber = streetNumber;
                address.house = house;
                address.floor = floor;

                // _address.additionalAddress = _additional;
                Get.find<ParcelController>().setDestinationAddress(address);
                AddressModel pickedAddress = Get.find<ParcelController>().pickupAddress!;
                if((pickedAddress.contactPersonName == null || pickedAddress.contactPersonName!.isEmpty)
                    && Get.find<ProfileController>().userInfoModel != null) {
                  pickedAddress.contactPersonName = '${Get.find<ProfileController>().userInfoModel!.fName}'
                      ' ${Get.find<ProfileController>().userInfoModel!.lName}';
                }
                if((pickedAddress.contactPersonNumber == null || pickedAddress.contactPersonNumber!.isEmpty)
                    && Get.find<ProfileController>().userInfoModel != null) {
                  pickedAddress.contactPersonNumber = Get.find<ProfileController>().userInfoModel!.phone;
                }
                Get.toNamed(RouteHelper.getParcelRequestRoute(
                  widget.category,
                  Get.find<ParcelController>().pickupAddress!,
                  Get.find<ParcelController>().destinationAddress!,
                ));
              }
            },
          ),
        ]),
      ),
    );
  }
}
