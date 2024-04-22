import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/web/web_basic_medicine_nearby_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/medicine_item_card.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class ProductWithCategoriesView extends StatefulWidget {
  final bool fromShop;
  const ProductWithCategoriesView({super.key, this.fromShop = false});

  @override
  State<ProductWithCategoriesView> createState() => _ProductWithCategoriesViewState();
}

class _ProductWithCategoriesViewState extends State<ProductWithCategoriesView> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ItemController>(builder: (itemController) {
      List<Categories>? categories = [];
      List<Item>? products = [];
      if(widget.fromShop ? itemController.reviewedCategoriesList != null && itemController.reviewedItemList !=null : itemController.basicMedicineModel != null){
        categories.add(Categories(name: 'all'.tr, id: 0));
        for (var category in widget.fromShop ? itemController.reviewedCategoriesList! : itemController.basicMedicineModel!.categories!) {
          categories.add(category);
        }
        for (var product in widget.fromShop ? itemController.reviewedItemList! : itemController.basicMedicineModel!.products!) {
          if(selectedCategory == 0) {
            products.add(product);
          }
          if(categories[selectedCategory].id == product.categoryId){
            products.add(product);
          }
        }
      }
      return products.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeLarge),
            child: Text(widget.fromShop ? 'best_reviewed_products'.tr : 'basic_medicine_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ),

          Column(children: [
            SizedBox(
              height: 50,
              child: Container(
                height: 40,
                color: widget.fromShop ? Theme.of(context).disabledColor.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedCategory == index;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = index;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                            ),
                            child: Text('${categories[index].name}', style: robotoMedium.copyWith(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)),
                          ),

                          isSelected ? Container(
                            height: 15, width: 35,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
                              color: Theme.of(context).cardColor
                            ),
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                            ),
                          ) : const SizedBox(),
                        ],
                      ),
                    );

                  },
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: widget.fromShop ? Theme.of(context).disabledColor.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: SizedBox(
                height: ResponsiveHelper.isDesktop(context) ? widget.fromShop ? 290 : 260 : widget.fromShop ? 292 : 247, width: Get.width,
                child: (widget.fromShop ? itemController.reviewedCategoriesList != null : itemController.basicMedicineModel != null) ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                      child: MedicineItemCard(item: products[index]),
                    );
                  },
                ) : const MedicineCardShimmer(),
              ),
            ),
          ]),

        ]),
      ) : const SizedBox();
    });
  }
}




