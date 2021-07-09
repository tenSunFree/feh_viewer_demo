import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/splash/splash_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    logger.d('SplashPage, build, controller: $controller');
    return CupertinoPageScaffold(
      child: Container(
        color: Colors.transparent,
        child: Image.asset(
          'assets/icon_splash.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
