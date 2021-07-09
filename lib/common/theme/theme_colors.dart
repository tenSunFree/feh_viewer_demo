import 'package:feh_viewer_demo/common/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EhDynamicColors {
  static const EhDynamicColor textFieldBackground = EhDynamicColor(
    color: Color.fromARGB(255, 239, 239, 240),
    darkColor: Color.fromARGB(255, 28, 28, 31),
    darkGrayColor: Color.fromARGB(255, 47, 47, 47),
  );

  static const EhDynamicColor commentTextFieldBackground = EhDynamicColor(
    color: Color.fromARGB(255, 233, 233, 233),
    darkColor: Color.fromARGB(255, 28, 28, 31),
    darkGrayColor: Color.fromARGB(255, 47, 47, 47),
  );

  static const EhDynamicColor favnoteTextFieldBackground = EhDynamicColor(
    color: Color.fromARGB(255, 250, 250, 250),
    darkColor: Color.fromARGB(255, 28, 28, 31),
    darkGrayColor: Color.fromARGB(255, 47, 47, 47),
  );

  static const EhDynamicColor itemBackground = EhDynamicColor(
    color: Color.fromARGB(255, 255, 255, 255),
    darkColor: Color.fromARGB(255, 30, 30, 30),
    darkGrayColor: Color.fromARGB(255, 30, 30, 30),
  );
}

// ignore: avoid_classes_with_only_static_members
class ThemeColors {
  static const CupertinoDynamicColor commitBackground =
      CupertinoDynamicColor.withBrightness(
    debugLabel: 'commitBackground',
    color: Color.fromARGB(255, 242, 242, 247),
    darkColor: Color.fromARGB(255, 30, 30, 30),
  );

  // Gray
  static const CupertinoDynamicColor commitBackgroundGray =
      CupertinoDynamicColor.withBrightness(
    debugLabel: 'commitBackground',
    color: Color.fromARGB(255, 242, 242, 247),
    darkColor: Color.fromARGB(255, 40, 40, 40),
  );

  static const CupertinoDynamicColor pressedBackground =
      CupertinoDynamicColor.withBrightness(
    debugLabel: 'pressedBackground',
    color: Color.fromARGB(255, 209, 209, 214),
    darkColor: Color.fromARGB(255, 50, 50, 50),
  );

  static const CupertinoDynamicColor commitText =
      CupertinoDynamicColor.withBrightness(
    debugLabel: 'commitText',
    color: Colors.black87,
    darkColor: CupertinoColors.systemGrey4,
  );

  static const CupertinoDynamicColor tagText =
      CupertinoDynamicColor.withBrightness(
    debugLabel: 'tagText',
    color: Color(0xff505050),
    darkColor: CupertinoColors.systemGrey4,
  );

  static const CupertinoDynamicColor tagBackground =
      CupertinoDynamicColor.withBrightness(
    debugLabel: 'tagBackground',
    color: Color(0xffeeeeee),
    darkColor: CupertinoColors.secondaryLabel,
  );

  /// 主题配置
  /// 浅色主题
  static CupertinoThemeData ligthTheme = const CupertinoThemeData(
    brightness: Brightness.light,
    barBackgroundColor: navigationBarBackground,
    // scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
  );

  /// 浅色主题
  static CupertinoThemeData ligthThemeSecondary = const CupertinoThemeData(
    brightness: Brightness.light,
    barBackgroundColor: navigationBarBackground,
    scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
  );

  /// 深色纯黑主题
  static CupertinoThemeData darkPureTheme = const CupertinoThemeData(
    brightness: Brightness.dark,
    barBackgroundColor: navigationBarBackground,
    // scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
  );

  static const CupertinoDynamicColor navigationBarBackground =
      CupertinoDynamicColor.withBrightness(
    debugLabel: 'navigationBarBackground',
    color: Color.fromARGB(222, 249, 249, 249),
    darkColor: Color.fromARGB(230, 20, 20, 20),
  );
}
