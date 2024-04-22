import 'package:flutter/material.dart';

class CustomHeaderLine extends StatelessWidget {
  final Color? color;
  final Color gradientColor1;
  final Color gradientColor2;
  final bool cancelOrder;
  const CustomHeaderLine({super.key, this.color, required this.gradientColor1, required this.gradientColor2, this.cancelOrder = false});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Stack(
        alignment: cancelOrder == false ? AlignmentDirectional.topStart : AlignmentDirectional.center,
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                stops: const [0.6,0.5],
                tileMode: TileMode.repeated,
                colors: [gradientColor1, gradientColor2],
              ),
            ),
          ),
          color != null ? Container(
            height: 3, width: 30,
            decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(50),),
          ) : const SizedBox(),
          cancelOrder ? const Icon(
            Icons.close,
            color: Colors.red,
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
