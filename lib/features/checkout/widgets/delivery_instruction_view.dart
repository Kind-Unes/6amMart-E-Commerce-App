import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class DeliveryInstructionView extends StatefulWidget {
  const DeliveryInstructionView({super.key});

  @override
  State<DeliveryInstructionView> createState() => _DeliveryInstructionViewState();
}

class _DeliveryInstructionViewState extends State<DeliveryInstructionView> {
  ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
      child: GetBuilder<CheckoutController>(
        builder: (orderController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: widget.key,
                controller: controller,
                title: Text('add_more_delivery_instruction'.tr, style: robotoMedium),
                trailing: Icon(orderController.isExpanded ? Icons.remove : Icons.add, size: 18),
                tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                onExpansionChanged: (value) => orderController.expandedUpdate(value),

                children: [

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: AppConstants.deliveryInstructionList.length,
                      itemBuilder: (context, index){
                      bool isSelected = orderController.selectedInstruction == index;
                    return InkWell(
                      onTap: () {
                        orderController.setInstruction(index);
                        if(controller.isExpanded) {
                          controller.collapse();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.5) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Row(children: [
                          Icon(Icons.ac_unit, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 18),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(
                            child: Text(
                              AppConstants.deliveryInstructionList[index].tr,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
                            ),
                          ),
                        ]),

                      ),
                    );
                  }),
                ],
              ),
            ),

            orderController.selectedInstruction != -1 ? Padding(
              padding:  EdgeInsets.symmetric(vertical: orderController.isExpanded ? Dimensions.paddingSizeSmall : 0),
              child: Row(children: [
                Text(
                  AppConstants.deliveryInstructionList[orderController.selectedInstruction].tr,
                  style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
                ),

                InkWell(
                  onTap: ()=> orderController.setInstruction(-1),
                  child: const Icon(Icons.clear, size: 16),
                ),
              ])
            ) : const SizedBox(),

          ]);
        }
      ),
    );
  }
}
