import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';

part 'generated/ticket_state.g.dart';

/// 宸ュ崟鐘舵€佺鐞?

/// 鑾峰彇宸ュ崟鍒楄〃
@riverpod
Future<List<TicketModel>> getTickets(Ref ref) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.ticket.getTickets();
}

/// 鑾峰彇鍗曚釜宸ュ崟
@riverpod
Future<TicketDetailModel> getTicket(Ref ref, int id) async {
  final sdk = await ref.watch(xboardSdkProvider.future);
  return await sdk.ticket.getTicket(id);
}
