import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Gallery3D extends StatefulWidget {
  final double? height;
  final double width;
  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<int>? onItemChanged;
  final ValueChanged<int>? onClickItem;
  final Gallery3DController controller;
  final GalleryItemConfig itemConfig;
  final EdgeInsetsGeometry? padding;
  final bool isClip;

  const Gallery3D({super.key, this.onClickItem, this.onItemChanged, this.isClip = true, this.height, this.padding,
    required this.itemConfig, required this.controller, required this.width, required this.itemBuilder});

  @override
  Gallery3DState createState() => Gallery3DState();
}

class Gallery3DState extends State<Gallery3D> with TickerProviderStateMixin, WidgetsBindingObserver, Gallery3DMixin {
  
  List<Widget> _galleryItemWidgetList = [];
  AnimationController? _autoScrollAnimationController;
  Timer? _timer;

  late Gallery3DController controller = widget.controller;
  
  AppLifecycleState appLifecycleState = AppLifecycleState.resumed;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleState = state;
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    controller.widgetWidth = widget.width;
    controller.vsync = this;
    controller.init(widget.itemConfig);

    _updateWidgetIndexOnStack();
    if (controller.autoLoop) {
      _timer = Timer.periodic(Duration(milliseconds: controller.delayTime), (timer) {
        if (!mounted) return;
        if (appLifecycleState != AppLifecycleState.resumed) return;
        if (DateTime.now().millisecondsSinceEpoch - _lastTouchMillisecond < controller.delayTime) return;
        if (_isTouching) return;
        animateTo(controller.getOffsetAngleFormTargetIndex(getNextIndex(controller.currentIndex)));
      });
    }

    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _timer = null;
    _autoScrollAnimationController?.stop(canceled: true);
    super.dispose();
  }

  @override
  void animateTo(angle) {
    _isTouching = true;
    _lastTouchMillisecond = DateTime.now().millisecondsSinceEpoch;
    _scrollToAngle(angle);
  }

  @override
  void jumpTo(angle) {
    setState(() {
      _updateAllGalleryItemTransformByAngle(angle);
    });
  }

  var _isTouching = false;
  var _lastTouchMillisecond = 0;
  Offset? _panDownLocation;
  Offset? _lastUpdateLocation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height ?? widget.itemConfig.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragCancel: (() {
          _onFingerUp();
        }),
        onHorizontalDragDown: (details) {
          _isTouching = true;
          _panDownLocation = details.localPosition;
          _lastUpdateLocation = details.localPosition;
          _lastTouchMillisecond = DateTime.now().millisecondsSinceEpoch;
        },
        onHorizontalDragEnd: (details) {
          _onFingerUp();
        },
        onHorizontalDragStart: (details) {},
        onHorizontalDragUpdate: (details) {
          setState(() {
            _lastUpdateLocation = details.localPosition;
            _lastTouchMillisecond = DateTime.now().millisecondsSinceEpoch;
            _updateAllGalleryItemTransformByOffsetDx(details.delta.dx);
          });
        },
        child: _buildWidgetList(),
      ),
    );
  }

  Widget _buildWidgetList() {
    if (widget.isClip) {
      return ClipRect(
        child: Stack(
          children: _galleryItemWidgetList,
        ),
      );
    }
    return Stack(
      children: _galleryItemWidgetList,
    );
  }

  void _scrollToAngle(double angle) {
    _autoScrollAnimationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    Animation animation;

    if (angle.ceil().abs() == 0) return;
    animation =
        Tween(begin: 0.0, end: angle).animate(_autoScrollAnimationController!);

    double lastValue = 0;
    animation.addListener(() {
      setState(() {
        _updateAllGalleryItemTransformByAngle(animation.value - lastValue);
        lastValue = animation.value;
      });
    });
    _autoScrollAnimationController?.forward();
    _autoScrollAnimationController?.addListener(() {
      if (_autoScrollAnimationController != null &&
          _autoScrollAnimationController!.isCompleted) {
        _isTouching = false;
      }
    });
  }

  void _onFingerUp() {
    if (_lastUpdateLocation == null) {
      _isTouching = false;
      return;
    }
    double angle = controller.getTransformInfo(controller.currentIndex).angle;
    double targetAngle = 0;

    var offsetX = _lastUpdateLocation!.dx - _panDownLocation!.dx;
    if (offsetX.abs() > widget.width * 0.1) {
      targetAngle = controller.getTransformInfo(offsetX > 0 ? getPreIndex(controller.currentIndex) : getNextIndex(controller.currentIndex)).angle - 180;
    } else {
      targetAngle = angle - 180;
    }

    _scrollToAngle(targetAngle);
  }

  void _updateAllGalleryItemTransformByAngle(double angle) {
    controller.updateTransformByAngle(angle);
    _updateAllGalleryItemTransform();
  }

  void _updateAllGalleryItemTransformByOffsetDx(double offsetDx) {
    controller.updateTransformByOffsetDx(offsetDx);
    _updateAllGalleryItemTransform();
  }

  void _updateAllGalleryItemTransform() {
    for (var i = 0; i < controller.getTransformInfoListSize(); i++) {
      var item = controller.getTransformInfo(i);

      if (item.angle > 180 - controller.unitAngle / 2 &&
          item.angle < 180 + controller.unitAngle / 2) {
        if (controller.currentIndex != i) {
          controller.currentIndex = i;
          widget.onItemChanged?.call(controller.currentIndex);
        }
      }
      _updateWidgetIndexOnStack();
    }
  }
  
  int getPreIndex(int index) {
    var preIndex = index - 1;
    if (preIndex < 0) {
      preIndex = controller.itemCount - 1;
    }
    return preIndex;
  }
  
  int getNextIndex(int index) {
    var nextIndex = index + 1;
    if (nextIndex == controller.itemCount) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  final List<GalleryItem> _leftWidgetList = [];
  final List<GalleryItem> _rightWidgetList = [];
  final List<GalleryItem> _tempList = [];

  void _updateWidgetIndexOnStack() {
    _leftWidgetList.clear();
    _rightWidgetList.clear();
    _tempList.clear();
    for (var i = 0; i < controller.getTransformInfoListSize(); i++) {
      var angle = controller.getTransformInfo(i).angle;

      if (angle >= 180 + controller.unitAngle / 2) {
        _leftWidgetList.add(_buildGalleryItem(i));
      } else {
        _rightWidgetList.add(_buildGalleryItem(i));
      }
    }

    _rightWidgetList.sort((widget1, widget2) => widget1.transformInfo.angle.compareTo(widget2.transformInfo.angle));

    for (var element in _rightWidgetList) {
      if (element.transformInfo.angle < controller.unitAngle / 2) {
        element.transformInfo.angle += 360;
        _tempList.add(element);
      }
    }
    for (var element in _tempList) {
      _rightWidgetList.remove(element);
    }
    _leftWidgetList.insertAll(0, _tempList);
    _leftWidgetList.sort((widget1, widget2) =>
        widget2.transformInfo.angle.compareTo(widget1.transformInfo.angle));

    _galleryItemWidgetList = [
      ..._leftWidgetList,
      ..._rightWidgetList,
    ];
  }

  GalleryItem _buildGalleryItem(int index) {
    return GalleryItem(
      index: index,
      ellipseHeight: controller.ellipseHeight,
      builder: widget.itemBuilder,
      config: widget.itemConfig,
      onClick: (index) {
        if (widget.onClickItem != null && index == controller.currentIndex) {
          widget.onClickItem?.call(index);
        }
      },
      transformInfo: controller.getTransformInfo(index),
    );
  }
}

class GalleryItemTransformInfo {
  Offset offset;
  double scale;
  double angle;
  int index;

  GalleryItemTransformInfo({required this.index, this.scale = 1, this.angle = 0, this.offset = Offset.zero});
}

class GalleryItem extends StatelessWidget {
  final GalleryItemConfig config;
  final double ellipseHeight;
  final int index;
  final IndexedWidgetBuilder builder;
  final ValueChanged<int>? onClick;
  final GalleryItemTransformInfo transformInfo;

  final double minScale;
  const GalleryItem({super.key, required this.index, required this.transformInfo, required this.config, required this.builder,
    this.minScale = 0.4, this.onClick, this.ellipseHeight = 0});

  Widget _buildItem(BuildContext context) {
    return SizedBox(
      width: config.width, height: config.height,
      child: builder(context, index),
    );
  }

  Widget _buildMaskTransformItem(Widget child) {
    if (!config.isShowTransformMask) return child;
    return Stack(children: [
      child,
      Container(
        width: config.width,
        height: config.height,
        color: Color.fromARGB(100 * (1 - transformInfo.scale) ~/ (1 - minScale), 0, 0, 0),
      )
    ]);
  }

  Widget _buildRadiusItem(Widget child) {
    if (config.radius <= 0) return child;
    return ClipRRect(borderRadius: BorderRadius.circular(config.radius), child: child);
  }

  Widget _buildShadowItem(Widget child) {
    if (config.shadows.isEmpty) return child;
    return Container(
      decoration: BoxDecoration(boxShadow: config.shadows),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: transformInfo.offset,
      child: SizedBox(
        width: config.width,
        height: config.height,
        child: Transform.scale(
          scale: transformInfo.scale,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => onClick?.call(index),
            child: _buildShadowItem(
                _buildRadiusItem(_buildMaskTransformItem(_buildItem(context)))),
          ),
        ),
      ),
    );
  }
}

class GalleryItemConfig {
  final double width;
  final double height;
  final double radius;
  final List<BoxShadow> shadows;
  final bool isShowTransformMask;

  const GalleryItemConfig({this.width = 220, this.height = 300, this.radius = 0, this.isShowTransformMask = true, this.shadows = const []});
}

class Gallery3DController {
  double perimeter = 0;
  double unitAngle = 0;
  final double minScale;
  double widgetWidth = 0;
  double ellipseHeight;
  int itemCount;
  late GalleryItemConfig itemConfig;
  int currentIndex = 0;
  final int delayTime;
  final int scrollTime;
  final bool autoLoop;
  late Gallery3DMixin vsync;
  final List<GalleryItemTransformInfo> _galleryItemTransformInfoList = [];
  double baseAngleOffset = 0;

  Gallery3DController({required this.itemCount, this.ellipseHeight = 0, this.autoLoop = true, this.minScale = 0.4,
    this.delayTime = 5000, this.scrollTime = 1000}) : assert(itemCount >= 3, 'ItemCount must be greater than or equal to 3');

  void init(GalleryItemConfig itemConfig) {
    this.itemConfig = itemConfig;
    unitAngle = 360 / itemCount;
    perimeter = calculatePerimeter(widgetWidth * 0.7, 50);

    _galleryItemTransformInfoList.clear();
    for (var i = 0; i < itemCount; i++) {
      var itemAngle = getItemAngle(i);
      _galleryItemTransformInfoList.add(GalleryItemTransformInfo(
        index: i,
        angle: itemAngle,
        scale: calculateScale(itemAngle),
        offset: calculateOffset(itemAngle),
      ));
    }
  }

  GalleryItemTransformInfo getTransformInfo(int index) {
    return _galleryItemTransformInfoList[index];
  }

  int getTransformInfoListSize() {
    return _galleryItemTransformInfoList.length;
  }

  double getItemAngle(int index) {
    double angle = 360 - (index * unitAngle + 180) % 360;
    return angle;
  }

  void updateTransformByAngle(double offsetAngle) {
    baseAngleOffset -= offsetAngle;
    for (int index = 0; index < _galleryItemTransformInfoList.length; index++) {
      GalleryItemTransformInfo transformInfo =
      _galleryItemTransformInfoList[index];

      double angle = getItemAngle(index);
      double scale = transformInfo.scale;
      Offset offset = transformInfo.offset;

      if (baseAngleOffset.abs() > 360) {
        baseAngleOffset %= 360;
      }

      angle += baseAngleOffset;
      angle = angle % 360;

      offset = calculateOffset(angle);

      scale = calculateScale(angle);

      transformInfo
        ..angle = angle
        ..scale = scale
        ..offset = offset;
    }
  }

  void updateTransformByOffsetDx(double offsetDx) {
    double offsetAngle = offsetDx / perimeter / 2 * 360;
    updateTransformByAngle(offsetAngle);
  }

  double calculateScale(double angle) {
    angle = angle % 360;
    if (angle > 180) {
      angle = 360 - angle;
    }
    angle += 30;
    var scale = angle / 180.0;
    if (scale > 1) {
      scale = 1;
    } else if (scale < minScale) {
      scale = minScale;
    }
    return scale;
  }

  Offset calculateOffset(double angle) {
    double width = widgetWidth * 0.7;
    double radiusOuterX = width / 2;
    double radiusOuterY = ellipseHeight;

    double angleOuter = (2 * pi / 360) * angle;
    double x = radiusOuterX * sin(angleOuter);
    double y = radiusOuterY > 0 ? radiusOuterY * cos(angleOuter) : 0;
    return Offset(x + (widgetWidth - itemConfig.width) / 2, -y);
  }


  double calculatePerimeter(double width, double height) {
    var a = width;
    var b = height;
    return 2 * pi * b + 4 * (a - b);
  }

  double getFinalAngle(double angle) {
    if (angle >= 360) {
      angle -= 360;
    } else if (angle < 0) {
      angle += 360;
    }
    return angle;
  }

  double getOffsetAngleFormTargetIndex(int index) {
    double targetItemAngle = getItemAngle(index) + baseAngleOffset;

    double offsetAngle = targetItemAngle % 180;
    if (targetItemAngle < 180 || targetItemAngle > 360) {
      offsetAngle = offsetAngle - 180;
    }

    return offsetAngle;
  }

  void animateTo(int index) {
    if (index == currentIndex) return;
    vsync.animateTo(getOffsetAngleFormTargetIndex(index));
  }

  void jumpTo(int index) {
    if (index == currentIndex) return;
    vsync.jumpTo(getOffsetAngleFormTargetIndex(index));
  }
}

mixin class Gallery3DMixin {
  void animateTo(angle) {}
  void jumpTo(angle) {}
}