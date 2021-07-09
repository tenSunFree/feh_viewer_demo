import 'package:feh_viewer_demo/home/view/home_error_view.dart';
import 'package:feh_viewer_demo/home/view/home_list_item_widget.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/home/controller/home_controller.dart';
import 'package:feh_viewer_demo/home/model/home_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeViewController> {
  @override
  Widget build(BuildContext context) {
    logger.d('PopularListTab, build');
    return CupertinoPageScaffold(
        child: CupertinoScrollbar(
            child: Column(children: <Widget>[
      Image.asset('assets/icon_home_top_bar.png', width: double.infinity),
      Expanded(
          child: CustomScrollView(slivers: <Widget>[
        SliverSafeArea(top: false, sliver: _buildListSliver())
      ]))
    ])));
  }

  Widget _buildListSliver() {
    return controller.obx(
        (List<HomeEntity>? entityList) => _onSuccess(entityList!),
        onLoading: _onLoading(),
        onError: _onError);
  }

  Widget _onSuccess(List<HomeEntity> entityList) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      final HomeEntity _entity = entityList[index];
      return HomeListItemWidget(entity: _entity);
    }, childCount: entityList.length));
  }

  Widget _onLoading() {
    return SliverFillRemaining(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 50),
            child: const CupertinoActivityIndicator(radius: 14.0)));
  }

  Widget _onError(err) {
    logger.d('HomeView, _buildListSliver, err: $err');
    return SliverFillRemaining(
        child: Container(
            padding: const EdgeInsets.only(bottom: 50),
            child: HomeErrorView(onTap: controller.reloadDataFirst)));
  }
}
