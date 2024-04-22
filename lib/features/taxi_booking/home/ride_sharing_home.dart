import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/rider_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/taxi_booking/home/widgets/rider_app_bar.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/features/taxi_booking/home/widgets/taxi_banner_view.dart';
import 'widgets/add_address_widget.dart';
import 'widgets/top_rated_cars_widget.dart';
import 'widgets/use_coupon_section.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = AuthHelper.isLoggedIn();
    if (_isLoggedIn) {
      Get.find<AddressController>().getAddressList();
    }
    Get.find<RiderController>().getTopRatedVehiclesList(1);
    Get.find<BannerController>().getTaxiBannerList(false);
    if (_isLoggedIn && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RiderAppBar(),
      body: GetBuilder<AddressController>(builder: (locationController) {
        return Stack(clipBehavior: Clip.none, children: [
          RefreshIndicator(
            onRefresh: () async {
              await Get.find<BannerController>().getTaxiBannerList(false);
              await Get.find<RiderController>()
                  .getTopRatedVehiclesList(1, isUpdate: true);
            },
            child: SingleChildScrollView(
              padding: ResponsiveHelper.isDesktop(context)
                  ? null
                  : const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: FooterView(
                  child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TaxiBannerView(),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Container(
                              height: 50,
                              width: Dimensions.webMaxWidth,
                              color: Theme.of(context).colorScheme.background,
                              child: InkWell(
                                onTap: () => Get.toNamed(
                                    RouteHelper.getSelectRideMapLocationRoute(
                                        "initial", null, null)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.5)),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                  child: Row(children: [
                                    Image.asset(
                                      Images.riderSearch,
                                      scale: 3,
                                    ),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Expanded(
                                        child: Text(
                                      'where_to_go'.tr,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    )),
                                  ]),
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeDefault),
                            _isLoggedIn &&
                                    locationController.addressList!.isEmpty
                                ? const AddAddressWidget()
                                : const SizedBox(),
                            _isLoggedIn
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        Text('saved_address'.tr,
                                            style: robotoMedium.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeDefault)),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),

                                        locationController.addressList !=
                                                    null &&
                                                locationController
                                                    .addressList!.isNotEmpty
                                            ? GridView.builder(
                                                controller: ScrollController(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? 3
                                                          : ResponsiveHelper
                                                                  .isTab(
                                                                      context)
                                                              ? 2
                                                              : 1,
                                                  childAspectRatio:
                                                      ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? (1 / 0.25)
                                                          : (1 / 0.205),
                                                  crossAxisSpacing: Dimensions
                                                      .paddingSizeSmall,
                                                  mainAxisSpacing: Dimensions
                                                      .paddingSizeSmall,
                                                ),
                                                itemCount: locationController
                                                            .addressList!
                                                            .length >
                                                        3
                                                    ? 3
                                                    : locationController
                                                        .addressList!.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Get.toNamed(RouteHelper
                                                          .getSelectRideMapLocationRoute(
                                                              "initial",
                                                              locationController
                                                                      .addressList![
                                                                  index],
                                                              null));
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .all(Dimensions
                                                              .paddingSizeSmall),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusSmall),
                                                      ),
                                                      child: Row(children: [
                                                        Container(
                                                          height: 33,
                                                          width: 32,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                  .all(
                                                                  Radius.circular(
                                                                      Dimensions
                                                                          .radiusSmall)),
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              shape: BoxShape
                                                                  .rectangle),
                                                          child: Image.asset(
                                                            locationController
                                                                        .addressList![
                                                                            index]
                                                                        .addressType ==
                                                                    'others'
                                                                ? Images
                                                                    .addressJourney
                                                                : locationController
                                                                            .addressList![
                                                                                index]
                                                                            .addressType ==
                                                                        'home'
                                                                    ? Images
                                                                        .addressHome
                                                                    : Images
                                                                        .addressOffice,
                                                            height: 13,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeSmall),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                              Text(
                                                                  locationController
                                                                      .addressList![
                                                                          index]
                                                                      .addressType!,
                                                                  style:
                                                                      robotoMedium),
                                                              const SizedBox(
                                                                  height: Dimensions
                                                                      .paddingSizeExtraSmall),
                                                              Text(
                                                                locationController
                                                                    .addressList![
                                                                        index]
                                                                    .address!,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: robotoRegular.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .color!
                                                                        .withOpacity(
                                                                            .5),
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall),
                                                              ),
                                                            ])),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeSmall),
                                                        Icon(
                                                          Icons.arrow_forward,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                    ),
                                                  );
                                                },
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('trip_history'.tr,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault)),
                                            InkWell(
                                              onTap: () {},
                                              child: Text('view_all'.tr,
                                                  style: robotoBold.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),

                                        ///Trip history..
                                        GridView.builder(
                                          controller: ScrollController(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                ResponsiveHelper.isDesktop(
                                                        context)
                                                    ? 3
                                                    : ResponsiveHelper.isTab(
                                                            context)
                                                        ? 2
                                                        : 1,
                                            childAspectRatio:
                                                ResponsiveHelper.isDesktop(
                                                        context)
                                                    ? (1 / 0.25)
                                                    : (1 / 0.205),
                                            crossAxisSpacing:
                                                Dimensions.paddingSizeSmall,
                                            mainAxisSpacing:
                                                Dimensions.paddingSizeSmall,
                                          ),
                                          itemCount: 3,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeSmall),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusSmall),
                                                ),
                                                child: Row(children: [
                                                  Container(
                                                    height: 55,
                                                    width: 55,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    Dimensions
                                                                        .radiusSmall)),
                                                        color: Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.1),
                                                        shape:
                                                            BoxShape.rectangle),
                                                    child: const CustomImage(
                                                      image: '',
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeSmall),
                                                  Expanded(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                        Text(
                                                            'Dhanmondi to Mirpur DOHS ',
                                                            style:
                                                                robotoMedium),
                                                        const SizedBox(
                                                            height: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        Text(
                                                          '\$144',
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: robotoRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color!
                                                                  .withOpacity(
                                                                      .5),
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                        ),
                                                      ])),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeSmall),
                                                  Text(
                                                    '16th \n August',
                                                    style: robotoRegular,
                                                  ),
                                                ]),
                                              ),
                                            );
                                          },
                                        ),
                                      ])
                                : const SizedBox(),
                            const TopRatedCars(),
                            const SizedBox(
                                height: Dimensions.paddingSizeDefault),
                            const UseCouponSection(),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                          ]))),
            ),
          ),
          ResponsiveHelper.isDesktop(context)
              ? const Positioned(top: 150, right: 0, child: SizedBox())
              : const SizedBox(),
        ]);
      }),
    );
  }
}

class ParcelShimmer extends StatelessWidget {
  final bool isEnabled;
  const ParcelShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context)
            ? 3
            : ResponsiveHelper.isTab(context)
                ? 2
                : 1,
        childAspectRatio:
            (1 / (ResponsiveHelper.isMobile(context) ? 0.20 : 0.20)),
        crossAxisSpacing: Dimensions.paddingSizeSmall,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
      ),
      itemCount: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: isEnabled,
            child: Row(children: [
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                    color: Colors.grey[300], shape: BoxShape.circle),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(height: 15, width: 200, color: Colors.grey[300]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Container(height: 15, width: 100, color: Colors.grey[300]),
                  ])),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              const Icon(Icons.keyboard_arrow_right),
            ]),
          ),
        );
      },
    );
  }
}
