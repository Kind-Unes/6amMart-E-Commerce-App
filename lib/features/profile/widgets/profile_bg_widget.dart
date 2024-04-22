import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileBgWidget extends StatelessWidget {
  final Widget circularImage;
  final Widget mainWidget;
  final bool backButton;
  const ProfileBgWidget({super.key, required this.mainWidget, required this.circularImage, required this.backButton});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Stack(clipBehavior: Clip.none, children: [

        Center(
          child: Container(
            width: Dimensions.webMaxWidth, height: 170,
            color: Theme.of(context).primaryColor,
          ),
        ),

        SizedBox(
          width: context.width, height: 160,
          child: Center(child: Image.asset(Images.profileBg, height: 260, width: Dimensions.webMaxWidth, fit: BoxFit.fill)),
        ),

        Positioned(
          top: 125, left: 0, right: 0, bottom: 0,
          child: Center(
            child: Container(
              width: Dimensions.webMaxWidth,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top+10, left: 0, right: 0,
          child: Text(
            'profile'.tr, textAlign: TextAlign.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
          ),
        ),

        backButton ? Positioned(
          top: MediaQuery.of(context).padding.top,
          left: Get.find<LocalizationController>().isLtr ? 10 : null,
          right: Get.find<LocalizationController>().isLtr ? null : 10,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).cardColor, size: 20),
            onPressed: () => Get.back(),
          ),
        ) : const SizedBox(),

        Positioned(
          top: 80, left: 0, right: 0,
          child: circularImage,
        ),

      ]),

      Expanded(
        child: mainWidget,
      ),

    ]);
  }
}
