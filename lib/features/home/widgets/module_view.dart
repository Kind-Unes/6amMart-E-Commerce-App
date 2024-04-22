import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/address_widget.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_loader.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/banner_view.dart';
import 'package:sixam_mart/features/home/widgets/popular_store_view.dart';

class ModuleView extends StatelessWidget {
  final SplashController splashController;
  const ModuleView({super.key, required this.splashController});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GetBuilder<BannerController>(builder: (bannerController) {
        return const BannerView(isFeatured: true);
      }),
      // splashController.moduleList != null
      //     ? splashController.moduleList!.isNotEmpty
      //         ? GridView.builder(
      //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 3,
      //               mainAxisSpacing: Dimensions.paddingSizeSmall,
      //               crossAxisSpacing: Dimensions.paddingSizeSmall,
      //               childAspectRatio: (1 / 1),
      //             ),
      //             padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      //             itemCount: splashController.moduleList!.length,
      //             shrinkWrap: true,
      //             physics: const NeverScrollableScrollPhysics(),
      //             itemBuilder: (context, index) {
      //               return Container(
      //                 decoration: BoxDecoration(
      //                   borderRadius:
      //                       BorderRadius.circular(Dimensions.radiusDefault),
      //                   color: Theme.of(context).cardColor,
      //                   border: Border.all(
      //                       color: Theme.of(context).primaryColor, width: 0.15),
      //                   boxShadow: [
      //                     BoxShadow(
      //                         color: Theme.of(context)
      //                             .primaryColor
      //                             .withOpacity(0.1),
      //                         spreadRadius: 1,
      //                         blurRadius: 3)
      //                   ],
      //                 ),
      //                 child: CustomInkWell(
      //                   onTap: () => splashController.switchModule(index, true),
      //                   radius: Dimensions.radiusDefault,
                        
      //               );
      //             },
      //           )
      //         : Center(
      //             child: Padding(
      //             padding:
      //                 const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      //             child: Text('no_module_found'.tr),
      //           ))
      //     : ModuleShimmer(isEnabled: splashController.moduleList == null),
      // GetBuilder<AddressController>(builder: (locationController) {
      //   List<AddressModel?> addressList = [];
      //   if (AuthHelper.isLoggedIn() && locationController.addressList != null) {
      //     addressList = [];
      //     bool contain = false;
      //     if (AddressHelper.getUserAddressFromSharedPref()!.id != null) {
      //       for (int index = 0;
      //           index < locationController.addressList!.length;
      //           index++) {
      //         if (locationController.addressList![index].id ==
      //             AddressHelper.getUserAddressFromSharedPref()!.id) {
      //           contain = true;
      //           break;
      //         }
      //       }
      //     }
      //     if (!contain) {
      //       addressList.add(AddressHelper.getUserAddressFromSharedPref());
      //     }
      //     addressList.addAll(locationController.addressList!);
      //   }
      //   return (!AuthHelper.isLoggedIn() ||
      //           locationController.addressList != null)
      //       ? addressList.isNotEmpty
      //           ? Column(
      //               children: [
      //                 const SizedBox(height: Dimensions.paddingSizeLarge),
      //                 Padding(
      //                   padding: const EdgeInsets.symmetric(
      //                       horizontal: Dimensions.paddingSizeSmall),
      //                   child: TitleWidget(title: 'deliver_to'.tr),
      //                 ),
      //                 const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      //                 SizedBox(
      //                   height: 80,
      //                   child: ListView.builder(
      //                     physics: const BouncingScrollPhysics(),
      //                     itemCount: addressList.length,
      //                     scrollDirection: Axis.horizontal,
      //                     padding: const EdgeInsets.only(
      //                         left: Dimensions.paddingSizeSmall,
      //                         right: Dimensions.paddingSizeSmall,
      //                         top: Dimensions.paddingSizeExtraSmall),
      //                     itemBuilder: (context, index) {
      //                       return Container(
      //                         width: 300,
      //                         padding: const EdgeInsets.only(
      //                             right: Dimensions.paddingSizeSmall),
      //                         child: AddressWidget(
      //                           address: addressList[index],
      //                           fromAddress: false,
      //                           onTap: () {
      //                             if (AddressHelper
      //                                         .getUserAddressFromSharedPref()!
      //                                     .id !=
      //                                 addressList[index]!.id) {
      //                               Get.dialog(const CustomLoader(),
      //                                   barrierDismissible: false);
      //                               Get.find<LocationController>()
      //                                   .saveAddressAndNavigate(
      //                                 addressList[index],
      //                                 false,
      //                                 null,
      //                                 false,
      //                                 ResponsiveHelper.isDesktop(context),
      //                               );
      //                             }
      //                           },
      //                         ),
      //                       );
      //                     },
      //                   ),
      //                 ),
      //               ],
      //             )
      //           : const SizedBox()
      //       : AddressShimmer(
      //           isEnabled: AuthHelper.isLoggedIn() &&
      //               locationController.addressList == null);
      // }),
      const PopularStoreView(isPopular: false, isFeatured: true),
      const SizedBox(height: 120),
    ]);
  }
}

class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;
  const ModuleShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        crossAxisSpacing: Dimensions.paddingSizeSmall,
        childAspectRatio: (1 / 1),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 700 : 200]!,
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: isEnabled,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[300]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Center(
                  child: Container(
                      height: 15, width: 50, color: Colors.grey[300])),
            ]),
          ),
        );
      },
    );
  }
}

class AddressShimmer extends StatelessWidget {
  final bool isEnabled;
  const AddressShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall),
          child: TitleWidget(title: 'deliver_to'.tr),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        SizedBox(
          height: 70,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                padding:
                    const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                          blurRadius: 5,
                          spreadRadius: 1)
                    ],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      Icons.location_on,
                      size: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: isEnabled,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 15,
                                  width: 100,
                                  color: Colors.grey[300]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                  height: 10,
                                  width: 150,
                                  color: Colors.grey[300]),
                            ]),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
