import 'dart:async';
import 'dart:convert';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/event.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/core/spill.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

final _utf8JsonDecoder = utf8.decoder.fuse(json.decoder);

Object? _decodeUtf8Json(Uint8List data) => _utf8JsonDecoder.convert(data);

Map<String, Object?> _decodeResponseOf((Uint8List, CoreMethod) request) {
  final (data, method) = request;
  final decoded = _decodeUtf8Json(data);
  return withResultModel(method, Map<String, Object?>.from(decoded as Map));
}

Future<Map<String, Object?>> _decodeResponse(
  Uint8List data,
  CoreMethod method,
) async {
  if (data.length < 51200) {
    return _decodeResponseOf((data, method));
  }
  return compute(_decodeResponseOf, (data, method));
}

abstract mixin class ServiceListener {
  void onServiceEvent(CoreEvent event) {}

  void onServiceStopped() {}

  void onServiceCrash(String message) {}

  /// iOS only: NEVPNStatus transitions (connected/disconnected/...),
  /// with the current tunnel run time in milliseconds.
  void onServiceStatus(String status, int runTime) {}
}

class Service {
  static Service? _instance;
  late MethodChannel methodChannel;
  static const _coreChannel = MethodChannel('$packageName/core');

  final ObserverList<ServiceListener> _listeners =
      ObserverList<ServiceListener>();

  int _commandRevision = 0;
  bool _startRequested = false;

  factory Service() {
    _instance ??= Service._internal();
    return _instance!;
  }

  Service._internal() {
    methodChannel = const MethodChannel('$packageName/service');
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'event':
          final methodCall = CoreMethodCall.fromJson(
            Map<String, Object?>.from(
              _decodeUtf8Json(call.arguments as Uint8List) as Map,
            ),
          );
          for (final event in coreEventsFromData(methodCall.arguments)) {
            _dispatch(
              'Core event ${event.type.name}',
              (listener) => listener.onServiceEvent(event),
            );
          }
          break;
        case 'stopped':
          // A report stamped before the newest command no longer describes it.
          if (call.arguments != _commandRevision || !_startRequested) {
            break;
          }
          _startRequested = false;
          _dispatch('stop report', (listener) => listener.onServiceStopped());
          break;
        case 'status':
          // iOS only: NEVPNStatus transition (connected/disconnected/...)
          // + tunnel run time, pushed by ServiceChannel. Without this the
          // connected flag that gates CoreHandlerInterface calls is never set
          // and every invoke blocks until the 10s timeout.
          final data = call.arguments as String? ?? '{}';
          try {
            final json = Map<String, dynamic>.from(jsonDecode(data) as Map);
            final status = json['status'] as String? ?? '';
            final runTime = json['runTime'] as int? ?? 0;
            for (final listener in _listeners) {
              listener.onServiceStatus(status, runTime);
            }
          } catch (error) {
            commonPrint.log(
              'Unable to dispatch iOS service status: $error',
              logLevel: LogLevel.error,
            );
          }
          break;
        case 'crash':
          // iOS only: fatal NE/tunnel failure reason pushed by ServiceChannel.
          final message = call.arguments as String? ?? '';
          for (final listener in _listeners) {
            listener.onServiceCrash(message);
          }
          break;
        default:
          throw MissingPluginException();
      }
    });
  }

  Future<CoreMethodResponse?> invokeMethod(CoreMethodCall call) async {
    final data = await _coreChannel.invokeMethod<Uint8List>(
      'invokeMethod',
      json.encode(call),
    );
    if (data == null) {
      return null;
    }
    return resolveSpilledResponse(
      CoreMethodResponse.fromJson(await _decodeResponse(data, call.method)),
      method: call.method,
    );
  }

  /// Not a core method: the packet tunnel provider answers `ping` itself,
  /// without reaching the Go core. That is the point — it separates "the app
  /// can reach the NE" from "the core inside it answers", which otherwise both
  /// look like a failed call.
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

  /// What the packet tunnel provider knows about the core by itself, answered
  /// locally rather than by calling into the core.
  ///
  /// `getIsInit` cannot tell "the core never booted" from "the call into it
  /// never came back" — both arrive as no answer. The extension can, because it
  /// is the one that booted the core.
  Future<IosCoreState?> coreState() async {
    try {
      final response = await methodChannel.invokeMethod<Object?>(
        'invokeMethod',
        json.encode({'method': 'getCoreState'}),
      );
      // The channel answers in bytes; plain strings are still accepted so a
      // provider that has not been rebuilt yet does not read as "not booted".
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

  void _dispatch(String label, void Function(ServiceListener) deliver) {
    for (final listener in List.of(_listeners)) {
      try {
        deliver(listener);
      } catch (error) {
        commonPrint.log(
          'Unable to dispatch Android $label: $error',
          logLevel: LogLevel.error,
        );
      }
    }
  }

  Future<bool> start() async {
    _startRequested = true;
    return await methodChannel.invokeMethod<bool>(
          'start',
          ++_commandRevision,
        ) ??
        false;
  }

  Future<bool> stop() async {
    _startRequested = false;
    return await methodChannel.invokeMethod<bool>('stop', ++_commandRevision) ??
        false;
  }

  Future<String> init() async {
    return await methodChannel.invokeMethod<String>('init') ?? '';
  }

  Future<String> syncState(SharedState state) async {
    return await methodChannel.invokeMethod<String>(
          'syncState',
          json.encode(state),
        ) ??
        '';
  }

  /// iOS only: persist the full SharedState (including setupParams) into the
  /// App Group so the PacketTunnel extension can boot the core headlessly.
  Future<String> saveState(SharedState state) async {
    return await methodChannel.invokeMethod<String>(
          'saveState',
          json.encode(state),
        ) ??
        '';
  }

  Future<bool> shutdown() async {
    return await methodChannel.invokeMethod<bool>('shutdown') ?? true;
  }

  Future<DateTime?> getRunTime() async {
    final ms = await methodChannel.invokeMethod<int>('getRunTime') ?? 0;
    if (ms == 0) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  void addListener(ServiceListener listener) {
    _listeners.add(listener);
  }

  void removeListener(ServiceListener listener) {
    _listeners.remove(listener);
  }
}

Service? get service => system.isMobile ? Service() : null;

/// The packet tunnel provider's own view of the core. See [Service.coreState].
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
