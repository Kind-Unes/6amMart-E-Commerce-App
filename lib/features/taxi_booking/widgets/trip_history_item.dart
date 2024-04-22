import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/models/trip_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/dotted_line.dart';

class TripHistoryItem extends StatelessWidget {
  final Data trip;
  const TripHistoryItem({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : null,
      margin: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall) : null,
      decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
      ) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

          Container(
            height: 70, width: 70, alignment: Alignment.center,
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              border: Border.all(color: Theme.of(context).primaryColor)
            ) ,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: const CustomImage(
                height: 70, width: 70,
                image: ''),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('${ 'order_id'.tr}:', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text('#${trip.id}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                height: 13,
                                width: 13,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                                ),
                              ),
                              Container(
                                height: 4,
                                width: 4,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                              ),
                            ],
                          ),
                          DottedLine(
                            lineLength: 12,
                            direction: Axis.vertical,
                            dashLength: 3,
                            dashGapLength: 1  ,
                            dashColor: Theme.of(context).primaryColor,
                          ),
                          Icon(Icons.location_on_outlined,
                            size: 18,
                            color: Theme.of(context).primaryColor,),
                        ],
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(trip.deliveryAddress?? '', style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.7)),
                          ),
                          const SizedBox(height: 12),
                          Text("Dhanmondi 32",style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.7)
                          ),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

            ]),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(PriceConverter.convertPrice(trip.trip!.estimatedFare), style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color,
            )),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(trip.trip!.tripStatus!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),
          ]),

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('view_details'.tr,style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                decoration: TextDecoration.underline,
              color: Theme.of(context).primaryColor,

            ),),
            
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(minimumSize: const Size(1, 28), shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall), side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                  )),
                  onPressed: () {

                  },
                  child: Text('give_review'.tr, style: robotoRegular.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                  )),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall,),
                CustomButton(
                    width: 90,
                    height: 30,
                    fontSize: Dimensions.fontSizeDefault,
                    onPressed: (){

                    },
                    buttonText: 'book_again'.tr),
              ],
            )
          ],
        ),
          const SizedBox(height: Dimensions.paddingSizeDefault,),
          Divider(
            height: 1,
            color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.4)),
          const SizedBox(height: Dimensions.paddingSizeDefault,),
        ],
      ),
    );
  }
}
