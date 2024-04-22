import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/auth/controllers/store_registration_controller.dart';
import 'package:sixam_mart/features/auth/domain/models/delivery_man_body.dart';
import 'package:sixam_mart/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:sixam_mart/features/auth/widgets/condition_check_box_widget.dart';
import 'package:sixam_mart/features/auth/widgets/pass_view_widget.dart';
import 'package:sixam_mart/helper/custom_validator.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_dropdown.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';

class DeliveryManRegistrationScreen extends StatefulWidget {
  const DeliveryManRegistrationScreen({super.key});

  @override
  State<DeliveryManRegistrationScreen> createState() => _DeliveryManRegistrationScreenState();
}

class _DeliveryManRegistrationScreenState extends State<DeliveryManRegistrationScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    if(Get.find<DeliverymanRegistrationController>().showPassView){
      Get.find<DeliverymanRegistrationController>().showHidePass();
    }
    Get.find<DeliverymanRegistrationController>().pickDmImage(false, true);
    Get.find<DeliverymanRegistrationController>().dmStatusChange(0.4, isUpdate: false);
    Get.find<StoreRegistrationController>().validPassCheck('', isUpdate: false);
    Get.find<DeliverymanRegistrationController>().setIdentityTypeIndex(Get.find<DeliverymanRegistrationController>().identityTypeList[0], false);
    Get.find<DeliverymanRegistrationController>().setDMTypeIndex(0, false);
    Get.find<DeliverymanRegistrationController>().getZoneList();
    Get.find<DeliverymanRegistrationController>().getVehicleList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(Get.find<DeliverymanRegistrationController>().dmStatus != 0.4 && !didPop){
          Get.find<DeliverymanRegistrationController>().dmStatusChange(0.4);
        }else{
          Future.delayed(const Duration(milliseconds: 0), () => Get.back());
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: CustomAppBar(title: 'delivery_man_registration'.tr, onBackPressed: (){
          if(Get.find<DeliverymanRegistrationController>().dmStatus != 0.4){
            Get.find<DeliverymanRegistrationController>().dmStatusChange(0.4);
          }else{
            Future.delayed(const Duration(milliseconds: 0), () => Get.back());
          }
        },),
        endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        body: GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanRegistrationController) {

          List<int> zoneIndexList = [];
          List<DropdownItem<int>> zoneList = [];
          List<DropdownItem<int>> vehicleList = [];
          List<DropdownItem<int>> dmTypeList = [];
          List<DropdownItem<int>> identityTypeList = [];

          for(int index=0; index<deliverymanRegistrationController.dmTypeList.length; index++) {
            dmTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${deliverymanRegistrationController.dmTypeList[index]?.tr}'),
              ),
            )));
          }
          for(int index=0; index<deliverymanRegistrationController.identityTypeList.length; index++) {
            identityTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(deliverymanRegistrationController.identityTypeList[index].tr),
              ),
            )));
          }
          if(deliverymanRegistrationController.zoneList != null) {
            for(int index=0; index<deliverymanRegistrationController.zoneList!.length; index++) {
              zoneIndexList.add(index);
              zoneList.add(DropdownItem<int>(value: index, child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${deliverymanRegistrationController.zoneList![index].name}'),
                ),
              )));
            }
          }
          if(deliverymanRegistrationController.vehicles != null){

            for(int index=0; index<deliverymanRegistrationController.vehicles!.length; index++) {
              vehicleList.add(DropdownItem<int>(value: index, child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${deliverymanRegistrationController.vehicles![index].type}'),
                ),
              )));
            }
          }

          return SafeArea(child: ResponsiveHelper.isDesktop(context) ? webView(deliverymanRegistrationController, zoneList, dmTypeList, vehicleList, identityTypeList) : Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
              child: Column(children: [
                Text(
                  'complete_registration_process_to_serve_as_delivery_man'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                LinearProgressIndicator(
                  backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                  value: deliverymanRegistrationController.dmStatus,
                ),
                // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              ]),
            ),

            Expanded(child: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
              physics: const BouncingScrollPhysics(),
              child: FooterView(
                child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


                  Column(children: [
                    Visibility(
                      visible: deliverymanRegistrationController.dmStatus == 0.4,
                      child: Column(children: [

                        Align(alignment: Alignment.center, child: Stack(clipBehavior: Clip.none, children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: deliverymanRegistrationController.pickedImage != null ? GetPlatform.isWeb ? Image.network(
                              deliverymanRegistrationController.pickedImage!.path, width: 150, height: 120, fit: BoxFit.cover,
                            ) : Image.file(
                              File(deliverymanRegistrationController.pickedImage!.path), width: 150, height: 120, fit: BoxFit.cover,
                            ) : SizedBox(
                              width: 150, height: 120,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                Icon(Icons.photo_camera, size: 38, color: Theme.of(context).disabledColor),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Text(
                                  'upload_profile_picture'.tr,
                                  style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                                ),
                              ]),
                            ),
                          ),

                          Positioned(
                            bottom: 0, right: 0, top: 0, left: 0,
                            child: InkWell(
                              onTap: () => deliverymanRegistrationController.pickDmImage(true, false),
                              child: DottedBorder(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const [5, 5],
                                padding: const EdgeInsets.all(0),
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(Dimensions.radiusDefault),
                                child: Visibility(
                                  visible: deliverymanRegistrationController.pickedImage != null,
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white), shape: BoxShape.circle,),
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                      child: const Icon(Icons.camera_alt, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          deliverymanRegistrationController.pickedImage != null ? Positioned(
                            bottom: -10, right: -10,
                            child: InkWell(
                              onTap: () => deliverymanRegistrationController.removeDmImage(),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).cardColor, width: 2),
                                  shape: BoxShape.circle, color: Theme.of(context).colorScheme.error,
                                ),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                child:  Icon(Icons.remove, size: 18, color: Theme.of(context).cardColor,),
                              ),
                            ),

                          ) : const SizedBox(),
                        ])),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        Row(children: [
                          Expanded(child: CustomTextField(
                            titleText: 'first_name'.tr,
                            controller: _fNameController,
                            capitalization: TextCapitalization.words,
                            inputType: TextInputType.name,
                            focusNode: _fNameNode,
                            nextFocus: _lNameNode,
                            prefixIcon: Icons.person,
                          )),
                          const SizedBox(width: Dimensions.paddingSizeLarge),

                          Expanded(child: CustomTextField(
                            titleText: 'last_name'.tr,
                            controller: _lNameController,
                            capitalization: TextCapitalization.words,
                            inputType: TextInputType.name,
                            focusNode: _lNameNode,
                            nextFocus: _phoneNode,
                            prefixIcon: Icons.person,
                          )),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextField(
                          titleText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'enter_phone_number'.tr,
                          controller: _phoneController,
                          focusNode: _phoneNode,
                          nextFocus: _emailNode,
                          inputType: TextInputType.phone,
                          isPhone: true,
                          onCountryChanged: (CountryCode countryCode) {
                            _countryDialCode = countryCode.dialCode;
                          },
                          countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                              : Get.find<LocalizationController>().locale.countryCode,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextField(
                          titleText: 'email'.tr,
                          controller: _emailController,
                          focusNode: _emailNode,
                          nextFocus: _passwordNode,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextField(
                          titleText: 'password'.tr,
                          controller: _passwordController,
                          focusNode: _passwordNode,
                          nextFocus: _identityNumberNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          isPassword: true,
                          prefixIcon: Icons.lock,
                          onChanged: (value){
                            if(value != null && value.isNotEmpty){
                              if(!deliverymanRegistrationController.showPassView){
                                deliverymanRegistrationController.showHidePass();
                              }
                              deliverymanRegistrationController.validPassCheck(value);
                            }else{
                              if(deliverymanRegistrationController.showPassView){
                                deliverymanRegistrationController.showHidePass();
                              }
                            }
                          },
                        ),

                        deliverymanRegistrationController.showPassView ? const PassViewWidget(forStoreRegistration: false) : const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextField(
                          titleText: 'confirm_password'.tr,
                          hintText: '',
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                        )
                      ]),
                    ),

                    Visibility(
                      visible: deliverymanRegistrationController.dmStatus != 0.4,
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [

                        Row(children: [
                          Expanded(child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                            ),
                            child: CustomDropdown<int>(
                              onChange: (int? value, int index) {
                                deliverymanRegistrationController.setDMTypeIndex(index, true);
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 45,
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeExtraSmall,
                                  horizontal: Dimensions.paddingSizeExtraSmall,
                                ),
                                primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                              dropdownStyle: DropdownStyle(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              ),
                              items: dmTypeList,
                              child: Text('select_delivery_type'.tr),
                            ),
                          )
                          ),
                          const SizedBox(width: Dimensions.paddingSizeLarge),

                          Expanded(child: deliverymanRegistrationController.zoneList != null ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                            ),
                            child: CustomDropdown<int>(
                              onChange: (int? value, int index) {
                                deliverymanRegistrationController.setZoneIndex(value);
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 45,
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeExtraSmall,
                                  horizontal: Dimensions.paddingSizeExtraSmall,
                                ),
                                primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                              dropdownStyle: DropdownStyle(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              ),
                              items: zoneList,
                              child: Text('${deliverymanRegistrationController.zoneList![0].name}'),
                            ),
                          ) : const Center(child: CircularProgressIndicator())),
                        ]),

                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        deliverymanRegistrationController.vehicleIds != null ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                          ),
                          child: CustomDropdown<int>(
                            onChange: (int? value, int index) {
                              deliverymanRegistrationController.setVehicleIndex(value, true);
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                                horizontal: Dimensions.paddingSizeExtraSmall,
                              ),
                              primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            dropdownStyle: DropdownStyle(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            ),
                            items: vehicleList,
                            child: Text('${deliverymanRegistrationController.vehicles![0].type}'),
                          ),
                        ) : const CircularProgressIndicator(),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                          ),
                          child: CustomDropdown<int>(
                            onChange: (int? value, int index) {
                              deliverymanRegistrationController.setIdentityTypeIndex(deliverymanRegistrationController.identityTypeList[index], true);
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                                horizontal: Dimensions.paddingSizeExtraSmall,
                              ),
                              primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            dropdownStyle: DropdownStyle(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            ),
                            items: identityTypeList,
                            child: Text(deliverymanRegistrationController.identityTypeList[0].tr),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextField(
                          titleText: deliverymanRegistrationController.identityTypeIndex == 0 ? 'Ex: XXXXX-XXXXXXX-X'
                              : deliverymanRegistrationController.identityTypeIndex == 1 ? 'L-XXX-XXX-XXX-XXX.' : 'XXX-XXXXX',
                          controller: _identityNumberController,
                          focusNode: _identityNumberNode,
                          inputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: deliverymanRegistrationController.pickedIdentities.length+1,
                          itemBuilder: (context, index) {
                            XFile? file = index == deliverymanRegistrationController.pickedIdentities.length ? null : deliverymanRegistrationController.pickedIdentities[index];
                            if(index == deliverymanRegistrationController.pickedIdentities.length) {
                              return InkWell(
                                onTap: () => deliverymanRegistrationController.pickDmImage(false, false),
                                child: DottedBorder(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [5, 5],
                                  padding: const EdgeInsets.all(5),
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(Dimensions.radiusDefault),
                                  child: SizedBox(
                                    height: 120, width: double.infinity,
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Icon(Icons.camera_alt, color: Theme.of(context).disabledColor, size: 38),
                                      Text('upload_identity_image'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
                                    ]),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                              child: DottedBorder(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const [5, 5],
                                padding: const EdgeInsets.all(5),
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(Dimensions.radiusDefault),
                                child: Stack(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    child: GetPlatform.isWeb ? Image.network(
                                      file!.path, width: double.infinity, height: 120, fit: BoxFit.cover,
                                    ) : Image.file(
                                      File(file!.path), width: double.infinity, height: 120, fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0, top: 0,
                                    child: InkWell(
                                      onTap: () => deliverymanRegistrationController.removeIdentityImage(index),
                                      child: const Padding(
                                        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: Icon(Icons.delete_forever, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        const ConditionCheckBoxWidget(forDeliveryMan: true, forSignUp: false),

                      ]),
                    ),
                  ]),


                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? buttonView() : const SizedBox() ,

                ])),
              ),
            )),

            (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? const SizedBox() : buttonView(),

          ]));
        }),
      ),
    );
  }

  //

  Widget webView(DeliverymanRegistrationController deliverymanRegistrationController, List<DropdownItem<int>> zoneList, List<DropdownItem<int>> typeList,
      List<DropdownItem<int>> vehicleList, List<DropdownItem<int>> identityTypeList) {
    return SingleChildScrollView(
      child: Column(
        children: [
          WebScreenTitleWidget(title: 'join_as_delivery_man'.tr),
          FooterView(
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(children: [
                      Text('delivery_man_registration'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(
                        'complete_registration_process_to_serve_as_delivery_man'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Align(alignment: Alignment.center, child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: deliverymanRegistrationController.pickedImage != null ? GetPlatform.isWeb ? Image.network(
                            deliverymanRegistrationController.pickedImage!.path, width: 180, height: 180, fit: BoxFit.cover,
                          ) : Image.file(
                            File(deliverymanRegistrationController.pickedImage!.path), width: 180, height: 180, fit: BoxFit.cover,
                          ) : SizedBox(
                            width: 180, height: 180,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Icon(Icons.camera_alt, size: 38, color: Theme.of(context).disabledColor),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(
                                'upload_deliveryman_photo'.tr,
                                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                              ),
                            ]),
                          ),
                        ),

                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => deliverymanRegistrationController.pickDmImage(true, false),
                            child: DottedBorder(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [5, 5],
                              padding: const EdgeInsets.all(0),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusDefault),
                              child: Visibility(
                                visible: deliverymanRegistrationController.pickedImage != null,
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white), shape: BoxShape.circle,),
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                    child: const Icon(Icons.camera_alt, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Row(children: [
                        Expanded(child: CustomTextField(
                          titleText: 'first_name'.tr,
                          controller: _fNameController,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          focusNode: _fNameNode,
                          nextFocus: _lNameNode,
                          prefixIcon: Icons.person,
                          showTitle: true,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextField(
                          titleText: 'last_name'.tr,
                          controller: _lNameController,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          focusNode: _lNameNode,
                          nextFocus: _phoneNode,
                          prefixIcon: Icons.person,
                          showTitle: true,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          child: CustomTextField(
                            titleText: 'phone'.tr,
                            controller: _phoneController,
                            focusNode: _phoneNode,
                            nextFocus: _emailNode,
                            inputType: TextInputType.phone,
                            isPhone: true,
                            showTitle: ResponsiveHelper.isDesktop(context),
                            onCountryChanged: (CountryCode countryCode) {
                              _countryDialCode = countryCode.dialCode;
                            },
                            countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                                : Get.find<LocalizationController>().locale.countryCode,
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child:CustomTextField(
                          titleText: 'email'.tr,
                          controller: _emailController,
                          focusNode: _emailNode,
                          nextFocus: _passwordNode,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          showTitle: true,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Column(
                          children: [
                            CustomTextField(
                              titleText: 'password'.tr,
                              controller: _passwordController,
                              focusNode: _passwordNode,
                              nextFocus: _identityNumberNode,
                              inputAction: TextInputAction.done,
                              inputType: TextInputType.visiblePassword,
                              isPassword: true,
                              prefixIcon: Icons.lock,
                              showTitle: true,
                              onChanged: (value){
                                // authController.validPassCheck(value);
                                if(value != null && value.isNotEmpty){
                                  if(!deliverymanRegistrationController.showPassView){
                                    deliverymanRegistrationController.showHidePass();
                                  }
                                  deliverymanRegistrationController.validPassCheck(value);
                                }else{
                                  if(deliverymanRegistrationController.showPassView){
                                    deliverymanRegistrationController.showHidePass();
                                  }
                                }
                              },
                            ),

                            deliverymanRegistrationController.showPassView ? const PassViewWidget(forStoreRegistration: false) : const SizedBox(),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextField(
                          titleText: 'confirm_password'.tr,
                          hintText: '8_character'.tr,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          showTitle: true,
                        ))
                      ]),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(children: [
                      Row(children: [
                        const Icon(Icons.person),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Text('delivery_man_information'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                      ]),
                      const Divider(),
                      const SizedBox(height: Dimensions.paddingSizeLarge),


                      Row(children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('delivery_man_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setDMTypeIndex(index, true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: typeList,
                                child: Text('${deliverymanRegistrationController.dmTypeList[0]}'),
                              ),
                            ),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('zone'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            deliverymanRegistrationController.zoneIds != null ?  Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setZoneIndex(value);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: zoneList,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(deliverymanRegistrationController.selectedZoneIndex == -1 ? 'select_zone'.tr : deliverymanRegistrationController.zoneList![deliverymanRegistrationController.selectedZoneIndex!].name.toString()),
                                ),
                              ),
                            ) : Center(child: Text('service_not_available_in_this_area'.tr)),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('vehicle_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            deliverymanRegistrationController.vehicleIds != null ?  Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setVehicleIndex(value, true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: vehicleList,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(deliverymanRegistrationController.vehicles![deliverymanRegistrationController.vehicleIndex!].type!),
                                ),
                              ),
                            ) : const Center(child: CircularProgressIndicator()),
                          ]),
                        ),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Row(children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('identity_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  deliverymanRegistrationController.setIdentityTypeIndex(deliverymanRegistrationController.identityTypeList[index], true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: identityTypeList,
                                child: Text(deliverymanRegistrationController.identityTypeList[0].tr),
                              ),
                            ),

                          ]),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextField(
                          titleText: deliverymanRegistrationController.identityTypeIndex == 0 ? 'identity_number'.tr
                              : deliverymanRegistrationController.identityTypeIndex == 1 ? 'driving_license_number'.tr : 'nid_number'.tr,
                          controller: _identityNumberController,
                          focusNode: _identityNumberNode,
                          inputAction: TextInputAction.done,
                          showTitle: true,
                        ),),

                        const Expanded(child: SizedBox()),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: deliverymanRegistrationController.pickedIdentities.length+1,
                          itemBuilder: (context, index) {
                            XFile? file = index == deliverymanRegistrationController.pickedIdentities.length ? null : deliverymanRegistrationController.pickedIdentities[index];
                            if(index == deliverymanRegistrationController.pickedIdentities.length) {
                              return InkWell(
                                onTap: () => deliverymanRegistrationController.pickDmImage(false, false),
                                child: DottedBorder(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [5, 5],
                                  padding: const EdgeInsets.all(5),
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(Dimensions.radiusDefault),
                                  child: Container(
                                    height: 120, width: 150, alignment: Alignment.center,
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                    child: Column(
                                      children: [
                                        Icon(Icons.camera_alt, color: Theme.of(context).disabledColor),
                                        Text('upload_identity_image'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: GetPlatform.isWeb ? Image.network(
                                    file!.path, width: 150, height: 120, fit: BoxFit.cover,
                                  ) : Image.file(
                                    File(file!.path), width: 150, height: 120, fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0, top: 0,
                                  child: InkWell(
                                    onTap: () => deliverymanRegistrationController.removeIdentityImage(index),
                                    child: const Padding(
                                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      child: Icon(Icons.delete_forever, color: Colors.red),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).hintColor)
                          ),
                          width: 165,
                          child: CustomButton(
                            transparent: true,
                            textColor: Theme.of(context).hintColor,
                            radius: Dimensions.radiusSmall,
                            onPressed: () {
                              _phoneController.text = '';
                              _emailController.text = '';
                              _fNameController.text = '';
                              _lNameController.text = '';
                              _lNameController.text = '';
                              _passwordController.text = '';
                              _confirmPasswordController.text = '';
                              _identityNumberController.text = '';
                              deliverymanRegistrationController.resetDeliveryRegistration();
                            },
                            buttonText: 'reset'.tr,
                            isBold: false,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),

                        const SizedBox( width: Dimensions.paddingSizeLarge),
                        SizedBox(width: 165, child: buttonView()),
                      ])


                    ]),
                  ),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buttonView(){
    return GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanRegistrationController) {
        return CustomButton(
          isBold: ResponsiveHelper.isDesktop(context) ? false : true,
          radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
          isLoading: deliverymanRegistrationController.isLoading,
          buttonText: deliverymanRegistrationController.dmStatus == 0.4 ? 'next'.tr : 'submit'.tr,
          margin: EdgeInsets.all((ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? 0 : Dimensions.paddingSizeSmall),
          height: 50,
          onPressed: !deliverymanRegistrationController.acceptTerms ? null : () async {
            if(deliverymanRegistrationController.dmStatus == 0.4 && !ResponsiveHelper.isDesktop(context)){
              String fName = _fNameController.text.trim();
              String lName = _lNameController.text.trim();
              String email = _emailController.text.trim();
              String phone = _phoneController.text.trim();
              String password = _passwordController.text.trim();
              String confirmPassword = _confirmPasswordController.text.trim();
              String numberWithCountryCode = _countryDialCode!+phone;
              PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);

              if(fName.isEmpty) {
                showCustomSnackBar('enter_delivery_man_first_name'.tr);
              }else if(lName.isEmpty) {
                showCustomSnackBar('enter_delivery_man_last_name'.tr);
              }else if(deliverymanRegistrationController.pickedImage == null) {
                showCustomSnackBar('pick_delivery_man_profile_image'.tr);
              }else if(email.isEmpty) {
                showCustomSnackBar('enter_delivery_man_email_address'.tr);
              }else if(!GetUtils.isEmail(email)) {
                showCustomSnackBar('enter_a_valid_email_address'.tr);
              }else if(phone.isEmpty) {
                showCustomSnackBar('enter_delivery_man_phone_number'.tr);
              }else if(!phoneValid.isValid) {
                showCustomSnackBar('enter_a_valid_phone_number'.tr);
              }else if(password.isEmpty) {
                showCustomSnackBar('enter_password_for_delivery_man'.tr);
              }else if(password != confirmPassword) {
                showCustomSnackBar('confirm_password_does_not_matched'.tr);
              }else if(!deliverymanRegistrationController.spatialCheck || !deliverymanRegistrationController.lowercaseCheck || !deliverymanRegistrationController.uppercaseCheck || !deliverymanRegistrationController.numberCheck || !deliverymanRegistrationController.lengthCheck) {
                showCustomSnackBar('provide_valid_password'.tr);
              }else {
                deliverymanRegistrationController.dmStatusChange(0.8);
              }
            }else{
              _addDeliveryMan(deliverymanRegistrationController);
            }
          },
        );
      });
  }

  void _addDeliveryMan(DeliverymanRegistrationController deliverymanRegiController) async {
    String fName = _fNameController.text.trim();
    String lName = _lNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String identityNumber = _identityNumberController.text.trim();
    String numberWithCountryCode = _countryDialCode!+phone;

    if(ResponsiveHelper.isDesktop(context)) {
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      if(fName.isEmpty) {
        showCustomSnackBar('enter_delivery_man_first_name'.tr);
        return;
      }else if(lName.isEmpty) {
        showCustomSnackBar('enter_delivery_man_last_name'.tr);
        return;
      }else if(deliverymanRegiController.pickedImage == null) {
        showCustomSnackBar('pick_delivery_man_profile_image'.tr);
        return;
      }else if(email.isEmpty) {
        showCustomSnackBar('enter_delivery_man_email_address'.tr);
        return;
      }else if(!GetUtils.isEmail(email)) {
        showCustomSnackBar('enter_a_valid_email_address'.tr);
        return;
      }else if(phone.isEmpty) {
        showCustomSnackBar('enter_delivery_man_phone_number'.tr);
        return;
      }else if(!phoneValid.isValid) {
        showCustomSnackBar('enter_a_valid_phone_number'.tr);
        return;
      }else if(password.isEmpty) {
        showCustomSnackBar('enter_password_for_delivery_man'.tr);
        return;
      }else if(!deliverymanRegiController.spatialCheck || !deliverymanRegiController.lowercaseCheck || !deliverymanRegiController.uppercaseCheck || !deliverymanRegiController.numberCheck || !deliverymanRegiController.lengthCheck) {
        showCustomSnackBar('provide_valid_password'.tr);
        return;
      }
    }

    if(identityNumber.isEmpty) {
      showCustomSnackBar('enter_delivery_man_identity_number'.tr);
    }else if(deliverymanRegiController.pickedImage == null) {
      showCustomSnackBar('upload_delivery_man_image'.tr);
    }else if(deliverymanRegiController.vehicleIndex! == -1) {
      showCustomSnackBar('please_select_vehicle_for_the_deliveryman'.tr);
    }else if(deliverymanRegiController.pickedIdentities.isEmpty) {
      showCustomSnackBar('please_upload_identity_image'.tr);
    }else if(deliverymanRegiController.dmTypeIndex == 0) {
      showCustomSnackBar('please_select_deliveryman_type'.tr);
    }else {
      deliverymanRegiController.registerDeliveryMan(DeliveryManBody(
        fName: fName, lName: lName, password: password, phone: numberWithCountryCode, email: email,
        identityNumber: identityNumber, identityType: deliverymanRegiController.identityTypeList[deliverymanRegiController.identityTypeIndex],
        earning: deliverymanRegiController.dmTypeIndex == 1 ? '1' : '0', zoneId: deliverymanRegiController.zoneList![deliverymanRegiController.selectedZoneIndex!].id.toString(),
        vehicleId: deliverymanRegiController.vehicles![deliverymanRegiController.vehicleIndex!].id.toString(),
      ));
    }
  }
}

