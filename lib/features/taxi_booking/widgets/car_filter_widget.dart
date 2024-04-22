import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/car_selection_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'filter_car_sorting_widget.dart';

class CarFilterWidget extends StatelessWidget {
  const CarFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarSelectionController>(
      builder: (carSelectionController){
        if(carSelectionController.isCarFilterActive) {
          return Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                Center(
                  child: Container(
                    height: 5, width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                Text("filter_by".tr,style: robotoRegular.copyWith(
                    color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeDefault,
                ),),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('price_range'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),)),
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.09),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '${Get.find<SplashController>().configModel!.currencySymbol}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              TextSpan(
                                  text: carSelectionController.startingPrice.toString(),
                                  style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraLarge),
                              ),
                              TextSpan(
                                  text: '/hr',
                                  style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5), fontSize: Dimensions.fontSizeSmall),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 1,
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.3),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '${Get.find<SplashController>().configModel!.currencySymbol}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              TextSpan(
                                  text: carSelectionController.endingPrice.toString(),
                                  style: robotoBold.copyWith(color:  Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraLarge),
                              ),
                              TextSpan(
                                  text: '/hr',
                                  style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5), fontSize: Dimensions.fontSizeSmall),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                RangeSlider(
                    values: carSelectionController.selectedPriceRange,
                    min: 0.0,
                    max: 5.0,
                    divisions: 10,
                    onChanged: (RangeValues newRange){
                      carSelectionController.selectPriceRange(newRange);
                    },
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('basic'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5))),
                    Container(height: 10, width: 1, color: Theme.of(context).primaryColor),

                    Text('standard'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5))),
                    Container(height: 10, width: 1, color: Theme.of(context).primaryColor),

                    Text('premium'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('model'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall))),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      itemCount: carSelectionController.brandModels!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          child: InkWell(
                            onTap: (){
                              carSelectionController.setBrandModel(index);
                            },
                            child: Container(
                                width: 54,
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                                  color: index != carSelectionController.selectedBrand ? Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.06) :
                                  Theme.of(context).primaryColor.withOpacity(.1),
                                  border: Border.all(color:index != carSelectionController.selectedBrand ? Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.06) : Theme.of(context).primaryColor )
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: CustomImage(
                                      image: '${Get.find<SplashController>().configModel!.baseUrls!.vehicleBrandImageUrl}/${carSelectionController.brandModels![index].logo}',
                                  ),
                                ),
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                // Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text('car_type'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),)),
                // SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                // Container(
                //   height: 50,
                //   child: ListView.builder(
                //       itemCount: 7,
                //       scrollDirection: Axis.horizontal,
                //       itemBuilder: (context,index){
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                //           child: Container(
                //               width: 54,
                //               height: 52,
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.all(Radius.circular(5)),
                //                 color: index != 0 ? Theme.of(context).textTheme.bodyText1.color.withOpacity(.06) :
                //                 Theme.of(context).primaryColor.withOpacity(.1),
                //                 border: Border.all(color:index != 0 ? Theme.of(context).textTheme.bodyText1.color.withOpacity(.06) : Theme.of(context).primaryColor )
                //               ),
                //               child: Image.asset(Images.demo_car_type)),
                //         );
                //       }),
                // ),
                // SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('sort_by'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ),
                const FilterCarSortingWidget(),
                const SizedBox(height: 20),
              ],
            ),
          ),

        );
        }
        return const SizedBox();
      },
    );
  }
}
