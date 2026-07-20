import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'environment.dart';
import 'error.dart';
import 'logging.dart';
import 'options.dart';
import 'target.dart';
import 'util.dart';

final _log = Logger('go_builder');

String _resolveCc(Target target) {
  final ndk = Environment.androidNdk;
  final prebuiltDir = Directory(
    p.join(ndk, 'toolchains', 'llvm', 'prebuilt'),
  );
  final entries = prebuiltDir
      .listSync()
      .where((e) => !p.basename(e.path).startsWith('.'))
      .toList();
  if (entries.isEmpty) {
    throw BuildException('No NDK prebuilt toolchain found in $prebuiltDir');
  }
  return p.join(entries.first.path, 'bin', target.ndkCcName);
}

const _kIosMinVersion = '15.0';

Future<String> _xcrun(List<String> args) async {
  final result = await Process.run('xcrun', args);
  if (result.exitCode != 0) {
    throw BuildException('xcrun ${args.join(' ')} failed: ${result.stderr}');
  }
  return (result.stdout as String).trim();
}

class GoBuilder {
  final String rootDir;
  final BuildConfig config;

  GoBuilder({required this.rootDir, required this.config});

  String get _corePath => p.join(rootDir, config.coreDir);
  String get _outputPath => p.join(rootDir, config.outputDir);

  Future<String> build(Target target) async {
    // Desktop: output directly to libclash/{platform}/
    // Android: output to libclash/android/{abi}/
    // iOS: output to libclash/ios/{abi}/ (c-archive)
    final outDir = target.isLib
        ? p.join(_outputPath, target.platformDir, target.abi!)
        : p.join(_outputPath, target.platformDir);
    ensureDir(outDir);

    final fileName = target.isStaticLib
        ? '${config.libName}${target.staticLibExtension}'
        : target.isLib
            ? '${config.libName}${target.dynamicLibExtension}'
            : '${config.coreName}${target.executableExtension}';
    final outFile = p.join(outDir, fileName);

    final env = <String, String>{
      'GOOS': target.goos,
      'GOARCH': target.goarch,
    };

    var tags = config.tags;
    if (target.goos == 'ios') {
      final sdk = target.sdk!;
      final cc = await _xcrun(['--sdk', sdk, '--find', 'clang']);
      final sdkPath = await _xcrun(['--sdk', sdk, '--show-sdk-path']);
      final versionFlag = sdk == 'iphonesimulator'
          ? '-target ${target.goarch == 'amd64' ? 'x86_64' : 'arm64'}-apple-ios$_kIosMinVersion-simulator'
          : '-miphoneos-version-min=$_kIosMinVersion';
      final cflags = '-isysroot $sdkPath -arch arm64 $versionFlag';
      env['CGO_ENABLED'] = '1';
      env['CC'] = cc;
      env['CGO_CFLAGS'] = cflags;
      env['CGO_LDFLAGS'] = cflags;
      // gVisor is required on iOS — system stack doesn't work without
      // iptables, and the user-space TCP stack lets MTProto/UDP flow.
    } else if (target.isLib) {
      env['CGO_ENABLED'] = '1';
      env['CC'] = _resolveCc(target);
      env['CFLAGS'] = '-O3 -Werror';
    } else {
      env['CGO_ENABLED'] = '0';
    }

    final args = [
      'build',
      '-ldflags=${config.goLdflags}',
      '-tags=$tags',
      if (target.isStaticLib)
        '-buildmode=c-archive'
      else if (target.isLib)
        '-buildmode=c-shared',
      '-o',
      outFile,
    ];

    _log.info(kDoubleSeparator);
    _log.info(
        'Building Go core: $target ${target.isStaticLib ? "(CGO, c-archive)" : target.isLib ? "(CGO, c-shared)" : "(standalone)"}');
    _log.info(kSeparator);

    await runCommandStream('go', args,
        workingDirectory: _corePath, environment: env);

    if (target.goos == 'ios') {
      _adjustIosOutput(abiDir: outDir);
    } else if (target.isLib && target.abi != null) {
      await _adjustAndroidOutput(
          outDir: p.join(_outputPath, target.platformDir),
          abiDir: target.abi!,
          archName: target.abi!,
          libPath: outFile,
          libName: fileName);
    }

    _log.info('Built: $outFile');
    return outFile;
  }

  Future<List<String>> buildAll(List<Target> targets) async {
    final results = await Future.wait(targets.map(build));
    return results;
  }

  /// Move the c-archive generated header plus bride.h into `<abi>/include/`,
  /// the layout expected by `createXcframework`.
  void _adjustIosOutput({required String abiDir}) {
    final includeDir = p.join(abiDir, 'include');
    ensureDir(includeDir);
    _clearDirectory(includeDir);

    final generatedHeader = File(p.join(abiDir, '${config.libName}.h'));
    if (generatedHeader.existsSync()) {
      generatedHeader.copySync(
        p.join(includeDir, '${config.libName}.h'),
      );
      generatedHeader.deleteSync();
    }
    final brideHeader = File(p.join(_corePath, 'bride.h'));
    if (brideHeader.existsSync()) {
      brideHeader.copySync(p.join(includeDir, 'bride.h'));
    }
  }

  /// Bundle every built iOS slice into libclash/ios/Libclash.xcframework.
  Future<String> createXcframework() async {
    final iosDir = p.join(_outputPath, 'ios');
    final frameworkPath = p.join(iosDir, 'Libclash.xcframework');

    final slices = Directory(iosDir)
        .listSync()
        .whereType<Directory>()
        .where((d) =>
            File(p.join(d.path, '${config.libName}.a')).existsSync())
        .toList();
    if (slices.isEmpty) {
      throw BuildException('No iOS slices found in $iosDir');
    }

    final framework = Directory(frameworkPath);
    if (framework.existsSync()) {
      framework.deleteSync(recursive: true);
    }

    final args = [
      '-create-xcframework',
      for (final slice in slices) ...[
        '-library',
        p.join(slice.path, '${config.libName}.a'),
        '-headers',
        p.join(slice.path, 'include'),
      ],
      '-output',
      frameworkPath,
    ];

    _log.info(kSeparator);
    _log.info(
        'Creating xcframework from ${slices.map((s) => p.basename(s.path)).join(', ')}');
    await runCommandStream('xcodebuild', args, workingDirectory: rootDir);
    _log.info('Built: $frameworkPath');
    return frameworkPath;
  }

  Future<void> _adjustAndroidOutput({
    required String outDir,
    required String abiDir,
    required String archName,
    required String libPath,
    required String libName,
  }) async {
    final includesPath = p.join(outDir, 'includes', archName);
    final androidCoreMainPath =
        p.join(rootDir, 'android', 'core', 'src', 'main');
    final jniLibsPath = p.join(androidCoreMainPath, 'jniLibs', abiDir);
    final cppIncludesPath =
        p.join(androidCoreMainPath, 'cpp', 'includes', archName);

    ensureDir(jniLibsPath);
    ensureDir(includesPath);
    _clearDirectory(includesPath);
    ensureDir(cppIncludesPath);
    _clearDirectory(cppIncludesPath);

    _deleteIfExists(p.join(jniLibsPath, libName));
    File(libPath).copySync(p.join(jniLibsPath, libName));

    final abiDirPath = p.join(outDir, abiDir);
    final headerFiles = [
      ...Directory(abiDirPath).listSync(),
      ...Directory(_corePath).listSync(),
    ];
    for (final file in headerFiles) {
      if (!file.path.endsWith('.h')) continue;
      final fileName = p.basename(file.path);
      final source = File(file.path);
      source.copySync(p.join(includesPath, fileName));
      source.copySync(p.join(cppIncludesPath, fileName));
      if (file.path.startsWith(abiDirPath)) {
        source.deleteSync();
      }
    }
  }

  void _clearDirectory(String dirPath) {
    final dir = Directory(dirPath);
    if (!dir.existsSync()) return;

    for (final entity in dir.listSync()) {
      if (entity is File || entity is Link) {
        entity.deleteSync();
      } else if (entity is Directory) {
        entity.deleteSync(recursive: true);
      }
    }
  }

  void _deleteIfExists(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
