import 'dart:async';
import 'package:photo_view/photo_view.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/confirmation_dialog.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_dialog.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/features/checkout/widgets/offline_success_dialog.dart';
import 'package:sixam_mart/features/order/widgets/cancellation_dialogue_widget.dart';
import 'package:sixam_mart/features/order/widgets/order_calcuation_widget.dart';
import 'package:sixam_mart/features/order/widgets/order_info_widget.dart';
import 'package:sixam_mart/features/review/screens/rate_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;
  final bool fromNotification;
  final bool fromOfflinePayment;
  final String? contactNumber;
  const OrderDetailsScreen({super.key, required this.orderModel, required this.orderId, this.fromNotification = false, this.fromOfflinePayment = false, this.contactNumber});

  @override
  OrderDetailsScreenState createState() => OrderDetailsScreenState();
}

class OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Timer? _timer;
  double? _maxCodOrderAmount;
  bool? _isCashOnDeliveryActive = false;
  final ScrollController scrollController = ScrollController();

  void _loadData(BuildContext context, bool reload) async {
    await Get.find<OrderController>().trackOrder(widget.orderId.toString(), reload ? null : widget.orderModel, false, contactNumber: widget.contactNumber).then((value) {
      if(widget.fromOfflinePayment) {
        Future.delayed(const Duration(seconds: 2), () => showAnimatedDialog(context, OfflineSuccessDialog(orderId: widget.orderId)));
      }
    });
    Get.find<OrderController>().timerTrackOrder(widget.orderId.toString(), contactNumber: widget.contactNumber);
    Get.find<OrderController>().getOrderDetails(widget.orderId.toString());
  }

  void _startApiCall(){
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>().timerTrackOrder(widget.orderId.toString(), contactNumber: widget.contactNumber);
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData(context, false);

    _startApiCall();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (value) async {
        if(widget.fromNotification || widget.fromOfflinePayment) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'order_details'.tr, onBackPressed: () {
          if(widget.fromNotification || widget.fromOfflinePayment) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          } else {
            Get.back();
          }
        }),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(child: GetBuilder<OrderController>(builder: (orderController) {
          double deliveryCharge = 0;
          double itemsPrice = 0;
          double discount = 0;
          double couponDiscount = 0;
          double tax = 0;
          double addOns = 0;
          double dmTips = 0;
          double additionalCharge = 0;
          OrderModel? order = orderController.trackModel;
          bool parcel = false;
          bool prescriptionOrder = false;
          bool taxIncluded = false;
          bool ongoing = false;
          if(orderController.orderDetails != null  && order != null) {
            parcel = order.orderType == 'parcel';
            prescriptionOrder = order.prescriptionOrder!;
            deliveryCharge = order.deliveryCharge!;
            couponDiscount = order.couponDiscountAmount!;
            discount = order.storeDiscountAmount! + order.flashAdminDiscountAmount! + order.flashStoreDiscountAmount!;
            tax = order.totalTaxAmount!;
            dmTips = order.dmTips!;
            taxIncluded = order.taxStatus!;
            additionalCharge = order.additionalCharge!;
            if(prescriptionOrder) {
              double orderAmount = order.orderAmount ?? 0;
              itemsPrice = (orderAmount + discount) - ((taxIncluded ? 0 : tax) + deliveryCharge) - dmTips - additionalCharge;
            } else{
              for(OrderDetailsModel orderDetails in orderController.orderDetails!) {
                for(AddOn addOn in orderDetails.addOns!) {
                  addOns = addOns + (addOn.price! * addOn.quantity!);
                }
                itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
              }
            }

            if(!parcel && order.store != null) {
              for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
                if(zData.id == order.store!.zoneId){
                  _isCashOnDeliveryActive = zData.cashOnDelivery;
                }
                for(Modules m in zData.modules!) {
                  if(m.id == order.store!.moduleId) {
                    _maxCodOrderAmount = m.pivot!.maximumCodOrderAmount;
                    break;
                  }
                }
              }
            }

            ongoing = (order.orderStatus != 'delivered' && order.orderStatus != 'failed'
                && order.orderStatus != 'canceled' && order.orderStatus != 'refund_requested' && order.orderStatus != 'refunded'
                && order.orderStatus != 'refund_request_canceled' );
          }
          double subTotal = itemsPrice + addOns;
          double total = itemsPrice + addOns - discount + (taxIncluded ? 0 : tax) + deliveryCharge - couponDiscount + dmTips + additionalCharge;

          return orderController.orderDetails != null && order != null && orderController.trackModel != null ? Column(children: [
            ResponsiveHelper.isDesktop(context) ? Container(
              height: 64,
              color: Theme.of(context).primaryColor.withOpacity(0.10),
              child: Center(child: Text('order_details'.tr, style: robotoMedium)),
            ) : const SizedBox(),

            Expanded(child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: FooterView(child: SizedBox(width: Dimensions.webMaxWidth, child: Column (
                children: [

                ResponsiveHelper.isDesktop(context) ?
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      flex: 6,
                      child : OrderInfoWidget(
                        order: order, ongoing: ongoing, parcel: parcel, prescriptionOrder: prescriptionOrder,
                        timerCancel : () => _timer?.cancel(), startApiCall : () =>  _startApiCall(),
                        orderController: orderController,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Expanded(
                      flex: 4,
                      child: OrderCalculationWidget(
                        orderController: orderController, order: order, ongoing: ongoing, parcel: parcel,
                        prescriptionOrder: prescriptionOrder, deliveryCharge: deliveryCharge, itemsPrice: itemsPrice,
                        discount: discount, couponDiscount: couponDiscount, tax: tax, addOns: addOns, dmTips: dmTips,
                        taxIncluded: taxIncluded, subTotal: subTotal, total: total,
                        bottomView: _bottomView(orderController, order, parcel, total),
                      ),
                    ),
                  ]) : const SizedBox(),

                  ResponsiveHelper.isDesktop(context) ? const SizedBox() : OrderInfoWidget(
                    order: order, ongoing: ongoing, parcel: parcel, prescriptionOrder: prescriptionOrder,
                    timerCancel : () => _timer?.cancel(), startApiCall : () =>  _startApiCall(),
                    orderController: orderController,
                  ),

                  ResponsiveHelper.isDesktop(context) ? const SizedBox() : OrderCalculationWidget(
                      orderController: orderController, order: order, ongoing: ongoing, parcel: parcel,
                      prescriptionOrder: prescriptionOrder, deliveryCharge: deliveryCharge, itemsPrice: itemsPrice,
                      discount: discount, couponDiscount: couponDiscount, tax: tax, addOns: addOns, dmTips: dmTips, taxIncluded: taxIncluded, subTotal: subTotal, total: total,
                      bottomView: _bottomView(orderController, order, parcel, total),
                  ),

                ],
              ))),
            )),

            ResponsiveHelper.isDesktop(context) ? const SizedBox() : _bottomView(orderController, order, parcel, total),

          ]) : const Center(child: CircularProgressIndicator());
        })),
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

  Widget _bottomView(OrderController orderController, OrderModel order, bool parcel, double totalPrice) {
    return Column(children: [
      !orderController.showCancelled ? Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Row(children: [
            ((order.orderStatus == 'pending' && order.paymentMethod != 'digital_payment') || order.orderStatus == 'accepted' || order.orderStatus == 'confirmed'
            || order.orderStatus == 'processing' || order.orderStatus == 'handover'|| order.orderStatus == 'picked_up') ? Expanded(
              child: CustomButton(
                buttonText: parcel ? 'track_delivery'.tr : 'track_order'.tr,
                margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
                onPressed: () async{
                  _timer?.cancel();
                  await Get.toNamed(RouteHelper.getOrderTrackingRoute(order.id, widget.contactNumber));
                  _startApiCall();
                },
              ),
            ) : const SizedBox(),

            (order.orderStatus == 'pending' && order.paymentStatus == 'unpaid' && order.paymentMethod == 'digital_payment' && _isCashOnDeliveryActive!) ?
            Expanded(
              child: CustomButton(
                buttonText: 'switch_to_cod'.tr,
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                onPressed: () {
                  Get.dialog(ConfirmationDialog(
                      icon: Images.warning, description: 'are_you_sure_to_switch'.tr,
                      onYesPressed: () {

                        if((((_maxCodOrderAmount != null && totalPrice < _maxCodOrderAmount!) || _maxCodOrderAmount == null || _maxCodOrderAmount == 0) && !parcel) || parcel){
                          orderController.switchToCOD(order.id.toString());
                        }else{
                          if(Get.isDialogOpen!) {
                            Get.back();
                          }
                          showCustomSnackBar('${'you_cant_order_more_then'.tr} ${PriceConverter.convertPrice(_maxCodOrderAmount)} ${'in_cash_on_delivery'.tr}');
                        }
                      }
                  ));
                },
              ),
            ): const SizedBox(),

            order.orderStatus == 'pending' ? const SizedBox(width: Dimensions.paddingSizeSmall) : const SizedBox(),

            order.orderStatus == 'pending' ? Expanded(child: Padding(
              padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(1, 50), shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault), side: BorderSide(width: 2, color: Theme.of(context).disabledColor),
                )),
                onPressed: () {
                  orderController.setOrderCancelReason('');
                  Get.dialog(CancellationDialogueWidget(orderId: order.id));
                },
                child: Text(parcel ? 'cancel_delivery'.tr : 'cancel_order'.tr, style: robotoBold.copyWith(
                  color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeLarge,
                )),
              ),
            )) : const SizedBox(),

          ]),
        ),
      ) : Center(
        child: Container(
          width: Dimensions.webMaxWidth,
          height: 50,
          margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: Text('order_cancelled'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
        ),
      ),

      !AuthHelper.isGuestLoggedIn() && (order.orderStatus == 'delivered' && (parcel ? order.deliveryMan != null : (orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemCampaignId == null))) ? Center(
        child: Container(
          width: Dimensions.webMaxWidth,
          padding: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CustomButton(
            buttonText: 'review'.tr,
            onPressed: () {
              List<OrderDetailsModel> orderDetailsList = [];
              List<int?> orderDetailsIdList = [];
              for (var orderDetail in orderController.orderDetails!) {
                if(!orderDetailsIdList.contains(orderDetail.itemDetails!.id)) {
                  orderDetailsList.add(orderDetail);
                  orderDetailsIdList.add(orderDetail.itemDetails!.id);
                }
              }
              Get.toNamed(RouteHelper.getReviewRoute(), arguments: RateReviewScreen(
                orderDetailsList: orderDetailsList, deliveryMan: order.deliveryMan, orderID: order.id,
              ));
            },
          ),
        ),
      ) : const SizedBox(),

      (order.orderStatus == 'failed' && Get.find<SplashController>().configModel!.cashOnDelivery!) ? Center(
        child: Container(
          width: Dimensions.webMaxWidth,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CustomButton(
            buttonText: 'switch_to_cash_on_delivery'.tr,
            onPressed: () {
              Get.dialog(ConfirmationDialog(
                  icon: Images.warning, description: 'are_you_sure_to_switch'.tr,
                  onYesPressed: () {
                    orderController.switchToCOD(order.id.toString()).then((isSuccess) {
                      Get.back();
                      if(isSuccess) {
                        Get.back();
                      }
                    });
                  }
              ));
            },
          ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
