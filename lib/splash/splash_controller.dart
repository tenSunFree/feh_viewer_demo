import 'dart:async';
import 'package:feh_viewer_demo/common/routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future<void>.delayed(const Duration(milliseconds: 1000), () {
      Get.offNamed(Routes.tab);
    });
  }
}
