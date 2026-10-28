import 'dart:io';

import 'package:fl_clash/plugins/service.dart';
import 'package:flutter/services.dart';

class IosBoardResolver {
  static const _channel = MethodChannel('com.follow.clash/service');
  static Future<void> _routeQueue = Future.value();

  static Future<List<InternetAddress>> resolve(String host) async {
    final literal = InternetAddress.tryParse(host);
    final addresses = literal != null
        ? [literal]
        : (await _channel
                      .invokeListMethod<String>('resolveXboardHost', host)
                      .timeout(const Duration(seconds: 4)) ??
                  [])
              .map(InternetAddress.new)
              .toList();
    if (addresses.isEmpty) {
      throw const SocketException('XBoard physical DNS lookup failed');
    }
    final update = _routeQueue.then((_) async {
      if (!await Service()
          .setXboardDirectAddresses(
            addresses.map((address) => address.address).toList(),
          )
          .timeout(const Duration(seconds: 3), onTimeout: () => false)) {
        throw const SocketException('XBoard physical route unavailable');
      }
    });
    _routeQueue = update.catchError((Object _) {});
    await update;
    return addresses;
  }
}
