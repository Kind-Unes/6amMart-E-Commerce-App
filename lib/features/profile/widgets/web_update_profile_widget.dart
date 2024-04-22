import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/profile/domain/models/userinfo_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/common/widgets/image_picker_widget.dart';


class WebUpdateProfileWidget extends StatefulWidget {
  const WebUpdateProfileWidget({super.key});

  @override
  State<WebUpdateProfileWidget> createState() => _WebUpdateProfileWidgetState();
}

class _WebUpdateProfileWidgetState extends State<WebUpdateProfileWidget> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController> (
        builder: (profileController) {
          // bool isLoggedIn = AuthHelper.isLoggedIn();
          if(profileController.userInfoModel != null && _phoneController.text.isEmpty) {
            _firstNameController.text = profileController.userInfoModel!.fName ?? '';
            _lastNameController.text = profileController.userInfoModel!.lName ?? '';
            _phoneController.text = profileController.userInfoModel!.phone ?? '';
            _emailController.text = profileController.userInfoModel!.email ?? '';
          }

          return SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children : [
              SizedBox(
                height: 243,
                child: Stack(
                  children: [
                    Container(
                      height: 162,
                      width: Dimensions.webMaxWidth,
                      color: Theme.of(context).primaryColor.withOpacity(0.10),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                              child: Text('edit_profile'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)))),
                    ),

                    Positioned(
                        top: 96,
                        left: (Dimensions.webMaxWidth/2) - 60,
                        child: ImagePickerWidget(
                          image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${profileController.userInfoModel!.image}',
                          onTap: () => profileController.pickImage(), rawFile: profileController.rawFile,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),


              Row(
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'first_name'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        CustomTextField(
                          hintText: ' ',
                          controller: _firstNameController,
                          focusNode: _firstNameFocus,
                          nextFocus: _lastNameFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      'last_name'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    CustomTextField(
                      hintText: ' ',
                      controller: _lastNameController,
                      focusNode: _lastNameFocus,
                      nextFocus: _emailFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                    ),
                  ],
                )),
                ],
              ),

              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                'email'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              CustomTextField(
                hintText: 'email'.tr,
                controller: _emailController,
                focusNode: _emailFocus,
                inputAction: TextInputAction.done,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Text(
                  'phone'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text('(${'non_changeable'.tr})', style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error,
                )),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              CustomTextField(
                hintText: 'phone'.tr,
                controller: _phoneController,
                focusNode: _phoneFocus,
                inputType: TextInputType.phone,
                isEnabled: false,
              ),
              const SizedBox(height : Dimensions.paddingSizeDefault),

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
                      _firstNameController.text = '';
                      _lastNameController.text =  '';
                      _phoneController.text = '';
                      _emailController.text = '';
                      profileController.initData(isUpdate: true);
                    },
                    buttonText: 'reset'.tr,
                    isBold: false,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),

                const SizedBox( width: Dimensions.paddingSizeLarge),
                SizedBox(width: 165, child: UpdateProfileButton(isLoading: profileController.isLoading, onPressed: () => _updateProfile(profileController))),
              ])
            ]
          ));
        }
    );
  }

  void _updateProfile(ProfileController profileController) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    if (profileController.userInfoModel!.fName == firstName &&
        profileController.userInfoModel!.lName == lastName && profileController.userInfoModel!.phone == phoneNumber &&
        profileController.userInfoModel!.email == _emailController.text && profileController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      UserInfoModel updatedUser = UserInfoModel(fName: firstName, lName: lastName, email: email, phone: phoneNumber);
      ResponseModel responseModel = await profileController.updateUserInfo(updatedUser, Get.find<AuthController>().getUserToken());
      if(responseModel.isSuccess) {
        showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      }else {
        showCustomSnackBar(responseModel.message);
      }
    }
  }
}


class UpdateProfileButton extends StatelessWidget {
  final bool isLoading;
  final Function onPressed;
  const UpdateProfileButton({super.key, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return !isLoading ? CustomButton(
      radius: Dimensions.radiusSmall,
      onPressed: onPressed,
      buttonText: 'update_profile'.tr,
      isBold: false,
      fontSize: Dimensions.fontSizeSmall,
    ) : const Center(child: CircularProgressIndicator());
  }
}