import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';

class RippleButton extends StatelessWidget {
  const RippleButton({super.key, required this.onTap, this.radius = Dimensions.radiusDefault});
  final GestureTapCallback onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        radius: radius,
      ),
    );
  }
}
