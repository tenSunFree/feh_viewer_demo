import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/tab/tab_controller.dart' as Tab;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabPage extends GetView<Tab.TabController> {
  @override
  Widget build(BuildContext context) {
    logger.d('HomePage, build');
    controller.init(inContext: context);
    // final LayoutServices layoutServices = Get.find();

    final WillPopScope willPopScope = WillPopScope(
      onWillPop: controller.doubleClickBack,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // logger.d('${constraints.maxWidth}');
          // if (context.width > 1080) {
          //   layoutServices.layoutMode = LayoutMode.large;
          //   return const TabHomeLarge(
          //     wide: true,
          //   );
          // } else if (context.width > 700) {
          //   layoutServices.layoutMode = LayoutMode.large;
          //   return const TabHomeLarge();
          // } else {
          //   layoutServices.layoutMode = LayoutMode.small;
          //   return TabHomeSmall();
          // }
          return CupertinoTabScaffold(
            controller: controller.tabController,
            tabBar: CupertinoTabBar(
              items: controller.listBottomNavigationBarItem,
              onTap: controller.onTap,
            ),
            tabBuilder: (BuildContext context, int index) {
              // return controller.viewList[index];
              return CupertinoTabView(
                builder: (BuildContext context) {
                  // logger.d('build CupertinoTabView');
                  return controller.viewList[index];
                },
              );
            },
          );
        },
      ),
    );

    return willPopScope;
  }
}
