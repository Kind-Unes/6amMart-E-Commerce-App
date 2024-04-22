import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/booking_checkout_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/features/taxi_booking/booking_checkout_screen/widgets/custom_header_icon.dart';
import 'package:sixam_mart/features/taxi_booking/booking_checkout_screen/widgets/custom_header_line.dart';
import 'package:sixam_mart/features/taxi_booking/booking_checkout_screen/widgets/custom_text.dart';

class BookingCheckoutStepper extends StatelessWidget {
  final String pageState;
  const BookingCheckoutStepper({super.key,required this.pageState});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 426,
      child: GetBuilder<BookingCheckoutController>(
        builder: (controller){
          return Column(
            children: [
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
                child:  Stack(
                  children: [
                    SizedBox(
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              controller.updateState(PageState.payment,shouldUpdate: true);
                            },
                            child: const CustomHeaderIcon(
                              assetIconUnSelected: Images.bookingDetailsUnselected,
                            ),
                          ),
                          controller.currentPage == PageState.orderDetails ?
                           CustomHeaderLine(
                              color:Theme.of(context).primaryColor,
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2:Theme.of(context).disabledColor) :
                           CustomHeaderLine(
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2: Theme.of(context).primaryColor),

                          CustomHeaderIcon(
                            assetIconUnSelected:controller.currentPage == PageState.orderDetails ?  Images.paymentUnselectedGrey : Images.paymentUnselected,
                          ),
                          controller.cancelPayment ?
                          const CustomHeaderLine(
                              cancelOrder: true,
                              gradientColor1: Colors.grey,
                              gradientColor2: Colors.grey) :
                          controller.currentPage == PageState.payment || controller.currentPage == PageState.orderDetails ?
                           CustomHeaderLine(
                              color: Theme.of(context).disabledColor,
                              gradientColor1: Theme.of(context).disabledColor,
                              gradientColor2:Theme.of(context).disabledColor) :
                           CustomHeaderLine(
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2: Theme.of(context).primaryColor),
                          InkWell(
                              onTap: (){
                                controller.updateState(PageState.complete,shouldUpdate: true);
                              },
                              child: const CustomHeaderIcon(assetIconUnSelected: Images.completeUnselected,)),
                        ],),),

                    if(controller.currentPage == PageState.orderDetails  && PageState.orderDetails.name == pageState)
                      Positioned(
                        left: Get.find<LocalizationController>().isLtr ? 0: null,
                        right:Get.find<LocalizationController>().isLtr ? null: 0,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: (){
                            controller.updateState(PageState.payment,shouldUpdate: true);
                          },
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(50),
                                  image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage( Images.bookingDetailsSelected,))),
                            )),),
                    if(controller.currentPage == PageState.payment  || PageState.payment.name == pageState)
                      Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: (){
                              controller.updateState(PageState.orderDetails,shouldUpdate: true);
                            },
                              child: Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                                    image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage( Images.paymentSelected,))),
                              )),
                        ),
                      ), if(controller.currentPage == PageState.complete || pageState == 'complete')
                      Positioned(
                        right: Get.find<LocalizationController>().isLtr ? 0:null,
                        left: Get.find<LocalizationController>().isLtr ? null: 0,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: (){
                            controller.updateState(PageState.orderDetails,shouldUpdate: true);
                          },
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(50),
                                  image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage( Images.completeSelected,))),)),),],
                ),),
              Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault,left: 20.0,right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                    CustomText(
                        text: "booking_details".tr,isActive :controller.currentPage == PageState.orderDetails
                        && PageState.orderDetails.name == pageState),
                    Padding(
                      padding: EdgeInsets.only(
                        right:Get.find<LocalizationController>().isLtr ? 25:0,
                        left:Get.find<LocalizationController>().isLtr ? 0: 35.0,
                      ),
                      child: CustomText(
                          text: "payment".tr,
                          isActive : controller.currentPage == PageState.payment
                          || PageState.payment.name == pageState),
                    ),
                    CustomText(text: "complete".tr,isActive : controller.currentPage == PageState.complete  || pageState == 'complete'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
