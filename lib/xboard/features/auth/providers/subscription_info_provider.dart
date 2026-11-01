import 'package:fl_clash/xboard/domain/models/subscription.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionInfoProvider =
    NotifierProvider<_DomainSubscriptionHolder, DomainSubscription?>(
      _DomainSubscriptionHolder.new,
    );

class _DomainSubscriptionHolder extends Notifier<DomainSubscription?> {
  @override
  DomainSubscription? build() => null;
}
