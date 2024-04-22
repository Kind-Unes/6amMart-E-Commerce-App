import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScaledList extends StatefulWidget {
  const ScaledList({super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.itemColor,
    this.showDots = true,
    this.cardWidthRatio = 0.6,
    this.marginWidthRatio = 0.1,
    this.selectedCardHeightRatio = 0.4,
    this.unSelectedCardHeightRatio = 0.3,
  })  : assert(cardWidthRatio + marginWidthRatio >= 0.5,
  " Card width + margin width should exceed 0.5 of the screen"),
        assert(selectedCardHeightRatio > unSelectedCardHeightRatio,
        " selectedCardHeight should alwayes excceed the unSelectedCardHeight to show desire effect");

  final Widget Function(int index, int selectedIndex) itemBuilder;

  final int itemCount;

  final Color Function(int index) itemColor;

  final bool showDots;

  final double cardWidthRatio;

  final double marginWidthRatio;

  final double selectedCardHeightRatio;

  final double unSelectedCardHeightRatio;

  @override
  ScaledListState createState() => ScaledListState();
}

class ScaledListState extends State<ScaledList> {
  ScrollController? _scrollController;
  int _selectedIndex = 0;

  late double parentWidth;
  double? parentHeight;

  @override
  void initState() {
    _scrollController = ScrollController();
    final double fullCardWidth =
        widget.cardWidthRatio + widget.marginWidthRatio;
    _scrollController!.addListener(() {
      final double offset = _scrollController!.offset;
      double deltaReverse =
          (((_selectedIndex + 2) * fullCardWidth) - 1) * parentWidth;

      double deltaForward =
          (((_selectedIndex - 1) * (fullCardWidth)) + widget.marginWidthRatio) *
              parentWidth;

      if (offset > deltaReverse &&
          _scrollController!.position.userScrollDirection ==
              ScrollDirection.reverse) {
        setState(() {
          _selectedIndex += 1;
        });
      }
      if (offset < deltaForward &&
          _scrollController!.position.userScrollDirection ==
              ScrollDirection.forward) {
        setState(() {
          _selectedIndex -= 1;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      parentWidth = constraints.maxWidth;
      parentHeight = constraints.maxHeight;
      if (parentHeight == double.infinity) {
        final mediaQuery = MediaQuery.of(context);
        parentHeight = mediaQuery.size.height;
      }
      return Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: parentHeight! * 0.16,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.itemCount,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        if (index == 0) ...[
                          const SizedBox(width: 15),
                        ],
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Card(
                                margin: const EdgeInsets.only(
                                    left: 0, right: 0, top: 5, bottom: 25),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  width: parentWidth * widget.cardWidthRatio,
                                  height: _selectedIndex == index
                                      ? widget.selectedCardHeightRatio *
                                      parentHeight!
                                      : widget.unSelectedCardHeightRatio *
                                      parentHeight!,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                                child:
                                widget.itemBuilder(index, _selectedIndex))
                          ],
                        ),
                        const SizedBox(width: 15)
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: parentHeight! * 0.010,
            right: 62,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDot(_selectedIndex, widget.itemCount),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget buildDot(int index, int length) {
    return Container(
      width: parentWidth * 0.3,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          minHeight: 5,
          value: (0 + index + 1) / length,
          //backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(index == _selectedIndex
              ? const Color(0xff1B7FED)
              : const Color(0xff1B7FED).withOpacity(0.5)),
        ),
      ),
    );
  }
}
