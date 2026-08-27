import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';

import 'desktop/model.dart';
import 'interface.dart';
import 'method.dart';

class CoreLib extends CoreHandlerInterface {
  static CoreLib? _instance;

  Completer<bool> _connectedCompleter = Completer<bool>();
  Future<CoreLifecycleResult>? _closeOperation;
  int _lifecycleRevision = 0;
  int _methodCallId = 0;
  bool _closed = false;

  CoreLib._internal();

  factory CoreLib() {
    _instance ??= CoreLib._internal();
    return _instance!;
  }

  /// Called by the iOS tunnel once [ServiceListener.onServiceStatus] reports
  /// `connected` — only then is the Go core inside the NEProvider actually
  /// reachable, so pending [CoreHandlerInterface] calls can proceed.
  void markConnected() {
    if (!_connectedCompleter.isCompleted) {
      _connectedCompleter.complete(true);
    }
  }

  @override
  Future<CoreLifecycleResult> start() async {
    if (_closed) {
      throw StateError('Core lifecycle is closed');
    }
    final revision = ++_lifecycleRevision;
    if (_connectedCompleter.isCompleted) {
      return CoreLifecycleResult(
        revision: revision,
        outcome: CoreLifecycleOutcome.coalesced,
      );
    }
    final initializationError = await service?.init() ?? '';
    if (initializationError.isNotEmpty) {
      throw StateError(initializationError);
    }
    final syncError =
        await service?.syncState(
          globalState.container.read(sharedStateProvider),
        ) ??
        '';
    if (syncError.isNotEmpty) {
      _connectedCompleter = Completer<bool>();
      await service?.shutdown();
      throw StateError(syncError);
    }
    // iOS: the core lives inside the PacketTunnel NEProvider and is only
    // reachable once the tunnel connects. Kick off the tunnel NOW so the
    // core boots headlessly; the status callback (IosManager markConnected /
    // onServiceStatus) completes _connectedCompleter when it is up. Until
    // then, CoreHandlerInterface calls wait on the connected flag.
    if (system.isIOS) {
      await service?.start();
      await _connectedCompleter.future;
    } else {
      _connectedCompleter.complete(true);
    }
    return CoreLifecycleResult(
      revision: revision,
      outcome: CoreLifecycleOutcome.applied,
    );
  }

  @override
  Future<CoreLifecycleResult> restart() async {
    await stop();
    return start();
  }

  @override
  Future<CoreLifecycleResult> stop() => _stop();

  Future<CoreLifecycleResult> _stop({bool allowClosed = false}) async {
    if (_closed && !allowClosed) {
      throw StateError('Core lifecycle is closed');
    }
    final revision = ++_lifecycleRevision;
    if (!_connectedCompleter.isCompleted) {
      return CoreLifecycleResult(
        revision: revision,
        outcome: CoreLifecycleOutcome.coalesced,
      );
    }
    _connectedCompleter = Completer<bool>();
    final stopped = await service?.shutdown() ?? true;
    if (!stopped) {
      throw StateError('Android Core service shutdown failed');
    }
    return CoreLifecycleResult(
      revision: revision,
      outcome: CoreLifecycleOutcome.applied,
    );
  }

  @override
  Future<CoreLifecycleResult> close() {
    return _closeOperation ??= _close();
  }

  Future<CoreLifecycleResult> _close() async {
    _closed = true;
    return _stop(allowClosed: true);
  }

  @override
  Future<bool> startListener() async {
    final listenerStarted = await super.startListener();
    final serviceStarted = await service?.start() ?? false;
    return listenerStarted && serviceStarted;
  }

  @override
  Future<bool> stopListener() async {
    final serviceStopped = await service?.stop() ?? false;
    final listenerStopped = await super.stopListener();
    return serviceStopped && listenerStopped;
  }

  @override
  Future<T?> invokeMethod<T>({
    required CoreMethod method,
    Object? arguments,
    Duration? timeout,
  }) async {
    try {
      await _connectedCompleter.future.timeout(const Duration(seconds: 10));
    } catch (error) {
      commonPrint.log(
        'Invoke method ${method.name} before connection timed out: $error',
        logLevel: coreFailureLogLevel(error),
      );
      return null;
    }
    final id = '${++_methodCallId}';
    final response = await service
        ?.invokeMethod(
          CoreMethodCall(id: id, method: method, arguments: arguments),
        )
        .withTimeout(timeout: timeout, onTimeout: () => null);
    if (response == null) {
      return null;
    }
    return response.unwrap<T>();
  }
}

CoreLib? get coreLib => system.isMobile ? CoreLib() : null;
