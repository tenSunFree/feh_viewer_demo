import 'package:feh_viewer_demo/common/util/toast.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/home/model/home_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeListItemController extends GetxController {
  HomeListItemController(this.galleryItem);

  /// 点击item
  void onTap() {
    logger.d('onTaponTaponTaponTaponTaponTap ');
    // NavigatorUtil.goGalleryPage(galleryItem: galleryItem, tabTag: tabTag);
  }

  void onTapDown(_) => _updatePressedColor();

  void onTapUp(_) {
    Future<void>.delayed(const Duration(milliseconds: 150), () {
      _updateNormalColor();
    });
  }

  void onTapCancel() => _updateNormalColor();

  @override
  void onInit() {
    super.onInit();
    if (galleryItem.title != null && galleryItem.title!.isNotEmpty) {
      isFav = true;
    }
  }

  final RxBool _isFav = false.obs;

  bool get isFav => _isFav.value;

  set isFav(bool val) => _isFav.value = val;

  void setFavTitle({String favTitle = '', String? favcat}) {
    // logger.d('setFavTitle ');
    // galleryItem = galleryItem.copyWith(title: favTitle);
    isFav = favTitle.isNotEmpty;
    if (favcat != null || (favcat?.isNotEmpty ?? false)) {
      // alleryItem = galleryItem.copyWith(favcat: favcat);
      logger.d('item set favcat $favcat');
    } else {
      //  g// alleryItem = galleryItem.copyWith(favcat: '', favTitle: '');
    }
  }

  String get title {
    return galleryItem.title ?? '';
  }

  // late List<GalleryPreview> firstPagePreview;
  HomeEntity galleryItem;

  Rx<Color?> colorTap = const Color.fromARGB(0, 0, 0, 0).obs;

  void _updateNormalColor() {
    colorTap.value = Colors.transparent;
  }

  void _updatePressedColor() {
    colorTap.value = CupertinoDynamicColor.resolve(
        CupertinoColors.systemGrey4, Get.context!);
  }

  set localFav(bool value) {
    // galleryItem.localFav = value;
    // galleryItem = galleryItem.copyWith(localFav: localFav);
    update();
  }

  bool get localFav => false;

  Future<void> _showLongPressSheet() async {}

  void onLongPress() {
    toast('onLongPress');
  }
}
