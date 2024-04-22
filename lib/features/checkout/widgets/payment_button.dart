import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final Function onTap;
  const PaymentButton({super.key, required this.isSelected, required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                leading: Image.asset(
                  icon, width: 30, height: 30,
                  color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                ),
                title: Text(
                  title,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
                subtitle: Text(
                  subtitle,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            Positioned(
              top: 0, bottom: 0, right: 5,
              child: isSelected ? Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              ) : const SizedBox(),
            ),

          ],
        ),
      ),
    );
  }
}
