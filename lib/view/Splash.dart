import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wan_flutter_app/data/Const.dart';
import 'package:wan_flutter_app/utils/SPUtils.dart';
import 'package:wan_flutter_app/utils/SystemUtils.dart';

/// @author DeMon
/// Created on 2020/4/23.
/// E-mail 757454343@qq.com
/// Desc:
class SplashPage extends StatefulWidget {
  @override
  createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  AnimationController _ctrl;
  bool _animEnd = false;

  @override
  void initState() {
    _ctrl = AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..forward()
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _animEnd = true;
          });
          goto();
        }
      });
    super.initState();
  }

  goto() {
    Future.delayed(Duration(milliseconds: 500)).then((e) {
      SPUtils.getData(Const.IS_LOGIN, false).then((onValue) {
        if (onValue) {
          Navigator.of(context).pushReplacementNamed(Const.HOME);
        } else {
          Navigator.of(context).pushReplacementNamed(Const.LOGIN);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemUtils.setTransparentStatusBar();
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: <Widget>[_buildLogo(), _buildAppName(), _buildPower()],
    ));
  }

  Widget _buildLogo() => Positioned(
      top: 100,
      child: ScaleTransition(
        scale: CurvedAnimation(parent: _ctrl, curve: Curves.linear),
        child: Container(
          width: 100,
          height: 100,
          child: Image.asset('res/images/wan.png'),
        ),
      ));

  Widget _buildAppName() => Positioned(
        top: 250,
        child: Container(
            alignment: Alignment.center,
            width: 300,
            height: 100,
            child: DefaultTextStyleTransition(
              child: Text("wanFlutter"),
              overflow: TextOverflow.ellipsis,
              style: TextStyleTween(
                begin: TextStyle(color: Colors.white, fontSize: 10, shadows: [Shadow(offset: Offset(1, 1), color: Colors.purple, blurRadius: 2)]),
                end: TextStyle(color: Colors.blue, fontSize: 40, shadows: [Shadow(offset: Offset(1, 1), color: Colors.black, blurRadius: 2)]),
              ).animate(_ctrl),
            )),
      );

  Widget _buildPower() => Positioned(
        bottom: 30,
        right: 30,
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _animEnd ? 1.0 : 0.0,
            child: const Text(
              "Power By DeMon.",
              style: TextStyle(color: Colors.grey, shadows: [Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.3, 0.3))], fontSize: 16),
            )),
      );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}