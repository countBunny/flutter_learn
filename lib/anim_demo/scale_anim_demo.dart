import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class ScaleAnimationPage extends StatefulWidget {
  ScaleAnimationPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimationPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = new Scaffold(
      appBar: new AppBar(
        title: const Text('Scale Anim Page'),
      ),
      body: new Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: new FlutterLogo(),
      ),
    );
    return page;
  }
}
