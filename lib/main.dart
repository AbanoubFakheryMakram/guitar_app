import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guitar_app_animation/transform_slide_animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController transformAnimationController;
  Animation<double> transformAnimation;

  AnimationController slideAnimationController;
  Animation<double> slideAnimation;

  bool isClicked = false;
  Duration animationDuration = Duration(milliseconds: 1550);

  @override
  void initState() {
    super.initState();

    // Transform animation for first child
    transformAnimationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    transformAnimation = // start from zero : 90 - 0.01 (to remain a part be visible)
        Tween<double>(begin: 0.0, end: math.pi / 2 - 0.01)
            .animate(CurvedAnimation(
      parent: transformAnimationController,
      curve: Curves.fastLinearToSlowEaseIn,
    ))
              ..addListener(() {
                setState(() {});
              });

    // Slide animation for sceond child
    slideAnimationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    slideAnimation = // start from zero : 450
        Tween<double>(begin: 0.0, end: 450).animate(CurvedAnimation(
      parent: slideAnimationController,
      curve: Curves.fastLinearToSlowEaseIn,
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    ScreenUtil.init(context,
        width: screenWidth, height: screenHeight, allowFontScaling: true);

    return TransformSlide(
      screenOne: AnimatedContainer(
        duration: Duration(milliseconds: 1800),
        color: isClicked ? Colors.amber[50] : Colors.amber[100],
        width: screenWidth,
        child: Stack(
          children: <Widget>[
            // Text
            Positioned(
              left: ScreenUtil().setWidth(30),
              top: ScreenUtil().setHeight(120),
              child: RotatedBox(
                quarterTurns: 1,
                child: Text(
                  'Fender'.toUpperCase(),
                  style: TextStyle(
                    fontSize:
                        ScreenUtil().setSp(80, allowFontScalingSelf: true),
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // center image
            Positioned(
              top: 80,
              left: 10,
              right: 10,
              child: Image.asset(
                'assets/guitar.png',
                height: ScreenUtil().setHeight(400),
              ),
            ),
            Positioned(
              bottom: ScreenUtil().setHeight(1),
              left: ScreenUtil().setHeight(16),
              right: ScreenUtil().setHeight(16),
              child: Container(
                height: ScreenUtil().setHeight(100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Fender\nAmirican\nElite Start',
                          style: TextStyle(
                              fontSize: ScreenUtil()
                                  .setSp(28, allowFontScalingSelf: true),
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(15.0)),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            transformAnimationController.forward();
                            slideAnimationController.forward();
                            isClicked = true;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              'DETAILS',
                              style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(14, allowFontScalingSelf: true),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      screenTwo: screenTwo(screenWidth),
    );
  }

  Widget screenTwo(screenWidth) {
    return Container(
      color: Colors.amber[50],
      width: screenWidth,
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(22)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: RotatedBox(
                quarterTurns: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.grey,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      transformAnimationController.reverse();
                      slideAnimationController.reverse();
                      isClicked = true;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Fender\nAmirican\nElite Start',
                  style: TextStyle(
                      fontSize:
                          ScreenUtil().setSp(28, allowFontScalingSelf: true),
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "76\$",
                  style: TextStyle(
                      fontSize:
                          ScreenUtil().setSp(28, allowFontScalingSelf: true),
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Text(
              'The guitar is a type of chordophone, traditionally constructed from wood and strung with either gut, nylon or steel strings and distinguished from other chordophones by its construction and tuning.',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(17, allowFontScalingSelf: true),
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images.jfif',
                height: ScreenUtil().setHeight(150),
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget appBar() {
  return Container(
    height: ScreenUtil().setHeight(50),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        Text(
          'Guitar'.toUpperCase(),
          style: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    ),
  );
}
