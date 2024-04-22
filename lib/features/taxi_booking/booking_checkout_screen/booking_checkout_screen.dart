import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/booking_checkout_controller.dart';
import 'package:sixam_mart/features/profile/domain/models/user_information_body.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/payment_complete_dialog.dart';
import 'package:sixam_mart/features/taxi_booking/booking_checkout_screen/widgets/booking_checkout_stepper.dart';
import 'widgets/booking_complete_info.dart';
import 'widgets/booking_details_info.dart';
import 'widgets/select_payment_method.dart';

class BookingCheckoutScreen extends StatefulWidget {
  final Vehicles vehicle;
  final UserInformationBody filterBody;
  const BookingCheckoutScreen({super.key, required this.vehicle, required this.filterBody});

  @override
  State<BookingCheckoutScreen> createState() => _BookingCheckoutScreenState();
}

class _BookingCheckoutScreenState extends State<BookingCheckoutScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<BookingCheckoutController>().updateState(PageState.orderDetails, shouldUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'checkout'.tr),
      body: Column(
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          ///payment status section

          GetBuilder<BookingCheckoutController>(
              builder: (bookingCheckoutController){
                return BookingCheckoutStepper(pageState: bookingCheckoutController.currentPage.name);
              }
          ),


          GetBuilder<BookingCheckoutController>(
              builder: (bookingCheckoutController){
                if(Get.find<BookingCheckoutController>().currentPage.name == 'orderDetails') {
                  return Expanded(child: BookingDetailsInfo(vehicle: widget.vehicle, filterBody: widget.filterBody));
                }
                if(Get.find<BookingCheckoutController>().currentPage.name == 'payment' ) {
                  return const SelectPaymentMethod();
                }
                return Expanded(child: BookingCompleteInfo(vehicle: widget.vehicle, filterBody: widget.filterBody));
              }
          )
        ],

      ),
      bottomSheet: GetBuilder<BookingCheckoutController>(
        builder: (bookingCheckoutController){

          double subTotalPrice = widget.filterBody.distance! * (widget.filterBody.fareCategory == 'hourly' ? widget.vehicle.insidePerHourCharge! : widget.vehicle.insidePerKmCharge!);
          double vatTax = widget.vehicle.provider!.tax!.toDouble();
          double serviceFee = widget.vehicle.provider!.comission!.toDouble();

          double totalPrice = (subTotalPrice - bookingCheckoutController.couponDiscount!) + vatTax + serviceFee;
          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: kElevationToShadow[4],
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(bookingCheckoutController.currentPage.name == 'orderDetails')
                    SizedBox(width: context.width / 2,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'total'.tr,
                          style: robotoRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.4),
                          ),),
                        Text(
                          PriceConverter.convertPrice(totalPrice), style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: !bookingCheckoutController.isLoading ? CustomButton(
                      width: bookingCheckoutController.currentPage.name == 'orderDetails' ? 140 : Get.width,
                      fontSize: Dimensions.fontSizeDefault,
                      onPressed: () {
                        if(bookingCheckoutController.currentPage.name == 'payment'){

                          bookingCheckoutController.placeTrip(filterBody: widget.filterBody, vehicle: widget.vehicle).then((success) {
                            if(success){
                              Get.dialog(PaymentCompleteDialog(
                                icon: Images.completeChecked, title: 'booking_payment_is_done_successfully'.tr,
                                description: 'to_know_others_information'.tr,
                                shortDescription: 'please_call_or_chat_with_car_provider'.tr,
                                onYesPressed: () {
                                  Get.back();
                                  bookingCheckoutController.updateState(PageState.complete,shouldUpdate: true);
                                },
                              ));
                            }
                          });

                        }else if(bookingCheckoutController.currentPage.name == 'complete'){
                          Get.toNamed(RouteHelper.getOrderStatusScreen());
                        }
                        else{
                          bookingCheckoutController.updateState(PageState.payment, shouldUpdate: true);
                        }
                      },
                      buttonText: bookingCheckoutController.currentPage.name == 'complete' ? 'check_order_status'.tr
                          : bookingCheckoutController.currentPage.name == 'payment' ? 'confirm'.tr : 'rent_this_car'.tr,
                    ) : const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
