import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/features/payment/controllers/payment_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';

class OfflineInfoEditDialogWidget extends StatefulWidget {
  final OfflinePayment offlinePayment;
  final int orderId;
  const OfflineInfoEditDialogWidget({super.key, required this.offlinePayment, required this.orderId});

  @override
  State<OfflineInfoEditDialogWidget> createState() => _OfflineInfoEditDialogWidgetState();
}

class _OfflineInfoEditDialogWidgetState extends State<OfflineInfoEditDialogWidget> {

  @override
  void initState() {
    super.initState();

    Get.find<PaymentController>().informationControllerList = [];
    Get.find<PaymentController>().informationFocusList = [];
    for (int i=0; i<widget.offlinePayment.input!.length ; i++) {
      Get.find<PaymentController>().informationControllerList.add(TextEditingController(text: widget.offlinePayment.input![i].userData));
      Get.find<PaymentController>().informationFocusList.add(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: GetBuilder<PaymentController>(
            builder: (paymentController) {
              return SingleChildScrollView(
                child: Column(children: [

                  Image.asset(Images.offlinePayment, height: 100),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('update_payment_info'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodySmall?.color,
                  )),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  ListView.builder(
                    itemCount: paymentController.informationControllerList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        child: CustomTextField(
                          titleText: widget.offlinePayment.input![i].userInput.toString().replaceAll('_', ' '),
                          controller: paymentController.informationControllerList[i],
                          focusNode: paymentController.informationFocusList[i],
                          nextFocus: i != paymentController.informationControllerList.length-1 ? paymentController.informationFocusList[i+1] : null,
                          inputAction: i != paymentController.informationControllerList.length-1 ? TextInputAction.next : TextInputAction.done,
                        ),
                      );
                    },
                  ),

                  Row(children: [
                    const Spacer(),

                    CustomButton(
                      width: 100,
                      color: Theme.of(context).disabledColor.withOpacity(0.5),
                      textColor: Theme.of(context).textTheme.bodyMedium!.color,
                      buttonText: 'cancel'.tr,
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    CustomButton(
                      width: 100,
                      buttonText: 'update'.tr,
                      isLoading: paymentController.isLoading,
                      onPressed: () {

                        for(int i=0; i<paymentController.informationControllerList.length; i++){
                          if(paymentController.informationControllerList[i].text.isEmpty) {
                            showCustomSnackBar('please_provide_every_information'.tr);
                            break;
                          }else {
                            Map<String, String> data = {
                              "_method": "put",
                              "order_id": widget.orderId.toString(),
                              "method_id": widget.offlinePayment.data!.methodId.toString(),
                            };

                            for(int i=0; i<paymentController.informationControllerList.length; i++){
                              data.addAll({
                                widget.offlinePayment.input![i].userInput.toString() : paymentController.informationControllerList[i].text,
                              });
                            }

                            paymentController.updateOfflineInfo(jsonEncode(data)).then((success) {
                              if(success) {
                                Get.back();
                              }
                            });
                          }
                        }


                      },
                    ),


                  ])
                ]),
              );
            }
          ),
        ),
      ),
    );
  }
}
