import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/notification_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';

class NotificationPopUpDialogWidget extends StatefulWidget {
  final PayloadModel payloadModel;
  const NotificationPopUpDialogWidget(this.payloadModel, {super.key});

  @override
  State<NotificationPopUpDialogWidget> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NotificationPopUpDialogWidget> {

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  void _startAlarm() async {
    AudioPlayer audio = AudioPlayer();
    audio.play(AssetSource('notification.wav'));
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      //insetPadding: EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Icon(Icons.notifications_active, size: 60, color: Theme.of(context).primaryColor),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
                '${widget.payloadModel.title} ${widget.payloadModel.orderId != '' ? '(${widget.payloadModel.orderId})': ''}',
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              children: [
                Text(
                  widget.payloadModel.body!, textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                if(widget.payloadModel.image != 'null')
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                if(widget.payloadModel.image != 'null')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage.assetNetwork(
                      image: widget.payloadModel.image!,
                      height: 100,
                      width: 500,
                      placeholder: Images.placeholder,
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 70, width: 80, fit: BoxFit.cover),
                    ),
                  ),


              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            Flexible(
              child: SizedBox(width: 120, height: 40,child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                ),
                child: Text(
                  'cancel'.tr, textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              )),
            ),


            const SizedBox(width: 20),

            if(widget.payloadModel.orderId != null || widget.payloadModel.type == 'message') Flexible(
              child: SizedBox(
                width: 120,
                height: 40,
                child: CustomButton(
                  buttonText: 'go'.tr,
                  onPressed: () {
                    Get.back();

                    try{
                      if(widget.payloadModel.orderId == null
                          ||  widget.payloadModel.orderId == ''
                          || widget.payloadModel.orderId == 'null'
                      ) {
                        // RouteHelper.getChatRoute(notificationBody: notificationBody)
                         debugPrint('gh to to chat screen');
                      }else{
                        Get.toNamed(RouteHelper.getOrderDetailsRoute(int.tryParse(widget.payloadModel.orderId!)));
                      }

                    }catch (e) {
                      debugPrint('error ===> $e');
                    }

                  },
                ),
              ),
            ),

          ]),

        ]),
      ),
    );
  }
}
