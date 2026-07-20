import 'package:flutter_riverpod/flutter_riverpod.dart';
class LatencyState extends Notifier<Map<String, int?>> {
  @override
  Map<String, int?> build() => {};
  void updateLatencies(Map<String, int?> newLatencies) {
    state = {...state, ...newLatencies};
  }
  void clear() {
    state = {};
  }
}
final latencyProvider = NotifierProvider<LatencyState, Map<String, int?>>(LatencyState.new);
