import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';

/// 閰嶇疆鏁版嵁Provider
/// 鑾峰彇绯荤粺閰嶇疆淇℃伅锛屽閭楠岃瘉銆侀個璇风爜绛夎缃?
/// 浣跨敤 autoDispose 纭繚姣忔杩涘叆娉ㄥ唽椤甸潰閮介噸鏂拌幏鍙栨渶鏂伴厤缃?
final configProvider = FutureProvider.autoDispose<ConfigModel?>((ref) async {
  try {
    return await XBoardSDK.instance.config.getConfig();
  } catch (e) {
    // 閰嶇疆鑾峰彇澶辫触鏃惰繑鍥瀗ull锛屼娇鐢ㄩ粯璁ゅ€?
    return null;
  }
});

/// 閰嶇疆鐘舵€丳rovider
/// 鎻愪緵閰嶇疆鐨勫姞杞界姸鎬佸拰閿欒淇℃伅
final configStateProvider = NotifierProvider<ConfigStateNotifier, ConfigState>(
  ConfigStateNotifier.new,
);

class ConfigState {
  final ConfigModel? data;
  final bool isLoading;
  final String? error;

  const ConfigState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  ConfigState copyWith({
    ConfigModel? data,
    bool? isLoading,
    String? error,
  }) {
    return ConfigState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ConfigStateNotifier extends Notifier<ConfigState> {
  @override
  ConfigState build() {
    loadConfig();
    return const ConfigState(isLoading: false);
  }

  Future<void> loadConfig() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final config = await XBoardSDK.instance.config.getConfig();
      state = state.copyWith(
        data: config,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshConfig() async {
    await loadConfig();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}