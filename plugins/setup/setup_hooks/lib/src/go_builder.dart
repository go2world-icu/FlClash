import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'build.dart';
import 'build_cache.dart';
import 'error.dart';
import 'fingerprint.dart';
import 'options.dart';
import 'target.dart';
import 'util.dart';

final _log = Logger('go_builder');

/// The oldest iOS the Core targets; matches the app's deployment target.
const _kIosMinVersion = '15.0';

/// Asks Xcode's toolchain where a tool lives (iOS Clang is not on PATH).
Future<String> _xcrun(List<String> args) async {
  final result = await Process.run('xcrun', args);
  if (result.exitCode != 0) {
    throw BuildException('xcrun ${args.join(' ')} failed: ${result.stderr}');
  }
  return (result.stdout as String).trim();
}

class GoBuilder {
  GoBuilder({
    required this.rootDir,
    required this.config,
    required this.cache,
    required this.notice,
    this.harnessInputs = const [],
    this.androidToolchain,
  });

  final String rootDir;
  final BuildConfig config;
  final BuildCache cache;
  final BuildNotice notice;
  final List<String> harnessInputs;
  final AndroidToolchain? androidToolchain;

  String get _corePath => p.join(rootDir, config.coreDir);
  String get _outputPath => p.join(rootDir, config.outputDir);

  String _resolveCc(Target target) {
    final toolchain = androidToolchain;
    if (toolchain == null) {
      throw BuildException('Android target $target needs an NDK toolchain');
    }
    final cc = toolchain.clangFor(target);
    if (!File(cc).existsSync()) {
      throw BuildException(
        'NDK compiler not found: $cc (API ${toolchain.apiLevel} from the '
        'app minSdk; the NDK Flutter selected may be too old)',
      );
    }
    return cc;
  }

  Future<BuildExecution> build(Target target) async {
    // Desktop: libclash/{platform}/; Android: libclash/android/{abi}/;
    // iOS: libclash/ios/{abi}/ (c-archive, later bundled into an xcframework).
    final outDir = target.isLib
        ? p.join(_outputPath, target.platformDir, target.abi!)
        : p.join(_outputPath, target.platformDir);
    ensureDir(outDir);

    final fileName = target.isStaticLib
        ? '${config.libName}${target.staticLibExtension}'
        : target.isLib
        ? '${config.libName}.so'
        : '${config.coreName}${target.executableExtension}';
    final outFile = p.join(outDir, fileName);

    return cache.run(
      // Both iOS slices share GOARCH arm64, so the SDK disambiguates the cache
      // entry (the artifact directory already differs via `abi`).
      key: target.sdk == null
          ? '${target.platformDir}-${target.goarch}-core'
          : '${target.platformDir}-${target.sdk}-${target.goarch}-core',
      fingerprint: () => _calculateFingerprint(target),
      primaryOutput: outFile,
      notice: notice,
      build: () async {
        final env = await _buildEnvironment(target);
        _log.info(
          'Building Go core: $target '
          '${target.isStaticLib
              ? "(CGO, c-archive)"
              : target.isLib
              ? "(CGO, c-shared)"
              : "(standalone)"}',
        );

        // A failed build must not destroy the previous artifacts.
        final stagingDir = Directory(
          p.join(outDir, '.staging-${target.goarch}-$pid'),
        );
        final staged = p.join(stagingDir.path, fileName);
        try {
          await runCommandStream(
            'go',
            _buildArguments(target, outFile: staged),
            workingDirectory: _corePath,
            environment: env,
          );

          final outputs = <String>[outFile];
          if (target.goos == 'ios') {
            replaceFile(staged, outFile);
            outputs.addAll(
              _installIosOutput(abiDir: outDir, stagingDir: stagingDir.path),
            );
          } else if (target.isLib) {
            outputs.addAll(
              _installAndroidOutput(
                abi: target.abi!,
                platformDir: p.join(_outputPath, target.platformDir),
                stagingDir: stagingDir.path,
                libName: fileName,
                outFile: outFile,
              ),
            );
          } else {
            replaceFile(staged, outFile);
          }

          _log.info('Built: $outFile');
          return outputs;
        } finally {
          if (stagingDir.existsSync()) {
            stagingDir.deleteSync(recursive: true);
          }
        }
      },
    );
  }

  Future<Map<String, String>> _buildEnvironment(Target target) async {
    final env = <String, String>{'GOOS': target.goos, 'GOARCH': target.goarch};

    if (target.goos == 'ios') {
      // iOS has no usable system network stack (no iptables, and a
      // PacketTunnel extension cannot get those privileges), so the Core is
      // built against gVisor's user-space stack. `-tags` carries that.
      final sdk = target.sdk!;
      final cc = await _xcrun(['--sdk', sdk, '--find', 'clang']);
      final sdkPath = await _xcrun(['--sdk', sdk, '--show-sdk-path']);
      final arch = target.goarch == 'amd64' ? 'x86_64' : 'arm64';
      final versionFlag = sdk == 'iphonesimulator'
          ? '-target $arch-apple-ios$_kIosMinVersion-simulator'
          : '-miphoneos-version-min=$_kIosMinVersion';
      final cflags = '-isysroot $sdkPath -arch arm64 $versionFlag';
      env
        ..['CGO_ENABLED'] = '1'
        ..['CC'] = cc
        ..['CGO_CFLAGS'] = cflags
        ..['CGO_LDFLAGS'] = cflags;
    } else if (target.isLib) {
      env
        ..['CGO_ENABLED'] = '1'
        ..['CC'] = _resolveCc(target)
        ..['CFLAGS'] = '-O3 -Werror';
    } else {
      env['CGO_ENABLED'] = '0';
    }
    return env;
  }

  // AGP strips the copy it packages into the APK, and Crashlytics reads the
  // unstripped one from the merged native libs, so Android keeps its symbols.
  // iOS ships the archive itself, so it keeps the caller's -ldflags verbatim.
  String _ldflags(Target target) => target.goos == 'android'
      ? config.goLdflags
            .split(' ')
            .where((flag) => flag != '-s' && flag != '-w')
            .join(' ')
      : config.goLdflags;

  List<String> _buildArguments(Target target, {String? outFile}) => [
    'build',
    '-ldflags=${_ldflags(target)}',
    '-tags=${config.tags}',
    if (target.isStaticLib)
      '-buildmode=c-archive'
    else if (target.isLib)
      '-buildmode=c-shared',
    if (outFile != null) ...['-o', outFile],
  ];

  Future<Fingerprint> _calculateFingerprint(Target target) async {
    final env = await _buildEnvironment(target);
    final builder = FingerprintBuilder(rootDir: rootDir)
      ..addValue('cache_schema', BuildCache.schemaVersion)
      ..addValue('kind', 'go-core')
      ..addValue('target', {
        'goos': target.goos,
        'goarch': target.goarch,
        'abi': target.abi,
        'sdk': target.sdk,
      })
      ..addValue('config', config.toFingerprintMap())
      ..addValue('environment', env)
      ..addValue('arguments', _buildArguments(target));

    final goEnvResult = runCommand(
      'go',
      [
        'env',
        '-json',
        'GOVERSION',
        'GOTOOLCHAIN',
        'GOFLAGS',
        'GOEXPERIMENT',
        'GOAMD64',
        'GOARM',
        'GO386',
        'GOMIPS',
        'GOMIPS64',
        'CGO_CFLAGS',
        'CGO_CPPFLAGS',
        'CGO_CXXFLAGS',
        'CGO_LDFLAGS',
        'GOWORK',
        'GOENV',
      ],
      workingDirectory: _corePath,
      environment: env,
    );
    final goEnv = jsonDecode((goEnvResult.stdout as String).trim());
    builder.addValue('go_env', goEnv);

    final inputs = _resolveGoInputs(env);
    final goWork = (goEnv as Map<String, dynamic>)['GOWORK'];
    if (goWork is String && goWork.isNotEmpty && goWork != 'off') {
      inputs.add(goWork);
      final goWorkSum = p.join(p.dirname(goWork), 'go.work.sum');
      if (File(goWorkSum).existsSync()) inputs.add(goWorkSum);
    }
    inputs.addAll(harnessInputs);

    // The Android compiler version comes from the NDK. iOS compiles with
    // Xcode's clang, whose version is already captured in `environment`.
    if (target.isLib && target.goos != 'ios') {
      final compilerVersion = runCommand(env['CC']!, ['--version']);
      builder.addValue(
        'android_compiler',
        '${(compilerVersion.stdout as String).trim()}\n'
            '${(compilerVersion.stderr as String).trim()}',
      );
    }

    builder.addFiles(inputs);
    return builder.finishWithInputs();
  }

  Set<String> _resolveGoInputs(Map<String, String> environment) {
    const template =
        r'''{{range .GoFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .CgoFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .CFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .CXXFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .MFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .HFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .FFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .SFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .SwigFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .SwigCXXFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .SysoFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .EmbedFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{with .Module}}{{if .GoMod}}{{.GoMod}}{{"\n"}}{{end}}{{end}}''';
    final result = runCommand(
      'go',
      ['list', '-deps', '-tags=${config.tags}', '-f', template, '.'],
      workingDirectory: _corePath,
      environment: environment,
    );
    final corePath = p.normalize(p.absolute(_corePath));
    final inputs = <String>{};
    for (final line in (result.stdout as String).split('\n')) {
      final value = line.trim();
      if (value.isEmpty) continue;
      final filePath = p.normalize(
        p.absolute(p.isAbsolute(value) ? value : p.join(_corePath, value)),
      );
      if (!p.isWithin(corePath, filePath) && !p.equals(corePath, filePath)) {
        continue;
      }
      if (!File(filePath).existsSync()) continue;
      inputs.add(filePath);
      if (p.basename(filePath) == 'go.mod') {
        final goSum = p.join(p.dirname(filePath), 'go.sum');
        if (File(goSum).existsSync()) inputs.add(goSum);
      }
    }

    for (final name in const ['go.mod', 'go.sum']) {
      final filePath = p.join(_corePath, name);
      if (File(filePath).existsSync()) inputs.add(filePath);
    }
    return inputs;
  }

  /// Moves the c-archive header (`libclash.h`) plus `bride.h` into
  /// `<abi>/include/`, the layout `xcodebuild -create-xcframework` and the
  /// Swift bridging header expect.
  List<String> _installIosOutput({
    required String abiDir,
    required String stagingDir,
  }) {
    final includeDir = p.join(abiDir, 'include');
    ensureDir(includeDir);
    _clearDirectory(includeDir);

    final outputs = <String>[];
    final generatedHeader = File(p.join(stagingDir, '${config.libName}.h'));
    if (generatedHeader.existsSync()) {
      final includePath = p.join(includeDir, '${config.libName}.h');
      copyFile(generatedHeader.path, includePath);
      outputs.add(includePath);
    }
    final brideHeader = File(p.join(_corePath, 'bride.h'));
    if (brideHeader.existsSync()) {
      final includePath = p.join(includeDir, 'bride.h');
      copyFile(brideHeader.path, includePath);
      outputs.add(includePath);
    }
    return outputs;
  }

  /// Bundles every built iOS slice into `<output>/ios/Libclash.xcframework`,
  /// which the Runner and PacketTunnel targets link.
  Future<String> createXcframework() async {
    final iosDir = p.join(_outputPath, 'ios');
    final frameworkPath = p.join(iosDir, 'Libclash.xcframework');

    final slices = Directory(iosDir)
        .listSync()
        .whereType<Directory>()
        .where((d) => File(p.join(d.path, '${config.libName}.a')).existsSync())
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

    _log.info(
      'Creating xcframework from '
      '${slices.map((s) => p.basename(s.path)).join(', ')}',
    );
    await runCommandStream('xcodebuild', args, workingDirectory: rootDir);
    _log.info('Built: $frameworkPath');
    return frameworkPath;
  }

  List<String> _installAndroidOutput({
    required String abi,
    required String platformDir,
    required String stagingDir,
    required String libName,
    required String outFile,
  }) {
    final includesPath = p.join(platformDir, 'includes', abi);
    final androidCoreMainPath = p.join(
      rootDir,
      'android',
      'core',
      'src',
      'main',
    );
    final jniLibsPath = p.join(androidCoreMainPath, 'jniLibs', abi);
    final cppIncludesPath = p.join(androidCoreMainPath, 'cpp', 'includes', abi);
    final outputs = <String>[];

    ensureDir(includesPath);
    _clearDirectory(includesPath);
    ensureDir(cppIncludesPath);
    _clearDirectory(cppIncludesPath);

    replaceFile(p.join(stagingDir, libName), outFile);
    copyFile(outFile, p.join(jniLibsPath, libName));
    outputs.add(p.join(jniLibsPath, libName));

    final generatedHeaders = Directory(stagingDir).listSync();
    final staticHeaders = Directory(_corePath).listSync();
    for (final file in [...generatedHeaders, ...staticHeaders]) {
      if (!file.path.endsWith('.h')) continue;
      final headerName = p.basename(file.path);
      final includePath = p.join(includesPath, headerName);
      final cppIncludePath = p.join(cppIncludesPath, headerName);
      copyFile(file.path, includePath);
      copyFile(file.path, cppIncludePath);
      outputs
        ..add(includePath)
        ..add(cppIncludePath);
    }
    return outputs;
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
}
