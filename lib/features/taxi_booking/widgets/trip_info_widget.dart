import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/features/profile/domain/models/user_information_body.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/dotted_line.dart';
import 'package:sixam_mart/features/taxi_booking/widgets/see_details_widget.dart';
class TripInfoWidget extends StatelessWidget {
  final UserInformationBody filterBody;
  const TripInfoWidget({super.key, required this.filterBody});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('trip_info'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      ///pick up and destination address
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                height: 15,
                                width: 15,
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
                          Icon(Icons.location_on_outlined,color: Theme.of(context).primaryColor,),
                        ],
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${filterBody.from!.address}",
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.7)
                              ),),
                            const SizedBox(height: 18),
                            Text("${filterBody.to!.address}",
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (con) => const SeeDetailsWidget(),
                    );
                  },
                  child: Text(
                    'see_details'.tr,
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
