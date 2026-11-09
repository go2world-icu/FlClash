import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/initialization/sdk_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final boardAuthGatewayProvider = Provider<BoardAuthGateway>(
  (ref) => BoardAuthGateway(
    () async => (await ref.read(xboardSdkProvider.future)).auth,
  ),
);

class BoardAuthGateway {
  const BoardAuthGateway(this._auth);

  final Future<AuthApi> Function() _auth;

  Future<bool> register(
    String email,
    String password, {
    String? inviteCode,
    String? emailCode,
  }) async => (await _auth()).register(
    email,
    password,
    inviteCode: inviteCode,
    emailCode: emailCode,
  );

  Future<bool> sendEmailVerifyCode(
    String email, {
    bool? isPasswordReset,
  }) async => (await _auth()).sendEmailVerifyCode(
    email,
    isPasswordReset: isPasswordReset,
  );

  Future<bool> forgotPassword(
    String email,
    String code,
    String newPassword,
  ) async => (await _auth()).forgotPassword(email, code, newPassword);
}
