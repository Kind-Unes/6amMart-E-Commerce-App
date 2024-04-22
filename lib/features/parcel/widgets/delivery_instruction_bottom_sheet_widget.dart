import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';

class DeliveryInstructionBottomSheetWidget extends StatefulWidget {
  const DeliveryInstructionBottomSheetWidget({super.key});

  @override
  State<DeliveryInstructionBottomSheetWidget> createState() => _DeliveryInstructionBottomSheetWidgetState();
}

class _DeliveryInstructionBottomSheetWidgetState extends State<DeliveryInstructionBottomSheetWidget> {

  @override
  void initState() {
    Get.find<ParcelController>().getParcelInstruction();
    Get.find<ParcelController>().setInstructionselectedIndex(Get.find<ParcelController>().selectedIndexNote ?? -1, notify: false);
    Get.find<ParcelController>().setCustomNoteController(Get.find<ParcelController>().customNote ?? '', notify: false);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(
      builder: (parcelController) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8, minHeight: 250, maxWidth: 500),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radiusExtraLarge),
              topRight: Radius.circular(Dimensions.radiusExtraLarge),
            ),
          ),
          child: parcelController.parcelInstructionList != null ? SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              Container(
                height: 5, width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                parcelController.parcelInstructionList!.isNotEmpty ? Text("choose_delivery_instructions".tr, style: robotoMedium) : const SizedBox(),

                InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 20),
                ),

              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              parcelController.parcelInstructionList!.isNotEmpty ? ListView.builder(
                itemCount: parcelController.parcelInstructionList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    child: InkWell(
                      onTap: () {
                        parcelController.setInstructionselectedIndex(index);
                      },
                      child: SelectedCardWidget(title: parcelController.parcelInstructionList![index].instruction!, isSelect: parcelController.instructionselectedIndex == index),
                    ),
                  );
                },
              ) : const SizedBox(),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Row(
                children: [
                  parcelController.parcelInstructionList!.isNotEmpty ? Text("or".tr, style: robotoMedium) : const SizedBox(),
                  SizedBox(width: parcelController.parcelInstructionList!.isNotEmpty ? Dimensions.paddingSizeExtraSmall : 0),

                  Text("add_custom_note".tr, style: robotoMedium),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomTextField(
                titleText: "please_maintain_the_hygine".tr,
                maxLines: 3,
                controller: parcelController.customNoteController,
                onChanged: (value) {
                  parcelController.setCustomNoteController(value);
                }
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              CustomButton(
                onPressed: (parcelController.instructionselectedIndex != -1 || parcelController.customNoteController.text.isNotEmpty) ? () {

                  parcelController.setselectedIndex(null);
                  parcelController.setCustomNote(null);
                  Get.back();

                } : null,
                buttonText: 'apply'.tr,
              ),

            ]),
          ) : const Center(child: CircularProgressIndicator()),

        );
      }
    );
  }
}

class SelectedCardWidget extends StatelessWidget {
  final bool isSelect;
  final String title;
  const SelectedCardWidget({super.key, required this.isSelect, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.2)),
      ),
      child: Row(children: [
    
        Icon(isSelect ? Icons.check_circle : Icons.radio_button_off, color: isSelect ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 25),
        const SizedBox(width: Dimensions.paddingSizeSmall),
    
        Expanded(child: Text(title, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor), maxLines: 2, overflow: TextOverflow.ellipsis)),
    
      ]),
    );
  }
}
