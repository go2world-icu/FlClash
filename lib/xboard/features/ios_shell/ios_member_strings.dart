import 'package:flutter/widgets.dart';

extension IosMemberLocalization on BuildContext {
  IosMemberStrings get iosMemberStrings =>
      IosMemberStrings(Localizations.localeOf(this).languageCode == 'zh');
}

class IosMemberStrings {
  const IosMemberStrings(this._chinese);

  final bool _chinese;

  String _text(String english, String chinese) => _chinese ? chinese : english;

  String total(String value) => _text('Total $value', '总计 $value');
  String get accountRestricted => _text('Account restricted', '账号受限');
  String get checkConnection => _text('Check connection', '开始检测');
  String get chooseLine =>
      _text('Choose a line from your membership.', '选择当前会员套餐的线路。');
  String get configuration => _text('Configuration', '配置同步');
  String get confirmReport => _text(
    'Send the app version, VPN status, check outcome, and response time to ToWorld support?',
    '将应用版本、VPN 状态、检测结果和响应时间发送给 ToWorld 支持？',
  );
  String get connect => _text('Connect', '一键连接');
  String get connectToLoadLines => _text(
    'Connect first to load the lines from your plan.',
    '请先连接，线路会从当前套餐同步。',
  );
  String get connectionChecklist => _text('Connection checklist', '连接检查');
  String get connectionFailed => _text(
    'Connection failed. Try again or open Connection Health.',
    '连接失败，请重试或查看连接健康。',
  );
  String get connectionHealth => _text('Connection health', '连接健康');
  String get currentLine => _text('Current line', '当前线路');
  String get diagnosticReport => _text('Diagnostic report', '诊断报告');
  String get disconnecting => _text('Disconnecting', '正在断开');
  String get exitCheckDisclosure => _text(
    'The check reaches toworld.uk through your selected line.',
    '检测通过所选线路访问 toworld.uk。',
  );
  String get exitFailed => _text('Exit check failed', '出口检测失败');
  String get exitIp => _text('Exit IP', '出口 IP');
  String get exitRegion => _text('Exit region', '出口地区');
  String get exitVerification => _text('Exit verification', '出口验证');
  String get exitVerified => _text('Exit verified', '出口已核验');
  String get managedLines => _text('Managed lines', '托管线路');
  String get membership => _text('Membership', '会员套餐');
  String get membershipRequired =>
      _text('An active membership is required to connect.', '请确认账号有有效套餐。');
  String get membershipSyncFailed => _text(
    'Could not sync the membership configuration. Try refreshing again.',
    '会员配置同步失败，请重新刷新。',
  );
  String get needsSync => _text('Needs sync', '待同步');
  String get noSelectableLines =>
      _text('No selectable lines have loaded.', '暂无可切换的线路。');
  String get privacy => _text('Privacy information', '隐私说明');
  String get privacyDetails => _text(
    'ToWorld processes your sign-in details to authenticate and your plan information to sync your service configuration. When you run an exit check, ToWorld uses the request’s public IP to check its region and response time. You can review the fields included before sending a diagnostic report.',
    'ToWorld 使用登录信息验证账号，并使用套餐信息同步服务配置。主动检测出口时，ToWorld 会根据此次请求的公网 IP 查询地区和响应时间。发送诊断报告前，你可以查看报告包含的字段。',
  );
  String get privacyRead =>
      _text('I have read the privacy information', '我已阅读隐私说明');
  String get readyToCheck => _text('Ready to check', '可以开始检测');
  String get readyToConnect => _text('Ready to connect', '准备就绪');
  String get refreshMembership =>
      _text('Refresh membership and configuration', '刷新套餐和配置');
  String get refreshToSync =>
      _text('Refresh to sync your managed configuration.', '请刷新并同步托管配置。');
  String get remainingData => _text('Remaining data', '剩余流量');
  String get reportFailed =>
      _text('Could not send the report. Try again.', '报告发送失败，请重试。');
  String get reportSent => _text('Diagnostic report sent.', '诊断报告已发送。');
  String get responseTime => _text('Response time', '响应时间');
  String get selectLineToCheck =>
      _text('Select a managed line to check', '选择托管线路后即可检测');
  String get sendReport => _text('Send report', '发送报告');
  String get signIn => _text('Sign in and sync', '登录并同步');
  String get signInHint =>
      _text('Sign in to sync your plan and lines.', '登录后自动同步套餐和线路。');
  String get synced => _text('Synced', '已同步');
  String get syncedAndReady =>
      _text('Configuration synced and ready to connect.', '配置已同步，可以连接。');
  String get syncing =>
      _text('Syncing your service configuration…', '正在同步服务配置…');
  String get testLines => _text('Test line response times', '检测线路延迟');
  String get testingLines => _text('Testing lines…', '正在检测线路…');
  String get toworldMember => _text('ToWorld member', 'ToWorld 会员');
  String get tunnelUnavailable => _text('VPN tunnel unavailable', 'VPN 隧道尚未就绪');
  String get vpnConnected => _text('VPN connected', '连接已开启');
  String get vpnRunning =>
      _text('ToWorld VPN is running.', 'ToWorld VPN 正在运行。');
  String get waitingForResponse =>
      _text('Waiting for the VPN to respond…', '正在等待 VPN 响应…');
  String get waitingForVpn => _text('Waiting for the VPN', '等待 VPN 连接');
  String get welcome => _text('Welcome to ToWorld', '欢迎使用 ToWorld');
}
