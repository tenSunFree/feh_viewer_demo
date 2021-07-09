import 'package:feh_viewer_demo/common/remote/api.dart';
import 'package:feh_viewer_demo/home/model/home_entity.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tuple/tuple.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';

typedef FetchCallBack = Future<Tuple2<List<HomeEntity>, int>> Function();

class HomeViewController extends GetxController
    with StateMixin<List<HomeEntity>> {
  late FetchCallBack fetchNormal;

  @override
  void onInit() {
    fetchNormal = Api.getPopular;
    super.onInit();
    firstLoad();
  }

  Future<void> firstLoad() async {
    try {
      final Tuple2<List<HomeEntity>, int> tuple = await fetchData();
      List<HomeEntity> _listItem = tuple.item1;
      change(_listItem, status: RxStatus.success());
    } catch (err) {
      logger.d('TabViewController, firstLoad, err: ${err.toString()}');
      change(null, status: RxStatus.error(err.toString()));
    }
  }

  Future<Tuple2<List<HomeEntity>, int>> fetchData() async {
    final Future<Tuple2<List<HomeEntity>, int>> tuple = fetchNormal();
    return tuple;
  }

  Future<void> reloadDataFirst() async {
    change(null, status: RxStatus.loading());
    onInit();
  }
}
