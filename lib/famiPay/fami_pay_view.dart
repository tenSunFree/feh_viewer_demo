import 'package:feh_viewer_demo/famiPay/fami_pay_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamiPayView extends GetView<FamiPayController> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        color: Colors.transparent,
        child: Image.asset(
          'assets/icon_fami_pay.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
