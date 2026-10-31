import 'package:fl_clash/common/provider_reader.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flClashGatewayProvider = Provider<FlClashGateway>(
  (ref) => FlClashGateway(ref.read),
);

class FlClashGateway {
  const FlClashGateway(this._read);

  final ProviderReader _read;

  Future<bool> setRunning(bool running) =>
      _read(setupActionProvider.notifier).setRunning(running);

  void toggleRunning() => _read(commonActionProvider.notifier).toggleRunning();

  void changeMode(Mode mode) =>
      _read(setupActionProvider.notifier).changeMode(mode);

  Future<void> selectProxy({
    required String groupName,
    required String proxyName,
  }) => _read(
    proxiesActionProvider.notifier,
  ).changeProxy(groupName: groupName, proxyName: proxyName);

  Future<void> testProxy(Proxy proxy, [String? testUrl]) =>
      _read(proxiesActionProvider.notifier).proxyDelayTest(proxy, testUrl);

  Future<void> testProxies(List<Proxy> proxies, [String? testUrl]) =>
      _read(proxiesActionProvider.notifier).delayTest(proxies, testUrl);

  void installProfile(Profile profile) {
    _read(profilesProvider.notifier).put(profile);
    _read(currentProfileIdProvider.notifier).value = profile.id;
  }

  Future<bool> applyProfile() =>
      _read(setupActionProvider.notifier).applyProfile(silence: true);

  Future<void> deleteProfile(int id) =>
      _read(profilesActionProvider.notifier).deleteProfile(id);
}
