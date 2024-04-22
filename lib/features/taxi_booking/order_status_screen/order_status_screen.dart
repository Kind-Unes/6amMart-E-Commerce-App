import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/cancellation_dialog.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/ripple_button.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/dotted_line.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/pick_and_destination_address_info.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'order'.tr,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            children: [
              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
              InkWell(
                  onTap: (){
                    Get.toNamed(RouteHelper.getTripHistoryScreen());
                  },
                  child: Image.asset(Images.bookingCompleteCar,width: 109,height: 83,)),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              SizedBox(
                width: Get.width * .6,
                child: RichText(text: TextSpan(
                    children: [
                      TextSpan(
                          text: ' ${'10 - 5 '}',
                          style: robotoMedium.copyWith(
                              fontSize:Dimensions.paddingSizeDefault,
                              color: Theme.of(context).primaryColor)),
                      TextSpan(
                          text: 'min_left_to_reach'.tr,
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5))
                      ),]),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: Theme.of(context).primaryColor.withOpacity(.1),
                    ),
                    child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: Dimensions.paddingSizeSmall),
                      child: Text(
                        'track_on_map'.tr,
                        style: robotoRegular.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.fontSizeSmall),),
                  ),),
                  Positioned.fill(child: RippleButton(onTap: () {
                    Get.toNamed(RouteHelper.getSelectRideMapLocationRoute('willArrived', null, null));
                  }, radius: Dimensions.radiusDefault))
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
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
                        child: Image.asset(
                          Images.demoCar,
                          width: 120,
                          fit: BoxFit.fitHeight,
                          height: 120,),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Range Rover-2020',style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                          Row(
                            children: [
                              Image.asset(Images.demoBrandCar),
                              Text("ABC rent a car",style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),)
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'car_number'.tr,
                                style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),),
                              Text('B 45 55 23',style:  robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                          Text(
                            'contact_with_provider'.tr,
                            style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, ),),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Image.asset(Images.riderCallIcon,scale: 2.2,),
                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                  Text(
                                    'call_now'.tr,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeSmall,
                                      decoration: TextDecoration.underline,
                                  ),)
                                ],
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall,),
                              Row(
                                children: [
                                  Image.asset(Images.riderChatIcon,scale: 2.2,),
                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                  Text(
                                    'chat_now'.tr,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeSmall,
                                      decoration: TextDecoration.underline,
                                  ),)
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tuesday, 16 Auust 2022, 10.45 am',style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                          Image.asset(
                            Images.edit,
                            width: 16,
                            height: 16,),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      SizedBox(
                        height: 90,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 33,
                                  width: 33,
                                  alignment: Alignment.center,
                                  decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.08)),
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        height: 18,
                                        width: 18,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                        ),
                                      ),
                                      Container(
                                        height: 4,
                                        width: 4,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(20))),
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
                                  height: 33,
                                  width: 33, alignment: Alignment.center,
                                  decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.08)),
                                  child: Icon(Icons.location_on_sharp,color: Theme.of(context).primaryColor,),
                                ),
                              ],
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault,),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: RideAddressInfo(
                                    title: "Mirpur DOHS",
                                    subTitle: 'Road 9/a,house-666,Dhaka',
                                    isInsideCity:true,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: RideAddressInfo(
                                    title: "Mirpur DOHS",
                                    subTitle: 'Road 9/a,house-666,Dhaka',
                                    isInsideCity:true,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      Row(
                        children: [
                          Container(
                            height: 33,
                            width: 33, alignment: Alignment.center,
                            decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.08)),
                            child: Image.asset(Images.hourCost,width: 20,height: 20,),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('rent_type'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,),),
                              Text('hourly'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      Row(
                        children: [
                          Container(
                            height: 33,
                            width: 33, alignment: Alignment.center,
                            decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.08)),
                            child: Image.asset(Images.rideReturn,width: 20,height: 20,),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('return'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,),),
                              Text('N/A'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
              Stack(
                children: [
                  Container(
                    width: 175,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      color: Theme.of(context).colorScheme.error.withOpacity(.5),
                    ),
                    child: Center(child: Text('cancel_booking'.tr,style: robotoRegular.copyWith(color: Theme.of(context).cardColor),)),
                  ),
                  Positioned.fill(child: RippleButton(onTap: () {
                    Get.dialog(CancellationDialog(
                      icon: Images.cancellationIcon,
                      title: 'do_you_want_to_cancel_this_booking'.tr,
                      onYesPressed: (){
                      },
                      onNoPressed: (){
                        Get.back();
                      },
                    ));
                  }))
                ],
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
