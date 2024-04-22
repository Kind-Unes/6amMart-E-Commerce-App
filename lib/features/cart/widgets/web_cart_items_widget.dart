import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/web_constrained_box.dart';
import 'package:sixam_mart/features/cart/widgets/cart_item_widget.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';

class WebCardItemsWidget extends StatelessWidget {
  final List<CartModel> cartList;
  const WebCardItemsWidget({super.key, required this.cartList});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<CartController>(
      builder: (cartController) {
        return Expanded(
          flex: 6,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const  BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
            ),

            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Product
              WebConstrainedBox(
                dataLength: cartList.length, minLength: 5, minHeight: 0.6,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartList.length,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    itemBuilder: (context, index) {
                      return CartItemWidget(cart: cartList[index], cartIndex: index, addOns: cartController.addOnsList[index], isAvailable: cartController.availableList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),

                  const Divider(thickness: 0.5, height: 5),

                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                    child: TextButton.icon(
                      onPressed: (){
                        cartController.forcefullySetModule(cartController.cartList[0].item!.moduleId!);
                        Get.toNamed(
                          RouteHelper.getStoreRoute(id: cartController.cartList[0].item!.storeId, page: 'item'),
                          arguments: StoreScreen(store: Store(id: cartController.cartList[0].item!.storeId), fromModule: false),
                        );
                      },
                      icon: Icon(Icons.add_circle_outline_sharp, color: Theme.of(context).primaryColor),
                      label: Text('add_more_items'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                    ),
                  ),


                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ]),
          ),
        );
      }
    );
  }
}
