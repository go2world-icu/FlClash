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
  String usedData(String used, String total) =>
      _text('$used used of $total', '已用 / 总流量 · $used / $total');
  String get usedDataLabel => _text('Used / total data', '已用 / 总流量');
  String daysRemaining(int days) => _text(
    days == 1 ? 'Expires in 1 day' : 'Expires in $days days',
    '$days 天后到期',
  );
  String lineCount(int count) =>
      _text(count == 1 ? '1 line' : '$count lines', '$count 条线路');
  String get accountRestricted => _text('Account restricted', '账号受限');
  String get aboutToWorld => _text('About ToWorld', '关于 ToWorld');
  String get appVersion => _text('App version', 'App 版本');
  String get accountSyncFailed =>
      _text('Could not refresh account or plan details.', '账号或套餐信息刷新失败。');
  String get checkConnection => _text('Check connection', '开始检测');
  String get configuration => _text('Configuration', '托管配置');
  String get confirmReport => _text(
    'Send this diagnostic summary to ToWorld support?',
    '将这份诊断摘要发送给 ToWorld 支持？',
  );
  String get connect => _text('Connect', '一键连接');
  String get connectToLoadLines => _text(
    'Connect first to load the lines from your plan.',
    '请先连接，线路会从当前套餐同步。',
  );
  String get connectionChecklist => _text('Connection checklist', '连接检查');
  String get connectionActivity =>
      _text('Recent connection activity', '最近的连接活动');
  String get connectionDuration => _text('Duration', '连接时长');
  String get connectionFailed => _text(
    'Connection failed. Try again or open Connection Health.',
    '连接失败，请重试或查看连接健康。',
  );
  String get connectionHealth => _text('Connection health', '连接健康');
  String get currentLine => _text('Current line', '当前线路');
  String get copySummary => _text('Copy summary', '复制摘要');
  String get copyFailed => _text('Could not copy to clipboard.', '无法复制到剪贴板。');
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
  String get extensionUnavailable =>
      _text('VPN extension did not respond', 'VPN 扩展未响应');
  String get coreUnavailable => _text('Core not ready', '内核尚未就绪');
  String get ready => _text('Ready', '已就绪');
  String get reconnecting => _text('Reconnecting', '正在恢复连接');
  String get notChecked => _text('Not checked', '待检测');
  String get inviteRewards => _text('Invite and earn', '邀请返佣');
  String get shareInvite => _text('Share invitation', '分享邀请');
  String get generateInviteCode => _text('Generate invite code', '生成邀请码');
  String get inviteLinkUnavailable =>
      _text('The member website is unavailable.', '会员网站暂不可用。');
  String get renewedOnWebsite => _text('Renew on website', '官网续费');
  String get openWebsiteFailed =>
      _text('Could not open the member website.', '无法打开会员网站。');
  String get latestConfigSync => _text('Last configuration sync', '最近同步');
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
  String get searchLines => _text('Search lines', '搜索线路');
  String get noMatchingLines => _text('No matching lines', '没有匹配的线路');
  String get lineNotTested => _text('Not tested', '未测速');
  String get autoLineHint =>
      _text('Picks an available line for this network', '按当前网络挑选可用线路');
  String get useLine => _text('Use this line', '使用此线路');
  String get lineChangeFailed => _text('Could not switch lines.', '线路切换失败。');
  String get lineTestFailed => _text('Could not test lines.', '无法测试线路。');
  String get privacy => _text('Privacy information', '隐私说明');
  String get privacyDetails => _text(
    'ToWorld processes your sign-in details to authenticate and your plan information to sync your service configuration. When you run an exit check, ToWorld uses the request’s public IP to check its region and response time. You can review the fields included before sending a diagnostic report.',
    'ToWorld 使用登录信息验证账号，并使用套餐信息同步服务配置。主动检测出口时，ToWorld 会根据此次请求的公网 IP 查询地区和响应时间。发送诊断报告前，你可以查看报告包含的字段。',
  );
  String get privacyRead =>
      _text('I have read the privacy information', '我已阅读隐私说明');
  String get readyToCheck => _text('Ready to check', '可以检测');
  String get readyToConnect => _text('Ready to connect', '准备就绪');
  String get refreshMembership =>
      _text('Refresh membership and configuration', '刷新套餐和配置');
  String get refreshToSync =>
      _text('Refresh to sync your managed configuration.', '请刷新并同步托管配置。');
  String get remainingData => _text('Remaining data', '剩余流量');
  String get reportFailed =>
      _text('Could not send the report. Try again.', '报告发送失败，请重试。');
  String get reportSent => _text('Diagnostic report sent.', '诊断报告已发送。');
  String get responseTime => _text('Response time', '线路延迟');
  String get selectLineToCheck =>
      _text('Select a managed line to check', '选择托管线路后即可检测');
  String get sendReport => _text('Send report', '发送报告');
  String get signIn => _text('Sign in and sync', '登录并同步');
  String get signInHint =>
      _text('Sign in to sync your plan and lines.', '登录后自动同步你的套餐和线路。');
  String get synced => _text('Synced', '已同步');
  String get configDownloadFailed =>
      _text('Configuration download failed', '配置下载失败');
  String get configValidationFailed =>
      _text('Configuration validation failed', '配置校验失败');
  String get configSaveFailed =>
      _text('Could not save configuration', '配置保存失败');
  String get configSyncFailed => _text('Configuration sync failed', '配置同步失败');
  String get syncedAndReady =>
      _text('Configuration synced and ready to connect.', '配置已同步，可以连接');
  String get syncing =>
      _text('Syncing your service configuration…', '正在同步服务配置…');
  String get testLines => _text('Test line response times', '全部测速');
  String get testingLines => _text('Testing lines…', '测速中…');
  String get toworldMember => _text('ToWorld member', 'ToWorld 会员');
  String get tunnelUnavailable => _text('VPN tunnel unavailable', 'VPN 隧道尚未就绪');
  String get vpnConnected => _text('VPN connected', '连接已开启');
  String get vpnRunning => _text('ToWorld VPN is running.', 'ToWorld VPN 正在运行');
  String get waitingForResponse =>
      _text('Waiting for the VPN to respond…', '正在等待 VPN 响应…');
  String get waitingForVpn => _text('Waiting for the VPN', '等待连接');

  String get my => _text('My', '我的');
  String get accountTitle => _text('My account', '我的账户');
  String get disconnect => _text('Disconnect', '断开连接');
  String get notConnected => _text('Not connected', '未连接');
  String get upstream => _text('Upload', '上行');
  String get downstream => _text('Download', '下行');
  String get expiryDate => _text('Expiry date', '到期日期');
  String expiresOn(String date) => _text('Expires on $date', '$date到期');
  String get connectionDiagnosis => _text('Connection diagnostics', '连接诊断');
  String get accountAndPlan => _text('Account and plan', '账号与套餐');
  String get valid => _text('Valid', '有效');
  String get passed => _text('Passed', '通过');
  String get vpnTunnel => _text('VPN tunnel', 'VPN 隧道');
  String get extensionChannel => _text('Extension communication', '扩展通信');
  String get coreStartup => _text('Core startup', '内核启动');
  String get reachable => _text('Reachable', '可达');
  String get waitingForConnection => _text('Waiting for connection', '待连接');
  String get connectionHealthy => _text('Connection healthy', '连接正常');
  String get healthReadyHint => _text(
    'Verify the actual exit region and line latency.',
    '验证实际出口地区和线路延迟。',
  );
  String get healthDisconnectedHint =>
      _text('Connect to verify the exit and line quality.', '连接后可核验出口和线路质量。');
  String get healthSuccessHint => _text(
    'Exit verified. The tunnel and line are available.',
    '出口已核验，隧道和线路均可用。',
  );
  String get healthFailedHint => _text(
    'The VPN tunnel is connected. Try switching lines.',
    'VPN 隧道已连接，可切换线路后重试。',
  );
  String get connectFirst => _text('Connect VPN first', '先连接 VPN');
  String get recheckConnection => _text('Check again', '重新检测');
  String get viewDiagnosticReport => _text('View diagnostic report', '查看诊断报告');
  String get summaryCopied => _text('Diagnostic summary copied.', '诊断摘要已复制。');
  String get lineTestHint =>
      _text('Latency comes from the most recent line test.', '延迟来自最近一次线路测试。');
  String get linesTestingHint => _text('Testing line latency…', '正在测试线路延迟…');
  String get linesTestedHint => _text('Testing completed.', '测速已完成。');
  String get linesDisconnectedHint =>
      _text('Connect to test and switch lines.', '连接后可以测速和换线。');
  String get lineTimeout => _text('Test timed out', '测速超时');
  String get vpnActivityConnected => _text('VPN connected', 'VPN 已连接');
  String get commissionRules => _text('Commission rules', '返佣规则');
  String get pendingSettlement => _text('Pending settlement', '待结算');
  String get cumulativeCommission => _text('Total commission', '累计佣金');
  String get invited => _text('Invited', '已邀请');
  String invitedCount(int count) => _text('$count', '$count 人');
  String commissionRate(String rate) =>
      _text('Commission rate $rate%', '返佣比例 $rate%');
  String commissionRuleDetails(String rate) => _text(
    'Earn commission when a friend registers through your invitation link and completes an eligible order. The current commission rate is $rate%.\nPending commission becomes available after the order is settled.',
    '好友通过你的邀请链接注册并完成符合条件的订单后，可获得返佣。当前返佣比例为 $rate%。\n订单结算后，待结算佣金会计入可用佣金。',
  );
  String get copyLink => _text('Copy link', '复制链接');
  String get inviteLink => _text('Invitation link', '邀请链接');
  String get commissionDetails => _text('Commission details', '佣金明细');
  String get invitationCommission => _text('Invitation commission', '邀请佣金');
  String get logoutTitle => _text('Sign out of ToWorld', '退出 ToWorld');
  String get logoutHint => _text(
    'Signing out disconnects the VPN and returns to the sign-in page.',
    '退出会断开 VPN，并返回登录页面。',
  );
  String get confirmLogout => _text('Confirm sign out', '确认退出');

  String get welcome => _text('Welcome to ToWorld', '欢迎使用 ToWorld');
}
