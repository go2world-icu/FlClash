import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/event.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract mixin class ServiceListener {
  void onServiceEvent(CoreEvent event) {}

  void onServiceCrash(String message) {}

  /// iOS only: NEVPNStatus transitions (connected/disconnected/...),
  /// with the current tunnel run time in milliseconds.
  void onServiceStatus(String status, int runTime) {}
}

class Service {
  static Service? _instance;
  late MethodChannel methodChannel;
  ReceivePort? receiver;

  final ObserverList<ServiceListener> _listeners =
      ObserverList<ServiceListener>();

  factory Service() {
    _instance ??= Service._internal();
    return _instance!;
  }

  Service._internal() {
    methodChannel = const MethodChannel('$packageName/service');
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'event':
          final data = call.arguments as String? ?? '';
                    final methodCall = CoreMethodCall.fromJson(
            Map<String, Object?>.from(json.decode(data) as Map),
          );
          for (final event in coreEventsFromData(methodCall.arguments)) {
            for (final listener in _listeners) {
              try {
                listener.onServiceEvent(event);
              } catch (error) {
                commonPrint.log(
                  'Unable to dispatch Android Core event '
                  '${event.type.name}: $error',
                  logLevel: LogLevel.error,
                );
              }
            }
          }
          break;
        case 'status':
          // iOS only: NEVPNStatus transition (connected/disconnected/...)
          // + tunnel run time, pushed by ServiceChannel. Without this the
          // connected flag that gates CoreHandlerInterface calls is never set
          // and every invoke blocks until the 10s timeout.
          final data = call.arguments as String? ?? '{}';
          try {
            final json = Map<String, dynamic>.from(
              jsonDecode(data) as Map,
            );
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
    final data = await methodChannel.invokeMethod<String>(
      'invokeMethod',
      json.encode(call),
    );
    if (data == null) {
      return null;
    }
    final dataJson = await data.commonToJSON<dynamic>();
    return CoreMethodResponse.fromJson(dataJson);
  }

  Future<bool> start() async {
    return await methodChannel.invokeMethod<bool>('start') ?? false;
  }

  Future<bool> stop() async {
    return await methodChannel.invokeMethod<bool>('stop') ?? false;
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
