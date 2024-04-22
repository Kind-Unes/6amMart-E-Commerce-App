import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/rider_controller.dart';
import 'package:sixam_mart/features/location/domain/models/prediction_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
class RiderAddressInputField extends StatelessWidget {
  final bool isFormAddress;
  const RiderAddressInputField({super.key, required this.isFormAddress});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderController>(
      builder: (riderController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: Theme.of(context).cardColor,
          ),
          child: Row(
            children: [
              const SizedBox(width: Dimensions.paddingSizeSmall),

              isFormAddress ? Image.asset(Images.liveMarker, height: 16, width: 16, color: Theme.of(context).primaryColor)
                  : Icon(Icons.location_on_rounded, size: 16, color: Theme.of(context).primaryColor),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Expanded(
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: isFormAddress ? riderController.formTextEditingController : riderController.toTextEditingController,
                    textInputAction: TextInputAction.search,
                    autofocus: false,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      hintText: 'enter_pickup'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                      ),
                      hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                      ),
                      filled: true, fillColor: Theme.of(context).cardColor,
                    ),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await Get.find<LocationController>().searchLocation(context, pattern);
                  },
                  itemBuilder: (context, PredictionModel suggestion) {
                    return Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Row(children: [
                        isFormAddress ? Image.asset(Images.liveMarker, height: 16, width: 16, color: Theme.of(context).primaryColor)
                            : Icon(Icons.location_on_rounded, size: 16, color: Theme.of(context).primaryColor),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Expanded(
                          child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                          )),
                        ),
                      ]),
                    );
                  },
                  onSuggestionSelected: (PredictionModel suggestion) {
                    riderController.setLocationFromPlace(suggestion.placeId, suggestion.description, isFormAddress);
                  },
                ),
              ),

              (isFormAddress ? riderController.formTextEditingController.text != '' : riderController.toTextEditingController.text != '') ? InkWell(
                onTap: ()=> riderController.clearAddress(isFormAddress),
                child: const SizedBox(
                  height: 30, width: 30,
                  child: Icon(Icons.clear, size: 16),
                ),
              ) : const SizedBox()

            ],
          ),
        );
      }
    );
  }
}
