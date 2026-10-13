import 'dart:io';

import 'error.dart';

class Target {
  const Target({required this.goos, required this.goarch, this.abi, this.sdk});

  final String goos;
  final String goarch;
  final String? abi;

  /// Apple SDK name (iOS only): `iphoneos` / `iphonesimulator`.
  final String? sdk;

  static const androidArm = Target(
    goos: 'android',
    goarch: 'arm',
    abi: 'armeabi-v7a',
  );
  static const androidArm64 = Target(
    goos: 'android',
    goarch: 'arm64',
    abi: 'arm64-v8a',
  );
  static const androidAmd64 = Target(
    goos: 'android',
    goarch: 'amd64',
    abi: 'x86_64',
  );

  // iOS is a c-archive static library, packaged into Libclash.xcframework.
  static const iosArm64 = Target(
    goos: 'ios',
    goarch: 'arm64',
    abi: 'ios-arm64',
    sdk: 'iphoneos',
  );
  static const iosSimArm64 = Target(
    goos: 'ios',
    goarch: 'arm64',
    abi: 'ios-arm64-simulator',
    sdk: 'iphonesimulator',
  );

  static const macosArm64 = Target(goos: 'darwin', goarch: 'arm64');
  static const macosAmd64 = Target(goos: 'darwin', goarch: 'amd64');

  static const linuxArm64 = Target(goos: 'linux', goarch: 'arm64');
  static const linuxAmd64 = Target(goos: 'linux', goarch: 'amd64');

  static const windowsAmd64 = Target(goos: 'windows', goarch: 'amd64');
  static const windowsArm64 = Target(goos: 'windows', goarch: 'arm64');

  static const all = [
    androidArm,
    androidArm64,
    androidAmd64,
    iosArm64,
    iosSimArm64,
    macosArm64,
    macosAmd64,
    linuxArm64,
    linuxAmd64,
    windowsAmd64,
    windowsArm64,
  ];

  static List<Target> forPlatform(String platform) =>
      all.where((target) => target.platformDir == platform).toList();

  static Target resolve({required String platform, required String goarch}) {
    for (final target in forPlatform(platform)) {
      if (target.goarch == goarch) return target;
    }
    throw BuildException('No $platform Core target for GOARCH $goarch');
  }

  /// Resolves an iOS slice by the Xcode SDK Flutter reports
  /// (`iphoneos` / `iphonesimulator`), which [resolve] cannot distinguish
  /// because both slices share GOARCH `arm64`.
  static Target resolveIos({required String sdk, required String goarch}) {
    for (final target in forPlatform('ios')) {
      if (target.sdk == sdk && target.goarch == goarch) return target;
    }
    throw BuildException('No iOS Core target for SDK $sdk and GOARCH $goarch');
  }

  bool get isLib => abi != null;

  /// iOS only supports `-buildmode=c-archive` (a static library).
  bool get isStaticLib => goos == 'ios';

  bool get hasHelper => goos == 'linux' || goos == 'windows';

  String get executableExtension => goos == 'windows' ? '.exe' : '';

  /// The static archive extension produced by `-buildmode=c-archive`.
  String get staticLibExtension => '.a';

  String get platformDir => goos == 'darwin' ? 'macos' : goos;

  /// iOS cross-compiles from macOS: only there do `xcrun` and the SDK exist.
  bool get canBuildOnHost {
    if (goos == 'ios') return Platform.isMacOS;
    if (isLib) return true;
    return goos == Platform.operatingSystem;
  }

  String get ndkTriple => switch (abi) {
    'armeabi-v7a' => 'armv7a-linux-androideabi',
    'arm64-v8a' => 'aarch64-linux-android',
    'x86_64' => 'x86_64-linux-android',
    _ => throw BuildException('Not an Android target: $this'),
  };

  String get rustTriple {
    final arch = switch (goarch) {
      'amd64' => 'x86_64',
      'arm64' => 'aarch64',
      _ => throw BuildException('No Rust target for $this'),
    };
    return switch (goos) {
      'windows' => '$arch-pc-windows-msvc',
      'linux' => '$arch-unknown-linux-gnu',
      _ => throw BuildException('No Rust target for $this'),
    };
  }

  @override
  String toString() => '$goos/$goarch${abi != null ? ' ($abi)' : ''}';
}
