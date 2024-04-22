import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class AddAddressWidget extends StatelessWidget {
  const AddAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Align(
            alignment: Alignment.centerLeft,
            child: Text('add_address'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200]!, blurRadius: 5, spreadRadius: 1)]
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: InkWell(
            onTap: (){
              Get.toNamed(RouteHelper.getAddAddressRoute(false, true, 0));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    height: 33,
                    width: 32,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                        color: Theme.of(context).primaryColor.withOpacity(0.1), shape: BoxShape.rectangle),
                    child: Icon(Icons.add,color: Theme.of(context).primaryColor,),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('add_address'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),),
                      Text('type_or_select_from_map'.tr,style: robotoRegular.copyWith(fontSize: 10),),
                    ],
                  ),
                ],),
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                  child: Image.asset(Images.riderAddAddress,height: 95,width: 70,),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    );
  }
}
