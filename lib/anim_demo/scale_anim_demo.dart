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
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
        print('animation status is $status');
      });
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    /*..addListener(() {
        setState(() {});
      });*/
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
    /*final page = new Scaffold(
      appBar: new AppBar(
        title: const Text('Scale Anim Page1'),
      ),
      body: new Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: new FlutterLogo(),
      ),
    );*/
    /*new ScaleLogoWidget(
      animation: animation,
    );*/
    return new GrowTransition(animation: animation, child: new FlutterLogo());
  }
}

class ScaleLogoWidget extends AnimatedWidget {
  ScaleLogoWidget({Key key, Animation animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation animation = listenable;
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Scale Anim Page2'),
      ),
      body: new Center(
        child: new Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          height: animation.value,
          width: animation.value,
          child: new FlutterLogo(),
        ),
      ),
    );
  }
}

class GrowTransition extends StatelessWidget {
  GrowTransition({@required this.animation, @required this.child});

  Animation animation;
  Widget child;

  @override
  Widget build(BuildContext context) {
    final anim1 = new Tween(begin: 0.0, end: 300.0).animate(animation);
    final anim2 = new Tween(begin: 0.0, end: 1.0).animate(animation);
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Scale Anim Page 3'),
      ),
      body: new Center(
        child: new AnimatedBuilder(
          animation: animation,
          builder: (context, widget) {
            return new Opacity(
              opacity: anim2.value,
              child: new Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                width: anim1.value,
                height: anim1.value,
                child: widget,
              ),
            );
          },
          child: child,
        ),
      ),
    );
  }
}
