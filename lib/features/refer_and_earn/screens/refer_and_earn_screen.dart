import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sixam_mart/features/refer_and_earn/widgets/bottom_sheet_view_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/not_logged_in_screen.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall(){
    if(AuthHelper.isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return Scaffold(
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      appBar: CustomAppBar(title: 'refer_and_earn'.tr),
      body: ExpandableBottomSheet(
        background: isLoggedIn ? SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
          child: Column(
            children: [
              WebScreenTitleWidget(title: 'refer_and_earn'.tr ),
              FooterView(
                child: Center(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: GetBuilder<ProfileController>(builder: (profileController) {
                      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Image.asset(
                          Images.referImage, width: 500,
                          height: ResponsiveHelper.isDesktop(context) ? 250 : 150, fit: BoxFit.contain,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        ResponsiveHelper.isDesktop(context) ? const SizedBox() : Text('earn_money_on_every_referral'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                        ResponsiveHelper.isDesktop(context) ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        ResponsiveHelper.isDesktop(context) ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            '${'one_referral'.tr}= ', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),
                          Text(
                            PriceConverter.convertPrice(Get.find<SplashController>().configModel != null
                                ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0),
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault), textDirection: TextDirection.ltr,
                          ),
                        ]),
                        ResponsiveHelper.isDesktop(context) ? const SizedBox() : const SizedBox(height: 40),

                        Text('invite_friends_and_business'.tr , style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge), textAlign: TextAlign.center),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        ResponsiveHelper.isDesktop(context) ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            '${'one_referral'.tr}= ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                          Text(
                            PriceConverter.convertPrice(Get.find<SplashController>().configModel != null
                                ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0),
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                          ),
                        ]) : const SizedBox(),
                        ResponsiveHelper.isDesktop(context) ?  const SizedBox(height: 40) : const SizedBox(),

                        ResponsiveHelper.isDesktop(context) ? const SizedBox() : Text('copy_your_code_share_it_with_your_friends'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                        ResponsiveHelper.isDesktop(context) ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        ResponsiveHelper.isDesktop(context) ? Align(
                          alignment: Alignment.topLeft,
                          child: Text('your_personal_code'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                        ) : const SizedBox(),
                        ResponsiveHelper.isDesktop(context) ? const SizedBox() : Text('your_personal_code'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        DottedBorder(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 1,
                          strokeCap: StrokeCap.butt,
                          dashPattern: const [8, 5],
                          padding: const EdgeInsets.all(0),
                          borderType: BorderType.RRect,
                          radius: Radius.circular( ResponsiveHelper.isDesktop(context) ? Dimensions.radiusDefault : 50),
                          child: SizedBox(
                            height: 50,
                            child: (profileController.userInfoModel != null) ? Row(children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
                                  child: Text(
                                    profileController.userInfoModel != null ? profileController.userInfoModel!.refCode ?? '' : '',
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(profileController.userInfoModel!.refCode!.isNotEmpty){
                                    Clipboard.setData(ClipboardData(text: '${profileController.userInfoModel != null ? profileController.userInfoModel!.refCode : ''}'));
                                    showCustomSnackBar('referral_code_copied'.tr, isError: false);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular( ResponsiveHelper.isDesktop(context) ? Dimensions.radiusDefault : 50)),
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                                  margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  child: Text('copy'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeDefault)),
                                ),
                              ),
                            ]) : const CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Wrap(children: [

                          InkWell(
                            onTap: () => Share.share('${'this_is_my_refer_code'.tr}: ${profileController.userInfoModel!.refCode}'),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor,
                                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), blurRadius: 5)],
                              ),
                              padding: const EdgeInsets.all(7),
                              child: const Icon(Icons.share),
                            ),
                          )
                        ]),

                        ResponsiveHelper.isDesktop(context) ? const Padding(
                          padding: EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                          child: BottomSheetViewWidget(),
                        ) : const SizedBox(),

                      ]);
                    }
                    ),
                  ),
                ),
              ),
            ],
          ),
        ) : NotLoggedInScreen(callBack: (value){
          _initCall();
          setState(() {});
        }),

        persistentContentHeight: ResponsiveHelper.isDesktop(context) ? 0 : 60,
        expandableContent: ResponsiveHelper.isDesktop(context) || !isLoggedIn ? const SizedBox() : const BottomSheetViewWidget(),

      ),
    );
  }
}
