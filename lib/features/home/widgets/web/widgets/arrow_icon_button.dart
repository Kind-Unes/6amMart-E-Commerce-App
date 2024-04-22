import 'package:flutter/material.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';

class ArrowIconButton extends StatelessWidget {
  final bool isRight;
  final void Function()? onTap;
  const ArrowIconButton({super.key, this.isRight = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OnHover(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40, width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).cardColor,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Icon(isRight ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: Theme.of(context).disabledColor, size: 15),
        ),
      ),
    );
  }
}
