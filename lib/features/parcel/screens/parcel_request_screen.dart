import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/features/parcel/domain/models/parcel_category_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/not_logged_in_screen.dart';
import 'package:sixam_mart/features/checkout/widgets/condition_check_box.dart';
import 'package:sixam_mart/features/payment/widgets/offline_payment_button.dart';
import 'package:sixam_mart/features/checkout/widgets/payment_button.dart';
import 'package:sixam_mart/features/checkout/widgets/tips_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/card_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/delivery_instruction_bottom_sheet_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/details_widget.dart';

class ParcelRequestScreen extends StatefulWidget {
  final ParcelCategoryModel parcelCategory;
  final AddressModel pickedUpAddress;
  final AddressModel destinationAddress;
  const ParcelRequestScreen({super.key, required this.parcelCategory, required this.pickedUpAddress, required this.destinationAddress});

  @override
  State<ParcelRequestScreen> createState() => _ParcelRequestScreenState();
}

class _ParcelRequestScreenState extends State<ParcelRequestScreen> {
  final TextEditingController _tipController = TextEditingController();
  bool _isLoggedIn = AuthHelper.isLoggedIn();
  bool? _isCashOnDeliveryActive = false;
  bool? _isDigitalPaymentActive = false;
  bool canCheckSmall = false;
  final JustTheController tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall(){

    Get.find<ParcelController>().getOfflineMethodList();
    Get.find<ParcelController>().getDmTipMostTapped();
    Get.find<ParcelController>().setPaymentIndex(-1, false);
    Get.find<ParcelController>().getDistance(widget.pickedUpAddress, widget.destinationAddress);
    Get.find<ParcelController>().setPayerIndex(0, false);
    Get.find<ParcelController>().startLoader(false, canUpdate: false);
      for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!){
        if(zData.id == AddressHelper.getUserAddressFromSharedPref()!.zoneId){
          _isCashOnDeliveryActive = zData.cashOnDelivery! && Get.find<SplashController>().configModel!.cashOnDelivery!;
          _isDigitalPaymentActive = zData.digitalPayment! && Get.find<SplashController>().configModel!.digitalPayment!;

        }
      }
      if (Get.find<ProfileController>().userInfoModel == null && _isLoggedIn) {
        Get.find<ProfileController>().getUserInfo();
      }
      Get.find<ParcelController>().updateTips(
        Get.find<AuthController>().getDmTipIndex().isNotEmpty ? int.parse(Get.find<AuthController>().getDmTipIndex()) : 0, notify: false,
      );

    Get.find<ParcelController>().setInstructionselectedIndex(-1, notify: false);
    Get.find<ParcelController>().setCustomNoteController('', notify: false);
    Get.find<ParcelController>().setselectedIndex(-1);
    Get.find<ParcelController>().setCustomNote('');
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = AuthHelper.isLoggedIn();
    bool isGuestLoggedIn = AuthHelper.isGuestLoggedIn();
    bool guestCheckoutPermission = AuthHelper.isGuestLoggedIn() && Get.find<SplashController>().configModel!.guestCheckoutStatus!;
    return Scaffold(
      appBar: CustomAppBar(title: 'parcel_request'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: guestCheckoutPermission || _isLoggedIn ? GetBuilder<ParcelController>(builder: (parcelController) {
          double charge = -1;
          double total = 0;
          double dmTips = 0;
          double additionalCharge =  Get.find<SplashController>().configModel!.additionalChargeStatus! ? Get.find<SplashController>().configModel!.additionCharge! : 0;
          bool isOfflinePaymentActive = Get.find<SplashController>().configModel!.offlinePaymentStatus!/* && CheckoutHelper.checkZoneOfflinePaymentOnOff(addressModel: AddressHelper.getUserAddressFromSharedPref())*/;

          if(parcelController.distance != -1 && parcelController.extraCharge != null) {
            charge = _calculateParcelDeliveryCharge(parcelController: parcelController, parcelCategory: widget.parcelCategory, zoneId: widget.pickedUpAddress.zoneId!);
            dmTips = parcelController.tips;
            total = charge + dmTips + additionalCharge;
          }


          return Column(children: [

            Expanded(child: SingleChildScrollView(
              padding: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: FooterView(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ResponsiveHelper.isDesktop(context) ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

                DottedBorder(
                  color: Theme.of(context).disabledColor,
                  strokeWidth: 1.5,
                  dashPattern: const [5, 5],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(Dimensions.radiusDefault),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: CustomImage(
                          image: '${Get.find<SplashController>().configModel!.baseUrls!.parcelCategoryImageUrl}'
                              '/${widget.parcelCategory.image}',
                          height: 60, width: 60,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(widget.parcelCategory.name!, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(
                          widget.parcelCategory.description!, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                        ),
                      ])),

                    ]),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CardWidget(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  DetailsWidget(title: 'sender_details'.tr, address: widget.pickedUpAddress),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  DetailsWidget(title: 'receiver_details'.tr, address: widget.destinationAddress),
                ])),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CardWidget(child: Row(children: [
                  Expanded(child: Row(children: [
                    Image.asset(Images.distance, height: 30, width: 30),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('distance'.tr, style: robotoRegular),
                      Text(
                        parcelController.distance == -1 ? 'calculating'.tr : '${parcelController.distance!.toStringAsFixed(2)} ${'km'.tr}',
                        style: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ]),
                  ])),
                  Expanded(child: Row(children: [
                    Image.asset(Images.delivery, height: 30, width: 30),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('delivery_fee'.tr, style: robotoRegular),
                      Text(
                        parcelController.distance == -1 ? 'calculating'.tr : PriceConverter.convertPrice(charge),
                        style: robotoBold.copyWith(color: Theme.of(context).primaryColor), textDirection: TextDirection.ltr,
                      ),
                    ]),
                  ]))
                ])),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                CardWidget(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text("add_more_delivery_instruction".tr, style: robotoMedium),

                        InkWell(
                          onTap: () {
                            !ResponsiveHelper.isDesktop(context) ? Get.bottomSheet(
                              const DeliveryInstructionBottomSheetWidget(),
                              backgroundColor: Colors.transparent, isScrollControlled: true,
                            ) : showDialog(context: context,
                              builder: (context) {
                                return const Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusDefault))),
                                  child: DeliveryInstructionBottomSheetWidget(),
                                );
                              },
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                            child: Icon(CupertinoIcons.add, size: 20),
                          ),
                        ),
                      ]),
                      SizedBox(height: parcelController.selectedIndexNote != -1 || parcelController.customNote!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                      (parcelController.selectedIndexNote != -1 || parcelController.customNote!.isNotEmpty) ? Row(children: [

                        Image.asset(Images.parcelInstructionIcon, height: 30, width: 30),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Flexible(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

                            parcelController.selectedIndexNote != -1 ? Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    parcelController.parcelInstructionList![parcelController.selectedIndexNote!].instruction ?? '',
                                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                InkWell(
                                  onTap: () {
                                    parcelController.setInstructionselectedIndex(-1, notify: false);
                                    parcelController.setCustomNoteController('');
                                    Get.find<ParcelController>().setselectedIndex(-1);
                                    Get.find<ParcelController>().setCustomNote('');
                                  },
                                  child: Icon(Icons.clear, color: Theme.of(context).disabledColor, size: 20),
                                ),
                              ],
                            ) : const SizedBox(),

                            parcelController.customNote!.isNotEmpty ? Text(
                              parcelController.customNote ?? '',
                              style: robotoMedium.copyWith(color: Theme.of(context).disabledColor),
                            ) : const SizedBox(),

                          ]),
                        ),
                      ]) : const SizedBox(),

                    ]),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                (Get.find<SplashController>().configModel!.dmTipsStatus == 1) ? Container(
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text('delivery_man_tips'.tr, style: robotoMedium),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    SizedBox(
                      height: (parcelController.selectedTips == AppConstants.tips.length-1) && parcelController.canShowTipsField ? 0 : 60,
                      child: (parcelController.selectedTips == AppConstants.tips.length-1) && parcelController.canShowTipsField ? const SizedBox() : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: AppConstants.tips.length,
                        itemBuilder: (context, index) {
                          return TipsWidget(
                            title: AppConstants.tips[index] == '0' ? 'not_now'.tr : (index != AppConstants.tips.length -1)
                                ? PriceConverter.convertPrice(double.parse(AppConstants.tips[index].toString()), forDM: true)
                                : AppConstants.tips[index].tr,
                            isSelected: parcelController.selectedTips == index,
                            isSuggested: index != 0 && AppConstants.tips[index] == parcelController.mostDmTipAmount.toString(),
                            onTap: () {
                              parcelController.updateTips(index);
                              if(parcelController.selectedTips != 0 && parcelController.selectedTips != AppConstants.tips.length-1){
                                parcelController.addTips(double.parse(AppConstants.tips[index]));
                              }
                              if(parcelController.selectedTips == AppConstants.tips.length-1){
                                parcelController.showTipsField();
                              }
                              _tipController.text = parcelController.tips.toString();
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: (parcelController.selectedTips == AppConstants.tips.length-1) && parcelController.canShowTipsField ? Dimensions.paddingSizeExtraSmall : 0),

                    parcelController.selectedTips == AppConstants.tips.length-1 ? const SizedBox() : ListTile(
                      onTap: () => parcelController.toggleDmTipSave(),
                      leading: Checkbox(
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        activeColor: Theme.of(context).primaryColor,
                        value: parcelController.isDmTipSave,
                        onChanged: (bool? isChecked) => parcelController.toggleDmTipSave(),
                      ),
                      title: Text('save_for_later'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      horizontalTitleGap: 0,
                    ),
                    SizedBox(height: parcelController.selectedTips == AppConstants.tips.length-1 ? Dimensions.paddingSizeDefault : 0),

                    parcelController.selectedTips == AppConstants.tips.length-1 ? Row(children: [
                      Expanded(
                        child: CustomTextField(
                          titleText: 'enter_amount'.tr,
                          controller: _tipController,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.number,
                          onSubmit: (value) {
                            if(value.isNotEmpty){
                              if(double.parse(value) >= 0) {
                                parcelController.addTips(double.parse(value));
                              }else {
                                showCustomSnackBar('tips_can_not_be_negative'.tr);
                              }
                            }else{
                              parcelController.addTips(0.0);
                            }
                          },
                          onChanged: (String value) {
                            if(value.isNotEmpty) {
                              if(double.parse(value) >= 0) {
                                parcelController.addTips(double.parse(value));
                              }else{
                                showCustomSnackBar('tips_can_not_be_negative'.tr);
                              }
                            }else{
                              parcelController.addTips(0.0);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      InkWell(
                        onTap: (){
                          parcelController.updateTips(0);
                          parcelController.showTipsField();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor.withOpacity(0.5),
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: const Icon(Icons.clear),
                        ),
                      ),

                    ]) : const SizedBox(),

                  ]),
                ) : const SizedBox.shrink(),
                SizedBox(height: (Get.find<SplashController>().configModel!.dmTipsStatus == 1) ? Dimensions.paddingSizeExtraSmall : 0),

                Text('charge_pay_by'.tr, style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Row(children: [
                  Expanded(child: InkWell(
                    onTap: () => parcelController.setPayerIndex(0, true),
                    child: Row(children: [
                      Radio<String>(
                        value: parcelController.payerTypes[0],
                        groupValue: parcelController.payerTypes[parcelController.payerIndex],
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (String? payerType) => parcelController.setPayerIndex(0, true),
                      ),
                      Text(parcelController.payerTypes[0].tr, style: robotoRegular),
                    ]),
                  )),
                  _isCashOnDeliveryActive! ? Expanded(child: InkWell(
                    onTap: () => parcelController.setPayerIndex(1, true),
                    child: Row(children: [
                      Radio<String>(
                        value: parcelController.payerTypes[1],
                        groupValue: parcelController.payerTypes[parcelController.payerIndex],
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (String? payerType) => parcelController.setPayerIndex(1, true),
                      ),
                      Text(parcelController.payerTypes[1].tr, style: robotoRegular),
                    ]),
                  )) : const SizedBox(),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  _isCashOnDeliveryActive! ? Expanded(
                    child: PaymentButton(
                      icon: Images.cashOnDelivery,
                      title: 'cash_on_delivery'.tr,
                      subtitle: 'pay_your_payment_after_getting_item'.tr,
                      isSelected: parcelController.paymentIndex == 0,
                      onTap: () => parcelController.setPaymentIndex(0, true),
                    ),
                  ) : const SizedBox(),
                  SizedBox(width: (Get.find<SplashController>().configModel!.customerWalletStatus == 1 && parcelController.payerIndex == 0 && !isGuestLoggedIn) ? Dimensions.paddingSizeLarge : 0),

                  (Get.find<SplashController>().configModel!.customerWalletStatus == 1 && parcelController.payerIndex == 0 && !isGuestLoggedIn) ? Expanded(
                    child: PaymentButton(
                      icon: Images.wallet,
                      title: 'wallet_payment'.tr,
                      subtitle: 'pay_from_your_existing_balance'.tr,
                      isSelected: parcelController.paymentIndex == 1,
                      onTap: () => parcelController.setPaymentIndex(1, true),
                    ),
                  ) : const SizedBox(),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                (_isDigitalPaymentActive! && parcelController.payerIndex == 0) ? Column(children: [
                  Row(children: [
                    Text('pay_via_online'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    Text(
                      'faster_and_secure_way_to_pay_bill'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  ListView.builder(
                      itemCount: Get.find<SplashController>().configModel!.activePaymentMethodList!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        bool isSelected = parcelController.paymentIndex == 2 && Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == parcelController.digitalPaymentName;
                        return InkWell(
                          onTap: (){
                            parcelController.setPaymentIndex(2, true);
                            parcelController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.transparent,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                            child: Row(children: [
                              Container(
                                height: 20, width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                    border: Border.all(color: Theme.of(context).disabledColor)
                                ),
                                child: Icon(Icons.check, color: Theme.of(context).cardColor, size: 16),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeDefault),

                              CustomImage(
                                height: 20, fit: BoxFit.contain,
                                image: '${Get.find<SplashController>().configModel!.baseUrls!.gatewayImageUrl}/${Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayImage!}',
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Text(
                                Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayTitle!,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                              ),
                            ]),
                          ),
                        );
                      }),

                ]) : const SizedBox(),

                parcelController.offlineMethodList != null && parcelController.payerIndex == 0 ? OfflinePaymentButton(
                  isSelected: parcelController.paymentIndex == 3,
                  offlineMethodList: parcelController.offlineMethodList!,
                  isOfflinePaymentActive: isOfflinePaymentActive,
                  onTap: () {
                    parcelController.setPaymentIndex(3, true);
                  },
                  parcelController: parcelController,
                  forParcel: true, checkoutController: Get.find<CheckoutController>(), tooltipController: tooltipController,
                ) : const SizedBox(),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('order_summary'.tr, style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('delivery_fee'.tr, style: robotoRegular),
                  Text(
                    parcelController.distance == -1 ? 'calculating'.tr : PriceConverter.convertPrice(charge),
                    style: robotoRegular.copyWith(color: parcelController.distance == -1 ? Colors.red : Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                ]),
                SizedBox(height: Get.find<SplashController>().configModel!.dmTipsStatus == 1 ? Dimensions.paddingSizeSmall : 0.0),

                (Get.find<SplashController>().configModel!.dmTipsStatus == 1) ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('delivery_man_tips'.tr, style: robotoRegular),
                    Text('(+) ${PriceConverter.convertPrice(dmTips)}', style: robotoRegular, textDirection: TextDirection.ltr),
                  ],
                ) : const SizedBox.shrink(),
                SizedBox(height: Get.find<SplashController>().configModel!.additionalChargeStatus! ? Dimensions.paddingSizeSmall : 0),

                Get.find<SplashController>().configModel!.additionalChargeStatus! ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: robotoRegular),
                  Text(
                    '(+) ${PriceConverter.convertPrice(Get.find<SplashController>().configModel!.additionCharge)}',
                    style: robotoRegular, textDirection: TextDirection.ltr,
                  ),
                ]) : const SizedBox(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
                ),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('total_amount'.tr, style: robotoMedium),
                  PriceConverter.convertAnimationPrice(total, textStyle: robotoMedium),
                ]),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                const CheckoutCondition(isParcel: true),

                SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
                ResponsiveHelper.isDesktop(context) ? _bottomButton(parcelController, total) : const SizedBox(),

              ]))),
            )),

            ResponsiveHelper.isDesktop(context) ? const SizedBox() : _bottomButton(parcelController, total),

          ]);
        }) : NotLoggedInScreen(callBack: (value){
          initCall();
          setState(() {});
        }),
      ),
    );
  }

  Widget _bottomButton(ParcelController parcelController, double charge) {

    bool isInstructionSelected = parcelController.selectedIndexNote != -1;
    bool isCustomNote = parcelController.customNote!.isNotEmpty;

    return CustomButton(
      buttonText: 'confirm_parcel_request'.tr,
      isLoading: parcelController.isLoading,
      margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
      onPressed: parcelController.acceptTerms ? () {
        if(parcelController.distance == -1) {
          showCustomSnackBar('delivery_fee_not_set_yet'.tr);
        }else if(parcelController.tips < 0) {
          showCustomSnackBar('tips_can_not_be_negative'.tr);
        }else if(parcelController.paymentIndex == -1) {
          showCustomSnackBar('please_select_payment_method_first'.tr);
        }else {

          PlaceOrderBodyModel placeOrderBody = PlaceOrderBodyModel(
            cart: [], couponDiscountAmount: null, distance: parcelController.distance, scheduleAt: null,
            orderAmount: charge, orderNote: '', orderType: 'parcel', receiverDetails: widget.destinationAddress,
            paymentMethod: parcelController.paymentIndex == 0 ? 'cash_on_delivery'
                : parcelController.paymentIndex == 1 ? 'wallet'
                : parcelController.paymentIndex == 2 ? 'digital_payment' : 'offline_payment',
            couponCode: null, storeId: null, address: widget.pickedUpAddress.address, latitude: widget.pickedUpAddress.latitude,
            longitude: widget.pickedUpAddress.longitude, senderZoneId: widget.pickedUpAddress.zoneId,
            addressType: widget.pickedUpAddress.addressType,
            contactPersonName: widget.pickedUpAddress.contactPersonName ?? '',
            contactPersonNumber: widget.pickedUpAddress.contactPersonNumber ?? '',
            streetNumber: widget.pickedUpAddress.streetNumber ?? '', house: widget.pickedUpAddress.house ?? '',
            floor: widget.pickedUpAddress.floor ?? '',
            discountAmount: 0, taxAmount: 0, parcelCategoryId: widget.parcelCategory.id.toString(),
            chargePayer: parcelController.payerTypes[parcelController.payerIndex], dmTips: parcelController.tips.toString(),
            cutlery: 0, unavailableItemNote: '',
            deliveryInstruction: (isInstructionSelected ? '${parcelController.parcelInstructionList![parcelController.selectedIndexNote!].instruction}' : '') + (isInstructionSelected ? (isCustomNote ? " (${parcelController.customNote})" : '') : (isCustomNote ? parcelController.customNote ?? '' : '')),
            partialPayment: 0, guestId: AuthHelper.isGuestLoggedIn() ? int.parse(AuthHelper.getGuestId()) : 0, isBuyNow: 0, guestEmail: null,
          );

          if(parcelController.paymentIndex == 3) {
            Get.toNamed(RouteHelper.getOfflinePaymentScreen(placeOrderBody: placeOrderBody, zoneId: widget.pickedUpAddress.zoneId, total: charge, maxCodOrderAmount: 0, fromCart: false, isCodActive: false, forParcel: true));
          } else {
            parcelController.startLoader(true);
            parcelController.placeOrder(placeOrderBody, widget.pickedUpAddress.zoneId, 0, 0, false, false, forParcel: true);
          }
        }
      } : null,
    );
  }

  double _calculateParcelDeliveryCharge({required ParcelController parcelController, required ParcelCategoryModel parcelCategory, required int zoneId}) {
    double charge = 0;
    ZoneData? zoneData;
    for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      if(zData.id == zoneId) {
        zoneData = zData;
      }
    }

    if(parcelController.distance != -1 && parcelController.extraCharge != null) {
      double parcelPerKmShippingCharge = parcelCategory.parcelPerKmShippingCharge! > 0
          ? parcelCategory.parcelPerKmShippingCharge!
          : Get.find<SplashController>().configModel!.parcelPerKmShippingCharge!;
      double parcelMinimumShippingCharge = parcelCategory.parcelMinimumShippingCharge! > 0
          ? parcelCategory.parcelMinimumShippingCharge!
          : Get.find<SplashController>().configModel!.parcelMinimumShippingCharge!;
      charge = parcelController.distance! * parcelPerKmShippingCharge;
      if (charge < parcelMinimumShippingCharge) {
        charge = parcelMinimumShippingCharge;
      }

      if (parcelController.extraCharge != null) {
        charge = charge + parcelController.extraCharge!;
      }

      if (zoneData != null && zoneData.increaseDeliveryFeeStatus == 1) {
        charge = charge + (charge * (zoneData.increaseDeliveryFee! / 100));
      }
    }

    return PriceConverter.toFixed(charge);
  }

}
