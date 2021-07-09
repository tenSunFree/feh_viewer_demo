import 'package:cached_network_image/cached_network_image.dart';
import 'package:feh_viewer_demo/home/controller/home_list_item_controller.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/home/model/home_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class HomeListItemWidget extends StatelessWidget {
  HomeListItemWidget({required this.entity}) {
    _galleryItemController =
        Get.put(HomeListItemController(entity), tag: entity.id.toString());
  }

  final HomeEntity entity;

  // final String tabTag1;

  late HomeListItemController _galleryItemController;

  @override
  Widget build(BuildContext context) {
    logger.d('GalleryItemWidget, build');
    return GestureDetector(
      child: Center(
        child: _buildItem(),
      ),
      behavior: HitTestBehavior.opaque,
      onTap: () => _galleryItemController.onTap(),
      onTapDown: _galleryItemController.onTapDown,
      onTapUp: _galleryItemController.onTapUp,
      onTapCancel: _galleryItemController.onTapCancel,
      onLongPress: _galleryItemController.onLongPress,
    );
  }

  Widget _buildItem() {
    return Obx(() => Column(
          children: <Widget>[
            Container(
              color: _galleryItemController.colorTap.value,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    // 封面图片
                    _buildCoverImage(),
                    Container(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        _galleryItemController.galleryItem.title ?? '',
                        style: const TextStyle(
                            fontSize: 12, color: CupertinoColors.systemGrey),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            Divider(
              height: 0.5,
              indent: 8,
              color: CupertinoDynamicColor.resolve(
                  CupertinoColors.systemGrey4, Get.context!),
            ),
          ],
        ));
  }

  /// 构建封面图片
  Widget _buildCoverImage() {
    final HomeEntity _item = _galleryItemController.galleryItem;
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Hero(
        tag: '${_item.title}_cover_=',
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            //阴影
            BoxShadow(
              color: CupertinoDynamicColor.resolve(
                  CupertinoColors.systemGrey4, Get.context!),
              blurRadius: 10,
            )
          ]),
          child: ClipRRect(
            // 圆角
            borderRadius: BorderRadius.circular(6),
            child: CoverImg(
              imgUrl: _item.thumbnailUrl ?? '',
              height: 50,
            ),
          ),
        ),
      ),
    );
  }
}

/// 封面图片Widget
class CoverImg extends StatelessWidget {
  const CoverImg({
    Key? key,
    required this.imgUrl,
    this.height,
    this.width,
  }) : super(key: key);

  final String imgUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    // final EhConfigService ehConfigService = Get.find();
    final Map<String, String> _httpHeaders = {
      'Cookie': '',
    };

    Widget image() {
      if (imgUrl != null && imgUrl.isNotEmpty) {
        return CachedNetworkImage(
          placeholder: (_, __) {
            return Container(
              alignment: Alignment.center,
              color: CupertinoDynamicColor.resolve(
                  CupertinoColors.systemGrey5, context),
              child: const CupertinoActivityIndicator(),
            );
          },
          // height: height,
          width: width,
          httpHeaders: _httpHeaders,
          imageUrl: imgUrl,
          fit: BoxFit.contain,
        );
      } else {
        return Container();
      }
    }

    return image();
  }
}
