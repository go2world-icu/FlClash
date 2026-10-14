import 'package:fl_clash/xboard/features/auth/models/auth_state.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/features/notice/providers/notice_provider.dart';

/// Auth notifier with a fixed state, so widgets can render authenticated or
/// loading branches without touching storage or the SDK.
class FakeUserAuthNotifier extends XBoardUserAuthNotifier {
  FakeUserAuthNotifier(this.initial);

  final UserAuthState initial;

  @override
  UserAuthState build() => initial;
}

/// Notice notifier preloaded with state and a no-op fetch.
class FakeNoticeNotifier extends NoticeNotifier {
  FakeNoticeNotifier(this.initial);

  final NoticeState initial;

  @override
  NoticeState build() => initial;

  @override
  Future<void> fetchNotices() async {}
}

/// Invite notifier preloaded with state.
class FakeInviteNotifier extends InviteNotifier {
  FakeInviteNotifier(this.initial);

  final InviteState initial;

  @override
  InviteState build() => initial;
}
