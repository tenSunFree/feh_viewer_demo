import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeErrorView extends StatelessWidget {
  const HomeErrorView({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CupertinoButton(
            onPressed: onTap,
            child: Icon(FontAwesomeIcons.syncAlt,
                size: 50,
                color: CupertinoDynamicColor.resolve(
                    CupertinoColors.systemGrey, context))));
  }
}
