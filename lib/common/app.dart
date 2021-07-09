import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/common/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_cupertino_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:oktoast/oktoast.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    logger.d('_AppState, initState');
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    logger.d('_AppState, build');
    return OKToast(child: buildGetCupertinoApp());
  }

  GetCupertinoApp buildGetCupertinoApp({CupertinoThemeData? theme}) {
    return GetCupertinoApp(
      getPages: Routes.pageList,
      defaultTransition: Transition.cupertino,
      initialRoute: Routes.root,
      theme: theme,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        logger.d('_AppState, didChangeAppLifecycleState, paused');
        break;
      case AppLifecycleState.resumed:
        logger.d('_AppState, didChangeAppLifecycleState, resumed');
        break;
      case AppLifecycleState.inactive:
        logger.d('_AppState, didChangeAppLifecycleState, inactive');
        break;
      case AppLifecycleState.detached:
        logger.d('_AppState, didChangeAppLifecycleState, detached');
        break;
    }
  }

  @override
  void dispose() {
    logger.d('_AppState, dispose');
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
