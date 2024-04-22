import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/common/models/config_model.dart';
import 'package:sixam_mart/features/location/domain/models/prediction_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/location/widgets/web_landing_page_shimmer_widget.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_loader.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';
import 'package:sixam_mart/features/location/widgets/landing_card_widget.dart';
import 'package:sixam_mart/features/location/widgets/registration_card_widget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart' as intl;

class WebLandingPage extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String? route;
  const WebLandingPage({super.key, required this.fromSignUp, required this.fromHome, required this.route});

  @override
  State<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends State<WebLandingPage> {
  final TextEditingController _controller = TextEditingController();
  final PageController _pageController = PageController();
  AddressModel? _address;
  final ConfigModel? _config = Get.find<SplashController>().configModel;
  Timer? _timer;
  bool? _isRtl;

  @override
  void initState() {
    super.initState();

    if(Get.find<SplashController>().moduleList == null) {
      if (kDebugMode) {
        print('-------call from web landing page------------');
      }
      Get.find<SplashController>().getModules(headers: {'Content-Type': 'application/json; charset=UTF-8'});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isRtl = intl.Bidi.isRtlLanguage(Get.locale!.languageCode);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: FooterView(child: SizedBox(width: Dimensions.webMaxWidth, child: GetBuilder<SplashController>(
        builder: (splashController) {
          return splashController.landingModel == null ? const WebLandingPageShimmerWidget() : Column(children: [

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).primaryColor.withOpacity(0.05),
              ),
              child: Row(children: [
                const SizedBox(width: 40),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text(splashController.landingModel?.fixedHeaderTitle ?? '', style: robotoBold.copyWith(fontSize: 35)),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text(
                    splashController.landingModel?.fixedHeaderSubTitle ?? '',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                  ),
                ])),
                Expanded(child: ClipPath(clipper: CustomPath(isRtl: _isRtl), child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    right: _isRtl! ? const Radius.circular(0) : const Radius.circular(Dimensions.radiusDefault),
                    left: _isRtl! ? const Radius.circular(Dimensions.radiusDefault) : const Radius.circular(0),
                  ),
                  child: CustomImage(
                    image: '${splashController.landingModel?.baseUrls?.fixedHeaderImage ?? ''}/${splashController.landingModel != null
                        ? splashController.landingModel!.fixedHeaderImage : ''}',
                    height: 270, fit: BoxFit.cover,
                  ),
                ))),
              ]),
            ),
            const SizedBox(height: 20),

            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Opacity(opacity: 0.05, child: Image.asset(Images.landingBg, height: 130, width: context.width, fit: BoxFit.fill)),
              ),
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                child: Row(children: [
                  Expanded(flex: 3, child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      Image.asset(Images.landingChooseLocation, height: 70, width: 70),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Text(
                          splashController.landingModel?.fixedLocationTitle ?? '', textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                      ),
                    ]),
                  )),
                  Expanded(flex: 7, child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Row(children: [
                      Expanded(child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _controller,
                          textInputAction: TextInputAction.search,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            hintText: 'search_location'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 1),
                            ),
                            hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
                            ),
                            filled: true, fillColor: Theme.of(context).cardColor,
                            suffixIcon: IconButton(
                              onPressed: () async {
                                Get.dialog(const CustomLoader(), barrierDismissible: false);
                                _address = await Get.find<LocationController>().getCurrentLocation(true);
                                _controller.text = _address!.address ?? '';
                                Get.back();
                              },
                              icon: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                            ),
                          ),
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return await Get.find<LocationController>().searchLocation(context, pattern);
                        },
                        itemBuilder: (context, PredictionModel suggestion) {
                          return Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: Row(children: [
                              const Icon(Icons.location_on),
                              Expanded(child: Text(
                                suggestion.description ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                                ),
                              )),
                            ]),
                          );
                        },
                        onSuggestionSelected: (PredictionModel suggestion) async {
                          _controller.text = suggestion.description ?? '';
                          _address = await Get.find<LocationController>().setLocation(suggestion.placeId, suggestion.description, null);
                        },
                      )),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      CustomButton(
                        width: 150, height: 60, fontSize: Dimensions.fontSizeDefault,
                        buttonText: 'set_location'.tr,
                        onPressed: () async {
                          if(_address != null && _controller.text.trim().isNotEmpty) {
                            Get.dialog(const CustomLoader(), barrierDismissible: false);
                            ZoneResponseModel response = await Get.find<LocationController>().getZone(
                              _address!.latitude, _address!.longitude, false,
                            );
                            if(response.isSuccess) {
                              if(!AuthHelper.isGuestLoggedIn() && !AuthHelper.isLoggedIn()) {
                                Get.find<AuthController>().guestLogin().then((response) {
                                  if(response.isSuccess) {
                                    Get.find<ProfileController>().setForceFullyUserEmpty();
                                    Get.find<LocationController>().saveAddressAndNavigate(
                                      _address, widget.fromSignUp, widget.route, widget.route != null, ResponsiveHelper.isDesktop(Get.context),
                                    );
                                  }
                                });
                              } else {
                                Get.find<LocationController>().saveAddressAndNavigate(
                                  _address, widget.fromSignUp, widget.route, widget.route != null, ResponsiveHelper.isDesktop(Get.context),
                                );
                              }
                            }else {
                              Get.back();
                              showCustomSnackBar('service_not_available_in_current_location'.tr);
                            }
                          }else {
                            showCustomSnackBar('pick_an_address'.tr);
                          }
                        },
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      CustomButton(
                        width: 160, height: 60, fontSize: Dimensions.fontSizeDefault,
                        buttonText: 'pick_from_map'.tr,
                        onPressed: () {
                          if(ResponsiveHelper.isDesktop(Get.context)) {

                            showGeneralDialog(context: context, pageBuilder: (_,__,___) {
                              return SizedBox(
                                height: 300, width: 300,
                                child: PickMapScreen(
                                  fromSignUp: widget.fromSignUp, canRoute: widget.route != null, fromAddAddress: false, route: widget.route
                                    ?? (widget.fromSignUp ? RouteHelper.signUp : RouteHelper.accessLocation), fromLandingPage: true,
                                ),
                              );
                            });
                          }else {
                            Get.toNamed(RouteHelper.getPickMapRoute(
                              widget.route ?? (widget.fromSignUp ? RouteHelper.signUp : RouteHelper.accessLocation), widget.route != null,
                            ));
                          }
                        }
                        // onPressed: (){
                        //   Get.dialog(const PickMapScreen(fromSignUp: false, canRoute: false, fromAddAddress: false, route: null ));
                        // }
                      ),
                    ]),
                  )),
                ]),
              ),
            ]),
            const SizedBox(height: 40),

            Text(
              splashController.landingModel?.fixedModuleTitle ?? '',
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
            ),
            Text(
              splashController.landingModel?.fixedModuleSubTitle ?? '',
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
            ),
            const SizedBox(height: 40),

            GetBuilder<SplashController>(builder: (splashController) {
              if(splashController.moduleList != null && _timer == null) {
                _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
                  int index = splashController.moduleIndex >= splashController.moduleList!.length-1 ? 0 : splashController.moduleIndex+1;
                  splashController.setModuleIndex(index);
                  _pageController.animateToPage(index, duration: const Duration(seconds: 2), curve: Curves.easeInOut);
                });
              }
              return splashController.moduleList != null ? SizedBox(height: 450, child: Stack(children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: splashController.moduleList!.length,
                  onPageChanged: (int index) => splashController.setModuleIndex(index >= splashController.moduleList!.length ? 0 : index),
                  itemBuilder: (context, index) {
                    index = splashController.moduleIndex >= splashController.moduleList!.length ? 0 : splashController.moduleIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      child: Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const SizedBox(height: 80),
                          Text(
                            splashController.moduleList![index].moduleName ?? '',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Expanded(child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            child: Html(
                              data: splashController.moduleList![index].description ?? '', shrinkWrap: true,
                              onLinkTap: (url, context, attributes, element) {
                                if(url!.startsWith('www.')) {
                                  url = 'https://$url';
                                }
                                if (kDebugMode) {
                                  print('Redirect to url: $url');
                                }
                                html.window.open(url, "_blank");
                              },
                            ),
                          )),
                        ])),
                        CustomImage(
                          image: '${_config!.baseUrls!.moduleImageUrl}/${splashController.moduleList![index].thumbnail}',
                          height: 450, width: 450,
                        ),
                      ]),
                    );
                  },
                ),
                Positioned(top: 0, left: 0, child: SizedBox(height: 75, child: Container(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: splashController.moduleList!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              splashController.setModuleIndex(index);
                              _pageController.animateToPage(index, duration: const Duration(seconds: 2), curve: Curves.easeInOut);
                            },
                            child: CustomImage(
                              image: '${_config!.baseUrls!.moduleImageUrl}/${splashController.moduleList![index].icon}',
                              height: 45, width: 45,
                            ),
                          ),
                          SizedBox(width: 45, child: Divider(
                            color: splashController.moduleIndex == index ? Theme.of(context).primaryColor : Colors.transparent,
                            thickness: 2,
                          )),
                        ]),
                      );
                    },
                  ),
                ))),
              ])) : const SizedBox();
            }),
            const SizedBox(height: 40),

            Row(children: _generateChooseUsList(splashController)),
            SizedBox(height: AppConstants.whyChooseUsList.isNotEmpty ? 40 : 0),

            RegistrationCardWidget(isStore: true, splashController: splashController),
            SizedBox(height: splashController.landingModel != null && (splashController.landingModel!.downloadUserAppLinks!.playstoreUrlStatus == '1' || splashController.landingModel!.downloadUserAppLinks!.appleStoreUrlStatus == '1')
                ? 40 : 0),

            splashController.landingModel != null && (splashController.landingModel!.downloadUserAppLinks!.playstoreUrlStatus == '1' || splashController.landingModel!.downloadUserAppLinks!.appleStoreUrlStatus == '1')
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              CustomImage(
                image: '${splashController.landingModel!.baseUrls!.downloadUserAppImage!}/${splashController.landingModel!.downloadUserAppImage}',
                width: 500,
              ),
              Column(children: [
                Text(
                  splashController.landingModel!.downloadUserAppTitle ?? '', textAlign: TextAlign.center,
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  splashController.landingModel!.downloadUserAppSubTitle ?? '', textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  splashController.landingModel != null && splashController.landingModel!.downloadUserAppLinks!.playstoreUrlStatus == '1' ? InkWell(
                    onTap: () async {
                      String url = splashController.landingModel?.downloadUserAppLinks?.playstoreUrl ?? '';
                      if(await canLaunchUrlString(url)){
                        launchUrlString(url);
                      }
                    },
                    child: Image.asset(Images.landingGooglePlay, height: 45),
                  ) : const SizedBox(),
                  SizedBox(width: splashController.landingModel != null && (splashController.landingModel!.downloadUserAppLinks!.playstoreUrlStatus == '1' && splashController.landingModel!.downloadUserAppLinks!.appleStoreUrlStatus == '1')
                      ? Dimensions.paddingSizeLarge : 0),

                  splashController.landingModel != null && splashController.landingModel!.downloadUserAppLinks!.appleStoreUrlStatus == '1' ? InkWell(
                    onTap: () async {
                      String url = splashController.landingModel!.downloadUserAppLinks!.appleStoreUrl ?? '';
                      if(await canLaunchUrlString(url)){
                        launchUrlString(url);
                      }
                    },
                    child: Image.asset(Images.landingAppStore, height: 45),
                  ) : const SizedBox(),
                ]),
              ]),
            ]) : const SizedBox(),
            const SizedBox(height: 40),

            RegistrationCardWidget(isStore: false, splashController: splashController),
            const SizedBox(height: 40),

          ]);
        }
      ))),
    );
  }

  List<Widget> _generateChooseUsList(SplashController splashController) {
    List<Widget> chooseUsList = [];
    for(int index=0; index < (splashController.landingModel != null && splashController.landingModel!.specialCriterias!.length > 4 ? 4 : splashController.landingModel!.specialCriterias!.length); index++) {
      chooseUsList.add(Expanded(child: Row(children: [
        Expanded(child: LandingCardWidget(icon: '${splashController.landingModel!.baseUrls!.specialCriteriaImage}/${splashController.landingModel!.specialCriterias![index].image}',
            title: splashController.landingModel!.specialCriterias![index].title ?? '',
        )),
        SizedBox(width: index != splashController.landingModel!.specialCriterias!.length-1 ? 30 : 0),
      ])));
    }
    return chooseUsList;
  }

}

class CustomPath extends CustomClipper<Path> {
  final bool? isRtl;
  CustomPath({required this.isRtl});

  @override
  Path getClip(Size size) {
    final path = Path();
    if(isRtl!) {
      path..moveTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width*0.7, 0)
        ..lineTo(0, 0)
        ..close();
    }else {
      path..moveTo(0, size.height)
        ..lineTo(size.width*0.3, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
