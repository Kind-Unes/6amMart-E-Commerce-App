import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
class RefundRequestScreen extends StatefulWidget {
  final String? orderId;
  const RefundRequestScreen({super.key, required this.orderId});

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().selectReason(0, isUpdate: false);
    Get.find<OrderController>().pickRefundImage(true);
    Get.find<OrderController>().getRefundReasons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'refund_request'.tr),
      body: SafeArea(
        child: GetBuilder<OrderController>(
            builder: (orderController) {
              return Center(
                child: (orderController.refundReasons != null && orderController.refundReasons!.isNotEmpty) ? Container(
                  width: context.width > 700 ? 700 : context.width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  alignment: Alignment.center,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('what_is_wrong_with_this_order'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                border: Border.all(color: Theme.of(context).disabledColor)),
                            child: DropdownButton<String>(
                              value: orderController.refundReasons![orderController.selectedReasonIndex],
                              items: orderController.refundReasons!.map((String? items) {
                                return DropdownMenuItem(value: items, child: Text(items!.tr));
                              }).toList(),
                              onChanged: (value){
                                orderController.selectReason(orderController.refundReasons!.indexOf(value));
                                if(_noteController.text.isNotEmpty){
                                  _noteController.text = '';
                                }
                                if(orderController.refundImage != null){
                                  orderController.pickRefundImage(true);
                                }
                              },
                              isExpanded: true,
                              underline: const SizedBox(),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          orderController.selectedReasonIndex != 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('additional_note'.tr, style: robotoMedium),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), border: Border.all(color: Theme.of(context).disabledColor)),
                              child: CustomTextField(
                                controller: _noteController,
                                titleText: 'ex_please_provide_any_note'.tr,
                                maxLines: 3,
                                inputType: TextInputType.multiline,
                                inputAction: TextInputAction.newline,
                                capitalization: TextCapitalization.sentences,
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            DottedBorder(
                              color: Theme.of(context).disabledColor,
                              strokeWidth: 2,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [8, 5],
                              padding: const EdgeInsets.all(0),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusSmall),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: orderController.refundImage != null ? GetPlatform.isWeb ? Image.network(
                                    orderController.refundImage!.path, width: context.width, height: 150, fit: BoxFit.cover,
                                  ) : Image.file(
                                    File(orderController.refundImage!.path), width: context.width, height: 150, fit: BoxFit.cover,
                                  ) : InkWell(
                                    onTap: () => orderController.pickRefundImage(false),
                                    child: Container(
                                      width: context.width, height: 150, alignment: Alignment.center,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                        Icon(Icons.cloud_download_rounded, size: 34, color: Theme.of(context).disabledColor),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),

                                        Text('upload_image'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).disabledColor)),
                                      ]),
                                    ),
                                  ),
                                ),
                                orderController.refundImage != null ? Positioned(
                                  bottom: 0, right: 0, top: 0, left: 0,
                                  child: InkWell(
                                    onTap: () => orderController.pickRefundImage(false),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(25),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 2, color: Theme.of(context).disabledColor),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.camera_alt, color: Theme.of(context).disabledColor),
                                      ),
                                    ),
                                  ),
                                ) : const SizedBox(),
                              ]),
                            ),
                          ]) : const SizedBox(),

                        ]),
                      ),
                    ),

                    CustomButton(
                      buttonText: 'submit_refund_request'.tr,
                      isLoading: orderController.isLoading,
                      onPressed: () => orderController.submitRefundRequest(_noteController.text.trim(), widget.orderId),
                    ),

                  ]),
                ) : const CircularProgressIndicator(),
              );
            }
        ),
      ),
    );
  }
}
