import 'package:flutter/material.dart';

class CustomHeaderIcon extends StatelessWidget {
  final String assetIconUnSelected;

  const CustomHeaderIcon({super.key, required this.assetIconUnSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(assetIconUnSelected))),
    );
  }
}
