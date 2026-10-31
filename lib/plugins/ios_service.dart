import 'dart:convert';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter/services.dart';

import 'service.dart';

abstract mixin class IosServiceListener {
  void onServiceCrash(String message) {}

  void onServiceStatus(String status, int runTime) {}
}

bool dispatchIosServiceCall(MethodCall call, List<ServiceListener> listeners) {
  final void Function(IosServiceListener) deliver;
  switch (call.method) {
    case 'status':
      try {
        final data = jsonDecode(call.arguments as String? ?? '{}') as Map;
        final status = data['status'] as String? ?? '';
        final runTime = data['runTime'] as int? ?? 0;
        deliver = (listener) => listener.onServiceStatus(status, runTime);
      } catch (error) {
        commonPrint.log(
          'Unable to decode iOS service status: $error',
          logLevel: LogLevel.error,
        );
        return true;
      }
    case 'crash':
      final message = call.arguments as String? ?? '';
      deliver = (listener) => listener.onServiceCrash(message);
    default:
      return false;
  }
  for (final listener in listeners.whereType<IosServiceListener>()) {
    try {
      deliver(listener);
    } catch (error) {
      commonPrint.log(
        'Unable to dispatch iOS service ${call.method}: $error',
        logLevel: LogLevel.error,
      );
    }
  }
  return true;
}

extension IosServiceMethods on Service {
  Future<bool> ping() async {
    try {
      final response = await methodChannel.invokeMethod<Object?>(
        'invokeMethod',
        json.encode({'method': 'ping'}),
      );
      return response != null;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setXboardDirectAddresses(List<String> addresses) async {
    try {
      return await methodChannel.invokeMethod<bool>(
            'setXboardDirectAddresses',
            addresses,
          ) ??
          false;
    } catch (_) {
      return false;
    }
  }

  Future<IosCoreState?> coreState() async {
    try {
      final response = await methodChannel.invokeMethod<Object?>(
        'invokeMethod',
        json.encode({'method': 'getCoreState'}),
      );
      final String? text;
      if (response is String) {
        text = response;
      } else if (response is Uint8List) {
        text = utf8.decode(response);
      } else {
        text = null;
      }
      if (text == null) return null;
      final data = json.decode(text);
      if (data is! Map || !data.containsKey('coreBooted')) return null;
      return IosCoreState(
        booted: data['coreBooted'] == true,
        tunStarted: data['tunStarted'] == true,
        error: (data['error'] as String?) ?? '',
      );
    } catch (_) {
      return null;
    }
  }

  Future<String> saveState(SharedState state) async {
    return await methodChannel.invokeMethod<String>(
          'saveState',
          json.encode(state),
        ) ??
        '';
  }
}

class IosCoreState {
  const IosCoreState({
    required this.booted,
    required this.tunStarted,
    required this.error,
  });

  final bool booted;
  final bool tunStarted;
  final String error;
}
