import 'package:country_code_picker/country_code_picker.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/location/widgets/permission_dialog_widget.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/custom_validator.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class AddAddressScreen extends StatefulWidget {
  final bool fromCheckout;
  final bool fromRide;
  final AddressModel? address;
  final int? zoneId;
  final bool forGuest;
  final bool fromNavBar;
  const AddAddressScreen({super.key, required this.fromCheckout, required this.fromRide, this.address, this.zoneId, this.forGuest = false, this.fromNavBar = false});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _levelNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;
  bool _otherSelect = false;
  String? _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
      : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;

  @override
  void initState() {
    super.initState();
    initCall();
  }

  void initCall(){

    Get.find<LocationController>().setAddressTypeIndex(0, isUpdate: false);
    if(AuthHelper.isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
    if(widget.address == null) {
      _initialPosition = LatLng(
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
      );
    }else {
      Get.find<LocationController>().setUpdateAddress(widget.address!);
      _initialPosition = LatLng(
        double.parse(widget.address!.latitude ?? '0'),
        double.parse(widget.address!.longitude ?? '0'),
      );

      if(widget.address!.addressType == 'home') {
        Get.find<LocationController>().setAddressTypeIndex(0, isUpdate: false);
      } else if (widget.address!.addressType == 'office') {
        Get.find<LocationController>().setAddressTypeIndex(1, isUpdate: false);
      } else {
        Get.find<LocationController>().setAddressTypeIndex(2, isUpdate: false);
        _levelController.text = widget.address!.addressType!;
        _otherSelect = true;
      }
    }
  }

  void splitPhoneNumber(String number) async {
    try {
      PhoneNumber phoneNumber = PhoneNumber.parse(number);
      _countryDialCode = '+${phoneNumber.countryCode}';
      _contactPersonNumberController.text = phoneNumber.international.substring(_countryDialCode!.length);
    } catch (e) {
      debugPrint('number can\'t parse : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
      appBar: CustomAppBar(title: widget.forGuest ? 'set_address'.tr : widget.address == null ? 'add_new_address'.tr : 'update_address'.tr),
      body: SafeArea(
        child: GetBuilder<ProfileController>(builder: (profileController) {
          if(widget.address != null) {
            splitPhoneNumber(widget.address!.contactPersonNumber!);
              _contactPersonNameController.text = widget.address!.contactPersonName ?? '';
              _emailController.text = widget.address!.email ?? '';
              _streetNumberController.text = widget.address!.streetNumber ?? '';
              _houseController.text = widget.address!.house ?? '';
              _floorController.text = widget.address!.floor ?? '';

          }else if(profileController.userInfoModel != null && _contactPersonNameController.text.isEmpty) {
            _contactPersonNameController.text = '${profileController.userInfoModel!.fName} ${profileController.userInfoModel!.lName}';
            splitPhoneNumber(profileController.userInfoModel!.phone!);
          }

          return GetBuilder<LocationController>(builder: (locationController) {
            _addressController.text = locationController.address!;

            return ResponsiveHelper.isDesktop(context) ?
              SingleChildScrollView(
                child: FooterView(
                  child: Column(
                    children: [
                      Container(
                        height: 64,
                        color: Theme.of(context).primaryColor.withOpacity(0.10),
                        child: Center(child: Text('address'.tr, style: robotoMedium)),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Row( crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width : 680,
                                      height: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        child: Stack(clipBehavior: Clip.none, children: [
                                          GoogleMap(
                                            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 16),
                                            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                                            onTap: (latLng) {
                                              if(ResponsiveHelper.isDesktop(Get.context)) {

                                              }else {
                                                Get.toNamed(
                                                  RouteHelper.getPickMapRoute('add-address', false),
                                                  arguments: PickMapScreen(
                                                    fromAddAddress: true,
                                                    fromSignUp: false,
                                                    googleMapController: locationController.mapController,
                                                    route: null,
                                                    canRoute: false,
                                                  ),
                                                );
                                              }
                                            },
                                            zoomControlsEnabled: false,
                                            compassEnabled: false,
                                            indoorViewEnabled: true,
                                            mapToolbarEnabled: false,
                                            onCameraIdle: () {
                                              locationController.updatePosition(_cameraPosition, true);
                                            },
                                            onCameraMove: ((position) => _cameraPosition = position),
                                            onMapCreated: (GoogleMapController controller) {
                                              locationController.setMapController(controller);
                                              if(widget.address == null) {
                                                locationController.getCurrentLocation(true, mapController: controller);
                                              }
                                            },
                                          ),
                                          locationController.loading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
                                          Center(child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50)
                                              : const CircularProgressIndicator()),
                                          Positioned(
                                            bottom: 10, right: 0,
                                            child: InkWell(
                                              onTap: () => _checkPermission(() {
                                                locationController.getCurrentLocation(true, mapController: locationController.mapController);
                                              }),
                                              child: Container(
                                                width: 30, height: 30,
                                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                                                child: Icon(Icons.my_location, color: Theme.of(context).primaryColor, size: 20),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10, right: 0,
                                            child: InkWell(
                                              onTap: () {
                                                if(ResponsiveHelper.isDesktop(Get.context)) {
                                                  showGeneralDialog(context: context, pageBuilder: (_,__,___) {
                                                    return SizedBox(
                                                      height: 300, width: 300,
                                                      child: PickMapScreen(fromSignUp: false, canRoute: false, fromAddAddress: true, route: null, googleMapController: locationController.mapController)
                                                    );
                                                  });
                                                }else {
                                                  Get.toNamed(
                                                    RouteHelper.getPickMapRoute('add-address', false),
                                                    arguments: PickMapScreen(
                                                      fromAddAddress: true,
                                                      fromSignUp: false,
                                                      googleMapController: locationController.mapController,
                                                      route: null,
                                                      canRoute: false,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: 30, height: 30,
                                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                                                child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeLarge),


                                    Text(
                                      'label_as'.tr,
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    SizedBox(height: 50, child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: locationController.addressTypeList.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                        child: InkWell(
                                          onTap: () {
                                            _otherSelect = index == 2;
                                            locationController.setAddressTypeIndex(index);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                color: locationController.addressTypeIndex == index ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                                                // border: Border.all(color: locationController.addressTypeIndex == index ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 24, width: 24,
                                                  child: Image.asset(
                                                    index == 0 ? Images.homeIcon : index == 1 ? Images.workIcon : Images.otherIcon,
                                                    color: locationController.addressTypeIndex == index ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
                                                  ),
                                                ),
                                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                                Text(index == 0 ? 'home'.tr : index == 1 ? 'office'.tr : 'others'.tr,
                                                  style: robotoRegular.copyWith(color: locationController.addressTypeIndex == index ? Theme.of(context).cardColor : Theme.of(context).disabledColor),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    _otherSelect ? SizedBox (
                                      height: 90, width: 680,
                                      child: CustomTextField(
                                        titleText: '${'level_name'.tr}(${'optional'.tr})',
                                        hintText: '',
                                        showTitle: true,
                                        inputType: TextInputType.text,
                                        controller: _levelController,
                                        focusNode: _levelNode,
                                        nextFocus: _addressNode,
                                        capitalization: TextCapitalization.words,
                                      ),
                                    ) : const SizedBox(),

                                    const SizedBox(height: Dimensions.paddingSizeLarge),
                                    SizedBox(height: 90, width: 680,
                                      child: CustomTextField(
                                        suffixIcon: Icons.my_location,
                                        showTitle: true,
                                        titleText: 'delivery_address'.tr,
                                        inputType: TextInputType.streetAddress,
                                        controller: _addressController,
                                        focusNode: _addressNode,
                                        nextFocus: _nameNode,
                                        onChanged: (text) => locationController.setPlaceMark(text),
                                      ),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeLarge),
                                  ],
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeLarge),

                              Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      color: Theme.of(context).cardColor,
                                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                                    ),
                                    child: Column(
                                      children: [

                                        CustomTextField(
                                          showTitle: true,
                                          titleText: 'contact_person_name'.tr,
                                          hintText: ' ',
                                          inputType: TextInputType.name,
                                          controller: _contactPersonNameController,
                                          focusNode: _nameNode,
                                          nextFocus: _numberNode,
                                          capitalization: TextCapitalization.words,
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeLarge),

                                        CustomTextField(
                                          showTitle: true,
                                          titleText: 'contact_person_number'.tr,
                                          hintText: ' ',
                                          controller: _contactPersonNumberController,
                                          focusNode: _numberNode,
                                          nextFocus: widget.forGuest ? _emailFocus :_streetNode,
                                          inputType: TextInputType.phone,
                                          isPhone: true,
                                          onCountryChanged: (CountryCode countryCode) {
                                            _countryDialCode = countryCode.dialCode;
                                          },
                                          countryDialCode: _countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeLarge),

                                        widget.forGuest ? CustomTextField(
                                          showTitle: true,
                                          titleText: 'email'.tr,
                                          hintText: ' ',
                                          controller: _emailController,
                                          focusNode: _emailFocus,
                                          nextFocus: _streetNode,
                                          inputType: TextInputType.emailAddress,
                                        ) : const SizedBox(),
                                        SizedBox(height: widget.forGuest ? Dimensions.paddingSizeLarge : 0),

                                        CustomTextField(
                                          showTitle: true,
                                          hintText: ' ',
                                          titleText: '${'street_number'.tr} (${'optional'.tr})',
                                          inputType: TextInputType.streetAddress,
                                          focusNode: _streetNode,
                                          nextFocus: _houseNode,
                                          controller: _streetNumberController,
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeLarge),

                                        Row(children: [
                                          Expanded(
                                            child: CustomTextField(
                                              showTitle: true,
                                              hintText: ' ',
                                              titleText: '${'house'.tr} (${'optional'.tr})',
                                              inputType: TextInputType.text,
                                              focusNode: _houseNode,
                                              nextFocus: _floorNode,
                                              controller: _houseController,
                                            ),
                                          ),
                                          const SizedBox(width: Dimensions.paddingSizeSmall),

                                          Expanded(
                                            child: CustomTextField(
                                              hintText: ' ',
                                              showTitle: true,
                                              titleText: "${'floor'.tr} (${'optional'.tr})",
                                              inputType: TextInputType.text,
                                              focusNode: _floorNode,
                                              inputAction: TextInputAction.done,
                                              controller: _floorController,
                                            ),
                                          ),
                                        ]),
                                        const SizedBox(height: Dimensions.paddingSizeLarge),

                                        button(locationController),
                                      ],
                                    ),
                                  )
                              ),


                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Column(children: [
              Expanded(child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: Stack(clipBehavior: Clip.none, children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 16),
                          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                          onTap: (latLng) {
                          if(ResponsiveHelper.isDesktop(Get.context)) {
                            showGeneralDialog(context: context, pageBuilder: (_,__,___) {
                              return SizedBox(
                                  height: 300, width: 300,
                                  child: PickMapScreen(fromSignUp: false, canRoute: false, fromAddAddress: true, route: null, googleMapController: locationController.mapController)
                              );
                            });
                            // Get.dialog(PickMapScreen(fromSignUp: false, canRoute: false, fromAddAddress: true, route: null, googleMapController: locationController.mapController));
                          }else {
                            Get.toNamed(
                              RouteHelper.getPickMapRoute('add-address', false),
                              arguments: PickMapScreen(
                                fromAddAddress: true,
                                fromSignUp: false,
                                googleMapController: locationController.mapController,
                                route: null,
                                canRoute: false,
                              ),
                            );
                          }
                          },
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: false,
                          onCameraIdle: () {
                            locationController.updatePosition(_cameraPosition, true);
                          },
                          onCameraMove: ((position) {
                            _cameraPosition = position;
                          }
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            locationController.setMapController(controller);
                            if(widget.address == null) {
                              locationController.getCurrentLocation(true, mapController: controller);
                            }
                          },
                        ),
                        locationController.loading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
                        Center(child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50)
                            : const CircularProgressIndicator()),
                        Positioned(
                          bottom: 10, right: 0,
                          child: InkWell(
                            onTap: () => _checkPermission(() {
                              locationController.getCurrentLocation(true, mapController: locationController.mapController);
                            }),
                            child: Container(
                              width: 30, height: 30,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                              child: Icon(Icons.my_location, color: Theme.of(context).primaryColor, size: 20),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10, right: 0,
                          child: InkWell(
                            onTap: () {
                              if(ResponsiveHelper.isDesktop(Get.context)) {
                                showGeneralDialog(context: context, pageBuilder: (_,__,___) {
                                  return SizedBox(
                                      height: 300, width: 300,
                                      child: PickMapScreen(fromSignUp: false, canRoute: false, fromAddAddress: true, route: null, googleMapController: locationController.mapController)
                                  );
                                });
                              }else {
                                Get.toNamed(
                                  RouteHelper.getPickMapRoute('add-address', false),
                                  arguments: PickMapScreen(
                                    fromAddAddress: true,
                                    fromSignUp: false,
                                    googleMapController: locationController.mapController,
                                    route: null,
                                    canRoute: false,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 30, height: 30,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                              child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Center(child: Text(
                    'add_the_location_correctly'.tr,
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall),
                  )),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text(
                    'label_as'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  SizedBox(height: 50, child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: locationController.addressTypeList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      child: InkWell(
                        onTap: () {
                          _otherSelect = index == 2;
                          locationController.setAddressTypeIndex(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault), color: locationController.addressTypeIndex == index
                              ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
                            boxShadow: locationController.addressTypeIndex == index ? null : const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                            border: Border.all(color: locationController.addressTypeIndex == index ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)
                          ),
                          child: SizedBox(
                            height: 24, width: 24,
                            child: Image.asset(
                              index == 0 ? Images.homeIcon : index == 1 ? Images.workIcon : Images.otherIcon,
                              color: locationController.addressTypeIndex == index ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(height: _otherSelect ? Dimensions.paddingSizeLarge : 0),

                  _otherSelect ? CustomTextField(
                    titleText: '${'level_name'.tr}(${'optional'.tr})',
                    inputType: TextInputType.text,
                    controller: _levelController,
                    focusNode: _levelNode,
                    nextFocus: _addressNode,
                    capitalization: TextCapitalization.words,
                  ) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextField(
                    titleText: 'delivery_address'.tr,
                    inputType: TextInputType.streetAddress,
                    controller: _addressController,
                    focusNode: _addressNode,
                    nextFocus: _nameNode,
                    onChanged: (text) => locationController.setPlaceMark(text),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextField(
                    titleText: 'contact_person_name'.tr,
                    inputType: TextInputType.name,
                    controller: _contactPersonNameController,
                    focusNode: _nameNode,
                    nextFocus: _numberNode,
                    capitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextField(
                    titleText: 'contact_person_number'.tr,
                    controller: _contactPersonNumberController,
                    focusNode: _numberNode,
                    nextFocus: widget.forGuest ? _emailFocus : _streetNode,
                    inputType: TextInputType.phone,
                    isPhone: true,
                    onCountryChanged: (CountryCode countryCode) {
                      _countryDialCode = countryCode.dialCode;
                    },
                    countryDialCode: _countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  widget.forGuest ? CustomTextField(
                    titleText: 'email'.tr,
                    hintText: 'enter_email'.tr,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    nextFocus: _streetNode,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail,
                  ) : const SizedBox(),
                  SizedBox(height: widget.forGuest ? Dimensions.paddingSizeLarge : 0),

                  CustomTextField(
                    titleText: '${'street_number'.tr} (${'optional'.tr})',
                    inputType: TextInputType.streetAddress,
                    focusNode: _streetNode,
                    nextFocus: _houseNode,
                    controller: _streetNumberController,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Row(children: [
                    Expanded(
                      child: CustomTextField(
                        titleText: '${'house'.tr} (${'optional'.tr})',
                        inputType: TextInputType.text,
                        focusNode: _houseNode,
                        nextFocus: _floorNode,
                        controller: _houseController,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: CustomTextField(
                        titleText: "${'floor'.tr} (${'optional'.tr})",
                        inputType: TextInputType.text,
                        focusNode: _floorNode,
                        inputAction: TextInputAction.done,
                        controller: _floorController,
                      ),
                    ),
                  ]),

                  const SizedBox(height: Dimensions.paddingSizeLarge),

                ]))),
              )),

              button(locationController),
            ]);
          });
        }) ,
      ),
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialogWidget());
    }else {
      onTap();
    }
  }

  Widget button(LocationController locationController) {
    return Container(
      width: Dimensions.webMaxWidth,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: CustomButton(
        radius: Dimensions.radiusSmall,
        isBold: false,
        isLoading: locationController.isLoading,
        buttonText: widget.forGuest ? 'done'.tr : widget.address == null
            ? 'save_location'.tr : 'update_address'.tr,
        onPressed: () async => _onSaveOrUpdateButtonPressed(locationController),
      ),
    );
  }

  void _onSaveOrUpdateButtonPressed(LocationController locationController) async {

    String numberWithCountryCode = _countryDialCode! + _contactPersonNumberController.text;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    AddressModel? addressModel = _prepareAddressModel(locationController, phoneValid.isValid, numberWithCountryCode);
    if(addressModel == null) {
      return;
    }

    if(widget.forGuest) {
      addressModel.email = _emailController.text;
      Get.back(result: addressModel);
    } else {
      if(widget.address == null) {
        _addAddress(addressModel);
      }else {
        _updateAddress(addressModel);
      }
    }

  }

  AddressModel? _prepareAddressModel(LocationController locationController, bool isValid, String numberWithCountryCode) {
    String? addressType = locationController.addressTypeList[locationController.addressTypeIndex];
    if(locationController.addressTypeIndex == 2){
      addressType = _levelController.text.isNotEmpty ? _levelController.text.trim() : locationController.addressTypeList[locationController.addressTypeIndex];
    }
    if(_addressController.text.isEmpty) {
      showCustomSnackBar('please_enter_the_delivery_address'.tr);
    } else if(_contactPersonNameController.text.isEmpty) {
      showCustomSnackBar('please_enter_the_contact_person_name'.tr);
    } else if(_contactPersonNumberController.text.isEmpty) {
      showCustomSnackBar('please_enter_the_phone_number'.tr);
    } else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if(widget.forGuest && _emailController.text.isEmpty) {
      showCustomSnackBar('please_enter_contact_person_email'.tr);
    } else {
      AddressModel addressModel = AddressModel(
        id: widget.address?.id,
        addressType: addressType,
        contactPersonName: _contactPersonNameController.text,
        contactPersonNumber: _countryDialCode! + _contactPersonNumberController.text,
        address: _addressController.text,
        latitude: locationController.position.latitude.toString(),
        longitude: locationController.position.longitude.toString(),
        zoneId: locationController.zoneID,
        streetNumber: _streetNumberController.text,
        house: _houseController.text,
        floor: _floorController.text,
      );
      return addressModel;
    }
    return null;
  }

  void _addAddress(AddressModel addressModel) {
    Get.find<AddressController>().addAddress(addressModel, widget.fromCheckout, widget.zoneId).then((response) {
      if(response.isSuccess) {
        widget.fromNavBar ? Get.back() : Get.offNamed(RouteHelper.getAddressRoute());
        showCustomSnackBar('new_address_added_successfully'.tr, isError: false);
      }else {
        showCustomSnackBar(response.message);
      }
    });
  }

  void _updateAddress(AddressModel addressModel) {
    Get.find<AddressController>().updateAddress(addressModel, widget.address!.id).then((response) {
      if(response.isSuccess) {
        Get.back();
        showCustomSnackBar(response.message, isError: false);
      }else {
        showCustomSnackBar(response.message);
      }
    });
  }

}
