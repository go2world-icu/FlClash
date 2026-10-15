import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'build_cache.dart';
import 'error.dart';
import 'fingerprint.dart';
import 'options.dart';
import 'target.dart';
import 'util.dart';

final _log = Logger('go_builder');

/// The oldest iOS the Core targets; matches the app's deployment target.
const _kIosMinVersion = '15.0';

/// gomobile names the framework after the bound package and has no option to
/// change it — the Xcode project links this name.
const _kIosFrameworkName = 'Mobile';

class GoBuilder {
  GoBuilder({
    required this.rootDir,
    required this.config,
    required this.cache,
    required this.notice,
    this.harnessInputs = const [],
  });

  final String rootDir;
  final BuildConfig config;
  final BuildCache cache;
  final BuildNotice notice;
  final List<String> harnessInputs;

  static const _mainPackage = './cmd/core';

  /// iOS binds this package with gomobile; its Android half ships as the AAR
  /// gradle builds, which does not go through this class.
  static const _iosPackage = './mobile';

  String get _corePath => p.join(rootDir, config.coreDir);
  String get _outputPath => p.join(rootDir, config.outputDir);

  Future<BuildExecution> build(Target target) async {
    if (target.isFramework) return _buildFramework(target);

    final outDir = p.join(_outputPath, target.platformDir);
    ensureDir(outDir);

    final fileName = '${config.coreName}${target.executableExtension}';
    final outFile = p.join(outDir, fileName);

    return cache.run(
      key: '${target.platformDir}-${target.goarch}-core',
      fingerprint: () => _calculateFingerprint(target),
      primaryOutput: outFile,
      notice: notice,
      build: () async {
        final env = _buildEnvironment(target);
        _log.info('Building Go core: $target');

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
          replaceFile(staged, outFile);

          _log.info('Built: $outFile');
          return [outFile];
        } finally {
          if (stagingDir.existsSync()) {
            stagingDir.deleteSync(recursive: true);
          }
        }
      },
    );
  }

  /// Builds one iOS slice and installs it under `libclash/ios/<abi>/`; the
  /// slices are combined by [createXcframework].
  Future<BuildExecution> _buildFramework(Target target) async {
    final outDir = p.join(_outputPath, target.platformDir, target.abi!);
    ensureDir(outDir);
    final sliceDir = p.join(outDir, _kIosFrameworkName);
    final sliceBinary = p.join(sliceDir, _kIosFrameworkName);

    return cache.run(
      // Both iOS slices share GOARCH arm64, so the SDK is what tells their
      // cache entries apart.
      key: '${target.platformDir}-${target.sdk}-${target.goarch}-core',
      fingerprint: () => _calculateFingerprint(target),
      primaryOutput: sliceBinary,
      notice: notice,
      build: () async {
        final gomobile = await _ensureGomobile();
        _log.info('Binding Go core: $target (CGO, gomobile framework)');

        final stagingDir = Directory(
          p.join(outDir, '.staging-${target.sdk}-$pid'),
        );
        ensureDir(stagingDir.path);
        final staged = p.join(stagingDir.path, _kIosFrameworkName);
        try {
          await runCommandStream(
            gomobile,
            _bindArguments(target, outFramework: staged),
            workingDirectory: _corePath,
          );
          if (Directory(sliceDir).existsSync()) {
            Directory(sliceDir).deleteSync(recursive: true);
          }
          Directory(staged).renameSync(sliceDir);
          _log.info('Built: $sliceBinary');
          return [sliceBinary];
        } finally {
          if (stagingDir.existsSync()) {
            stagingDir.deleteSync(recursive: true);
          }
        }
      },
    );
  }

  List<String> _bindArguments(
    Target target, {
    required String outFramework,
  }) => [
    'bind',
    '-target=${target.sdk == 'iphonesimulator' ? 'iossimulator' : 'ios'}/${target.goarch}',
    '-iosversion',
    _kIosMinVersion,
    '-ldflags=${_ldflags()}',
    '-tags=${config.tags}',
    '-o',
    outFramework,
    _iosPackage,
  ];

  /// gomobile and gobind are built from the module's own dependency rather than
  /// installed on PATH — the same pair the Android gradle builds.
  Future<String> _ensureGomobile() async {
    final toolsDir = p.join(rootDir, '.dart_tool', 'setup_hooks', 'tools');
    final executable = p.join(
      toolsDir,
      'gomobile${Platform.isWindows ? '.exe' : ''}',
    );
    if (File(executable).existsSync()) return executable;
    ensureDir(toolsDir);
    _log.info('Building gomobile');
    await runCommandStream('go', [
      'build',
      '-o',
      '$toolsDir${p.separator}',
      'golang.org/x/mobile/cmd/gomobile',
      'golang.org/x/mobile/cmd/gobind',
    ], workingDirectory: _corePath);
    if (!File(executable).existsSync()) {
      throw BuildException('gomobile did not land at $executable');
    }
    return executable;
  }

  /// Bundles every built iOS slice into `<output>/ios/Mobile.xcframework`,
  /// which the Runner and PacketTunnel targets link.
  Future<String> createXcframework() async {
    final iosDir = p.join(_outputPath, 'ios');
    final frameworkPath = p.join(iosDir, '$_kIosFrameworkName.xcframework');

    final slices = Directory(iosDir)
        .listSync()
        .whereType<Directory>()
        .where(
          (d) => Directory(p.join(d.path, _kIosFrameworkName)).existsSync(),
        )
        .toList();
    if (slices.isEmpty) {
      throw BuildException('No iOS slices found in $iosDir');
    }

    final framework = Directory(frameworkPath);
    if (framework.existsSync()) {
      framework.deleteSync(recursive: true);
    }

    _log.info(
      'Creating xcframework from '
      '${slices.map((s) => p.basename(s.path)).join(', ')}',
    );
    await runCommandStream('xcodebuild', [
      '-create-xcframework',
      for (final slice in slices) ...[
        '-framework',
        p.join(slice.path, _kIosFrameworkName),
      ],
      '-output',
      frameworkPath,
    ], workingDirectory: rootDir);
    _log.info('Built: $frameworkPath');
    return frameworkPath;
  }

  Map<String, String> _buildEnvironment(Target target) => {
    'GOOS': target.goos,
    'GOARCH': target.goarch,
    'CGO_ENABLED': '0',
  };

  // Package-level vars in mihomo copy constant.Version during init, so only the
  // linker can set it for every reader.
  static const _versionSymbol = 'github.com/metacubex/mihomo/constant.Version';

  String _ldflags() => [
    config.goLdflags,
    if (config.coreVersion.isNotEmpty)
      '-X $_versionSymbol=${config.coreVersion}',
  ].join(' ');

  List<String> _buildArguments(Target target, {String? outFile}) => [
    'build',
    '-ldflags=${_ldflags()}',
    '-tags=${config.tags}',
    if (outFile != null) ...['-o', outFile],
    _mainPackage,
  ];

  Future<Fingerprint> _calculateFingerprint(Target target) async {
    final env = _buildEnvironment(target);
    final builder = FingerprintBuilder(rootDir: rootDir)
      ..addValue('cache_schema', BuildCache.schemaVersion)
      ..addValue('kind', 'go-core')
      ..addValue('target', {
        'goos': target.goos,
        'goarch': target.goarch,
        if (target.abi != null) 'abi': target.abi,
        if (target.sdk != null) 'sdk': target.sdk,
      })
      ..addValue('config', config.toFingerprintMap())
      ..addValue('environment', env)
      ..addValue(
        'arguments',
        target.isFramework
            ? _bindArguments(target, outFramework: '<out>')
            : _buildArguments(target),
      );

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

    final inputs = _resolveGoInputs(env, target);
    final goWork = (goEnv as Map<String, dynamic>)['GOWORK'];
    if (goWork is String && goWork.isNotEmpty && goWork != 'off') {
      inputs.add(goWork);
      final goWorkSum = p.join(p.dirname(goWork), 'go.work.sum');
      if (File(goWorkSum).existsSync()) inputs.add(goWorkSum);
    }
    inputs.addAll(harnessInputs);

    builder.addFiles(inputs);
    return builder.finishWithInputs();
  }

  Set<String> _resolveGoInputs(Map<String, String> environment, Target target) {
    const template =
        r'''{{range .GoFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .CgoFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .CFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .CXXFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .MFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .HFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .FFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .SFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .SwigFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .SwigCXXFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .SysoFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{range .EmbedFiles}}{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{with .Module}}{{if .GoMod}}{{.GoMod}}{{"\n"}}{{end}}{{end}}''';
    final result = runCommand(
      'go',
      [
        'list',
        '-deps',
        '-tags=${config.tags}',
        '-f',
        template,
        target.isFramework ? _iosPackage : _mainPackage,
      ],
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
}
