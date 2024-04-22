import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/my_text_field.dart';

class TripCompletedConfirmationScreen extends StatelessWidget {
  const TripCompletedConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'trip_completed'.tr,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Text('trip_completed'.tr,style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge,
                color: Theme.of(context).primaryColor,
              ),),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Image.asset(Images.tripCompletedCar,scale: 3,),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
              Text('your_trip_has_been_complete'.tr,textAlign: TextAlign.center,style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
                  fontSize: Dimensions.fontSizeDefault,
              ),),

              const SizedBox(height: 40,),
              Text('how_was_your_service'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColor),),
              const SizedBox(height: 4),
              Text('give_us_your_valuable_review'.tr,style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
                  fontSize: Dimensions.fontSizeSmall),),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

              SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return InkWell(
                      child: Icon(
                        i != 0  ? Icons.star_border : Icons.star,
                        size: 30,
                        color:Theme.of(context).primaryColor,
                      ),
                      onTap: () {

                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.1)),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: MyTextField(
                  maxLines: 3,
                  capitalization: TextCapitalization.sentences,
                  isEnabled: true,
                  hintText: 'write_your_review_here'.tr,
                  fillColor: Theme.of(context).disabledColor.withOpacity(0.05),
                ),
              ),
              const SizedBox(height: 50),

              CustomButton(
                  onPressed: (){
                    Get.toNamed(RouteHelper.getTripHistoryScreen());
                  },
                  buttonText: 'submit'.tr),
              TextButton(
                  onPressed: (){},
                  child: Text('not_now'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),))

            ],
          ),
        ),
      ),
    );
  }
}
