import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sixam_mart/common/widgets/address_widget.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_loader.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';
import 'package:sixam_mart/features/location/screens/web_landing_page.dart';

class AccessLocationScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String? route;
  const AccessLocationScreen(
      {super.key,
      required this.fromSignUp,
      required this.fromHome,
      required this.route});

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();
    if (AuthHelper.isLoggedIn()) {
      Get.find<AddressController>().getAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (_canExit) {
          if (GetPlatform.isAndroid) {
            SystemNavigator.pop();
          } else if (GetPlatform.isIOS) {
            exit(0);
          } else {
            Navigator.pushNamed(context, RouteHelper.getInitialRoute());
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr,
                style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ));
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        appBar:
            CustomAppBar(title: 'set_location'.tr, backButton: widget.fromHome),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
            child: Padding(
          padding: ResponsiveHelper.isDesktop(context)
              ? EdgeInsets.zero
              : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: GetBuilder<AddressController>(builder: (locationController) {
            bool isLoggedIn = AuthHelper.isLoggedIn();
            return (ResponsiveHelper.isDesktop(context) &&
                    AddressHelper.getUserAddressFromSharedPref() == null)
                ? WebLandingPage(
                    fromSignUp: widget.fromSignUp,
                    fromHome: widget.fromHome,
                    route: widget.route,
                  )
                : isLoggedIn
                    ? Column(children: [
                        Expanded(
                            child: SingleChildScrollView(
                          child: FooterView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                locationController.addressList != null
                                    ? locationController.addressList!.isNotEmpty
                                        ? ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: locationController
                                                .addressList!.length,
                                            itemBuilder: (context, index) {
                                              return Center(
                                                  child: SizedBox(
                                                      width: 700,
                                                      child: AddressWidget(
                                                        address:
                                                            locationController
                                                                    .addressList![
                                                                index],
                                                        fromAddress: false,
                                                        onTap: () {
                                                          Get.dialog(
                                                              const CustomLoader(),
                                                              barrierDismissible:
                                                                  false);
                                                          AddressModel address =
                                                              locationController
                                                                      .addressList![
                                                                  index];
                                                          Get.find<
                                                                  LocationController>()
                                                              .saveAddressAndNavigate(
                                                            address,
                                                            widget.fromSignUp,
                                                            widget.route,
                                                            widget.route !=
                                                                null,
                                                            ResponsiveHelper
                                                                .isDesktop(
                                                                    context),
                                                          );
                                                        },
                                                      )));
                                            },
                                          )
                                        : NoDataScreen(
                                            text: 'no_saved_address_found'.tr)
                                    : const Center(
                                        child: CircularProgressIndicator()),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                                ResponsiveHelper.isDesktop(context)
                                    ? BottomButton(
                                        fromSignUp: widget.fromSignUp,
                                        route: widget.route)
                                    : const SizedBox(),
                              ])),
                        )),
                        ResponsiveHelper.isDesktop(context)
                            ? const SizedBox()
                            : BottomButton(
                                fromSignUp: widget.fromSignUp,
                                route: widget.route),
                      ])
                    : Center(
                        child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: FooterView(
                            child: SizedBox(
                                width: 700,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(Images.deliveryLocation,
                                          height: 220),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeLarge),
                                      Text(
                                          'find_stores_and_items'
                                              .tr
                                              .toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: robotoMedium.copyWith(
                                              fontSize: Dimensions
                                                  .fontSizeExtraLarge)),
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeLarge),
                                        child: Text(
                                          'by_allowing_location_access'.tr,
                                          textAlign: TextAlign.center,
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeLarge),
                                      Padding(
                                        padding: ResponsiveHelper.isWeb()
                                            ? EdgeInsets.zero
                                            : const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeLarge),
                                        child: BottomButton(
                                            fromSignUp: widget.fromSignUp,
                                            route: widget.route),
                                      ),
                                    ]))),
                      ));
          }),
        )),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final bool fromSignUp;
  final String? route;
  const BottomButton(
      {super.key, required this.fromSignUp, required this.route});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 700,
            child: Column(children: [
              CustomButton(
                buttonText: 'user_current_location'.tr,
                onPressed: () async {
                  Get.find<LocationController>().checkPermission(() async {
                    Get.dialog(const CustomLoader(), barrierDismissible: false);
                    AddressModel address = await Get.find<LocationController>()
                        .getCurrentLocation(true);
                    ZoneResponseModel response =
                        await Get.find<LocationController>().getZone(
                            address.latitude, address.longitude, false);

                    if (response.isSuccess) {


                      
                      Get.find<LocationController>().saveAddressAndNavigate(
                        address,
                        fromSignUp,
                        route,
                        route != null,
                        ResponsiveHelper.isDesktop(Get.context),
                      );
                    } else {
                      Get.back();
                      if (ResponsiveHelper.isDesktop(Get.context)) {
                        showGeneralDialog(
                            context: Get.context!,
                            pageBuilder: (_, __, ___) {
                              return SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: PickMapScreen(
                                      fromSignUp: fromSignUp,
                                      canRoute: route != null,
                                      fromAddAddress: false,
                                      route:
                                          route ?? RouteHelper.accessLocation));
                            });
                      } else {
                        Get.toNamed(RouteHelper.getPickMapRoute(
                            route ?? RouteHelper.accessLocation,
                            route != null));
                        showCustomSnackBar(
                            'service_not_available_in_current_location'.tr);
                      }
                    }
                  });
                },
                icon: Icons.my_location,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  minimumSize: const Size(Dimensions.webMaxWidth, 50),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  if (ResponsiveHelper.isDesktop(Get.context)) {
                    showGeneralDialog(
                        context: Get.context!,
                        pageBuilder: (_, __, ___) {
                          return SizedBox(
                              height: 300,
                              width: 300,
                              child: PickMapScreen(
                                  fromSignUp: fromSignUp,
                                  canRoute: route != null,
                                  fromAddAddress: false,
                                  route: route ?? RouteHelper.accessLocation));
                        });
                  } else {
                    Get.toNamed(RouteHelper.getPickMapRoute(
                      route ??
                          (fromSignUp
                              ? RouteHelper.signUp
                              : RouteHelper.accessLocation),
                      route != null,
                    ));
                  }
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: Dimensions.paddingSizeExtraSmall),
                    child:
                        Icon(Icons.map, color: Theme.of(context).primaryColor),
                  ),
                  Text('set_from_map'.tr,
                      textAlign: TextAlign.center,
                      style: robotoBold.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeLarge,
                      )),
                ]),
              ),
            ])));
  }
}
