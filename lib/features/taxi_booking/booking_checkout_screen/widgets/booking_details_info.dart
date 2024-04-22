import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/booking_checkout_controller.dart';
import 'package:sixam_mart/features/coupon/controllers/coupon_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/features/profile/domain/models/user_information_body.dart';
import 'package:sixam_mart/features/taxi_booking/models/vehicle_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/dotted_line.dart';
import 'package:sixam_mart/features/taxi_booking/select_map_location/widgets/pick_and_destination_address_info.dart';

class BookingDetailsInfo extends StatefulWidget {
  final Vehicles vehicle;
  final UserInformationBody filterBody;
  const BookingDetailsInfo({super.key, required this.vehicle, required this.filterBody});

  @override
  State<BookingDetailsInfo> createState() => _BookingDetailsInfoState();
}

class _BookingDetailsInfoState extends State<BookingDetailsInfo> {
  final TextEditingController _couponTextController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: GetBuilder<BookingCheckoutController>(
        builder: (bookingCheckoutController) {

          double subTotalPrice = widget.filterBody.distance! * (widget.filterBody.fareCategory == 'hourly' ? widget.vehicle.insidePerHourCharge! : widget.vehicle.insidePerKmCharge!);
          double vatTax = widget.vehicle.provider!.tax!.toDouble();
          double serviceFee = widget.vehicle.provider!.comission!.toDouble();

          // double _totalPrice = (_subTotalPrice - bookingCheckoutController.couponDiscount) + _vatTax + _serviceFee;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],),
                child: Row(
                  children: [
                    CustomImage(
                      width: 48, height: 46,
                      image: '${Get.find<SplashController>().configModel!.baseUrls!.vehicleImageUrl}/${widget.vehicle.carImages!.isNotEmpty ? widget.vehicle.carImages![0] : ''}',
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.vehicle.name!, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                        Row(
                          children: [
                            CustomImage(
                              width: 20, height: 20,
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.vehicleBrandImageUrl}/${''}',
                            ),
                            Text(widget.vehicle.categoryName!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall))
                          ],
                        )
                      ],
                    )
                  ],
                ),

              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1)]),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateConverter.isoStringToReadableString(widget.filterBody.rentTime!), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

                          Image.asset(Images.edit, width: 16, height: 16),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

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
                            const SizedBox(width: Dimensions.paddingSizeDefault),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: RideAddressInfo(
                                      title: widget.filterBody.from!.address,
                                      subTitle: 'Road 9/a,house-666,Dhaka',
                                      isInsideCity:true,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: RideAddressInfo(
                                      title: widget.filterBody.to!.address,
                                      subTitle: 'Road 9/a,house-666,Dhaka',
                                      isInsideCity:true,
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
                          const SizedBox(width: Dimensions.paddingSizeDefault,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('rent_type'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,),),
                              Text( widget.filterBody.filterType == 'hourly' ? 'hourly'.tr : 'per_km'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
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
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: GetBuilder<CouponController>(
                    builder: (couponController) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('have_any_promo_code'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                              InkWell(
                                onTap: (){
                                  if(!bookingCheckoutController.showCouponSection) {
                                    bookingCheckoutController.showHideCoupon();
                                  }
                                },
                                child: Text(
                                  'add_promo_code'.tr,
                                  style: robotoBold.copyWith(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline,
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          bookingCheckoutController.showCouponSection ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              border: Border.all(color: Theme.of(context).primaryColor),
                            ),
                            child: Row(children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: TextField(
                                    controller: _couponTextController,
                                    style: robotoRegular.copyWith(height: ResponsiveHelper.isMobile(context) ? null : 2),
                                    decoration: InputDecoration(
                                      hintText: 'enter_promo_code'.tr,
                                      hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                      isDense: true,
                                      filled: true,
                                      enabled: couponController.discount == 0,
                                      fillColor: Theme.of(context).cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(Get.find<LocalizationController>().isLtr ? 10 : 0),
                                          right: Radius.circular(Get.find<LocalizationController>().isLtr ? 0 : 10),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  String couponCode = _couponTextController.text.trim();
                                  if(couponController.discount! < 1) {
                                    if(couponCode.isNotEmpty && !couponController.isLoading) {
                                      couponController.applyTaxiCoupon(couponCode, widget.filterBody.distance! * (widget.filterBody.fareCategory == 'hourly'
                                          ? widget.vehicle.insidePerHourCharge! : widget.vehicle.insidePerKmCharge!), widget.vehicle.providerId).then((discount) {
                                        if (discount! > 0) {
                                          bookingCheckoutController.setCouponDiscount(discount);
                                          showCustomSnackBar('${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}', isError: false,);
                                        }
                                      });
                                    } else if(couponCode.isEmpty) {
                                      showCustomSnackBar('enter_a_coupon_code'.tr);
                                    }
                                  } else {
                                    couponController.removeCouponData(true);
                                  }
                                },
                                child: Container(
                                  height: 50, width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(Get.find<LocalizationController>().isLtr ? 0 : 10),
                                      right: Radius.circular(Get.find<LocalizationController>().isLtr ? 10 : 0),
                                    ),
                                  ),
                                  child: (couponController.discount! <= 0) ? !couponController.isLoading ? Text(
                                    'apply'.tr,
                                    style: robotoMedium.copyWith(color: Theme.of(context).cardColor),
                                  ) : const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                      : const Icon(Icons.clear, color: Colors.white),
                                ),
                              ),
                            ]),
                          ) : const SizedBox(),
                        ],
                      );
                    }
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('add_special_note'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.09))
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          child: CustomTextField(
                            controller: _noteTextController,
                            titleText: 'type_here'.tr,
                            inputType: TextInputType.emailAddress,
                          ),
                        ),
                      ),

                    ],
                  ),

                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('bill_details'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            billDetailsItem('subtotal'.tr, PriceConverter.convertPrice(subTotalPrice)),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            billDetailsItem('vat'.tr, '(+) ${PriceConverter.convertPrice(vatTax)}'),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            billDetailsItem('service_fee'.tr, '(+) ${PriceConverter.convertPrice(serviceFee)}'),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            billDetailsItem('coupon_discount'.tr, '(-) ${PriceConverter.convertPrice(bookingCheckoutController.couponDiscount)}'),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            billDetailsItem('advance_booking_fee'.tr, '(+) ${PriceConverter.convertPrice(30)}', isPrimary: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star,color: Theme.of(context).primaryColor,size: 8,),
                          const SizedBox(width: Dimensions.paddingSizeDefault,),
                          Expanded(child: Text('advanced_booking_free_should_be_pay'.tr,style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)
                          ),))
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall,),
                      Row(
                        children: [
                          Icon(Icons.star,color: Theme.of(context).primaryColor,size: 8,),
                          const SizedBox(width: Dimensions.paddingSizeDefault,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('by_placing_the_order_you'.tr,style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)
                              ),),
                              Row(
                                children: [
                                  Text('terms_and_conditions'.tr,style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).primaryColor),),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          );
        }
      ),
    );
  }

  Widget billDetailsItem(String billName, String price, {bool isPrimary = false}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          billName,
          style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color:isPrimary ? Theme.of(Get.context!).primaryColor : Theme.of(Get.context!).textTheme.bodyLarge!.color),
        ),
        Text(
          price,
          style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color:isPrimary ? Theme.of(Get.context!).primaryColor : Theme.of(Get.context!).textTheme.bodyLarge!.color),
        ),
      ],
    );
  }
}
