import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:feh_viewer_demo/common/const.dart';
import 'package:feh_viewer_demo/common/global.dart';
import 'package:feh_viewer_demo/common/remote/options.dart';
import 'package:feh_viewer_demo/common/remote/retry_interceptor.dart';
import 'package:feh_viewer_demo/common/util/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';

const int kDefconnectTimeout = 10000;
const int kDefreceiveTimeout = 10000;

class HttpManager {
  HttpManager(
    String _baseUrl, {
    bool cache = true,
    bool retry = false,
    int? connectTimeout = kDefconnectTimeout,
  }) {
    _options = BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: connectTimeout ?? kDefconnectTimeout,
        receiveTimeout: kDefreceiveTimeout,
        headers: <String, String>{
          'User-Agent': Const.CHROME_USER_AGENT,
          'Accept': Const.CHROME_ACCEPT,
          'Accept-Language': Const.CHROME_ACCEPT_LANGUAGE,
        },
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.json);
    _dio = Dio(_options);
    _dio.interceptors.add(Global.cookieManager);
    if (cache) {
      _dio.interceptors.add(DioCacheManager(
        CacheConfig(
          databasePath: Global.appSupportPath,
          baseUrl: _baseUrl,
        ),
      ).interceptor);
    }
    if (retry) {
      _dio.interceptors.add(RetryInterceptor(
          dio: _dio..options.extra.addAll({DIO_CACHE_KEY_FORCE_REFRESH: true}),
          options: RetryOptions(
            retries: 3, // Number of retries before a failure
            retryInterval:
                const Duration(seconds: 1), // Interval between each retry
            retryEvaluator: (error) =>
                error.type != DioErrorType.cancel &&
                error.type !=
                    DioErrorType
                        .response, // Evaluating if a retry is necessary regarding the error. It is a good candidate for updating authentication token in case of a unauthorized error (be careful with concurrency though)
          )));
    }
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      final HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return httpClient;
    };
  }

  static final Map<String, HttpManager> _instanceMap = <String, HttpManager>{};

  late Dio _dio;

  Dio get dio => _dio;
  late BaseOptions _options;

  static HttpManager getInstance(
      {String baseUrl = '', bool cache = true, bool retry = false}) {
    final String _key = '${baseUrl}_$cache';
    if (null == _instanceMap[_key]) {
      _instanceMap[_key] = HttpManager(baseUrl, cache: cache, retry: retry);
    }
    return _instanceMap[_key]!;
  }

  Future<String?> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Response<String> response;
    time.showTime('get $url start');
    try {
      response = await _dio.get<String>(url,
          queryParameters: params, options: options, cancelToken: cancelToken);
    } on DioError catch (e, stack) {
      logger.e('getHttp exception: $e\n$stack');
      formatError(e);
      rethrow;
    }
    time.showTime('get $url end');
    return response.data;
  }

  Future<Response<dynamic>> getAll(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    late Response<dynamic> response;
    try {
      response = await _dio.get<dynamic>(url,
          queryParameters: params, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      print('getHttp exception: $e');
      return response;
    }
    return response;
  }

  Future<Response<dynamic>> post(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    late Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(url,
          queryParameters: params, options: options, cancelToken: cancelToken);
      debugPrint('postHttp response: $response');
    } on DioError catch (e) {
      print('postHttp exception: $e');
      formatError(e);
    }
    return response;
  }

  Future<Response<dynamic>> postForm(
    String url, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    late Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(url,
          options: options, cancelToken: cancelToken, data: data);
    } on DioError catch (e) {
      formatError(e);
      rethrow;
    }
    return response;
  }

  Future<Response<dynamic>> downLoadFile(
      String urlPath, String savePath) async {
    late Response<dynamic> response;
    try {
      response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: (int count, int total) {
          print('$count $total');
        },
        options: Options(
          receiveTimeout: 0,
        ),
      );
      print('downLoadFile response: $response');
    } on DioError catch (e) {
      print('downLoadFile exception: $e');
      formatError(e);
    }
    return response;
  }

  void cancleRequests(CancelToken token) {
    token.cancel('cancelled');
  }

  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      showToast('连接超时');
    } else if (e.type == DioErrorType.sendTimeout) {
      showToast('请求超时');
    } else if (e.type == DioErrorType.receiveTimeout) {
      showToast('响应超时');
    } else if (e.type == DioErrorType.response) {
      showToast('响应异常');
    } else if (e.type == DioErrorType.cancel) {
      showToast('请求取消');
    } else {
      showToast('网络好像出问题了');
    }
  }
}
