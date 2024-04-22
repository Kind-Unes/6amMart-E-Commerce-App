import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';

class CustomNavigationDrawer extends StatefulWidget {
  final Color selectedColor;
  final Color? backgroundColor;
  final TextStyle defaultTextStyle;
  final TextStyle selectedTextStyle;
  final Widget child;
  const CustomNavigationDrawer({super.key, 
    this.selectedColor = const Color(0xFF4AC8EA), this.backgroundColor,
    required this.child,
    this.defaultTextStyle = const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
    this.selectedTextStyle = const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
  });

  @override
  CustomNavigationDrawerState createState() => CustomNavigationDrawerState();
}

class CustomNavigationDrawerState extends State<CustomNavigationDrawer> with SingleTickerProviderStateMixin {

  double maxWidth = 200;
  double minWidth = 45;
  bool isCollapsed = true;
  AnimationController? _animationController;
  late Animation<double> widthAnimation;
  int currentselectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animationController!.forward();
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController!);
    if(Get.find<SplashController>().moduleList == null && !mounted ? ResponsiveHelper.isDesktop(context) : true) {
      Get.find<SplashController>().getModules();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      return Stack(children: [
        widget.child,
        splashController.moduleList != null ? Positioned(
          top: 100, right: 0,
          child: AnimatedBuilder(
            animation: _animationController!,
            builder: (context, widget1) => getWidget(context, widget1, widget.backgroundColor, splashController),
          ),
        ) : const SizedBox(),
      ]);
    });
  }

  Widget getWidget(context, widget, Color? backgroundColor, SplashController splashController) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isCollapsed = false;
          _animationController!.reverse();
        });
      },
      onExit: (event) {
        setState(() {
          isCollapsed = true;
          _animationController!.forward();
        });
      },
      child: Material(
        elevation: 80.0,
        color: Colors.transparent,
        child: Container(
          width: widthAnimation.value,
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(Dimensions.radiusDefault)),
          ),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListView.separated(
                separatorBuilder: (context, counter) {
                  return const Divider(height: 12.0);
                },
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                    onTap: () {},
                    isSelected: currentselectedIndex == counter,
                    title: splashController.moduleList![counter].moduleName,
                    icon: splashController.moduleList![counter].icon,
                    animationController: _animationController,
                    selectedColor: widget.selectedColor,
                    defaultTextStyle: widget.defaultTextStyle,
                    selectedTextStyle: widget.selectedTextStyle,
                  );
                },
                itemCount: splashController.moduleList!.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CollapsingListTile extends StatefulWidget {
  final String? title;
  final String? icon;
  final Color selectedColor;
  final TextStyle defaultTextStyle;
  final TextStyle selectedTextStyle;
  final AnimationController? animationController;
  final bool isSelected;
  final Function? onTap;

  const CollapsingListTile({super.key, required this.title, required this.icon, required this.selectedColor, required this.animationController,
    required this.defaultTextStyle, required this.selectedTextStyle, this.isSelected = false, this.onTap});

  @override
  CollapsingListTileState createState() => CollapsingListTileState();
}

class CollapsingListTileState extends State<CollapsingListTile> {
  late Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation = Tween<double>(begin: 200, end: 70).animate(widget.animationController!);
    sizedBoxAnimation = Tween<double>(begin: 10, end: 0).animate(widget.animationController!);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.3)
              : Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImage(
                image: '${Get.find<SplashController>().configModel!.baseUrls!.moduleImageUrl}/${widget.icon}',
                width: 25, height: 25,
              ),
            ),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 190)
                ? Text(widget.title!,
                style: widget.isSelected ? widget.selectedTextStyle : widget.defaultTextStyle)
                : Container()
          ],
        ),
      ),
    );
  }
}

class NavigationModel {
  String? title;
  IconData? icon;
  Function? onTap;

  NavigationModel({this.title, this.icon, this.onTap});
}