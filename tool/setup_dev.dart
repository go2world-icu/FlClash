/// 开发环境初始化脚本
///
/// 用法：dart run tools/setup_dev.dart
///
/// 执行顺序：
///   1. git submodule update --init --recursive
///   2. flutter pub get
///   3. dart run build_runner build
///   4. dart run intl_utils:generate

import 'dart:io';

Future<void> main(List<String> args) async {
  final start = DateTime.now();

  print('=== FlClash 开发环境初始化 ===\n');

  // Step 1: Submodules
  print('[1/4] 更新子模块...');
  await _run('git', ['submodule', 'update', '--init', '--recursive']);
  print('');

  // Step 2: Pub get
  print('[2/4] 安装依赖...');
  await _run('flutter', ['pub', 'get']);
  print('');

  // Step 3: Build runner
  print('[3/4] 代码生成（riverpod / freezed / json / drift）...');
  await _run('dart', ['run', 'build_runner', 'build', '--delete-conflicting-outputs']);
  print('');

  // Step 4: Localization
  print('[4/4] 生成本地化代码...');
  await _run('dart', ['run', 'intl_utils:generate']);
  print('');

  final elapsed = DateTime.now().difference(start);
  print('✅ 初始化完成，耗时 ${elapsed.inSeconds} 秒');
  print('   运行 flutter run -d windows 启动应用');
}

Future<void> _run(String cmd, List<String> args) async {
  final result = await Process.run(cmd, args,
      workingDirectory: Directory.current.path,
      runInShell: true);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    stderr.writeln('❌ 命令失败: $cmd $args (exit ${result.exitCode})');
    exit(result.exitCode);
  }
}
