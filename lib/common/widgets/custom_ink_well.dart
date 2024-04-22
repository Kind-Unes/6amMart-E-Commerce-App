import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final double? radius;
  final Widget child;
  final Function? onTap;
  final Color? highlightColor;
  final EdgeInsetsGeometry? padding;
  const CustomInkWell({super.key, this.radius, required this.child, required this.onTap, this.highlightColor, this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (onTap == null) ? null : () {
          Future.delayed(const Duration(milliseconds: 100), () => onTap!());
        },
        borderRadius: BorderRadius.circular(radius ?? 0.0),
        highlightColor: highlightColor ?? Theme.of(context).hintColor.withOpacity(0.2),
        hoverColor: Theme.of(context).hintColor.withOpacity(0.02),
        splashColor: Theme.of(context).hintColor.withOpacity(0.5),
        child: Padding(
          padding: padding!,
          child: child,
        ),
      ),
    );
  }
}

