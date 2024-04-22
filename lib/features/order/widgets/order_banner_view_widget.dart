import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';

class OrderBannerViewWidget extends StatelessWidget {
  final OrderModel order;
  final bool ongoing;
  final bool parcel;
  final bool prescriptionOrder;
  final OrderController orderController;
  const OrderBannerViewWidget({super.key, required this.order, required this.ongoing, required this.parcel, required this.prescriptionOrder, required this.orderController, });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DateConverter.isBeforeTime(order.scheduleAt) && Get.find<SplashController>().getModuleConfig(order.moduleType).newVariation! ? ongoing ? Column(children: [

        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(
          order.orderStatus == 'pending' ? Images.pendingFoodOrderDetails : (order.orderStatus == 'confirmed' || order.orderStatus == 'processing' || order.orderStatus == 'handover')
              ? Images.preparingFoodOrderDetails : Images.ongoingAnimation, fit: BoxFit.contain, height: 200,
        )),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text('your_food_will_delivered_within'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Center(
          child: Row(mainAxisSize: MainAxisSize.min, children: [

            Text(
              DateConverter.differenceInMinute(order.store!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt) < 5 ? '1 - 5'
                  : '${DateConverter.differenceInMinute(order.store!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt)-5} '
                  '- ${DateConverter.differenceInMinute(order.store!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt)}',
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textDirection: TextDirection.ltr,
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text('min'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

      ]) : CustomImage(image: '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${order.store!.coverPhoto}', height: 150, width: double.infinity) : const SizedBox(),

      parcel ? (ongoing && order.orderStatus == 'pending') ? Image.asset(Images.pendingOrderDetails, height: 160, width: double.infinity) : Center(child: CustomImage(image: '${Get.find<SplashController>().configModel!.baseUrls!.parcelCategoryImageUrl}/${order.parcelCategory?.image}', height: 160)) : const SizedBox(),

      prescriptionOrder ? ongoing ? Image.asset(
          order.orderStatus == 'pending' ? Images.pendingOrderDetails : (order.orderStatus == 'confirmed' || order.orderStatus == 'processing' || order.orderStatus == 'handover')
              ? Images.preparingGroceryOrderDetails : Images.ongoingAnimation, height: 160, width: double.infinity)
          : CustomImage(image: '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${order.store?.coverPhoto}', height: 160, width: double.infinity)
          : const SizedBox(),

      orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemDetails!.moduleType == 'grocery'
          ? (ongoing && order.orderStatus == 'pending') ? Image.asset(Images.pendingOrderDetails, height: 160, width: double.infinity)
          : CustomImage(image: '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${order.store?.coverPhoto}', height: 160, width: double.infinity)
          : const SizedBox(),

      orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemDetails!.moduleType == 'pharmacy'
          ?(ongoing && order.orderStatus == 'pending') ? Image.asset(Images.pendingOrderDetails, height: 160, width: double.infinity)
          : CustomImage(image: '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${order.store?.coverPhoto}', height: 160, width: double.infinity)
          : const SizedBox(),

      orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemDetails!.moduleType == 'ecommerce'
          ?(ongoing && order.orderStatus == 'pending') ? Image.asset(Images.pendingOrderDetails, height: 160, width: double.infinity)
          : CustomImage(image: '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${order.store?.coverPhoto}', height: 160, width: double.infinity)
          : const SizedBox(),

    ]);
  }
}
