import 'package:feh_viewer_demo/common/remote/dns_cache.dart';
import 'package:feh_viewer_demo/common/remote/dns.dart';
import 'package:feh_viewer_demo/common/util/logger.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'base_service.dart';

const String _regExpIP = r'(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}';

class DnsService extends ProfileService {
  RxBool enableCustomHosts = false.obs;
  RxBool enableDoH = false.obs;
  RxBool enableDomainFronting = false.obs;
  final RxList<DnsCache> _hosts = <DnsCache>[].obs;
  final RxList<DnsCache> _dohCache = <DnsCache>[].obs;

  RxList<DnsCache> get hosts => _hosts;

  RxList<DnsCache> get dohCache => _dohCache;

  void removeCustomHostAt(int index) {
    _hosts.removeAt(index);
  }

  bool addCustomHost(String host, String addr) {
    /// 检查
    if (host.isEmpty) {
      showToast('host无效');
      return false;
    }
    if (!RegExp(_regExpIP).hasMatch(addr)) {
      showToast('地址无效');
      return false;
    }
    if (host.isNotEmpty && addr.isNotEmpty) {
      final int index =
          _hosts.indexWhere((DnsCache element) => element.host == host);
      if (index < 0) {
        _hosts.add(DnsCache(
          host: host,
          addr: addr,
          ttl: 0,
          lastResolve: 0,
          addrs: [],
        ));
      } else {
        _hosts[index] = _hosts[index].copyWith(addr: addr);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateDoHCache(String host) async {
    if (host == 'cloudflare-dns.com') {
      return;
    }
    const int updateInterval = 86400;
    final int index =
        dohCache.indexWhere((DnsCache element) => element.host == host);
    final DnsCache? dnsCache = index >= 0 ? dohCache[index] : null;
    final int nowTime = DateTime.now().millisecondsSinceEpoch;
    if (dnsCache != null) {
      if (dnsCache.lastResolve != null &&
          nowTime - (dnsCache.lastResolve ?? -1) > updateInterval) {
        logger.wtf(' updateDoHCache $host');
        final String _addr = await DnsUtil.doh(host);
        dohCache[index] = dnsCache.copyWith(lastResolve: nowTime, addr: _addr);
      }
    } else {
      final String _addr = await DnsUtil.doh(host);
      dohCache.add(DnsCache(
        host: host,
        lastResolve: nowTime,
        addr: _addr,
        ttl: -1,
        addrs: [],
      ));
    }
  }
}
