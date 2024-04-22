import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/booking_checkout_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/profile/domain/models/user_information_body.dart';
import 'package:sixam_mart/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/dotted_line.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/pick_and_destination_address_info.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookingCompleteInfo extends StatelessWidget {
  final Vehicles vehicle;
  final UserInformationBody filterBody;
  const BookingCompleteInfo({super.key, required this.vehicle, required this.filterBody});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Column(
        children: [
          const SizedBox(height: Dimensions.paddingSizeLarge,),
          InkWell(
              onTap: (){
                Get.toNamed(RouteHelper.getTripHistoryScreen());
              },
              child: Image.asset(Images.bookingCompleteCar, width: 109, height: 83),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          SizedBox(
            width: Get.width * .6,
            child: RichText(text: TextSpan(children: [
              TextSpan(
                  text: 'the_driver_will_arrive_at_pick_location_within'.tr,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.paddingSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)
                  )),
              TextSpan(text: ' ${'30'}', style: robotoMedium.copyWith(
                  fontSize:Dimensions.paddingSizeDefault,
                  color: Theme.of(context).primaryColor)),
              TextSpan(text: 'minutes'.tr, style: robotoMedium.copyWith(
                  fontSize:Dimensions.paddingSizeDefault,
                  color: Theme.of(context).primaryColor)),
              TextSpan(text: 'max'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
            ]), textAlign: TextAlign.center),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius:const BorderRadius.all(Radius.circular(8)),
                    child: CustomImage(
                      width: 120, height: 120,
                      image: '${Get.find<SplashController>().configModel!.baseUrls!.vehicleImageUrl}/${vehicle.carImages!.isNotEmpty ? vehicle.carImages![0] : ''}',
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${vehicle.name}',style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Row(
                        children: [
                          CustomImage(
                            width: 20, height: 20,
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.vehicleBrandImageUrl}/${''}',
                          ),
                          Text(vehicle.brandName!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),)
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Row(
                        children: [
                          Text(
                            'car_number'.tr,
                            style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),),
                          Text(' ${vehicle.modelName}',style:  robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              if(await canLaunchUrlString('tel:${vehicle.provider!.phone}')) {
                                launchUrlString('tel:${vehicle.provider!.phone}', mode: LaunchMode.externalApplication);
                              }else {
                                showCustomSnackBar('${'can_not_launch'.tr} ${vehicle.provider!.phone}');
                              }
                            },
                            icon: Icon(Icons.call, color: Theme.of(context).primaryColor, size: 20),
                            label: Text(
                              'call_now'.tr,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          TextButton.icon(
                            onPressed: () async {
                              await Get.toNamed(RouteHelper.getChatRoute(
                                notificationBody: NotificationBodyModel(orderId: Get.find<BookingCheckoutController>().tripId, restaurantId: vehicle.provider!.vendorId),
                                user: User(id: vehicle.provider!.vendorId, fName: vehicle.provider!.name, lName: '', image: vehicle.provider!.logo),
                              ));
                            },
                            icon: Icon(Icons.chat, color: Theme.of(context).primaryColor, size: 20),
                            label: Text(
                              'chat_now'.tr,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),

                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    DateConverter.isoStringToReadableString(filterBody.rentTime!),
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  SizedBox(
                    height: 90,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 33, width: 33,
                              alignment: Alignment.center,
                              decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.08)),
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Container(
                                    height: 18, width: 18,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                                    ),
                                  ),
                                  Container(
                                    height: 4, width: 4,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DottedLine(
                              lineLength: 20,
                              direction: Axis.vertical,
                              dashLength: 3,
                              dashGapLength: 1  ,
                              dashColor: Theme.of(context).primaryColor,
                            ),
                            Container(
                              height: 33, width: 33, alignment: Alignment.center,
                              decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.08)),
                              child: Icon(Icons.location_on_sharp, color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: RideAddressInfo(
                                  title: filterBody.from!.address,
                                  subTitle: 'Road 9/a,house-666,Dhaka',
                                  isInsideCity: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: RideAddressInfo(
                                  title: filterBody.to!.address,
                                  subTitle: 'Road 9/a,house-666,Dhaka',
                                  isInsideCity: true,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Row(
                    children: [
                      Container(
                        height: 33,
                        width: 33, alignment: Alignment.center,
                        decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.08)),
                        child: Image.asset(Images.hourCost,width: 20,height: 20,),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('rent_type'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          Text(filterBody.filterType == 'hourly' ? 'hourly'.tr : 'per_km'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Row(
                    children: [
                      Container(
                        height: 33, width: 33, alignment: Alignment.center,
                        decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.08)),
                        child: Image.asset(Images.rideReturn,width: 20,height: 20,),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('return'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          Text('N/A'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                        ],
                      )
                    ],
                  ),

                ],
              ),
            ),

          ),

          const SizedBox(height: 100),

        ],
      ),
    );
  }
}
