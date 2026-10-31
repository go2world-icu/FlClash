part of 'go_builder.dart';

const _kIosMinVersion = '15.0';

const _kIosFrameworkName = 'Mobile';

extension IosFrameworkBuild on GoBuilder {
  Future<BuildExecution> _buildFramework(Target target) async {
    final outDir = p.join(_outputPath, target.platformDir, target.abi!);
    ensureDir(outDir);
    final slice = p.join(outDir, '$_kIosFrameworkName.xcframework');
    // xcodebuild names the directory inside after the platform, which is not
    // worth guessing at; its Info.plist sits at the root either way.
    final sliceMarker = p.join(slice, 'Info.plist');

    return cache.run(
      // Both iOS slices share GOARCH arm64, so the SDK is what tells their
      // cache entries apart.
      key: '${target.platformDir}-${target.sdk}-${target.goarch}-core',
      fingerprint: () => _calculateFingerprint(target),
      primaryOutput: sliceMarker,
      notice: notice,
      build: () async {
        final gomobile = await _ensureGomobile();
        _log.info('Binding Go core: $target (gomobile xcframework)');
        await runCommandStream(
          gomobile,
          _bindArguments(target, outXcframework: slice),
          workingDirectory: _corePath,
        );
        final framework = _frameworkIn(slice);
        if (framework == null) {
          throw BuildException('gomobile produced no framework in $slice');
        }
        _log.info('Built: $framework');
        // Files only: the cache stats every output, and a .framework is a
        // directory.
        return [
          sliceMarker,
          p.join(framework, 'Info.plist'),
          p.join(framework, _kIosFrameworkName),
        ];
      },
    );
  }

  List<String> _bindArguments(
    Target target, {
    required String outXcframework,
  }) => [
    'bind',
    '-target=${target.sdk == 'iphonesimulator' ? 'iossimulator' : 'ios'}/${target.goarch}',
    '-iosversion',
    _kIosMinVersion,
    '-ldflags=${_ldflags()}',
    '-tags=${config.tags}',
    '-o',
    outXcframework,
    GoBuilder._iosPackage,
  ];

  String? _frameworkIn(String xcframeworkPath) {
    final root = Directory(xcframeworkPath);
    if (!root.existsSync()) return null;
    for (final entity in root.listSync().whereType<Directory>()) {
      final framework = p.join(entity.path, '$_kIosFrameworkName.framework');
      if (Directory(framework).existsSync()) return framework;
    }
    return null;
  }

  Future<String> _ensureGomobile() async {
    final toolsDir = p.join(rootDir, '.dart_tool', 'setup_hooks', 'tools');
    final executable = p.join(
      toolsDir,
      'gomobile${Platform.isWindows ? '.exe' : ''}',
    );
    if (File(executable).existsSync()) {
      registerToolDirectory(toolsDir);
      return executable;
    }
    ensureDir(toolsDir);
    registerToolDirectory(toolsDir);
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

  Future<String> createXcframework() async {
    final iosDir = p.join(_outputPath, 'ios');
    final frameworkPath = p.join(iosDir, '$_kIosFrameworkName.xcframework');

    final slices =
        Directory(iosDir)
            .listSync()
            .whereType<Directory>()
            .map(
              (d) => _frameworkIn(
                p.join(d.path, '$_kIosFrameworkName.xcframework'),
              ),
            )
            .whereType<String>()
            .toList()
          ..sort();
    if (slices.isEmpty) {
      throw BuildException('No iOS slices found in $iosDir');
    }

    final framework = Directory(frameworkPath);
    if (framework.existsSync()) {
      framework.deleteSync(recursive: true);
    }

    _log.info(
      'Creating xcframework from '
      '${slices.map((s) => p.basename(p.dirname(s))).join(', ')}',
    );
    await runCommandStream('xcodebuild', [
      '-create-xcframework',
      for (final slice in slices) ...['-framework', slice],
      '-output',
      frameworkPath,
    ], workingDirectory: rootDir);
    _log.info('Built: $frameworkPath');
    return frameworkPath;
  }
}
