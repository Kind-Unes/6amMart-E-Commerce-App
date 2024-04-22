import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/car_selection_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class FilterCarSortingWidget extends StatelessWidget {
   const FilterCarSortingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarSelectionController>(
      builder: (carSelectionController) {
        return Column(
          children:[
            _myRadioButton(
              carSelectionController: carSelectionController,
              title: 'top_rated'.tr,
              value: 0,
              onChanged: (){
                carSelectionController.setSortBy(0);
              },
            ),
            // _myRadioButton(
            //   carSelectionController: carSelectionController,
            //   title: "Km/h",
            //   value: 1,
            //   onChanged: (){
            //     carSelectionController.setSortBy(1);
            //   },
            // ),
          ],
        );
      }
    );
  }

  Widget _myRadioButton({required String title, int? value, Function? onChanged, required CarSelectionController carSelectionController}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onChanged as void Function()?,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: carSelectionController.sortByIndex == value ? robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault) : robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(Get.context!).primaryColor, width: 2),
                color: Theme.of(Get.context!).cardColor, shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                height: 10, width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: carSelectionController.sortByIndex == value ? Theme.of(Get.context!).primaryColor : Theme.of(Get.context!).cardColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
