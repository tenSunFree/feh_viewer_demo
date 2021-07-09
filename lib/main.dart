import 'dart:async';
import 'package:feh_viewer_demo/common/app.dart';
import 'package:feh_viewer_demo/common/global.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  logger.d('main');
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded<Future<void>>(() async {
    await Global.init();
    runApp(App());
  }, (Object error, StackTrace stackTrace) {
    logger.e('main, runZonedGuarded: Caught error in my root zone.');
  });
}
