import 'package:feh_viewer_demo/splash/splash_binding.dart';
import 'package:feh_viewer_demo/splash/splash_page.dart';
import 'package:feh_viewer_demo/tab/tab_binding.dart';
import 'package:feh_viewer_demo/tab/tab_page.dart';
import 'package:feh_viewer_demo/temporary/temporary_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import '../home/view/home_view.dart';
import '../member/member_view.dart';
import '../mobile/mobile_view.dart';

class Routes {
  static const String root = '/';
  static const String tab = '/tab';
  static const String home = '/home';
  static const String temporary = '/temporary';
  static const String mobile = '/mobile';
  static const String famiPay = '/famiPay';
  static const String member = '/member';

  static final List<GetPage> pageList = <GetPage>[
    GetPage(
      name: Routes.root,
      page: () => SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.tab,
      page: () => TabPage(),
      binding: TabBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.member,
      page: () => MemberView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.mobile,
      page: () => TemporaryView(),
    ),
    GetPage(
      name: Routes.temporary,
      page: () => MobileView(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
    ),
  ];
}
