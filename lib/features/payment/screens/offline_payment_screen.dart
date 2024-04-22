import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/features/payment/controllers/payment_controller.dart';
import 'package:sixam_mart/features/payment/domain/models/offline_method_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';

class OfflinePaymentScreen extends StatefulWidget {
  final PlaceOrderBodyModel placeOrderBody;
  final int zoneId;
  final double total;
  final double? maxCodOrderAmount;
  final bool fromCart;
  final bool isCashOnDeliveryActive;
  final bool forParcel;

  const OfflinePaymentScreen({super.key, required this.placeOrderBody, required this.zoneId,
    required this.total, required this.maxCodOrderAmount, required this.fromCart, required this.isCashOnDeliveryActive, required this.forParcel});

  @override
  State<OfflinePaymentScreen> createState() => _OfflinePaymentScreenState();
}

class _OfflinePaymentScreenState extends State<OfflinePaymentScreen> {
  PageController pageController = PageController(viewportFraction: 0.85, initialPage: Get.find<PaymentController>().selectedOfflineBankIndex);
  final TextEditingController _customerNoteController = TextEditingController();
  final FocusNode _customerNoteNode = FocusNode();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  Future<void> initCall() async {
    if(widget.forParcel) {
      pageController = PageController(viewportFraction: 0.85, initialPage: Get.find<ParcelController>().selectedOfflineBankIndex);
      Get.find<PaymentController>().selectOfflineBank(Get.find<ParcelController>().selectedOfflineBankIndex, canUpdate: false);
      await Get.find<PaymentController>().getOfflineMethodList();
      Get.find<PaymentController>().changesMethod(canUpdate: false);
    }
    if(Get.find<PaymentController>().offlineMethodList == null){
      await Get.find<PaymentController>().getOfflineMethodList();
    }
    Get.find<PaymentController>().informationControllerList = [];
    Get.find<PaymentController>().informationFocusList = [];
    if(Get.find<PaymentController>().offlineMethodList != null && Get.find<PaymentController>().offlineMethodList!.isNotEmpty) {
      for(int index=0; index<Get.find<PaymentController>().offlineMethodList![Get.find<PaymentController>().selectedOfflineBankIndex].methodInformations!.length; index++) {
        Get.find<PaymentController>().informationControllerList.add(TextEditingController());
        Get.find<PaymentController>().informationFocusList.add(FocusNode());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'offline_payment'.tr),
      body: SafeArea(
        child: GetBuilder<PaymentController>(
          builder: (paymentController) {
            List<MethodInformations>? methodInformation = paymentController.offlineMethodList != null ? paymentController.offlineMethodList![paymentController.selectedOfflineBankIndex].methodInformations! : [];

            return paymentController.offlineMethodList != null ? Column(children: [
              Expanded(child: SingleChildScrollView(
                child: FooterView(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Image.asset(Images.offlinePayment, height: 100),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text('pay_your_bill_using_the_info'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodySmall?.color,
                      )),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      SizedBox(
                        height: 160,
                        child: PageView.builder(
                          onPageChanged: (int pageIndex) {
                            paymentController.selectOfflineBank(pageIndex);
                            paymentController.changesMethod();
                          },
                          scrollDirection: Axis.horizontal,
                            controller: pageController,
                            itemCount: paymentController.offlineMethodList!.length,
                            itemBuilder: (context, index) {
                            bool selected = paymentController.selectedOfflineBankIndex == index;
                          return bankCard(context, paymentController.offlineMethodList, index, selected);
                        }),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Text(
                        '${'amount'.tr} '' ${PriceConverter.convertPrice(widget.total)}',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'payment_info'.tr,
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                            ),
                          ),

                          ListView.builder(
                            itemCount: paymentController.informationControllerList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                child: CustomTextField(
                                  titleText: methodInformation[i].customerPlaceholder!,
                                  controller: paymentController.informationControllerList[i],
                                  focusNode: paymentController.informationFocusList[i],
                                  nextFocus: i != paymentController.informationControllerList.length-1 ? paymentController.informationFocusList[i+1] : _customerNoteNode,
                                ),
                              );
                            },
                          ),

                          CustomTextField(
                            titleText: 'write_your_note'.tr,
                            controller: _customerNoteController,
                            focusNode: _customerNoteNode,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                        ]),
                      ),

                      ResponsiveHelper.isDesktop(context) ? completeButton(paymentController, methodInformation) : const SizedBox(),



                    ]),
                  ),
                ),
              )),

              !ResponsiveHelper.isDesktop(context) ? completeButton(paymentController, methodInformation) : const SizedBox(),


            ]) : const Center(child: CircularProgressIndicator());
          }
        ),
      ),
    );
  }

  Widget completeButton(PaymentController paymentController, List<MethodInformations>? methodInformation, ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
      child: CustomButton(
        buttonText: 'complete'.tr,
        isLoading: paymentController.isLoading,
        width: ResponsiveHelper.isDesktop(context) ? 300 : 500,
        onPressed: () async {
          bool complete = false;
          String text = '';
          for(int i=0; i<methodInformation!.length; i++){
            if(methodInformation[i].isRequired!) {
              if(paymentController.informationControllerList[i].text.isEmpty){
                complete = false;
                text = methodInformation[i].customerPlaceholder!;
                break;
              } else {
                complete = true;
              }
            } else {
              complete = true;
            }
          }

          if(complete) {
            String methodId = paymentController.offlineMethodList![paymentController.selectedOfflineBankIndex].id.toString();

            String? orderId = '';
            if(widget.forParcel) {
              orderId = await Get.find<ParcelController>().placeOrder(
                  widget.placeOrderBody, widget.zoneId, widget.total, widget.maxCodOrderAmount, widget.fromCart,
                  widget.isCashOnDeliveryActive, isOfflinePay: true, forParcel: widget.forParcel);
            } else {
              orderId = await Get.find<CheckoutController>().placeOrder(
                  widget.placeOrderBody, widget.zoneId, widget.total, widget.maxCodOrderAmount, widget.fromCart,
                  widget.isCashOnDeliveryActive, isOfflinePay: true);
            }

            if(orderId.isNotEmpty) {
              Map<String, String> data = {
                "_method": "put",
                "order_id": orderId,
                "method_id": methodId,
                "customer_note": _customerNoteController.text,
              };

              for(int i=0; i<methodInformation.length; i++){
                data.addAll({
                  methodInformation[i].customerInput! : paymentController.informationControllerList[i].text,
                });
              }

              paymentController.saveOfflineInfo(jsonEncode(data)).then((success) {
                if(success){
                  Get.offAllNamed(RouteHelper.getOrderDetailsRoute(int.parse(orderId!), fromOffline: true, contactNumber: widget.placeOrderBody.contactPersonNumber));
                }
              });
            }


          } else {
            showCustomSnackBar(text);
          }
        },
      ),
    );
  }

  Widget bankCard(BuildContext context, List<OfflineMethodModel>? offlineMethodList, int index, bool selected) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: selected ? const [BoxShadow(color: Colors.black12, blurRadius: 10)] : [],
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Text('bank_info'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
            const Spacer(),

            selected ? Row(children: [
              Text('pay_on_this_account'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),),
              Icon(Icons.check_circle_rounded, size: 20, color: Theme.of(context).primaryColor),
            ]) : const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ListView.builder(
            itemCount: offlineMethodList![index].methodFields!.length,
              addRepaintBoundaries: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
              child: Row(children: [
                Text(
                  '${offlineMethodList[index].methodFields![i].inputName!.toString().replaceAll('_', ' ')} : ',
                  style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5)),
                ),
                Flexible(child: Text(offlineMethodList[index].methodFields![i].inputData!, style: robotoMedium, overflow: TextOverflow.ellipsis)),
              ]),
            );
          })

        ]),
      ),
    );
  }
}
