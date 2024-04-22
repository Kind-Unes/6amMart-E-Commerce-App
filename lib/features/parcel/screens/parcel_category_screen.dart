import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
 import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/features/home/widgets/bad_weather_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/parcel_app_bar_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/deliver_item_card_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/get_service_video_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/sevice_info_list_widget.dart';

class ParcelCategoryScreen extends StatefulWidget {
  const ParcelCategoryScreen({super.key});

  @override
  State<ParcelCategoryScreen> createState() => _ParcelCategoryScreenState();
}

class _ParcelCategoryScreenState extends State<ParcelCategoryScreen> {

  @override
  void initState() {
    super.initState();
    if(AuthHelper.isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
    Get.find<BannerController>().getParcelOtherBannerList(true);
    Get.find<ParcelController>().getWhyChooseDetails();
    Get.find<ParcelController>().getVideoContentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? null : const ParcelAppBarWidget(),
      body: GetBuilder<ParcelController>(builder: (parcelController) {
        return GetBuilder<BannerController>(builder: (bannerController) {

          bool showVideoAndServices = parcelController.videoContentDetails != null && (parcelController.videoContentDetails!.bannerVideo != null || parcelController.videoContentDetails!.bannerImage != null);
          return Stack(clipBehavior: Clip.none, children: [

            RefreshIndicator(
              onRefresh: () async {
                await Get.find<ParcelController>().getParcelCategoryList();
                await Get.find<BannerController>().getParcelOtherBannerList(true);
                await Get.find<ParcelController>().getWhyChooseDetails();
                await Get.find<ParcelController>().getVideoContentDetails();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
                child: FooterView(child: SizedBox(width: Dimensions.webMaxWidth,
                    child: Column(crossAxisAlignment: ResponsiveHelper.isDesktop(context) ? CrossAxisAlignment.center : CrossAxisAlignment.start, children: [

                      bannerController.parcelOtherBannerModel != null ? bannerController.parcelOtherBannerModel!.banners!.isNotEmpty ? CarouselSlider.builder(
                        itemCount: bannerController.parcelOtherBannerModel!.banners!.length,
                        options: CarouselOptions(
                          autoPlay: true,
                          height: ResponsiveHelper.isDesktop(context) ? 395 : 150,
                          enlargeCenterPage: true,
                          disableCenter: true,
                          viewportFraction: 1,
                          autoPlayInterval: const Duration(seconds: 5),
                          onPageChanged: (index, reason) {
                            bannerController.setCurrentIndex(index, false);
                          },
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImage(
                              image: '${bannerController.parcelOtherBannerModel!.promotionalBannerUrl}''/${bannerController.parcelOtherBannerModel!.banners![index].image}',
                            ),
                          );
                        },
                      ) : const SizedBox() : Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: ResponsiveHelper.isDesktop(context) ? 395 : 150,
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeLarge),
                      const BadWeatherWidget(inParcel: true),

                      Text('bringing_happiness_from_door_to_door'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text('ready_to_send_something_special'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      parcelController.parcelCategoryList != null ? parcelController.parcelCategoryList!.isNotEmpty ? GridView.builder(
                        controller: ScrollController(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : 2,
                          crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
                          mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
                          mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 95 : 80,
                        ),
                        itemCount: parcelController.parcelCategoryList!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return CustomInkWell(
                            onTap: () {
                              Get.toNamed(RouteHelper.getParcelLocationRoute(parcelController.parcelCategoryList![index]));
                            },
                            radius: Dimensions.radiusDefault,
                            child: DeliverItemCardWidget(
                              isDeliverItem: true,
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.parcelCategoryImageUrl}'
                                  '/${parcelController.parcelCategoryList![index].image}',
                              itemName: parcelController.parcelCategoryList![index].name!,
                              description: parcelController.parcelCategoryList![index].description!,
                            ),
                          );
                        },
                      ) : Center(child: Text('no_parcel_category_found'.tr)) : ParcelShimmer(isEnabled: parcelController.parcelCategoryList == null, isDeliveryItem: true),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      parcelController.whyChooseDetails != null ? Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.02),
                        child: GridView.builder(
                          controller: ScrollController(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                            crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
                            mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
                            mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 95 : 80,
                          ),
                          itemCount: parcelController.whyChooseDetails!.banners!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return DeliverItemCardWidget(
                              image: '${parcelController.whyChooseDetails!.whyChooseUrl}''/${parcelController.whyChooseDetails!.banners![index].image}',
                              itemName: parcelController.whyChooseDetails!.banners![index].title!,
                              description: parcelController.whyChooseDetails!.banners![index].shortDescription!,
                            );
                          },
                        ),
                      ) : ParcelShimmer(isEnabled: parcelController.parcelCategoryList == null, isDeliveryItem: false),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('easiest_way_to_get_services'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      parcelController.videoContentDetails != null ? ResponsiveHelper.isDesktop(context) ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

                        showVideoAndServices ? Expanded(
                          child: parcelController.videoContentDetails!.bannerType == 'image' ? ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImage(image: '${parcelController.videoContentDetails!.promotionalBannerUrl}/${parcelController.videoContentDetails!.bannerImage}'),
                          )
                              : parcelController.videoContentDetails!.bannerType == 'video' ? GetServiceVideoWidget(youtubeVideoUrl: parcelController.videoContentDetails!.bannerVideo ?? '', fileVideoUrl: '',)
                              : GetServiceVideoWidget(youtubeVideoUrl: '', fileVideoUrl: '${parcelController.videoContentDetails!.bannerVideoContentUrl!}/${parcelController.videoContentDetails!.bannerVideoContent}'),
                        ) : const SizedBox(),
                        const SizedBox(width: 125),

                        Expanded(
                          child: ServiceInfoListWidget(
                            parcelController: parcelController,
                          ),
                        ),
                      ]) : Column(children: [

                        parcelController.videoContentDetails!.bannerType == 'image' ? ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: CustomImage(image: '${parcelController.videoContentDetails!.promotionalBannerUrl}/${parcelController.videoContentDetails!.bannerImage}'),
                        ) : parcelController.videoContentDetails!.bannerType == 'video' ? GetServiceVideoWidget(youtubeVideoUrl: parcelController.videoContentDetails!.bannerVideo ?? '', fileVideoUrl: '',)
                            : GetServiceVideoWidget(youtubeVideoUrl: '', fileVideoUrl: '${parcelController.videoContentDetails!.bannerVideoContentUrl!}/${parcelController.videoContentDetails!.bannerVideoContent}'),
                        
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        ServiceInfoListWidget(parcelController: parcelController),
                      ]) : const VideoContentDetailsShimmer(),

                      SizedBox(height: ResponsiveHelper.isDesktop(context) ? 0 : 100),
                    ]))),
                  ),
            ),

            ResponsiveHelper.isDesktop(context) ? const Positioned(right: 0, top: 0, bottom: 0, child: Center(child: SizedBox())) : const SizedBox(),

          ]);
        });
      }),
    );
  }
}


class ParcelShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isDeliveryItem;
  const ParcelShimmer({super.key, required this.isEnabled, required this.isDeliveryItem});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: isDeliveryItem ? SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : 2,
        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
        mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 100 : 75,
      ) : SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
        mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 100 : 80,
      ),
      itemCount: 7,
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
                height: 50, width: 50, alignment: Alignment.center,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(height: 15, width: 200, color: Colors.grey[300]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Container(height: 15, width: 100, color: Colors.grey[300]),
              ])),
              const SizedBox(width: Dimensions.paddingSizeSmall),
            ]),
          ),
        );
      },
    );
  }
}

class VideoContentDetailsShimmer extends StatelessWidget {
  const VideoContentDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

      Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 350,
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
        ),
      ),
      const SizedBox(width: 125),

      Expanded(
        child: ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                Container(
                  height: 14, width: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(height: 15, width: 200, color: Colors.grey[300]),
              ]),

              Container(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 22.5),
                margin: const EdgeInsets.only(left: 7),
                decoration: BoxDecoration(
                    border: index == 6 - 1 ? null : Border(left: BorderSide(width: 1, color: Theme.of(context).disabledColor))),
                child: Container(height: 15, width: 100, color: Colors.grey[300]),
              ),
            ]);
          },
        ),
      ),
    ]) : Column(children: [

      Container(
        width: MediaQuery.of(context).size.width,
        height: 185,
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeLarge),

      ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [
              Container(
                height: 14, width: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Container(height: 15, width: 200, color: Colors.grey[300]),
            ]),

            Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 22.5),
              margin: const EdgeInsets.only(left: 7),
              decoration: BoxDecoration(
                  border: index == 6 - 1 ? null : Border(left: BorderSide(width: 1, color: Theme.of(context).disabledColor))),
              child: Container(height: 15, width: 100, color: Colors.grey[300]),
            ),
          ]);
        },
      ),
    ]);
  }
}

