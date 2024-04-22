import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class RideAddressInfo extends StatelessWidget {
  final String? title;
  final String subTitle;
  final bool isInsideCity;

  const RideAddressInfo({super.key, required this.title, required this.isInsideCity, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 1, overflow: TextOverflow.ellipsis),

        Text(subTitle, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall))
      ],
    );
  }
}
