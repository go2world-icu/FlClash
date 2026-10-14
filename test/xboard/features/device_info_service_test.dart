import 'dart:io';

import 'package:fl_clash/xboard/features/remote_task/services/device_info_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeviceInfoService.collectSystemResources', () {
    test('reports dart runtime platform facts', () async {
      final result = await DeviceInfoService.collectSystemResources();
      expect(result['status'], 'success');
      final system = result['system_resources'] as Map<String, dynamic>;
      expect(system['platform'], Platform.operatingSystem);
      final runtime = system['runtime_info'] as Map<String, dynamic>;
      expect(runtime['number_of_processors'], Platform.numberOfProcessors);
      expect(runtime['dart_version'], Platform.version);
      expect(runtime['locale_name'], Platform.localeName);
    });
  });

  group('DeviceInfoService.collectAppRuntimeInfo', () {
    test('reports the dart vm version', () async {
      final result = await DeviceInfoService.collectAppRuntimeInfo();
      expect(result['status'], 'success');
      final runtime = result['runtime_info'] as Map<String, dynamic>;
      expect(runtime['platform'], Platform.operatingSystem);
      expect((runtime['dart_vm_info'] as Map)['version'], Platform.version);
    });
  });

  group('DeviceInfoService plugin-backed collectors', () {
    // These reach platform channels that are absent under `flutter test`, so we
    // assert the shape of the result rather than assuming plugin availability.
    test('collectBasicDeviceInfo never throws', () async {
      final result = await DeviceInfoService.collectBasicDeviceInfo();
      expect(result['status'], anyOf('success', 'error'));
      if (result['status'] == 'error') {
        expect(result['error_message'], contains('收集设备信息时发生错误'));
      } else {
        expect(result['device_info'], isA<Map<String, dynamic>>());
      }
    });

    test('collectNetworkInfo never throws', () async {
      final result = await DeviceInfoService.collectNetworkInfo();
      expect(result['status'], anyOf('success', 'error'));
      if (result['status'] == 'error') {
        expect(result['error_message'], contains('收集网络信息时发生错误'));
      }
    });
  });
}
