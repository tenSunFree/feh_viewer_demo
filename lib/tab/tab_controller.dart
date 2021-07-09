import 'package:feh_viewer_demo/home/view/home_view.dart';
import 'package:feh_viewer_demo/member/member_view.dart';
import 'package:feh_viewer_demo/temporary/temporary_view.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/common/routes.dart';
import 'package:feh_viewer_demo/famiPay/fami_pay_view.dart';
import 'package:feh_viewer_demo/mobile/mobile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

const double kIconSize = 16;
final TabPages tabPages = TabPages();

class TabPages {
  final Map<String, ScrollController> scrollControllerMap = {};

  ScrollController? _scrollController(String key) {
    if (scrollControllerMap[key] == null) {
      scrollControllerMap[key] = ScrollController();
    }
    return scrollControllerMap[key];
  }

  Map<String, Widget> get tabViews => <String, Widget>{
        Routes.home: HomeView(),
        Routes.temporary: TemporaryView(),
        Routes.mobile: MobileView(),
        Routes.famiPay: FamiPayView(),
        Routes.member: MemberView(),
      };

  final Map<String, IconData> iconDatas = <String, IconData>{
    Routes.home: FontAwesomeIcons.home,
    Routes.temporary: FontAwesomeIcons.hamburger,
    Routes.mobile: FontAwesomeIcons.backward,
    Routes.famiPay: FontAwesomeIcons.handHoldingHeart,
    Routes.member: FontAwesomeIcons.personBooth,
  };

  Map<String, Widget> get tabIcons => iconDatas
      .map((key, value) => MapEntry(key, Icon(value, size: kIconSize)));

  Map<String, String> get tabTitles => <String, String>{
        Routes.home: '首頁',
        Routes.temporary: '臨時買',
        Routes.mobile: '全家行動購',
        Routes.famiPay: 'My FamiPay',
        Routes.member: '會員',
      };
}

class TabController extends GetxController {
  DateTime? lastPressedAt; //上次点击时间

  int currentIndex = 0;
  bool tapAwait = false;

  // final EhConfigService _ehConfigService = Get.find();
  // final GStore gStore = Get.find();

  // bool get isSafeMode => _ehConfigService.isSafeMode.value;

  final CupertinoTabController tabController = CupertinoTabController();

  // 需要显示的tab
  List<String> get _showTabs {
    logger.d('get _showTabs');
    return <String>[
      Routes.home,
      Routes.temporary,
      Routes.mobile,
      Routes.famiPay,
      Routes.member,
    ];
  }

  // late TabConfig _tabConfig;

  RxString aa = ''.obs;

  @override
  void onInit() {
    logger.d('TabHomeController, onInit');
    super.onInit();

    // _tabConfig = gStore.tabConfig ?? (TabConfig(tabItemList: []));

    // logger.i('get tab config ${_tabConfig.tabItemList.length}');

    // if (_tabConfig.tabMap.isNotEmpty) {
    //   if (_tabConfig.tabItemList.length < kTabNameList.length) {
    //     final List<String> _tabConfigNames =
    //         _tabConfig.tabItemList.map((e) => e.name).toList();
    //     final List<String> _newTabs = kTabNameList
    //         .where((String element) => !_tabConfigNames.contains(element))
    //         .toList();
//
    //     // 新增tab页的处理
    //     logger.d('add tab $_newTabs');
//
    //     _newTabs.forEach((String element) {
    //       _tabConfig.tabItemList.add(TabItem(name: element, enable: false));
    //     });
    //   }
//
    //   tabMap(_tabConfig.tabMap);
    //   // if (!Global.inDebugMode) {
    //   //   tabMap.remove(EHRoutes.download);
    //   // }
    // }
//
    // if (_tabConfig.tabNameList.isNotEmpty) {
    //   _tabConfig.tabNameList
    //       .removeWhere((element) => element == EHRoutes.setting);
    //   tabNameList(_tabConfig.tabNameList);
    // }

    // logger.d('${tabNameList}');

    ever(aa, (String bb) {
      logger.d('TabHomeController, onInit, ever(aa, (String bb), '
          'aa: $aa, bb: $bb');
    });

    // ever(tabMap, (Map<String, bool> map) {
    //   logger
    //       .d('TabHomeController, onInit, ever(tabMap, (Map<String, bool> map), '
    //           'tabMap: $tabMap, map: $map');
    //   _tabConfig.setItemList(map, tabNameList);
    //   gStore.tabConfig = _tabConfig;
    //   logger.d(
    //       '${_tabConfig.tabItemList.map((e) => '${e.name}:${e.enable}').toList().join('\n')} ');
    // });
//
    // ever(tabNameList, (List<String> nameList) {
    //   _tabConfig.setItemList(tabMap, nameList);
    //   gStore.tabConfig = _tabConfig;
    //   logger.d(
    //       '${_tabConfig.tabItemList.map((e) => '${e.name}:${e.enable}').toList().join('\n')}');
    // });
  }

  List<BottomNavigationBarItem> get listBottomNavigationBarItem => _showTabs
      .map((e) => BottomNavigationBarItem(
            icon: (tabPages.tabIcons[e]) ??
                Icon(FontAwesomeIcons.fire, size: kIconSize),
            label: tabPages.tabTitles[e],
          ))
      .toList();

  BuildContext tContext = Get.context!;

  /// 需要初始化获取BuildContext 否则修改语言时tabitem的文字不会立即生效
  void init({required BuildContext inContext}) {
    // logger.d(' rebuild home');
    tContext = inContext;
  }

  List<Widget> get viewList =>
      _showTabs.map((e) => tabPages.tabViews[e]!).toList();

  List<ScrollController?> get scrollControllerList =>
      _showTabs.map((e) => tabPages.scrollControllerMap[e]).toList();

  Future<void> onTap(int index) async {
    logger.d('TabHomeController, onTap, index: $index');
    if (index == currentIndex &&
        index != listBottomNavigationBarItem.length - 1) {
      logger.d('TabHomeController, onTap2');
      await doubleTapBar(
        duration: const Duration(milliseconds: 800),
        awaitComplete: false,
        onTap: () {
          logger.d('TabHomeController, onTap3');
          scrollControllerList[index]?.animateTo(0.0,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        onDoubleTap: () {
          logger.d('TabHomeController, onTap4');
          scrollControllerList[index]?.animateTo(-100.0,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
      );
    } else {
      log.d('TabHomeController, onTap5');
      currentIndex = index;
    }
  }

  void resetIndex() {
    final int last = listBottomNavigationBarItem.length;
    tabController.index = last - 1;
  }

  /// 双击bar的处理
  Future<void> doubleTapBar({
    required VoidCallback onTap,
    required VoidCallback onDoubleTap,
    required Duration duration,
    required bool awaitComplete,
  }) async {
    logger.d('TabHomeController, doubleTapBar, '
        'duration: $duration, awaitComplete: $awaitComplete');
    final Duration _duration = duration;
    if (!tapAwait) {
      tapAwait = true;

      if (awaitComplete) {
        await Future<void>.delayed(_duration);
        if (tapAwait) {
//        loggerNoStack.v('等待结束 执行单击事件');
          tapAwait = false;
          onTap();
        }
      } else {
        onTap();
        await Future<void>.delayed(_duration);
        tapAwait = false;
      }
    } else if (onDoubleTap != null) {
//      loggerNoStack.v('等待时间内第二次点击 执行双击事件');
      tapAwait = false;
      onDoubleTap();
    }
  }

  /// 连按两次返回退出
  Future<bool> doubleClickBack() async {
    logger.v('click back');
    if (lastPressedAt == null ||
        DateTime.now().difference(lastPressedAt ?? DateTime.now()) >
            const Duration(seconds: 1)) {
      showToast('在一次試試看');
      //两次点击间隔超过1秒则重新计时
      lastPressedAt = DateTime.now();
      return false;
    }
    return true;
  }
}
