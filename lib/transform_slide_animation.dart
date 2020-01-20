import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransformSlide extends StatefulWidget {
  final Widget screenOne;
  final Widget screenTwo;
  final Widget appBar;
  final Color scaffoldBackgroundColor;
  final Duration animationDuration;
  final Curve curve;

  const TransformSlide({
    Key key,
    @required this.screenOne,
    @required this.screenTwo,
    this.appBar,
    this.scaffoldBackgroundColor = const Color(0xffACA498),
    this.animationDuration = const Duration(milliseconds: 1550),
    this.curve = Curves.fastLinearToSlowEaseIn,
  }) : super(key: key);

  @override
  _TransformSlideState createState() => _TransformSlideState();
}

class _TransformSlideState extends State<TransformSlide>
    with TickerProviderStateMixin {
  AnimationController transformAnimationController;
  Animation<double> transformAnimation;

  AnimationController slideAnimationController;
  Animation<double> slideAnimation;

  bool isClicked = false;

  @override
  void initState() {
    super.initState();

    // Transform animation for first child
    transformAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    transformAnimation = // start from zero : 90 - 0.01 (to remain a part be visible)
        Tween<double>(begin: 0.0, end: math.pi / 2 - 0.02)
            .animate(CurvedAnimation(
      parent: transformAnimationController,
      curve: widget.curve,
    ))
              ..addListener(() {
                setState(() {});
              });

    // Slide animation for sceond child
    slideAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    slideAnimation = // start from zero : 450
        Tween<double>(begin: 0.0, end: 450).animate(CurvedAnimation(
      parent: slideAnimationController,
      curve: widget.curve,
    ))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    transformAnimationController?.dispose();
    slideAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    ScreenUtil.init(context,
        width: screenWidth, height: screenHeight, allowFontScaling: true);
    return Scaffold(
      backgroundColor: widget.scaffoldBackgroundColor,
      body: Stack(
        children: <Widget>[
          // Transform (main screen)
          Positioned(
            top: -slideAnimation.value / 2,
            left: 0.0,
            right: 0.0,
            height: screenHeight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  transformAnimationController.forward();
                  slideAnimationController.forward();
                  isClicked = true;
                });
              },
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-transformAnimation.value),
                child: widget.screenOne,
              ),
            ),
          ),
          // Slide (feedback screen)
          Positioned(
            top: screenHeight - slideAnimation.value * 1.15,
            left: 0.0,
            right: 0.0,
            height: screenHeight,
            child: GestureDetector(
              onVerticalDragStart: (details) {
                setState(() {
                  transformAnimationController.reverse();
                  slideAnimationController.reverse();
                  isClicked = false;
                });
              },
              onTap: () {
                setState(() {
                  transformAnimationController.reverse();
                  slideAnimationController.reverse();
                  isClicked = false;
                });
              },
              child: widget.screenTwo,
            ),
          ),

          // appBar
          widget.appBar == SizedBox.shrink()
              ? null
              : Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      child: widget.appBar,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
