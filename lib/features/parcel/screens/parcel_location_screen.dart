import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/features/parcel/domain/models/parcel_category_model.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/custom_validator.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/features/parcel/widgets/parcel_view_widget.dart';

class ParcelLocationScreen extends StatefulWidget {
  final ParcelCategoryModel category;
  const ParcelLocationScreen({super.key, required this.category});

  @override
  State<ParcelLocationScreen> createState() => _ParcelLocationScreenState();
}

class _ParcelLocationScreenState extends State<ParcelLocationScreen> with TickerProviderStateMixin {
   final TextEditingController _senderNameController = TextEditingController();
   final TextEditingController _senderPhoneController = TextEditingController();
   final TextEditingController _receiverNameController = TextEditingController();
   final TextEditingController _receiverPhoneController = TextEditingController();
   final TextEditingController _senderStreetNumberController = TextEditingController();
   final TextEditingController _senderHouseController = TextEditingController();
   final TextEditingController _senderFloorController = TextEditingController();
   final TextEditingController _receiverStreetNumberController = TextEditingController();
   final TextEditingController _receiverHouseController = TextEditingController();
   final TextEditingController _receiverFloorController = TextEditingController();

  TabController? _tabController;
  String? _countryDialCode;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    initCall();
  }

  Future<void> initCall() async {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
        : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;

    Get.find<ParcelController>().setPickupAddress(AddressHelper.getUserAddressFromSharedPref(), false);
    Get.find<ParcelController>().setDestinationAddress(AddressHelper.getUserAddressFromSharedPref(), notify: false);
    Get.find<ParcelController>().setIsPickedUp(true, false);
    Get.find<ParcelController>().setIsSender(true, false);
    Get.find<ParcelController>().setSenderAddressIndex(0, canUpdate: false);
    Get.find<ParcelController>().setReceiverAddressIndex(0, canUpdate: false);
    Get.find<ParcelController>().setCountryCode(_countryDialCode!, true);
    Get.find<ParcelController>().setCountryCode(_countryDialCode!, false);
    if(AuthHelper.isLoggedIn() && Get.find<AddressController>().addressList == null) {
      Get.find<AddressController>().getAddressList();
    }
    if (AuthHelper.isLoggedIn()){
      if(Get.find<ProfileController>().userInfoModel == null){
        await Get.find<ProfileController>().getUserInfo();
        _senderNameController.text = Get.find<ProfileController>().userInfoModel != null ? '${Get.find<ProfileController>().userInfoModel!.fName!} ${Get.find<ProfileController>().userInfoModel!.lName!}' : '';
        _countryDialCode = await splitPhoneNumber(Get.find<ProfileController>().userInfoModel != null ? Get.find<ProfileController>().userInfoModel!.phone! : '', true);
        _senderPhoneController.text = await splitPhoneNumber(Get.find<ProfileController>().userInfoModel != null ? Get.find<ProfileController>().userInfoModel!.phone! : '', false);
      }else{
        _senderNameController.text = '${Get.find<ProfileController>().userInfoModel!.fName!} ${Get.find<ProfileController>().userInfoModel!.lName!}';
        _countryDialCode = await splitPhoneNumber(Get.find<ProfileController>().userInfoModel != null ? Get.find<ProfileController>().userInfoModel!.phone! : '', true);
        _senderPhoneController.text = await splitPhoneNumber(Get.find<ProfileController>().userInfoModel != null ? Get.find<ProfileController>().userInfoModel!.phone! : '', false);
      }
      Get.find<ParcelController>().setCountryCode(_countryDialCode!, true);
      Get.find<ParcelController>().setCountryCode(_countryDialCode!, false);
      setState(() {});

    }

    _tabController?.addListener((){
      Get.find<ParcelController>().setIsPickedUp(_tabController!.index == 0, false);
      Get.find<ParcelController>().setIsSender(_tabController!.index == 0, true);
    });
  }

   Future<String> splitPhoneNumber(String number, bool returnCountyCode) async {
    String code = '';
    String pNumber = '';
    try {
      PhoneNumber phoneNumber = PhoneNumber.parse(number);
      code = '+${phoneNumber.countryCode}';
      pNumber = phoneNumber.international.substring(_countryDialCode!.length);
    } catch (e) {
      debugPrint('number can\'t parse : $e');
    }
     if(returnCountyCode) {
       return code;
     } else {
       return pNumber;
     }
   }

  @override
  void dispose() {
    super.dispose();
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _senderStreetNumberController.dispose();
    _senderHouseController.dispose();
    _senderFloorController.dispose();
    _receiverStreetNumberController.dispose();
    _receiverHouseController.dispose();
    _receiverFloorController.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'parcel_location'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: GetBuilder<ParcelController>(builder: (parcelController) {
          return Column(children: [

            Expanded(child: Column(children: [

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  width: Dimensions.webMaxWidth,
                  color: Theme.of(context).cardColor,
                  child: Column(
                    children: [

                      TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.black,
                        onTap: (int index) {
                          if(index == 1) {
                            _validateSender(parcelController);
                          }
                        },
                        unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                        labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text(
                              'sender_info'.tr,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: parcelController.isSender ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color),
                            ),
                          ),
                          Text(
                            'receiver_info'.tr,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: !parcelController.isSender ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color),
                          ),
                        ],
                      ),
                      // Container(height: 3, width: Dimensions.webMaxWidth, decoration: BoxDecoration(color: Theme.of(context).primaryColor))
                    ],
                  ),
                ),
              ),

              Expanded(child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ParcelViewWidget(
                    isSender: true, nameController: _senderNameController, phoneController: _senderPhoneController, bottomButton: _bottomButton(),
                    streetController: _senderStreetNumberController, floorController: _senderFloorController, houseController: _senderHouseController,
                    countryCode: parcelController.senderCountryCode/* _countryDialCode*/,
                  ),
                  ParcelViewWidget(
                    isSender: false, nameController: _receiverNameController, phoneController: _receiverPhoneController, bottomButton: _bottomButton(),
                    streetController: _receiverStreetNumberController, floorController: _receiverFloorController, houseController: _receiverHouseController,
                    countryCode: parcelController.receiverCountryCode /*_countryDialCode*/,
                  ),
                ],
              )),
            ])),

            ResponsiveHelper.isDesktop(context) ? const SizedBox() : _bottomButton(),

          ]);
        }),
      ),
    );
  }

  Widget _bottomButton() {
    return GetBuilder<ParcelController>(
      builder: (parcelController) {
        return CustomButton(
          margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          buttonText: parcelController.isSender ? 'continue'.tr : 'save_and_continue'.tr,
          onPressed: () async {
            if( _tabController!.index == 0 ) {
              _validateSender(parcelController);
            }
            else{
              String numberWithCountryCode = '${parcelController.receiverCountryCode??''}${_receiverPhoneController.text.trim()}';
              PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
              numberWithCountryCode = phoneValid.phone;

              if(parcelController.destinationAddress == null) {
                  showCustomSnackBar('select_destination_address'.tr);
              }
              else if(_receiverNameController.text.isEmpty){
                showCustomSnackBar('enter_receiver_name'.tr);
              }
              else if(_receiverPhoneController.text.isEmpty){
                showCustomSnackBar('enter_receiver_phone_number'.tr);
              }
              else if (!phoneValid.isValid) {
                showCustomSnackBar('invalid_phone_number'.tr);
              }
              else {
                AddressModel destination = AddressModel(
                  address: parcelController.destinationAddress!.address,
                  additionalAddress: parcelController.destinationAddress!.additionalAddress,
                  addressType: parcelController.destinationAddress!.addressType,
                  contactPersonName: _receiverNameController.text.trim(),
                  contactPersonNumber: numberWithCountryCode,
                  latitude: parcelController.destinationAddress!.latitude,
                  longitude: parcelController.destinationAddress!.longitude,
                  method: parcelController.destinationAddress!.method,
                  zoneId: parcelController.destinationAddress!.zoneId,
                  zoneIds: parcelController.destinationAddress!.zoneIds,
                  id: parcelController.destinationAddress!.id,
                  streetNumber: _receiverStreetNumberController.text.trim(),
                  house: _receiverHouseController.text.trim(),
                  floor: _receiverFloorController.text.trim(),
                );

                parcelController.setDestinationAddress(destination);

                Get.toNamed(RouteHelper.getParcelRequestRoute(
                  widget.category,
                  parcelController.pickupAddress!,
                  parcelController.destinationAddress!,
                ));
              }
           }
          },
        );
      }
    );
  }

  Future<void> _validateSender(ParcelController parcelController) async {
    String numberWithCountryCode = '${parcelController.senderCountryCode??''}${_senderPhoneController.text.trim()}';
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if(parcelController.pickupAddress == null) {
      showCustomSnackBar('select_pickup_address'.tr);
      _tabController!.animateTo(0);
    } else if(_senderNameController.text.isEmpty){
      showCustomSnackBar('enter_sender_name'.tr);
      _tabController!.animateTo(0);
    } else if(_senderPhoneController.text.isEmpty){
      showCustomSnackBar('enter_sender_phone_number'.tr);
      _tabController!.animateTo(0);
    } else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
      _tabController!.animateTo(0);
    } else{
      AddressModel pickup = AddressModel(
        address: parcelController.pickupAddress!.address,
        additionalAddress: parcelController.pickupAddress!.additionalAddress,
        addressType: parcelController.pickupAddress!.addressType,
        contactPersonName: _senderNameController.text.trim(),
        contactPersonNumber: numberWithCountryCode,
        latitude: parcelController.pickupAddress!.latitude,
        longitude: parcelController.pickupAddress!.longitude,
        method: parcelController.pickupAddress!.method,
        zoneId: parcelController.pickupAddress!.zoneId,
        id: parcelController.pickupAddress!.id,
        zoneIds: parcelController.pickupAddress!.zoneIds,
        streetNumber: _senderStreetNumberController.text.trim(),
        house: _senderHouseController.text.trim(),
        floor: _senderFloorController.text.trim(),
      );
      parcelController.setPickupAddress(pickup, true);
      _tabController!.animateTo(1);
    }
  }

}
