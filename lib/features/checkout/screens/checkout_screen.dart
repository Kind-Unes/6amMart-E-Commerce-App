import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart/common/widgets/address_widget.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/coupon/controllers/coupon_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/common/models/config_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_dropdown.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/not_logged_in_screen.dart';
import 'package:sixam_mart/features/checkout/widgets/checkout_screen_shimmer_view.dart';
import 'package:sixam_mart/features/checkout/widgets/payment_method_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/checkout/widgets/bottom_section.dart';
import 'package:sixam_mart/features/checkout/widgets/top_section.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel?>? cartList;
  final bool fromCart;
  final int? storeId;
  const CheckoutScreen({super.key, required this.fromCart, required this.cartList, required this.storeId});

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {

  final ScrollController _scrollController = ScrollController();
  final JustTheController tooltipController1 = JustTheController();
  final JustTheController tooltipController2 = JustTheController();
  final JustTheController tooltipController3 = JustTheController();

  double? _taxPercent = 0;
  bool? _isCashOnDeliveryActive = false;
  bool? _isDigitalPaymentActive = false;
  bool _isOfflinePaymentActive = false;
  List<CartModel?>? _cartList;
  bool _isWalletActive = false;

  List<AddressModel> address = [];
  bool canCheckSmall = false;

  final TextEditingController guestContactPersonNameController = TextEditingController();
  final TextEditingController guestContactPersonNumberController = TextEditingController();
  final TextEditingController guestEmailController = TextEditingController();
  final FocusNode guestNumberNode = FocusNode();
  final FocusNode guestEmailNode = FocusNode();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  Future<void> initCall() async {
      bool isLoggedIn = AuthHelper.isLoggedIn();
      Get.find<CheckoutController>().setGuestAddress(null, isUpdate: false);
      Get.find<CheckoutController>().streetNumberController.text = AddressHelper.getUserAddressFromSharedPref()!.streetNumber ?? '';
      Get.find<CheckoutController>().houseController.text = AddressHelper.getUserAddressFromSharedPref()!.house ?? '';
      Get.find<CheckoutController>().floorController.text = AddressHelper.getUserAddressFromSharedPref()!.floor ?? '';
      Get.find<CheckoutController>().couponController.text = '';

      Get.find<CheckoutController>().getDmTipMostTapped();
      Get.find<CheckoutController>().setPreferenceTimeForView('', isUpdate: false);

      Get.find<CheckoutController>().getOfflineMethodList();

      if(Get.find<CheckoutController>().isPartialPay){
        Get.find<CheckoutController>().changePartialPayment(isUpdate: false);
      }

      if(isLoggedIn) {
        if(Get.find<ProfileController>().userInfoModel == null) {
          Get.find<ProfileController>().getUserInfo();
        }

        Get.find<CouponController>().getCouponList();

        if(Get.find<AddressController>().addressList == null) {
          Get.find<AddressController>().getAddressList();
        }
      }

      if(widget.storeId == null){
        _cartList = [];
        if(GetPlatform.isWeb) {
         await Get.find<CartController>().getCartDataOnline();
        }
        widget.fromCart ? _cartList!.addAll(Get.find<CartController>().cartList) : _cartList!.addAll(widget.cartList!);
        if(_cartList != null && _cartList!.isNotEmpty) {
          Get.find<CheckoutController>().initCheckoutData(_cartList![0]!.item!.storeId);
        }
      }
      if(widget.storeId != null){
        Get.find<CheckoutController>().initCheckoutData(widget.storeId);
        Get.find<CheckoutController>().pickPrescriptionImage(isRemove: true, isCamera: false);
        Get.find<CouponController>().removeCouponData(false);
      }
      _isWalletActive = Get.find<SplashController>().configModel!.customerWalletStatus == 1;
      Get.find<CheckoutController>().updateTips(
        Get.find<CheckoutController>().getSharedPrefDmTipIndex().isNotEmpty ? int.parse(Get.find<CheckoutController>().getSharedPrefDmTipIndex()) : 0,
        notify: false,
      );
      Get.find<CheckoutController>().tipController.text = Get.find<CheckoutController>().selectedTips != -1 ? AppConstants.tips[Get.find<CheckoutController>().selectedTips] : '';

  }

  @override
  void dispose() {
    super.dispose();

    guestContactPersonNameController.dispose();
    guestContactPersonNumberController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Module? module = Get.find<SplashController>().configModel!.moduleConfig!.module;
    bool guestCheckoutPermission = AuthHelper.isGuestLoggedIn() && Get.find<SplashController>().configModel!.guestCheckoutStatus!;

    return Scaffold(
      appBar: CustomAppBar(title: 'checkout'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: guestCheckoutPermission || AuthHelper.isLoggedIn() ? GetBuilder<CheckoutController>(builder: (checkoutController) {

        List<DropdownItem<int>> addressList = _getDropdownAddressList(context: context, addressList: Get.find<AddressController>().addressList, store: checkoutController.store);
        address = _getAddressList(addressList: Get.find<AddressController>().addressList, store: checkoutController.store);

        bool todayClosed = false;
        bool tomorrowClosed = false;
        Pivot? moduleData = _getModuleData(store: checkoutController.store);
        _isCashOnDeliveryActive = _checkCODActive(store: checkoutController.store);
        _isDigitalPaymentActive = _checkDigitalPaymentActive(store: checkoutController.store);
        _isOfflinePaymentActive = Get.find<SplashController>().configModel!.offlinePaymentStatus! && _checkZoneOfflinePaymentOnOff(addressModel: AddressHelper.getUserAddressFromSharedPref());
        if(checkoutController.store != null) {
          todayClosed = checkoutController.isStoreClosed(true, checkoutController.store!.active!, checkoutController.store!.schedules);
          tomorrowClosed = checkoutController.isStoreClosed(false, checkoutController.store!.active!, checkoutController.store!.schedules);
          _taxPercent = checkoutController.store!.tax;
        }
        return GetBuilder<CouponController>(builder: (couponController) {
          double? maxCodOrderAmount;

          if(moduleData != null) {
            maxCodOrderAmount = moduleData.maximumCodOrderAmount;
          }
          double price = _calculatePrice(store: checkoutController.store, cartList: _cartList);
          double addOns = _calculateAddonsPrice(store: checkoutController.store, cartList: _cartList);
          double variations = _calculateVariationPrice(store: checkoutController.store, cartList: _cartList, calculateWithoutDiscount: true);
          double? discount = _calculateDiscount(
            store: checkoutController.store, cartList: _cartList, price: price, addOns: addOns,
          );
          double couponDiscount = PriceConverter.toFixed(couponController.discount!);
          bool taxIncluded = Get.find<SplashController>().configModel!.taxIncluded == 1;
          double orderAmount = _calculateOrderAmount(
            price: price, variations: variations, discount: discount, addOns: addOns,
            couponDiscount: couponDiscount, cartList: _cartList,
          );
          double tax = _calculateTax(
            taxIncluded: taxIncluded, orderAmount: orderAmount, taxPercent: _taxPercent,
          );
          double subTotal = _calculateSubTotal(price: price, addOns: addOns, variations: variations, cartList: _cartList);
          double additionalCharge =  Get.find<SplashController>().configModel!.additionalChargeStatus!
              ? Get.find<SplashController>().configModel!.additionCharge! : 0;
          double originalCharge = _calculateOriginalDeliveryCharge(
            store: checkoutController.store, address: AddressHelper.getUserAddressFromSharedPref()!,
            distance: checkoutController.distance, extraCharge: checkoutController.extraCharge,
          );
          double deliveryCharge = _calculateDeliveryCharge(
            store: checkoutController.store, address: AddressHelper.getUserAddressFromSharedPref()!, distance: checkoutController.distance,
            extraCharge: checkoutController.extraCharge, orderType: checkoutController.orderType!, orderAmount: orderAmount,
          );

          double total = _calculateTotal(
            subTotal: subTotal, deliveryCharge: deliveryCharge, discount: discount,
            couponDiscount: couponDiscount, taxIncluded: taxIncluded, tax: tax, orderType: checkoutController.orderType!,
            tips: checkoutController.tips, additionalCharge: additionalCharge,
          );

          if(widget.storeId != null){
            checkoutController.setPaymentMethod(0, isUpdate: false);
          }
          checkoutController.setTotalAmount(total - (checkoutController.isPartialPay ? Get.find<ProfileController>().userInfoModel!.walletBalance! : 0));

          return (checkoutController.distance != null && checkoutController.store != null) ? Column(
            children: [
              ResponsiveHelper.isDesktop(context) ? Container(
                height: 64,
                color: Theme.of(context).primaryColor.withOpacity(0.10),
                child: Center(child: Text('checkout'.tr, style: robotoMedium)),
              ) : const SizedBox(),

              Expanded(child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: FooterView(child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: ResponsiveHelper.isDesktop(context) ? Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Expanded(flex: 6, child: TopSection(
                        checkoutController: checkoutController, charge: originalCharge, deliveryCharge: deliveryCharge,
                        addressList: addressList,
                        tomorrowClosed: tomorrowClosed, todayClosed: todayClosed, module : module, price: price,
                        discount: discount, addOns: addOns, address: address, cartList: _cartList, isCashOnDeliveryActive: _isCashOnDeliveryActive!,
                        isDigitalPaymentActive: _isDigitalPaymentActive!, isWalletActive: _isWalletActive, storeId: widget.storeId,
                        total: total, isOfflinePaymentActive: _isOfflinePaymentActive, guestNameTextEditingController: guestContactPersonNameController,
                        guestNumberTextEditingController: guestContactPersonNumberController, guestNumberNode: guestNumberNode,
                        guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
                        tooltipController1: tooltipController1, tooltipController2: tooltipController2, dmTipsTooltipController: tooltipController3,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Expanded(flex: 4, child: BottomSection(
                        checkoutController: checkoutController, total: total, module: module!, subTotal: subTotal,
                        discount: discount, couponController: couponController, taxIncluded: taxIncluded, tax: tax,
                        deliveryCharge: deliveryCharge,
                        todayClosed: todayClosed, tomorrowClosed: tomorrowClosed, orderAmount: orderAmount,
                        maxCodOrderAmount: maxCodOrderAmount, storeId: widget.storeId, taxPercent: _taxPercent, price: price, addOns : addOns,
                        checkoutButton: _orderPlaceButton(
                          checkoutController, todayClosed, tomorrowClosed,
                          orderAmount, deliveryCharge, tax, discount, total, maxCodOrderAmount,
                        ),
                      )),
                    ]),
                  ) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    TopSection(
                      checkoutController: checkoutController, charge: originalCharge, deliveryCharge: deliveryCharge,
                      addressList: addressList,
                      tomorrowClosed: tomorrowClosed, todayClosed: todayClosed, module : module, price: price,
                      discount: discount, addOns: addOns, address: address, cartList: _cartList, isCashOnDeliveryActive: _isCashOnDeliveryActive!,
                      isDigitalPaymentActive: _isDigitalPaymentActive!, isWalletActive: _isWalletActive, storeId: widget.storeId,
                      total: total, isOfflinePaymentActive: _isOfflinePaymentActive, guestNameTextEditingController: guestContactPersonNameController,
                      guestNumberTextEditingController: guestContactPersonNumberController, guestNumberNode: guestNumberNode,
                      guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
                      tooltipController1: tooltipController1, tooltipController2: tooltipController2, dmTipsTooltipController: tooltipController3,
                    ),

                    BottomSection(
                      checkoutController: checkoutController, total: total, module: module!, subTotal: subTotal,
                      discount: discount, couponController: couponController, taxIncluded: taxIncluded, tax: tax,
                      deliveryCharge: deliveryCharge,
                      todayClosed: todayClosed,tomorrowClosed: tomorrowClosed, orderAmount: orderAmount,
                      maxCodOrderAmount: maxCodOrderAmount, storeId: widget.storeId, taxPercent: _taxPercent, price: price, addOns : addOns,
                      checkoutButton: _orderPlaceButton(
                        checkoutController, todayClosed, tomorrowClosed,
                        orderAmount, deliveryCharge, tax, discount, total, maxCodOrderAmount,
                      ),
                    )
                  ]),
                )),
              )),

              ResponsiveHelper.isDesktop(context) ? const SizedBox() : Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(
                          checkoutController.isPartialPay ? 'due_payment'.tr : 'total_amount'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        ),
                        PriceConverter.convertAnimationPrice(
                          checkoutController.viewTotalPrice,
                          textStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        ),
                      ]),
                    ),

                    _orderPlaceButton(
                        checkoutController, todayClosed, tomorrowClosed, orderAmount, deliveryCharge, tax, discount, total, maxCodOrderAmount
                    ),
                  ],
                ),
              ),

            ],
          ) : const CheckoutScreenShimmerView();
        });
      }) : NotLoggedInScreen(callBack: (value){
        initCall();
        setState(() {});
      }),
    );
  }


  Widget _orderPlaceButton(CheckoutController checkoutController, bool todayClosed, bool tomorrowClosed,
      double orderAmount, double? deliveryCharge, double tax, double? discount, double total, double? maxCodOrderAmount) {
    return Container(
      width: Dimensions.webMaxWidth,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
      child: SafeArea(
        child: CustomButton(
          isLoading: checkoutController.isLoading,
          buttonText: checkoutController.isPartialPay ? 'place_order'.tr : 'confirm_order'.tr,
          onPressed: checkoutController.acceptTerms ? () {
          bool isAvailable = true;
          DateTime scheduleStartDate = DateTime.now();
          DateTime scheduleEndDate = DateTime.now();
          bool isGuestLogIn = AuthHelper.isGuestLoggedIn();
          if(checkoutController.timeSlots == null || checkoutController.timeSlots!.isEmpty) {
            isAvailable = false;
          }else {
            DateTime date = checkoutController.selectedDateSlot == 0 ? DateTime.now() : DateTime.now().add(const Duration(days: 1));
            DateTime startTime = checkoutController.timeSlots![checkoutController.selectedTimeSlot].startTime!;
            DateTime endTime = checkoutController.timeSlots![checkoutController.selectedTimeSlot].endTime!;
            scheduleStartDate = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute+1);
            scheduleEndDate = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute+1);
            if(_cartList != null){
              for (CartModel? cart in _cartList!) {
                if (!DateConverter.isAvailable(
                  cart!.item!.availableTimeStarts, cart.item!.availableTimeEnds,
                  time: checkoutController.store!.scheduleOrder! ? scheduleStartDate : null,
                ) && !DateConverter.isAvailable(
                  cart.item!.availableTimeStarts, cart.item!.availableTimeEnds,
                  time: checkoutController.store!.scheduleOrder! ? scheduleEndDate : null,
                )) {
                  isAvailable = false;
                  break;
                }
              }
            }
          }

          if(isGuestLogIn && checkoutController.guestAddress == null && checkoutController.orderType != 'take_away') {
            showCustomSnackBar('please_setup_your_delivery_address_first'.tr);
          } else if(isGuestLogIn && checkoutController.orderType == 'take_away' && guestContactPersonNameController.text.isEmpty) {
            showCustomSnackBar('please_enter_contact_person_name'.tr);
          } else if(isGuestLogIn && checkoutController.orderType == 'take_away' && guestContactPersonNumberController.text.isEmpty) {
            showCustomSnackBar('please_enter_contact_person_number'.tr);
          }else if(isGuestLogIn && checkoutController.orderType == 'take_away' && guestEmailController.text.isEmpty) {
            showCustomSnackBar('please_enter_contact_person_email'.tr);
          } else if(!_isCashOnDeliveryActive! && !_isDigitalPaymentActive! && !_isWalletActive) {
            showCustomSnackBar('no_payment_method_is_enabled'.tr);
          }else if(checkoutController.paymentMethodIndex == -1) {
            if(ResponsiveHelper.isDesktop(context)){
              Get.dialog(Dialog(backgroundColor: Colors.transparent, child: PaymentMethodBottomSheet(
                isCashOnDeliveryActive: _isCashOnDeliveryActive!, isDigitalPaymentActive: _isDigitalPaymentActive!,
                isWalletActive: _isWalletActive, storeId: widget.storeId, totalPrice: total, isOfflinePaymentActive: _isOfflinePaymentActive,
              )));
            }else{
              showModalBottomSheet(
                context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                builder: (con) => PaymentMethodBottomSheet(
                  isCashOnDeliveryActive: _isCashOnDeliveryActive!, isDigitalPaymentActive: _isDigitalPaymentActive!,
                  isWalletActive: _isWalletActive, storeId: widget.storeId, totalPrice: total, isOfflinePaymentActive: _isOfflinePaymentActive,
                ),
              );
            }
          } else if(orderAmount < checkoutController.store!.minimumOrder! && widget.storeId == null) {
            showCustomSnackBar('${'minimum_order_amount_is'.tr} ${checkoutController.store!.minimumOrder}');
          }else if(checkoutController.tipController.text.isNotEmpty && checkoutController.tipController.text != 'not_now' && double.parse(checkoutController.tipController.text.trim()) < 0) {
            showCustomSnackBar('tips_can_not_be_negative'.tr);
          }else if((checkoutController.selectedDateSlot == 0 && todayClosed) || (checkoutController.selectedDateSlot == 1 && tomorrowClosed)) {
            showCustomSnackBar(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                ? 'restaurant_is_closed'.tr : 'store_is_closed'.tr);
          }else if(checkoutController.paymentMethodIndex == 0 && _isCashOnDeliveryActive! && maxCodOrderAmount != null && maxCodOrderAmount != 0 && (total > maxCodOrderAmount) && widget.storeId == null){
            showCustomSnackBar('${'you_cant_order_more_then'.tr} ${PriceConverter.convertPrice(maxCodOrderAmount)} ${'in_cash_on_delivery'.tr}');
          }else if(checkoutController.paymentMethodIndex != 0 && widget.storeId != null){
            showCustomSnackBar('payment_method_is_not_available'.tr);
          }else if (checkoutController.timeSlots == null || checkoutController.timeSlots!.isEmpty) {
            if(checkoutController.store!.scheduleOrder!) {
              showCustomSnackBar('select_a_time'.tr);
            }else {
              showCustomSnackBar(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                  ? 'restaurant_is_closed'.tr : 'store_is_closed'.tr);
            }
          }else if (!isAvailable) {
            showCustomSnackBar('one_or_more_products_are_not_available_for_this_selected_time'.tr);
          }else if (checkoutController.orderType != 'take_away' && checkoutController.distance == -1 && deliveryCharge == -1) {
            showCustomSnackBar('delivery_fee_not_set_yet'.tr);
          }else if (widget.storeId != null && checkoutController.pickedPrescriptions.isEmpty) {
            showCustomSnackBar('please_upload_your_prescription_images'.tr);
          }else if (!checkoutController.acceptTerms) {
            showCustomSnackBar('please_accept_privacy_policy_trams_conditions_refund_policy_first'.tr);
          }
          else {

            AddressModel? finalAddress = isGuestLogIn ? checkoutController.guestAddress : address[checkoutController.addressIndex!];

            if(isGuestLogIn && checkoutController.orderType == 'take_away') {
              String number = checkoutController.countryDialCode! + guestContactPersonNumberController.text;
              finalAddress = AddressModel(contactPersonName: guestContactPersonNameController.text, contactPersonNumber: number,
                address: AddressHelper.getUserAddressFromSharedPref()!.address!, latitude: AddressHelper.getUserAddressFromSharedPref()!.latitude,
                longitude: AddressHelper.getUserAddressFromSharedPref()!.longitude, zoneId: AddressHelper.getUserAddressFromSharedPref()!.zoneId,
                email: guestEmailController.text,
              );
            }

            if(!isGuestLogIn && finalAddress!.contactPersonNumber == 'null'){
              finalAddress.contactPersonNumber = Get.find<ProfileController>().userInfoModel!.phone;
            }

            if(widget.storeId == null){

              List<OnlineCart> carts = [];
              for (int index = 0; index < _cartList!.length; index++) {
                CartModel cart = _cartList![index]!;
                List<int?> addOnIdList = [];
                List<int?> addOnQtyList = [];
                for (var addOn in cart.addOnIds!) {
                  addOnIdList.add(addOn.id);
                  addOnQtyList.add(addOn.quantity);
                }

                List<OrderVariation> variations = [];
                if(Get.find<SplashController>().getModuleConfig(cart.item!.moduleType).newVariation!) {
                  for(int i=0; i<cart.item!.foodVariations!.length; i++) {
                    if(cart.foodVariations![i].contains(true)) {
                      variations.add(OrderVariation(name: cart.item!.foodVariations![i].name, values: OrderVariationValue(label: [])));
                      for(int j=0; j<cart.item!.foodVariations![i].variationValues!.length; j++) {
                        if(cart.foodVariations![i][j]!) {
                          variations[variations.length-1].values!.label!.add(cart.item!.foodVariations![i].variationValues![j].level);
                        }
                      }
                    }
                  }
                }
                carts.add(OnlineCart(
                  cart.id, cart.item!.id, cart.isCampaign! ? cart.item!.id : null,
                  cart.discountedPrice.toString(), '',
                  Get.find<SplashController>().getModuleConfig(cart.item!.moduleType).newVariation! ? null : cart.variation,
                  Get.find<SplashController>().getModuleConfig(cart.item!.moduleType).newVariation! ? variations : null,
                  cart.quantity, addOnIdList, cart.addOns, addOnQtyList, 'Item', itemType: !widget.fromCart ? "AppModelsItemCampaign" : null,
                ));
              }

              PlaceOrderBodyModel placeOrderBody = PlaceOrderBodyModel(
                cart: carts, couponDiscountAmount: Get.find<CouponController>().discount, distance: checkoutController.distance,
                scheduleAt: !checkoutController.store!.scheduleOrder! ? null : (checkoutController.selectedDateSlot == 0
                    && checkoutController.selectedTimeSlot == 0) ? null : DateConverter.dateToDateAndTime(scheduleEndDate),
                orderAmount: total, orderNote: checkoutController.noteController.text, orderType: checkoutController.orderType,
                paymentMethod: checkoutController.paymentMethodIndex == 0 ? 'cash_on_delivery'
                    : checkoutController.paymentMethodIndex == 1 ? 'wallet'
                    : checkoutController.paymentMethodIndex == 2 ? 'digital_payment' : 'offline_payment',
                couponCode: (Get.find<CouponController>().discount! > 0 || (Get.find<CouponController>().coupon != null
                    && Get.find<CouponController>().freeDelivery)) ? Get.find<CouponController>().coupon!.code : null,
                storeId: _cartList![0]!.item!.storeId,
                address: finalAddress!.address, latitude: finalAddress.latitude, longitude: finalAddress.longitude,
                senderZoneId: null, addressType: finalAddress.addressType,
                contactPersonName: finalAddress.contactPersonName ?? '${Get.find<ProfileController>().userInfoModel!.fName} '
                    '${Get.find<ProfileController>().userInfoModel!.lName}',
                contactPersonNumber: finalAddress.contactPersonNumber ?? Get.find<ProfileController>().userInfoModel!.phone,
                streetNumber: isGuestLogIn ? finalAddress.streetNumber??'' : checkoutController.streetNumberController.text.trim(),
                house: isGuestLogIn ? finalAddress.house??'' : checkoutController.houseController.text.trim(),
                floor: isGuestLogIn ? finalAddress.floor??'' : checkoutController.floorController.text.trim(),
                discountAmount: discount, taxAmount: tax, receiverDetails: null, parcelCategoryId: null,
                chargePayer: null, dmTips: (checkoutController.orderType == 'take_away' || checkoutController.tipController.text == 'not_now') ? '' : checkoutController.tipController.text.trim(),
                cutlery: Get.find<CartController>().addCutlery ? 1 : 0,
                unavailableItemNote: Get.find<CartController>().notAvailableIndex != -1 ? Get.find<CartController>().notAvailableList[Get.find<CartController>().notAvailableIndex] : '',
                deliveryInstruction: checkoutController.selectedInstruction != -1 ? AppConstants.deliveryInstructionList[checkoutController.selectedInstruction] : '',
                partialPayment: checkoutController.isPartialPay ? 1 : 0, guestId: isGuestLogIn ? int.parse(AuthHelper.getGuestId()) : 0,
                isBuyNow: widget.fromCart ? 0 : 1, guestEmail: isGuestLogIn ? finalAddress.email : null,
              );

              if(checkoutController.paymentMethodIndex == 3){
                Get.toNamed(RouteHelper.getOfflinePaymentScreen(
                  placeOrderBody: placeOrderBody, zoneId: checkoutController.store!.zoneId!, total: checkoutController.viewTotalPrice!,
                  maxCodOrderAmount: maxCodOrderAmount, fromCart: widget.fromCart, isCodActive: _isCashOnDeliveryActive, forParcel: false,
                ));
              } else {
                checkoutController.placeOrder(placeOrderBody, checkoutController.store!.zoneId, total, maxCodOrderAmount, widget.fromCart, _isCashOnDeliveryActive!);
              }
            }else{

              checkoutController.placePrescriptionOrder(widget.storeId, checkoutController.store!.zoneId, checkoutController.distance,
                  finalAddress!.address!, finalAddress.longitude!, finalAddress.latitude!, checkoutController.noteController.text,
                  checkoutController.pickedPrescriptions, (checkoutController.orderType == 'take_away' || checkoutController.tipController.text == 'not_now')
                      ? '' : checkoutController.tipController.text.trim(), checkoutController.selectedInstruction != -1
                      ? AppConstants.deliveryInstructionList[checkoutController.selectedInstruction] : '', 0, 0, widget.fromCart, _isCashOnDeliveryActive!
              );
            }

          }
        } : null),
      ),
    );
  }

  List<DropdownItem<int>> _getDropdownAddressList({required BuildContext context, required List<AddressModel>? addressList, required Store? store}) {
    List<DropdownItem<int>> dropDownAddressList = [];

    dropDownAddressList.add(DropdownItem<int>(value: 0, child: SizedBox(
      width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth - 50 : context.width - 50,
      child: AddressWidget(
        address: AddressHelper.getUserAddressFromSharedPref(),
        fromAddress: false, fromCheckout: true,
      ),
    )));

    if(addressList != null && store != null) {
      for(int index=0; index<addressList.length; index++) {
        if(addressList[index].zoneIds!.contains(store.zoneId)) {

          dropDownAddressList.add(DropdownItem<int>(value: index + 1, child: SizedBox(
            width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth-50 : context.width-50,
            child: AddressWidget(
              address: addressList[index],
              fromAddress: false, fromCheckout: true,
            ),
          )));
        }
      }
    }
    return dropDownAddressList;
  }

  List<AddressModel> _getAddressList({required List<AddressModel>? addressList, required Store? store}) {
    List<AddressModel> address = [];

    address.add(AddressHelper.getUserAddressFromSharedPref()!);

    if(addressList != null && store != null) {
      for(int index=0; index<addressList.length; index++) {
        if(addressList[index].zoneIds!.contains(store.zoneId)) {
          address.add(addressList[index]);
        }
      }
    }
    return address;
  }

  Pivot? _getModuleData({required Store? store}) {
    Pivot? moduleData;
    if(store != null) {
      for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
        for(Modules m in zData.modules!) {
          if(m.id == Get.find<SplashController>().module!.id && m.pivot!.zoneId == store.zoneId) {
            moduleData = m.pivot;
            break;
          }
        }
      }
    }
    return moduleData;
  }

  bool _checkCODActive({required Store? store}) {
    bool isCashOnDeliveryActive = false;
    if(store != null){
      for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
        if(zData.id ==  store.zoneId) {
          isCashOnDeliveryActive = zData.cashOnDelivery! && Get.find<SplashController>().configModel!.cashOnDelivery!;
        }
      }
    }
    return isCashOnDeliveryActive;
  }

  bool _checkDigitalPaymentActive({required Store? store}) {
    bool isDigitalPaymentActive = false;
    if(store != null){
      for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
        if(zData.id ==  store.zoneId) {
          isDigitalPaymentActive = zData.digitalPayment! && Get.find<SplashController>().configModel!.digitalPayment!;
        }
      }
    }
    return isDigitalPaymentActive;
  }

  double _calculatePrice({required Store? store, required List<CartModel?>? cartList}) {
    double price = 0;
    if(cartList != null) {
      for (var cartModel in cartList) {
        if(Get.find<SplashController>().getModuleConfig(cartModel!.item!.moduleType).newVariation!){
          price = price + (cartModel.item!.price! * cartModel.quantity!);
        } else {
          price = _calculateVariationPrice(store: store, cartList: cartList);
        }
      }
    }
    return PriceConverter.toFixed(price);
  }

  double _calculateAddonsPrice({required Store? store, required List<CartModel?>? cartList}) {
    double addOns = 0;
    if(store != null && cartList != null) {
      for (var cartModel in cartList) {
        List<AddOns> addOnList = [];
        for (var addOnId in cartModel!.addOnIds!) {
          for (AddOns addOns in cartModel.item!.addOns!) {
            if (addOns.id == addOnId.id) {
              addOnList.add(addOns);
              break;
            }
          }
        }
        for (int index = 0; index < addOnList.length; index++) {
          addOns = addOns + (addOnList[index].price! * cartModel.addOnIds![index].quantity!);
        }
      }
    }
    return PriceConverter.toFixed(addOns);
  }

  double _calculateVariationPrice({required Store? store, required List<CartModel?>? cartList, bool calculateDiscount = false, bool calculateWithoutDiscount = false}) {
    double variationPrice = 0;
    double variationDiscount = 0;
    if(store != null && cartList != null) {
      for (var cartModel in cartList) {
        double? discount = cartModel!.item!.storeDiscount == 0 ? cartModel.item!.discount : cartModel.item!.storeDiscount;
        String? discountType = cartModel.item!.storeDiscount == 0 ? cartModel.item!.discountType : 'percent';

        if(Get.find<SplashController>().getModuleConfig(cartModel.item!.moduleType).newVariation!) {
          for(int index = 0; index< cartModel.item!.foodVariations!.length; index++) {
            for(int i=0; i<cartModel.item!.foodVariations![index].variationValues!.length; i++) {
              if(cartModel.foodVariations![index][i]!) {
                variationPrice += (PriceConverter.convertWithDiscount(cartModel.item!.foodVariations![index].variationValues![i].optionPrice!, discount, discountType, isFoodVariation: true)! * cartModel.quantity!);
                variationDiscount += (cartModel.item!.foodVariations![index].variationValues![i].optionPrice! * cartModel.quantity!);
              }
            }
          }
        } else {

          String variationType = '';
          for(int i=0; i<cartModel.variation!.length; i++) {
            variationType = cartModel.variation![i].type!;
          }

          if(cartModel.item!.variations!.isNotEmpty) {
            for (Variation variation in cartModel.item!.variations!) {
              if (variation.type == variationType) {
                variationPrice += (variation.price! * cartModel.quantity!);
                break;
              }
            }
          } else {
            variationDiscount += (PriceConverter.convertWithDiscount(cartModel.item!.price!, discount, discountType)! * cartModel.quantity!);
            variationPrice += (cartModel.item!.price! * cartModel.quantity!);
          }

        }
      }
    }
    if(calculateDiscount) {
      return (variationDiscount - variationPrice);
    } else if(calculateWithoutDiscount) {
      return variationDiscount;
    } else {
      return variationPrice;
    }
  }

  double _calculateDiscount({required Store? store, required List<CartModel?>? cartList, required double price, required double addOns}) {
    double discount = 0;
    if (store != null && cartList != null) {
      for (var cartModel in cartList) {
        double? dis = (store.discount != null
            && DateConverter.isAvailable(store.discount!.startTime, store.discount!.endTime))
            && cartModel!.item!.flashSale != 1
            ? store.discount!.discount : cartModel!.item!.discount;
        String? disType = (store.discount != null
            && DateConverter.isAvailable(store.discount!.startTime, store.discount!.endTime))
            && cartModel.item!.flashSale != 1
            ? 'percent' : cartModel.item!.discountType;
        if(Get.find<SplashController>().getModuleConfig(cartModel.item!.moduleType).newVariation!) {
          double d = ((cartModel.item!.price! - PriceConverter.convertWithDiscount(cartModel.item!.price!, dis, disType)!) * cartModel.quantity!);
          discount = discount + d;
          if(disType == 'percent' && discount != 0) {
            discount = discount + _calculateVariationPrice(store: store, cartList: cartList, calculateDiscount: true);
          }
        } else {
          String variationType = '';
          double variationPrice = 0;
          double variationWithoutDiscountPrice = 0;
          for(int i=0; i<cartModel.variation!.length; i++) {
            variationType = cartModel.variation![i].type!;
          }
          if(cartModel.item!.variations!.isNotEmpty){
            for (Variation variation in cartModel.item!.variations!) {
              if (variation.type == variationType) {
                variationPrice += (PriceConverter.convertWithDiscount(variation.price!, dis, disType)! * cartModel.quantity!);
                variationWithoutDiscountPrice += (variation.price! * cartModel.quantity!);
                break;
              }
            }
            discount = discount + (variationWithoutDiscountPrice - variationPrice);

          } else {
            double d = ((cartModel.item!.price! - PriceConverter.convertWithDiscount(cartModel.item!.price!, dis, disType)!) * cartModel.quantity!);
            discount = discount + d;
          }

        }
      }
    }

    if (store != null && store.discount != null) {
      if (store.discount!.maxDiscount != 0 && store.discount!.maxDiscount! < discount) {
        discount = store.discount!.maxDiscount!;
      }
      if (store.discount!.minPurchase != 0 && store.discount!.minPurchase! > (price + addOns)) {
        discount = 0;
      }
    }
    return PriceConverter.toFixed(discount);
  }

  double _calculateOrderAmount({required double price, required double variations, required double discount, required double addOns, required double couponDiscount, required List<CartModel?>? cartList}) {
    double orderAmount = 0;
    double variationPrice = 0;
    if(cartList != null && cartList.isNotEmpty && Get.find<SplashController>().getModuleConfig(cartList[0]?.item?.moduleType).newVariation!){
      variationPrice = variations;
    }
    orderAmount = (price + variationPrice - discount) + addOns - couponDiscount;
    return PriceConverter.toFixed(orderAmount);
  }

  double _calculateTax({required bool taxIncluded, required double orderAmount, required double? taxPercent}) {
    double tax = 0;
    if(taxIncluded){
      tax = orderAmount * taxPercent! /(100 + taxPercent);
    }else{
      tax = PriceConverter.calculation(orderAmount, taxPercent, 'percent', 1);
    }
    return PriceConverter.toFixed(tax);
  }

  double _calculateSubTotal({required double price, required double addOns, required double variations, required List<CartModel?>? cartList}) {
    double subTotal = 0;
    bool isFoodVariation = false;

    if(cartList != null && cartList.isNotEmpty) {
      isFoodVariation = Get.find<SplashController>().getModuleConfig(cartList[0]!.item!.moduleType).newVariation!;
    }
    if(isFoodVariation){
      subTotal = price + addOns + variations;
    } else {
      subTotal = price;
    }

    return subTotal;
  }

  double _calculateOriginalDeliveryCharge({required Store? store, required AddressModel address, required double? distance, required double? extraCharge}) {
    double deliveryCharge = -1;

    Pivot? moduleData;
    ZoneData? zoneData;
    if(store != null) {
      for(ZoneData zData in address.zoneData!) {

        for(Modules m in zData.modules!) {
          if(m.id == Get.find<SplashController>().module!.id && m.pivot!.zoneId == store.zoneId) {
            moduleData = m.pivot;
            break;
          }
        }

        if(zData.id == store.zoneId) {
          zoneData = zData;
        }
      }
    }
    double perKmCharge = 0;
    double minimumCharge = 0;
    double? maximumCharge = 0;
    if(store != null && distance != null && distance != -1 && store.selfDeliverySystem == 1) {
      perKmCharge = store.perKmShippingCharge!;
      minimumCharge = store.minimumShippingCharge!;
      maximumCharge = store.maximumShippingCharge;
    }else if(store != null && distance != null && distance != -1 && moduleData != null) {
      perKmCharge = moduleData.perKmShippingCharge!;
      minimumCharge = moduleData.minimumShippingCharge!;
      maximumCharge = moduleData.maximumShippingCharge;
    }
    if(store != null && distance != null) {
      deliveryCharge = distance * perKmCharge;

      if(deliveryCharge < minimumCharge) {
        deliveryCharge = minimumCharge;
      }else if(maximumCharge != null && deliveryCharge > maximumCharge) {
        deliveryCharge = maximumCharge;
      }
    }

    if(store != null && store.selfDeliverySystem == 0 && extraCharge != null) {
      deliveryCharge = deliveryCharge + extraCharge;
    }

    if(store != null && store.selfDeliverySystem == 0 && zoneData!.increaseDeliveryFeeStatus == 1) {
      deliveryCharge = deliveryCharge + (deliveryCharge * (zoneData.increaseDeliveryFee!/100));
    }

    return deliveryCharge;
  }

  double _calculateDeliveryCharge({required Store? store, required AddressModel address, required double? distance, required double? extraCharge, required double orderAmount, required String orderType}) {
    double deliveryCharge = _calculateOriginalDeliveryCharge(store: store, address: address, distance: distance, extraCharge: extraCharge);

    if (orderType == 'take_away' || (store != null && store.freeDelivery!)
        || (Get.find<SplashController>().configModel!.freeDeliveryOver != null && orderAmount
            >= Get.find<SplashController>().configModel!.freeDeliveryOver!)
        || Get.find<CouponController>().freeDelivery || (AuthHelper.isGuestLoggedIn() && (Get.find<CheckoutController>().guestAddress == null && Get.find<CheckoutController>().orderType != 'take_away'))) {
      deliveryCharge = 0;
    }

    return PriceConverter.toFixed(deliveryCharge);
  }

  double _calculateTotal({
    required double subTotal, required double deliveryCharge, required double discount,
    required double couponDiscount, required bool taxIncluded, required double tax,
    required String orderType, required double tips, required double additionalCharge,
  }) {

    return PriceConverter.toFixed(
        subTotal + deliveryCharge - discount- couponDiscount + (taxIncluded ? 0 : tax)
            + ((orderType != 'take_away' && Get.find<SplashController>().configModel!.dmTipsStatus == 1) ? tips : 0)
            + additionalCharge
    );
  }

  bool _checkZoneOfflinePaymentOnOff({required AddressModel? addressModel}) {
    bool? status = false;
    ZoneData? zoneData;
    for (var data in addressModel!.zoneData!) {
      if(data.id == addressModel.zoneId){
        zoneData = data;
        break;
      }
    }
    status = zoneData?.offlinePayment ?? false;
    return status;
  }

}