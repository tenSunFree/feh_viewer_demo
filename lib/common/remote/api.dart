import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:feh_viewer_demo/common/const.dart';
import 'package:feh_viewer_demo/common/remote/dio.dart';
import 'package:feh_viewer_demo/common/global.dart';
import 'package:feh_viewer_demo/common/remote/https_proxy.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:feh_viewer_demo/home/model/home_entity.dart';
import 'package:tuple/tuple.dart';

final Api api = Api();

class Api {
  Api() {
    final String _baseUrl = Const.BASE_URL;
    httpManager = HttpManager.getInstance(baseUrl: _baseUrl);
  }

  late HttpManager httpManager;
  static PersistCookieJar? _cookieJar;

  static Future<PersistCookieJar> get cookieJar async {
    if (_cookieJar == null) {
      print('获取的文件系统目录 appSupportPath： ' + Global.appSupportPath);
      _cookieJar =
          PersistCookieJar(storage: FileStorage(Global.appSupportPath));
    }
    return _cookieJar!;
  }

  static HttpManager getHttpManager({
    bool cache = true,
    String? baseUrl,
    int? connectTimeout,
  }) {
    final String _baseUrl = Const.BASE_URL;
    return HttpManager(baseUrl ?? _baseUrl,
        cache: cache, connectTimeout: connectTimeout);
  }

  static dio.Options getCacheOptions(
      {bool forceRefresh = false, dio.Options? options}) {
    return buildCacheOptions(
      const Duration(days: 5),
      maxStale: const Duration(days: 7),
      forceRefresh: forceRefresh,
      options: options,
    );
  }

  static String getBaseUrl({bool? isSiteEx}) {
    return Const.BASE_URL;
  }

  /// 获取热门画廊列表
  static Future<Tuple2<List<HomeEntity>, int>> getPopular({
    int? page,
    String? fromGid,
    int? cats,
    bool refresh = false,
    // SearchType searchType = SearchType.normal,
    dio.CancelToken? cancelToken,
    String? favcat,
  }) async {
    logger.d('Api, getPopular');
    logger.d('Api, getPopular, '
        'getBaseUrl: ${getBaseUrl()}');
    // logger.d('getPopular');
    // https://jsonplaceholder.typicode.com/photos
    const String url = '/photos';

    await CustomHttpsProxy.instance.init();
    final dio.Options _cacheOptions = getCacheOptions(forceRefresh: refresh);

    final String response =
        await getHttpManager().get(url, options: _cacheOptions) ?? '';

    // logger.d('Api, getPopular, response: $response');
    logger.d('Api, getPopular, response2');

    List<HomeEntity> list = (json.decode(response) as List)
        .map((data) => HomeEntity().fromJson(data))
        .toList();

    logger.d('Api, getPopular, list: ${list.length}');
    list.forEach((element) {
      // logger.d('Api, getPopular, element: ${element.title}');
    });

    int _maxPage = 0;
    return Tuple2(list, _maxPage);
  }
}