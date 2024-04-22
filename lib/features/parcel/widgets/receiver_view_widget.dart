import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';
import 'package:sixam_mart/features/location/widgets/serach_location_widget.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/my_text_field.dart';
import 'package:sixam_mart/common/widgets/text_field_shadow.dart';

class ReceiverViewWidget extends StatefulWidget {
  const ReceiverViewWidget({super.key});

  @override
  State<ReceiverViewWidget> createState() => _ReceiverViewWidgetState();
}

class _ReceiverViewWidgetState extends State<ReceiverViewWidget> {

  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();


  @override
  void initState() {
    super.initState();

    Get.find<ParcelController>().setPickupAddress(AddressHelper.getUserAddressFromSharedPref(), false);
    Get.find<ParcelController>().setIsPickedUp(false, false);
    if(AuthHelper.isLoggedIn() && Get.find<AddressController>().addressList == null) {
      Get.find<AddressController>().getAddressList();
    }
    if (AuthHelper.isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
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
    return Scaffold(
      body: SizedBox(width: Dimensions.webMaxWidth, child: GetBuilder<ParcelController>(builder: (parcelController) {

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
          child: Column(children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),

            SearchLocationWidget(
              mapController: null,
              pickedAddress: parcelController.destinationAddress != null ? parcelController.destinationAddress!.address : '',
              isEnabled: !parcelController.isPickedUp!,
              isPickedUp: false,
              hint: 'destination'.tr,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(children: [
              Expanded(flex: 4,
                child: CustomButton(
                  buttonText: 'set_from_map'.tr,
                  onPressed: () {
                    if(ResponsiveHelper.isDesktop(Get.context)) {
                      showGeneralDialog(context: context, pageBuilder: (_,__,___) {
                        return SizedBox(
                            height: 300, width: 300,
                            child: PickMapScreen(fromSignUp: false, canRoute: false, fromAddAddress: false, route:'', onPicked: (AddressModel address) {
                              if(parcelController.isPickedUp!) {
                                parcelController.setPickupAddress(address, true);
                                _streetNumberController.text = '';
                                _houseController.text = '';
                                _floorController.text = '';
                              }else {
                                parcelController.setDestinationAddress(address);
                              }
                            }
                            ),
                        );
                      });
                    } else {
                      Get.toNamed(RouteHelper.getPickMapRoute('parcel', false), arguments: PickMapScreen(
                        fromSignUp: false, fromAddAddress: false, canRoute: false, route: '', onPicked: (AddressModel address) {
                        if(parcelController.isPickedUp!) {
                          parcelController.setPickupAddress(address, true);
                          _streetNumberController.text = '';
                          _houseController.text = '';
                          _floorController.text = '';
                        }else {
                          parcelController.setDestinationAddress(address);
                        }
                      },
                      ));
                    }
                  }
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(flex: 6,
                  child: InkWell(
                    onTap: (){},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
                      child: Center(child: Text('set_from_saved_address'.tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))),
                    ),
                  )
              ),
            ]),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Column(children: [

              Center(child: Text('receiver_information'.tr, style: robotoMedium)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              TextFieldShadow(
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

              TextFieldShadow(
                child: MyTextField(
                  hintText: 'receiver_phone_number'.tr,
                  inputType: TextInputType.phone,
                  focusNode: _phoneNode,
                  inputAction: TextInputAction.done,
                  controller: _phoneController,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
            ]),

            Column(children: [

              Center(child: Text('destination_information'.tr, style: robotoMedium)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              TextFieldShadow(
                child: MyTextField(
                  hintText: "${'street_number'.tr} (${'optional'.tr})",
                  inputType: TextInputType.streetAddress,
                  focusNode: _streetNode,
                  nextFocus: _houseNode,
                  controller: _streetNumberController,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Row(children: [
                Expanded(
                  child: TextFieldShadow(
                    child: MyTextField(
                      hintText: "${'house'.tr} (${'optional'.tr})",
                      inputType: TextInputType.text,
                      focusNode: _houseNode,
                      nextFocus: _floorNode,
                      controller: _houseController,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: TextFieldShadow(
                    child: MyTextField(
                      hintText: "${'floor'.tr} (${'optional'.tr})",
                      inputType: TextInputType.text,
                      focusNode: _floorNode,
                      inputAction: TextInputAction.done,
                      controller: _floorController,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),
            ]),



          ]),
        );
      }
      ),
      ),
    );
  }
}
