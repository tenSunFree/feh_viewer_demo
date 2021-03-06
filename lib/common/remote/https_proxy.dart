import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:feh_viewer_demo/common/remote/dns_cache.dart';
import 'package:feh_viewer_demo/common/remote/dns_service.dart';
import 'package:feh_viewer_demo/common/util/utility.dart';
import 'package:feh_viewer_demo/common/global.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:get/get.dart';

class CustomHttpsProxy {
  CustomHttpsProxy._internal();

  factory CustomHttpsProxy.getInstance() => _getInstance();

  static CustomHttpsProxy get instance => _getInstance();

  static CustomHttpsProxy _getInstance() {
    _instance ??= CustomHttpsProxy._internal();
    return _instance!;
  }

  static CustomHttpsProxy? _instance;
  ServerSocket? serverSocket;

  Future<ServerSocket?> init() async {
    if (serverSocket == null) {
      await ServerSocket.bind(InternetAddress.anyIPv4, kProxyPort)
          .then((ServerSocket serverSocket) {
        this.serverSocket = serverSocket;
        serverSocket.listen((Socket client) {
          try {
            ClientConnectionHandler(client).handle();
          } catch (e) {
            print('ClientConnectionHandler exception $e');
          }
        });
      }).catchError((e) {
        print('serverSocket 处理异常$e');
      });
    }
    return serverSocket;
  }

  void close() {
    if (serverSocket != null) {
      serverSocket?.close();
    }
  }
}

class ClientConnectionHandler {
  ClientConnectionHandler(this.client);

  final RegExp regx = RegExp(r'CONNECT ([^ :]+)(?::([0-9]+))? HTTP/1.1\r\n');

  Socket? server;
  Socket client;
  String content = '';
  late String _oriHost;
  late int port;

  final DnsService dnsConfigController = Get.find();

  void closeSockets() {
    if (server != null) {
      server?.destroy();
    }
    client.destroy();
  }

  Future<void> dataHandler(dynamic data) async {
    final List<DnsCache> _customHosts = dnsConfigController.hosts;
    final bool enableDoH = dnsConfigController.enableDoH.value;
    if (server == null) {
      content += utf8.decode(data);
      logger.d('\n$content');
      final RegExpMatch? m = regx.firstMatch(content);
      if (m != null) {
        _oriHost = m.group(1)!;
        port = m.group(2) == null ? 443 : int.parse(m.group(2)!);
        if (enableDoH) {
          await dnsConfigController.updateDoHCache(_oriHost);
        }
        String realHost = _oriHost;
        try {
          final List<DnsCache> _dohDnsCacheList = dnsConfigController.dohCache;
          final int customDnsCacheIndex = _customHosts
              .indexWhere((DnsCache element) => element.host == _oriHost);
          final DnsCache? customDnsCache = customDnsCacheIndex > -1
              ? _customHosts[customDnsCacheIndex]
              : null;
          if (enableDoH) {
            final int _dohDnsCacheIndex = dnsConfigController.dohCache
                .indexWhere((DnsCache element) => element.host == _oriHost);
            final DnsCache? dohDnsCache = _dohDnsCacheIndex > -1
                ? _dohDnsCacheList[_dohDnsCacheIndex]
                : null;
            if (dnsConfigController.enableCustomHosts.value) {
              realHost = customDnsCache?.addr ?? dohDnsCache?.addr ?? _oriHost;
            } else {
              realHost = dohDnsCache?.addr ?? _oriHost;
            }
          } else {
            realHost = customDnsCache?.addr ?? _oriHost;
          }
        } catch (e, stack) {
          logger.e('$e \n $stack');
          closeSockets();
        }
        logger.i('$_oriHost  =>  $realHost');
        try {
          ServerConnectionHandler(realHost, port, this)
              .handle()
              .catchError((e) {
            logger.e('Server error $e');
            closeSockets();
          });
        } catch (e) {
          logger.e('Server exception $e');
          closeSockets();
        }
      }
    } else {
      final String hex = EHUtils.formatBytesAsHexString(data);
      if (hex.contains(EHUtils.stringToHex('e-hentai.org')) ||
          hex.contains(EHUtils.stringToHex('exhentai.org')) ||
          hex.contains(EHUtils.stringToHex('ehgt.org')) ||
          hex.contains(EHUtils.stringToHex('hath.network'))) {
        logger.i('client hello [$hex]');
        data = EHUtils.createUint8ListFromHexString(hex);
      }
      try {
        server?.add(data);
      } catch (e) {
        print('sever has been shut down');
        closeSockets();
      }
    }
  }

  void errorHandler(error, StackTrace trace) {
    print('client socket error: $error');
  }

  void doneHandler() {
    closeSockets();
  }

  void handle() {
    client.listen(dataHandler,
        onError: errorHandler, onDone: doneHandler, cancelOnError: true);
  }
}

class ServerConnectionHandler {
  ServerConnectionHandler(this.host, this.port, this.handler) {
    client = handler.client;
  }

  final String responce = 'HTTP/1.1 200 Connection Established\r\n\r\n';
  final String host;
  final int port;
  final ClientConnectionHandler handler;
  Socket? server;
  Socket? client;
  String content = '';

  void dataHandler(Uint8List data) {
    try {
      client?.add(data);
    } on Exception catch (e) {
      print('client has been shut down $e');
      handler.closeSockets();
    }
  }

  void errorHandler(error, StackTrace trace) {
    logger.e('server socket error: $error \n $trace');
    handler.closeSockets();
    throw error;
  }

  void doneHandler() {
    handler.closeSockets();
  }

  Future handle() async {
    server = await Socket.connect(host, port,
        timeout: const Duration(milliseconds: 10000));
    server?.listen(dataHandler,
        onError: errorHandler, onDone: doneHandler, cancelOnError: true);
    handler.server = server;
    client?.write(responce);
  }
}

class HttpProxy extends HttpOverrides {
  HttpProxy(this.host, this.port);

  String? host;
  String? port;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true;
    };
    return client;
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    if (host == null) {
      return super.findProxyFromEnvironment(url, environment);
    }
    environment ??= {};
    if (port != null) {
      environment['http_proxy'] = '$host:$port';
      environment['https_proxy'] = '$host:$port';
    } else {
      environment['http_proxy'] = '$host:8888';
      environment['https_proxy'] = '$host:8888';
    }
    return super.findProxyFromEnvironment(url, environment);
  }
}
