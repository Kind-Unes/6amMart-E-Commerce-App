import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/confirmation_dialog.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/profile/widgets/profile_button_widget.dart';
import 'package:sixam_mart/features/profile/widgets/profile_card_widget.dart';

class WebProfileWidget extends StatelessWidget {
  const WebProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController> (
      builder: (profileController) {
        bool isLoggedIn = AuthHelper.isLoggedIn();
        return SizedBox(
          width: Dimensions.webMaxWidth,
          child: Column(children : [
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
                          child: Text('profile'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)))),
                    ),

                    Positioned(
                      top: 96,
                      left: (Dimensions.webMaxWidth/2) - 60,
                      child: ClipOval(child: CustomImage(
                        placeholder: Images.guestIcon,
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                            '/${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.image : ''}',
                        height: 120, width: 120, fit: BoxFit.cover,
                    ))),

                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          isLoggedIn ? '${profileController.userInfoModel!.fName} ${profileController.userInfoModel!.lName}' : 'guest_user'.tr,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                    ))),

                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: (){
                            Get.dialog(ConfirmationDialog(icon: Images.support,
                              title: 'are_you_sure_to_delete_account'.tr,
                              description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
                              onYesPressed: () => profileController.deleteUser(),
                            ), useSafeArea: false);
                          },
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Image.asset(Images.profileDelete, height: 20, width: 20),
                              const SizedBox(width: Dimensions.paddingSizeSmall),
                              Text('delete_account'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ],
                          ))),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                const SizedBox( width: Dimensions.paddingSizeLarge),
                Expanded(
                  child: Container(
                    height: ResponsiveHelper.isDesktop(context) ? 130 :112,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).primaryColor, width: 0.1),
                      boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)],
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ClipOval(child: CustomImage(
                        placeholder: Images.guestIcon,
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                            '/${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.image : ''}',
                        height: 30, width: 30, fit: BoxFit.cover,
                      )),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(
                        DateConverter.containTAndZToUTCFormat(profileController.userInfoModel!.createdAt!), textDirection: TextDirection.ltr,
                        style: robotoMedium.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeDefault : Dimensions.fontSizeExtraLarge),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text('since_joining'.tr, style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                      )),
                    ]),
                  ),
                ),


                // Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Expanded(child: ProfileCard(
                //   image: Images.walletProfile,
                //   data: DateConverter.containTAndZToUTCFormat(profileController.userInfoModel!.createdAt!),
                //   title: 'since_joining'.tr,
                // )) : const SizedBox(),
                const SizedBox( width: Dimensions.paddingSizeExtremeLarge),
                //SizedBox(width: Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Dimensions.paddingSizeSmall : 0),

                Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Expanded(child: ProfileCardWidget(
                  image: Images.walletProfile,
                  data: PriceConverter.convertPrice(profileController.userInfoModel!.walletBalance),
                  title: 'wallet_balance'.tr,
                )) : const SizedBox(),
                SizedBox(width: Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Dimensions.paddingSizeExtremeLarge : 0),

                isLoggedIn ?  Expanded(child: ProfileCardWidget(
                    image: Images.shoppingBagIcon,
                    data: profileController.userInfoModel!.orderCount.toString(),
                    title: 'total_order'.tr,
                  )) : const SizedBox(),
                  SizedBox(width: Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Dimensions.paddingSizeExtremeLarge : 0),

                Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Expanded(child: ProfileCardWidget(
                  image: Images.loyaltyIcon,
                  data: profileController.userInfoModel!.loyaltyPoint != null ? profileController.userInfoModel!.loyaltyPoint.toString() : '0',
                  title: 'loyalty_points'.tr,
                )) : const SizedBox(),
                SizedBox(width: Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Dimensions.paddingSizeLarge : 0),
                ],
              ),
            const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 9,
              children: <Widget>[

                ProfileButtonWidget(icon: Icons.tonality_outlined, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                  Get.find<ThemeController>().toggleTheme();
                }),

                isLoggedIn ? GetBuilder<AuthController>(builder: (authController) {
                  return ProfileButtonWidget(
                    icon: Icons.notifications, title: 'notification'.tr,
                    isButtonActive: authController.notification, onTap: () {
                    authController.setNotificationActive(!authController.notification);
                  },
                  );
                }) : const SizedBox(),

                isLoggedIn ? profileController.userInfoModel!.socialId == null ? ProfileButtonWidget(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                  Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
                }) : const SizedBox() : const SizedBox(),

                isLoggedIn ? ProfileButtonWidget(icon: Icons.edit, title: 'edit_profile'.tr, onTap: () {
                  Get.toNamed(RouteHelper.getUpdateProfileRoute());
                }) : const SizedBox(),

              ],
            ),
            const SizedBox( height: 100)

            ]
          ),
        );
      }
    );
  }
}
