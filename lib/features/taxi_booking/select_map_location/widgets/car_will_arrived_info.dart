import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/rider_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class CarWillArrivedInfo extends StatelessWidget {
  const CarWillArrivedInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderController>(
      builder: (riderController){
        return InkWell(
          onTap: (){
            Get.toNamed(RouteHelper.getTripCompletedConfirmationScreen());
          },
          child: Container(
            height: 310,
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      Center(
                        child: Container(
                          height: 5, width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).highlightColor,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Text('the_car_will_arrived_within'.tr,style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
                      ),),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),

                      Text("15 - 20 mins",style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),),
                      const SizedBox(height: Dimensions.paddingSizeSmall,),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Images.pickAndDestination,scale: 2.5,),
                          const SizedBox(width: Dimensions.paddingSizeSmall,),
                          Text("2.2 km away",style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),)
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      Divider(color: Theme.of(context).textTheme.bodyLarge!.color,),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('car_driver'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.paddingSizeSmall),)),
                      const SizedBox(height: Dimensions.paddingSizeSmall,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //driver section
                          Row(
                            children: [
                              Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 5))],
                                      borderRadius: const BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Image.asset(Images.driverIcon,scale: 2,)),
                              const SizedBox(width: Dimensions.paddingSizeSmall,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Alex Maxwell",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                  Row(
                                    children: [
                                      Icon(Icons.star,size: 18.0,color: Theme.of(context).primaryColor,),
                                      const Text("4.5"),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Image.asset(Images.riderChatIcon,scale: 2.2,),
                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                  Text('chat'.tr,style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeSmall,
                                    decoration: TextDecoration.underline,
                                  ),)
                                ],
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall,),
                              Row(
                                children: [
                                  Image.asset(Images.riderCallIcon,scale: 2.2,),
                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                  Text('call'.tr,style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeSmall,
                                    decoration: TextDecoration.underline,
                                  ),)
                                ],
                              ),


                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //driver section
                          Row(
                            children: [
                              Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 5))],

                                      borderRadius: const BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Image.asset(Images.trackingCarIcon,scale: 2,)),
                              const SizedBox(width: Dimensions.paddingSizeSmall,),
                              Text("RAnge Rover-2020",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                            ],
                          ),
                          Row(
                            children: [
                              Text('car_no'.tr,style: robotoRegular.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeSmall
                              ),),
                              const SizedBox(width: Dimensions.paddingSizeSmall,),

                              Text('B 45 55 23'.tr,style: robotoMedium.copyWith(
                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                  fontSize: Dimensions.fontSizeSmall
                              ),),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                    ],
                  ),
                ),

                const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
              ],
            ),

          ),
        );
      },
    );
  }
}
