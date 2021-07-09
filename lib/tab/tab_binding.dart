import 'package:feh_viewer_demo/mobile/mobile_controller.dart';
import 'package:feh_viewer_demo/tab/tab_controller.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/home/controller/home_controller.dart';
import 'package:feh_viewer_demo/famiPay/fami_pay_controller.dart';
import 'package:get/get.dart';

import '../temporary/temporary_controller.dart';

class TabBinding extends Bindings {
  @override
  void dependencies() {
    logger.d('TabHomeBinding, dependencies');
    // logger.d('TabHomeBinding');
    Get.lazyPut(() => TabController(), fenix: true);
    Get.lazyPut(() => HomeViewController(), fenix: true);
    Get.lazyPut(() => MobileViewController(), fenix: true);
    // Get.lazyPut(() => GalleryViewController(), fenix: true);
    // Get.lazyPut(() => FavoriteViewController(), fenix: true);
    Get.lazyPut(() => FamiPayController(), fenix: true);

    Get.lazyPut(() => TemporaryController(), fenix: true);
    //Get.lazyPut(() => DownloadViewController(), fenix: true);
  }
}
