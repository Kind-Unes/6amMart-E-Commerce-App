import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class CancellationDialogueWidget extends StatelessWidget {
  final int? orderId;
  const CancellationDialogueWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    Get.find<OrderController>().getOrderCancelReasons();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<OrderController>(
        builder: (orderController) {
          return SizedBox(
            width: 500, height: MediaQuery.of(context).size.height * 0.6,
            child: Column(children: [

              Container(
                width: 500,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                ),
                child: Column(children: [
                  Text('select_cancellation_reasons'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                ]),
              ),

              Expanded(
                child: orderController.orderCancelReasons != null ? orderController.orderCancelReasons!.isNotEmpty ? ListView.builder(
                    itemCount: orderController.orderCancelReasons!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: ListTile(
                          onTap: (){
                            orderController.setOrderCancelReason(orderController.orderCancelReasons![index].reason);
                          },
                          title: Row(
                            children: [
                              Icon(orderController.orderCancelReasons![index].reason == orderController.cancelReason ? Icons.radio_button_checked : Icons.radio_button_off, color: Theme.of(context).primaryColor, size: 18),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Flexible(child: Text(orderController.orderCancelReasons![index].reason!, style: robotoRegular, maxLines: 3, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                      );
                    }) : Center(child: Text('no_reasons_available'.tr)) : const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.fontSizeDefault, vertical: Dimensions.paddingSizeSmall),
                child: !orderController.isLoading ? Row(children: [
                  Expanded(child: CustomButton(
                    buttonText: 'cancel'.tr, color: Theme.of(context).disabledColor, radius: 50,
                    onPressed: () => Get.back(),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: CustomButton(
                    buttonText: 'submit'.tr,  radius: 50,
                    onPressed: (){
                      if(orderController.cancelReason != '' && orderController.cancelReason != null){

                        orderController.cancelOrder(orderId, orderController.cancelReason).then((success) {
                          if(success){
                            orderController.trackOrder(orderId.toString(), null, true);
                          }
                        });

                      }else{
                        if(Get.isDialogOpen!){
                          Get.back();
                        }

                        showCustomSnackBar('you_did_not_select_select_any_reason'.tr);
                      }
                    },
                  )),
                ]) : const Center(child: CircularProgressIndicator()),
              ),
            ]),
          );
        }
      ),
    );
  }
}
