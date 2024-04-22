import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotAvailableWidget extends StatelessWidget {
  final double fontSize;
  final bool isStore;
  final bool isAllSideRound;
  final double? radius;
  const NotAvailableWidget({super.key, this.fontSize = 12, this.isStore = false, this.isAllSideRound = true, this.radius = Dimensions.radiusSmall});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, left: 0, bottom: 0, right: 0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: isAllSideRound ? BorderRadius.circular(radius!) :  BorderRadius.vertical(top: Radius.circular(radius!)), color: Colors.black.withOpacity(0.6)),
        child: Text(
          isStore ? 'closed_now'.tr : 'not_available_now_break'.tr, textAlign: TextAlign.center,
          style: robotoMedium.copyWith(color: Colors.white, fontSize: fontSize),
        ),
      ),
    );
  }
}
