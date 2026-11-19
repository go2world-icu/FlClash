import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/ios_lifecycle.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prism_ui/prism_ui.dart';

import 'ios_member_strings.dart';

typedef IosConnectionEvent = ({DateTime time, String status});

final iosConnectionActivityProvider =
    NotifierProvider.autoDispose<
      IosConnectionActivity,
      List<IosConnectionEvent>
    >(IosConnectionActivity.new);

class IosConnectionActivity extends Notifier<List<IosConnectionEvent>> {
  @override
  List<IosConnectionEvent> build() {
    final (signedIn, _) = ref.watch(
      xboardUserProvider.select((user) => (user.isAuthenticated, user.email)),
    );
    if (signedIn) {
      ref.listen(iosTunnelStatusProvider, (_, next) {
        final status = switch (next) {
          'connected' || 'reasserting' || 'disconnected' => next,
          'invalid' => 'disconnected',
          _ => null,
        };
        if (status == null || state.firstOrNull?.status == status) return;
        state = [(time: DateTime.now(), status: status), ...state.take(4)];
      });
    }
    return const [];
  }
}

class IosConnectionActivityCard extends ConsumerStatefulWidget {
  const IosConnectionActivityCard({super.key});

  @override
  ConsumerState<IosConnectionActivityCard> createState() =>
      _IosConnectionActivityCardState();
}

class _IosConnectionActivityCardState
    extends ConsumerState<IosConnectionActivityCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(iosConnectionActivityProvider);
    final app = context.appLocalizations;
    final format = DateFormat.MMMd(
      Localizations.localeOf(context).languageCode,
    ).add_jm();
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton.icon(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: GlyphIcon(
              _expanded ? AppGlyphs.chevronUp : AppGlyphs.caretDown,
            ),
            label: Text(context.iosMemberStrings.connectionActivity),
          ),
          if (_expanded)
            if (events.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Text(app.noData),
              )
            else
              for (final event in events)
                ListRow(
                  title: Text(switch (event.status) {
                    'connected' =>
                      context.iosMemberStrings.vpnActivityConnected,
                    'reasserting' => context.iosMemberStrings.reconnecting,
                    _ => app.disconnected,
                  }),
                  trailing: Text(format.format(event.time)),
                ),
        ],
      ),
    );
  }
}
