import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    logger.d('SplashBinding, dependencies');
    Get.lazyPut(() => SplashController());
  }
}
