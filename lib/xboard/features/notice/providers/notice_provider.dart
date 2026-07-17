import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/state/notice_state.dart';
import 'package:fl_clash/xboard/core/core.dart';

// 鍒濆鍖栨枃浠剁骇鏃ュ織鍣?final _logger = FileLogger('notice_provider.dart');

/// 鍏憡鐘舵€?class NoticeState {
  final List<DomainNotice> notices;
  final bool isLoading;
  final String? error;
  final Set<int> dismissedIndices;

  const NoticeState({
    this.notices = const [],
    this.isLoading = false,
    this.error,
    this.dismissedIndices = const {},
  });

  /// 鑾峰彇鍙鐨勫叕鍛婂垪琛紙鏈鍏抽棴鐨勶級
  List<DomainNotice> get visibleNotices {
    return notices
        .asMap()
        .entries
        .where((entry) => !dismissedIndices.contains(entry.key))
        .map((entry) => entry.value)
        .toList();
  }

  NoticeState copyWith({
    List<DomainNotice>? notices,
    bool? isLoading,
    String? error,
    Set<int>? dismissedIndices,
  }) {
    return NoticeState(
      notices: notices ?? this.notices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      dismissedIndices: dismissedIndices ?? this.dismissedIndices,
    );
  }
}

/// 鍏憡Provider
class NoticeNotifier extends Notifier<NoticeState> {
  @override
  NoticeState build() => const NoticeState();

  /// 鑾峰彇鍏憡鍒楄〃
  Future<void> fetchNotices() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final noticeModels = await ref.read(getNoticesProvider.future);
      final notices = (noticeModels as List<NoticeModel>?)?.map(_mapNotice).toList() ?? [];
      state = state.copyWith(
        notices: notices,
        isLoading: false,
      );
    } catch (e) {
      _logger.error('鑾峰彇鍏憡鍒楄〃澶辫触', e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 鏍囪鍏憡涓哄凡璇?  void markAsRead(int index) {
    // 瀹炵幇鍏憡宸茶閫昏緫锛堝彲閫夛級
  }

  /// 鍏抽棴鍏憡妯箙
  void dismissBanner(int index) {
    final newDismissed = Set<int>.from(state.dismissedIndices)..add(index);
    state = state.copyWith(dismissedIndices: newDismissed);
  }
}

/// 鍏憡Provider瀹炰緥
final noticeProvider = NotifierProvider<NoticeNotifier, NoticeState>(NoticeNotifier.new);

DomainNotice _mapNotice(NoticeModel notice) {
  return DomainNotice(
    id: notice.id,
    title: notice.title,
    content: notice.content,
    imageUrls: notice.imgUrl != null && notice.imgUrl!.isNotEmpty ? [notice.imgUrl!] : [],
    tags: notice.tags ?? [],
    isVisible: notice.show,
    createdAt: DateTime.fromMillisecondsSinceEpoch(notice.createdAt * 1000),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(notice.updatedAt * 1000),
  );
}
