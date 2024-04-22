import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/features/review/domain/models/review_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/rating_bar.dart';
import 'package:sixam_mart/features/chat/widgets/image_dialog_widget.dart';
import 'package:sixam_mart/features/order/widgets/delivery_details_widget.dart';
import 'package:sixam_mart/features/payment/widgets/offline_info_edit_dialog_widget.dart';
import 'package:sixam_mart/features/order/widgets/order_banner_view_widget.dart';
import 'package:sixam_mart/features/order/widgets/order_item_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/details_widget.dart';
import 'package:sixam_mart/features/store/widgets/review_dialog_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderInfoWidget extends StatelessWidget {
  final OrderModel order;
  final bool ongoing;
  final bool parcel;
  final bool prescriptionOrder;
  final OrderController orderController;
  final Function timerCancel;
  final Function startApiCall;
  const OrderInfoWidget({super.key, required this.order, required this.ongoing, required this.parcel, required this.prescriptionOrder, required this.orderController, required this.timerCancel, required this.startApiCall});

  @override
  Widget build(BuildContext context) {
    ExpansionTileController controller = ExpansionTileController();
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = AuthHelper.isGuestLoggedIn();
    return Stack(children: [

      !isDesktop ? OrderBannerViewWidget(
        order: order, orderController: orderController, ongoing: ongoing,
        parcel: parcel, prescriptionOrder: prescriptionOrder,
      ) : const SizedBox(),


      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
          // isDesktop ? Text('general_info'.tr, style: robotoMedium) : const SizedBox(),
          isDesktop ? const SizedBox(height: Dimensions.paddingSizeExtraLarge) : const SizedBox(),

        !isDesktop ? SizedBox(height: DateConverter.isBeforeTime(order.scheduleAt) && Get.find<SplashController>().getModuleConfig(order.moduleType).newVariation!
            ? (order.orderStatus != 'delivered' && order.orderStatus != 'failed'
            && order.orderStatus != 'canceled' && order.orderStatus != 'refund_requested' && order.orderStatus != 'refunded'
            && order.orderStatus != 'refund_request_canceled' ) ? 280 : 140 :
        parcel || prescriptionOrder || (orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemDetails!.moduleType == 'grocery')
            || (orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemDetails!.moduleType == 'ecommerce')
            || (orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemDetails!.moduleType == 'pharmacy')
            ? 140 : 0) : const SizedBox(),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)) : BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [isDesktop ? const BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1) : const BoxShadow()],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

              isDesktop ? OrderBannerViewWidget(
                order: order, orderController: orderController, ongoing: ongoing,
                parcel: parcel, prescriptionOrder: prescriptionOrder,
              ) : const SizedBox(),
              isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

              Text('general_info'.tr, style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Text(parcel ? 'delivery_id'.tr : 'order_id'.tr, style: robotoRegular),
                const Expanded(child: SizedBox()),

                Text('#${order.id}', style: robotoBold),
              ]),
              Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),

              Row(children: [
                Text('order_date'.tr, style: robotoRegular),
                const Expanded(child: SizedBox()),

                Text(
                  DateConverter.dateTimeStringToDateTime(order.createdAt!),
                  style: robotoRegular,
                ),
              ]),

              order.scheduled == 1 ? Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)) : const SizedBox(),
              order.scheduled == 1 ? Row(children: [
                Text('${'scheduled_at'.tr}:', style: robotoRegular),
                const Expanded(child: SizedBox()),
                Text(DateConverter.dateTimeStringToDateTime(order.scheduleAt!), style: robotoMedium),
              ]) : const SizedBox(),

              Get.find<SplashController>().configModel!.orderDeliveryVerification! ? const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(),
              Get.find<SplashController>().configModel!.orderDeliveryVerification! ? Row(children: [
                Text('${'delivery_verification_code'.tr}:', style: robotoRegular),
                const Expanded(child: SizedBox()),
                Text(order.otp!, style: robotoMedium),
              ]) : const SizedBox(),
              Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),

              Row(children: [
                Text(order.orderType!.tr, style: robotoMedium),
                const Expanded(child: SizedBox()),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text( order.paymentMethod == 'cash_on_delivery' ? 'cash_on_delivery'.tr
                      : order.paymentMethod == 'wallet' ? 'wallet_payment'.tr
                      : order.paymentMethod == 'partial_payment' ? 'partial_payment'.tr
                      : order.paymentMethod == 'offline_payment' ? 'offline_payment'.tr : 'digital_payment'.tr,
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                  ),
                ),
              ]),
              Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${parcel ? 'charge_pay_by'.tr : 'item'.tr}:', style: robotoRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text(
                    parcel ? order.chargePayer!.tr : orderController.orderDetails!.length.toString(),
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const Expanded(child: SizedBox()),

                  Container(height: 7, width: 7, decoration: BoxDecoration(
                    color: (order.orderStatus == 'failed' || order.orderStatus == 'canceled' || order.orderStatus == 'refund_request_canceled')
                        ? Colors.red : order.orderStatus == 'refund_requested' ? Colors.yellow : Colors.green,
                    shape: BoxShape.circle,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text(
                    order.orderStatus == 'delivered' ? '${'delivered_at'.tr} \n${DateConverter.dateTimeStringToDateTime(order.delivered!)}'
                        : order.orderStatus!.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                ]),
              ),

              Get.find<SplashController>().getModuleConfig(order.moduleType).newVariation! ? Column(children: [
                Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),

                Row(children: [
                  Text('${'cutlery'.tr}: ', style: robotoRegular),
                  const Expanded(child: SizedBox()),

                  Text(
                    order.cutlery! ? 'yes'.tr : 'no'.tr,
                    style: robotoRegular,
                  ),
                ]),
              ]) : const SizedBox(),

              order.unavailableItemNote != null ? Column(
                children: [
                  Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),

                  Row(children: [
                    Text('${'unavailable_item_note'.tr}: ', style: robotoMedium),

                    Text(
                      order.unavailableItemNote!,
                      style: robotoRegular,
                    ),
                  ]),
                ],
              ) : const SizedBox(),

              order.deliveryInstruction != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),

                RichText(
                  text: TextSpan(
                      text: '${'delivery_instruction'.tr}: ',
                      style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                      children: <TextSpan>[
                        TextSpan(text: order.deliveryInstruction!,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)
                        )
                      ]
                  ),
                ),
              ]) : const SizedBox(),
              SizedBox(height: order.deliveryInstruction != null ? Dimensions.paddingSizeSmall : 0),

              order.orderStatus == 'canceled' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),
                Text('${'cancellation_note'.tr}:', style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.cancellationReason), fromOrderDetails: true)),
                  child: Text(
                    order.cancellationReason ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                ),
              ]) : const SizedBox(),

              (order.orderStatus == 'refund_requested' || order.orderStatus == 'refund_request_canceled') ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withOpacity(0.30)),

                order.orderStatus == 'refund_requested' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  RichText(text: TextSpan(children: [
                    TextSpan(text: '${'refund_note'.tr}:', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                    TextSpan(text: '(${(order.refund != null) ? order.refund!.customerReason : ''})', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  ])),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  (order.refund != null && order.refund!.customerNote != null) ? InkWell(
                    onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.refund!.customerNote), fromOrderDetails: true)),
                    child: Text(
                      '${order.refund!.customerNote}', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: (order.refund != null && order.refund!.image != null) ? Dimensions.paddingSizeSmall : 0),

                  (order.refund != null && order.refund!.image != null && order.refund!.image!.isNotEmpty) ? InkWell(
                    onTap: () => showDialog(context: context, builder: (context) {
                      return ImageDialogWidget(imageUrl: '${Get.find<SplashController>().configModel!.baseUrls!.refundImageUrl}/${order.refund!.image!.isNotEmpty ? order.refund!.image![0] : ''}');
                    }),
                    child: CustomImage(
                      height: 40, width: 40, fit: BoxFit.cover,
                      image: order.refund != null ? '${Get.find<SplashController>().configModel!.baseUrls!.refundImageUrl}/${order.refund!.image!.isNotEmpty ? order.refund!.image![0] : ''}' : '',
                    ),
                  ) : const SizedBox(),
                ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${'refund_cancellation_note'.tr}:', style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  InkWell(
                    onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.refund!.adminNote), fromOrderDetails: true)),
                    child: Text(
                      '${order.refund != null ? order.refund!.adminNote : ''}', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ),

                ]),
              ]) : const SizedBox(),

            ]),
          ),




          isDesktop ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeSmall),
          !isDesktop ? (parcel || orderController.orderDetails!.isNotEmpty) ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: parcel ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              DetailsWidget(title: 'sender_details'.tr, address: order.deliveryAddress),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              DetailsWidget(title: 'receiver_details'.tr, address: order.receiverDetails),
            ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('item_info'.tr, style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderController.orderDetails!.length,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                itemBuilder: (context, index) {
                  return OrderItemWidget(order: order, orderDetails: orderController.orderDetails![index]);
                },
              ),
            ]),
          ) : const SizedBox() : const SizedBox(),


          (isDesktop && Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachment != null
              && order.orderAttachment!.isNotEmpty ) ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

          (isDesktop && Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachment != null
              && order.orderAttachment!.isNotEmpty )  ? Text('prescription'.tr, style: robotoMedium) :  const SizedBox(),

          (isDesktop && Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachment != null
              && order.orderAttachment!.isNotEmpty ) ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),

          (Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachment != null && order.orderAttachment!.isNotEmpty) ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [isDesktop ? const BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1) : const BoxShadow()],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              !isDesktop ? Text('prescription'.tr, style: robotoRegular) : const SizedBox(),
              !isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
              SizedBox(child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: isDesktop ? 8 : 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.orderAttachment!.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => openDialog(context, '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderAttachment![index]}'),
                        child: Center(child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: CustomImage(
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderAttachment![index]}',
                            width: 100, height: 100,
                          ),
                        )),
                      ),
                    );
                  }),
              ),

              const SizedBox(height: Dimensions.paddingSizeLarge),

              SizedBox(width: (Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment!
                  && order.orderAttachment != null && order.orderAttachment!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),

              (order.orderNote  != null && order.orderNote!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('additional_note'.tr, style: robotoRegular),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.orderNote), fromOrderDetails: true)),
                  child: Text(
                    order.orderNote!, overflow: TextOverflow.ellipsis, maxLines: 3,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ]) : const SizedBox(),
            ]),
          ) : const SizedBox(),
          SizedBox(height: Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachment != null && order.orderAttachment!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

        (order.orderStatus == 'delivered' && order.orderProof != null && order.orderProof!.isNotEmpty) ? Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
          ),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('order_proof'.tr, style: robotoRegular),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.5,
                crossAxisCount: ResponsiveHelper.isTab(context) ? 5 : 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.orderProof!.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => openDialog(context, '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderProof![index]}'),
                    child: Center(child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderProof![index]}',
                        width: 100, height: 100,
                      ),
                    )),
                  ),
                );
              },
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),
          ]),
        ) : const SizedBox(),

          (order.deliveryMan != null && isDesktop) ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
          (order.deliveryMan != null && isDesktop) ? Text('delivery_man_details'.tr, style: robotoMedium) :  const SizedBox(),
          (order.deliveryMan != null && isDesktop) ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),
          order.deliveryMan != null ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [isDesktop ? const BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1) : const BoxShadow()],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('delivery_man_details'.tr, style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(children: [

                ClipOval(child: CustomImage(
                  image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${order.deliveryMan!.image}',
                  height: 35, width: 35, fit: BoxFit.cover,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    '${order.deliveryMan!.fName} ${order.deliveryMan!.lName}', maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  RatingBar(
                    rating: order.deliveryMan!.avgRating, size: 10,
                    ratingCount: order.deliveryMan!.ratingCount,
                  ),
                ])),

                (order.orderStatus != 'delivered' && order.orderStatus != 'failed' && order.orderStatus != 'canceled' && order.orderStatus != 'refunded') ? Row(children: [

                  InkWell(
                    onTap: () async{
                      timerCancel();
                      await Get.toNamed(RouteHelper.getChatRoute(
                        notificationBody: NotificationBodyModel(deliverymanId: order.deliveryMan!.id, orderId: int.parse(order.id.toString())),
                        user: User(id: order.deliveryMan!.id, fName: order.deliveryMan!.fName, lName: order.deliveryMan!.lName, image: order.deliveryMan!.image),
                      ));
                      startApiCall();
                    },
                    child: Image.asset(Images.chatOrderDetails, height: 20, width: 20),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  InkWell(
                    onTap: () async {
                      if(await canLaunchUrlString('tel:${order.deliveryMan!.phone}')) {
                        launchUrlString('tel:${order.deliveryMan!.phone}', mode: LaunchMode.externalApplication);
                      }else {
                        showCustomSnackBar('${'can_not_launch'.tr} ${order.deliveryMan!.phone}');
                      }
                    },
                    child: Image.asset(Images.phoneOrderDetails, height: 20, width: 20),
                  ),

                ]) : const SizedBox(),

              ]),
            ]),
          ) : const SizedBox(),
          SizedBox(height: order.deliveryMan != null ? Dimensions.paddingSizeLarge : 0),

          isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
          (parcel &&  isDesktop) ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              DetailsWidget(title: 'sender_details'.tr, address: order.deliveryAddress),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              DetailsWidget(title: 'receiver_details'.tr, address: order.receiverDetails),
            ]),
          ) : const SizedBox(),

          (!parcel && isDesktop) ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
          (!parcel && isDesktop) ? Text('delivery_details'.tr, style: robotoMedium) :  const SizedBox(),
          (!parcel && isDesktop) ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),

          (!parcel && order.store != null) ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: isDesktop ? const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)] : [],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              !isDesktop ? Text('delivery_details'.tr, style: robotoMedium) : const SizedBox(),
              !isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              DeliveryDetailsWidget(from: true, address: order.store!.address),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              DeliveryDetailsWidget(from: false, address: order.deliveryAddress!.address),
            ]),
          ) : const SizedBox(),
          SizedBox(height: !parcel ? Dimensions.paddingSizeSmall : 0),

          isDesktop ? const SizedBox(height: Dimensions.paddingSizeDefault) : const SizedBox(),
          isDesktop ? Text(parcel ? 'parcel_category'.tr : Get.find<SplashController>().getModuleConfig(order.moduleType).showRestaurantText! ? 'restaurant_details'.tr : 'store_details'.tr, style: robotoMedium)  : const SizedBox(),
          isDesktop ? const SizedBox(height: Dimensions.paddingSizeDefault) : const SizedBox(),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0 ),
              boxShadow: isDesktop ? const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)] : [],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              !isDesktop  ? Text(parcel ? 'parcel_category'.tr : Get.find<SplashController>().getModuleConfig(order.moduleType).showRestaurantText! ? 'restaurant_details'.tr : 'store_details'.tr, style: robotoMedium) : const SizedBox(),
              !isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

              (parcel && order.parcelCategory == null) ? Text(
                  'no_parcel_category_data_found'.tr, style: robotoMedium
              ) : (!parcel && order.store == null) ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Text('no_restaurant_data_found'.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              )) : Row(children: [
                ClipOval(child: CustomImage(
                  image: parcel ? '${Get.find<SplashController>().configModel!.baseUrls!.parcelCategoryImageUrl}/${order.parcelCategory!.image}'
                      : '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${order.store!.logo}',
                  height: 35, width: 35, fit: BoxFit.cover,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    parcel ? order.parcelCategory!.name! : order.store!.name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  Text(
                    parcel ? order.parcelCategory!.description! : order.store?.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ])),

                (!parcel && order.orderType == 'take_away' && (order.orderStatus == 'pending' || order.orderStatus == 'accepted'
                || order.orderStatus == 'confirmed' || order.orderStatus == 'processing' || order.orderStatus == 'handover'
                || order.orderStatus == 'picked_up')) ? TextButton.icon(onPressed: () async {
                  if(!parcel) {
                    String url ='https://www.google.com/maps/dir/?api=1&destination=${order.store!.latitude}'
                        ',${order.store!.longitude}&mode=d';
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    }else {
                      showCustomSnackBar('unable_to_launch_google_map'.tr);
                    }
                  }
                }, icon: const Icon(Icons.directions), label: Text('direction'.tr),

                ) : const SizedBox(),

                (!parcel && order.orderStatus != 'delivered' && order.orderStatus != 'failed' && order.orderStatus != 'canceled' && order.orderStatus != 'refunded') ? InkWell(
                  onTap: () async {
                    await Get.toNamed(RouteHelper.getChatRoute(
                      notificationBody: NotificationBodyModel(orderId: order.id, restaurantId: order.store!.vendorId),
                      user: User(id: order.store!.vendorId, fName: order.store!.name, lName: '', image: order.store!.logo),
                    ));
                  },
                  child: Image.asset(Images.chatOrderDetails, height: 20, width: 20),
                ) : const SizedBox(),

                !isGuestLoggedIn && (Get.find<SplashController>().configModel!.refundActiveStatus! && order.orderStatus == 'delivered' && !parcel
                && (parcel || (orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemCampaignId == null))) ? InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getRefundRequestRoute(order.id.toString())),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeSmall),
                    child: Text('refund_this_order'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                  ),
                ) : const SizedBox(),

              ]),
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
          isDesktop ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('payment_method'.tr, style: robotoMedium),
              order.paymentMethod == 'offline_payment' ? Text(
                orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status!.tr : '',
                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
              ) : const SizedBox(),
            ],
          ) : const SizedBox(),
          isDesktop ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: isDesktop ? const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)] : [],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              !isDesktop ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Text('payment_method'.tr, style: robotoMedium),

                order.paymentMethod == 'offline_payment' || (order.paymentMethod == 'partial_payment' && orderController.trackModel!.offlinePayment != null) ? Text(
                  orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status!.tr : '',
                  style: robotoMedium.copyWith(color: (orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status.toString() == 'denied' : false) ? Colors.red : Theme.of(context).primaryColor),
                ) : const SizedBox(),

              ]) : const SizedBox(),
              (!isDesktop && order.paymentMethod != 'offline_payment') ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

              order.paymentMethod == 'offline_payment' || (order.paymentMethod == 'partial_payment' && orderController.trackModel!.offlinePayment != null)
              ? offlineView(context, orderController, controller, ongoing) : Row(children: [

                Image.asset(
                  order.paymentMethod == 'cash_on_delivery' ? Images.cash
                      : order.paymentMethod == 'wallet' ? Images.wallet
                      : order.paymentMethod == 'partial_payment' ? Images.partialWallet
                      : Images.digitalPayment,
                  width: 20, height: 20,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Text(
                    order.paymentMethod == 'cash_on_delivery' ? 'cash'.tr
                        : order.paymentMethod == 'wallet' ? 'wallet'.tr
                        : order.paymentMethod == 'partial_payment' ? 'partial_payment'.tr
                        : 'digital'.tr,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ),

              ]),

            ]),
          ),
          SizedBox(height: isDesktop ?  Dimensions.paddingSizeLarge : 0),
        ],
      ),


    ]);
  }
}

Widget offlineView(BuildContext context, OrderController orderController, ExpansionTileController controller, bool ongoing) {
  return ListTileTheme(
    contentPadding: const EdgeInsets.all(0),
    dense: true,
    horizontalTitleGap: 5.0,
    minLeadingWidth: 0,
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controller: controller,
        leading: Image.asset(
          Images.cash, width: 20, height: 20,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        title: Text(
          'offline_payment'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),
        trailing: Icon(!orderController.isExpanded ? Icons.expand_more : Icons.expand_less, size: 18),
        tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        onExpansionChanged: (value) => orderController.expandedUpdate(value),

        children: [
          const Divider(),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('seller_payment_info'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
            const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          orderController.trackModel!.offlinePayment != null ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.trackModel!.offlinePayment!.methodFields!.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${orderController.trackModel!.offlinePayment!.methodFields![index].inputName.toString().replaceAll('_', ' ')} : ', style: robotoRegular),
                  Text('${orderController.trackModel!.offlinePayment!.methodFields![index].inputData}', style: robotoRegular),
                ]),
              );
            },
          ) : Text('no_data_found'.tr),
          const Divider(),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('my_payment_info'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),

            (ongoing && orderController.trackModel!.offlinePayment != null && orderController.trackModel!.offlinePayment!.data!.status != 'verified') ? InkWell(
              onTap: (){
                Get.dialog(OfflineInfoEditDialogWidget(offlinePayment: orderController.trackModel!.offlinePayment!, orderId: orderController.trackModel!.id!), barrierDismissible: true);
              },
              child: Text('edit_details'.tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
            ) : const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          orderController.trackModel!.offlinePayment != null ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.trackModel!.offlinePayment!.input!.length,
            itemBuilder: (context, index){
              Input data = orderController.trackModel!.offlinePayment!.input![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${data.userInput.toString().replaceAll('_', ' ')}: ', style: robotoRegular),
                  Text(data.userData.toString(), style: robotoRegular),
                ]),
              );
            },
          ) : const SizedBox(),
          // const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      ),
    ),
  );
}

void openDialog(BuildContext context, String imageUrl) => showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Stack(children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          child: PhotoView(
            tightMode: true,
            imageProvider: NetworkImage(imageUrl),
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
          ),
        ),

        Positioned(top: 0, right: 0, child: IconButton(
          splashRadius: 5,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.cancel, color: Colors.red),
        )),

      ]),
    );
  },
);