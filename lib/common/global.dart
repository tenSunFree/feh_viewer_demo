import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:feh_viewer_demo/common/remote/api.dart';
import 'package:feh_viewer_demo/common/remote/https_proxy.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/common/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

const int kProxyPort = 4041;

class Global {
  static bool inDebugMode = false;

  static late CookieManager cookieManager;

  static late PersistCookieJar cookieJar;

  static HttpProxy httpProxy = HttpProxy('localhost', '$kProxyPort');

  static String appSupportPath = '';
  static String appDocPath = '';
  static String tempPath = '';
  static late String extStorePath;

  static bool isDBinappSupportPath = false;

  static bool canCheckBiometrics = false;

  // init
  static Future<void> init() async {
    // 判断是否debug模式
    inDebugMode = EHUtils().isInDebugMode;
    if (!inDebugMode) Logger.level = Level.info;
    // 代理初始化
    if (Platform.isIOS || Platform.isAndroid) {
      await CustomHttpsProxy.instance.init();
    }
    await FlutterStatusbarManager.setColor(Colors.transparent);
    appSupportPath = (await getApplicationSupportDirectory()).path;
    appDocPath = (await getApplicationDocumentsDirectory()).path;
    tempPath = (await getTemporaryDirectory()).path;
    extStorePath = !Platform.isIOS
        ? (await getExternalStorageDirectory())?.path ?? ''
        : '';
    logger.d('doc $appDocPath \napps $appSupportPath \ntemp $tempPath');
    cookieManager = CookieManager(await Api.cookieJar);
    cookieJar = await Api.cookieJar;
  }
}
