// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  static String m0(count, skipped) => "将添加 ${count} 项，跳过 ${skipped} 项已存在";

  static String m1(code) =>
      "Windows 拒绝运行 FlClashCore.exe（错误 ${code}）。智能应用控制、AppLocker 等应用控制策略会拦截未签名程序，请在该策略中放行 FlClash 或关闭策略后重试。";

  static String m2(name) =>
      "应用连续两次未能完成启动。为打断崩溃循环，已取消选中配置 ${name}，并跳过本次自动配置，你可以随时重新选中它。";

  static String m3(url) => "是否要通过 ${url} 创建配置？";

  static String m4(rate) => "当前综合佣金返利比例：${rate}%";

  static String m5(count) => "${count} 天前";

  static String m6(label) => "确定删除选中的${label}吗？";

  static String m7(label) => "确定删除当前${label}吗？";

  static String m8(label) => "${label}详情";

  static String m9(label) => "${label}不能为空";

  static String m10(count) => "${count} 个条目";

  static String m11(label) => "${label}当前已存在";

  static String m12(name) => "${name} 已是最新版本";

  static String m13(name) => "${name} 已更新";

  static String m14(name) => "正在更新 ${name}...";

  static String m15(action) => "已被“${action}”使用，保存后将移到这里";

  static String m16(modifiers) => "至少包含 ${modifiers} 中的一个";

  static String m17(count) => "${count} 小时前";

  static String m18(count) => "${count} 小时";

  static String m19(target) => "${target} 是一个无效的策略";

  static String m20(proxyName) => "${proxyName} 是一个无效的代理";

  static String m21(providerName) => "${providerName} 是一个无效的代理集";

  static String m22(ruleSet) => "${ruleSet} 不是有效的规则集";

  static String m23(subRule) => "${subRule} 是一个无效的SUB_RULE";

  static String m24(line, message) => "第 ${line} 行：${message}";

  static String m25(appName) =>
      "1. 打开 系统设置 > 隐私与安全性\n2. 选择 定位服务\n3. 在右侧列表中找到并勾选 ${appName}\n\n完成设置后，返回应用即可正常使用。感谢您的配合。";

  static String m26(error) => "登出失败：${error}";

  static String m27(label, max) => "${label}最多${max}个字符";

  static String m28(amount) => "最大可划转: ¥${amount}";

  static String m29(size) => "已释放 ${size}";

  static String m30(count) => "${count} 分钟前";

  static String m31(count) => "${count} 个月前";

  static String m32(code) => "服务器拒绝访问（HTTP ${code}），链接可能已过期或凭据有误";

  static String m33(code) => "服务器拒绝了请求（HTTP ${code}）";

  static String m34(code) => "该地址下没有内容（HTTP ${code}），请确认链接是否正确";

  static String m35(detail) => "网络请求失败：${detail}";

  static String m36(code) => "服务器出现问题（HTTP ${code}），请稍后再试";

  static String m37(label) => "暂无${label}";

  static String m38(label) => "${label}必须为数字";

  static String m39(statusCode) => "获取消息失败: ${statusCode}";

  static String m40(error) => "选择图片失败: ${error}";

  static String m41(method) => "不支持的HTTP方法: ${method}";

  static String m42(error) => "上传失败: ${error}";

  static String m43(amount) => "订单金额: ${amount}";

  static String m44(orderNo) => "订单: ${orderNo}";

  static String m45(message) => "内核无法解析该代理：${message}";

  static String m46(name) => "名称 ${name} 已被其他代理或策略组使用";

  static String m47(path) => "策略组之间存在循环引用：${path}";

  static String m48(names) => "以下代理集不存在：${names}";

  static String m49(names) => "以下代理或策略不存在：${names}";

  static String m50(name) => "${name} 是内置策略名，不能在此使用";

  static String m51(names) => "配置文件自身的策略组引用了自定义代理中已没有的代理：${names}";

  static String m52(count) => "${count} 项存在问题，应用覆写可能失败";

  static String m53(page) => "第 ${page} 页";

  static String m54(label) => "${label} 必须在 1024 到 49151 之间";

  static String m55(label, profiles) =>
      "${label} 仍被 ${profiles} 的自定义策略组或规则使用，请先在那里移除";

  static String m56(profiles, label) =>
      "${profiles} 的订阅里已有 ${label}，改名后这些配置会改用订阅里的那个，请换一个名称";

  static String m57(count) => "${count} 个代理";

  static String m58(e) => "注册失败: ${e}";

  static String m59(count) => "${count} 条规则";

  static String m60(appName) => "${appName}（安全模式）";

  static String m61(count) => "${count} 秒";

  static String m62(count) => "已选择 ${count} 项";

  static String m63(e) => "发送验证码失败: ${e}";

  static String m64(time) => "检测于 ${time}";

  static String m65(label) => "${label}只能是一项";

  static String m66(date) => "套餐已于 ${date} 过期，请续费后继续使用";

  static String m67(days) => "套餐将在 ${days} 天后过期，建议及时续费";

  static String m68(days) => "订阅将在 ${days} 天后过期";

  static String m69(count) => "共 ${count} 条记录";

  static String m70(amount) => "划转金额不能超过 ¥${amount}";

  static String m71(error) => "划转失败：${error}";

  static String m72(amount) => "划转成功！已划转 ¥${amount} 到钱包";

  static String m73(version) => "当前版本: ${version}";

  static String m74(version) => "强制更新: ${version}";

  static String m75(version) => "发现新版本: ${version}";

  static String m76(statusCode) => "服务器返回错误状态码 ${statusCode}";

  static String m77(label) => "${label}必须为URL";

  static String m78(email) => "验证码已发送到 ${email}，请查收并输入验证码和新密码";

  static String m79(amount) => "可提现金额: ${amount}";

  static String m80(time) => "运行时间: ${time}";

  static String m81(count) => "${count} 年前";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("关于"),
    "accessControl": MessageLookupByLibrary.simpleMessage("访问控制"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "只允许选中应用进入VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage("配置应用访问代理"),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "应用访问控制已关闭",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "选中应用将会被排除在VPN之外",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage("访问控制设置"),
    "account": MessageLookupByLibrary.simpleMessage("账号"),
    "action": MessageLookupByLibrary.simpleMessage("操作"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage("测试全部延迟"),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("直连模式"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage("全局模式"),
    "actionMode": MessageLookupByLibrary.simpleMessage("切换模式"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("规则模式"),
    "actionStart": MessageLookupByLibrary.simpleMessage("启动/停止"),
    "actionTun": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage("更新全部配置"),
    "actionView": MessageLookupByLibrary.simpleMessage("显示/隐藏"),
    "action_mode": MessageLookupByLibrary.simpleMessage("切换模式"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "action_start": MessageLookupByLibrary.simpleMessage("启动/停止"),
    "action_tun": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "action_view": MessageLookupByLibrary.simpleMessage("显示/隐藏"),
    "add": MessageLookupByLibrary.simpleMessage("添加"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("添加代理"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage("添加覆写项"),
    "addProfile": MessageLookupByLibrary.simpleMessage("添加配置"),
    "addProxies": MessageLookupByLibrary.simpleMessage("添加代理"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage("添加策略组"),
    "addProxyProviders": MessageLookupByLibrary.simpleMessage("添加代理集"),
    "addRule": MessageLookupByLibrary.simpleMessage("添加规则"),
    "addSsid": MessageLookupByLibrary.simpleMessage("添加SSID"),
    "addWidget": MessageLookupByLibrary.simpleMessage("添加组件"),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage("附加到原始规则"),
    "addedRules": MessageLookupByLibrary.simpleMessage("附加规则"),
    "additionalParameters": MessageLookupByLibrary.simpleMessage("附加参数"),
    "address": MessageLookupByLibrary.simpleMessage("地址"),
    "addressHelp": MessageLookupByLibrary.simpleMessage("WebDAV服务器地址"),
    "addressTip": MessageLookupByLibrary.simpleMessage("请输入有效的WebDAV地址"),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage("管理员自启动"),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage("使用管理员模式开机自启动"),
    "advancedConfig": MessageLookupByLibrary.simpleMessage("进阶配置"),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage(
      "网络、DNS、附加规则与脚本",
    ),
    "ago": MessageLookupByLibrary.simpleMessage("前"),
    "agree": MessageLookupByLibrary.simpleMessage("同意"),
    "allApps": MessageLookupByLibrary.simpleMessage("所有应用"),
    "allowBypass": MessageLookupByLibrary.simpleMessage("允许应用绕过VPN"),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage("开启后部分应用可绕过VPN"),
    "allowLan": MessageLookupByLibrary.simpleMessage("局域网代理"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage("允许通过局域网访问代理"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage("已有账号？"),
    "answers": MessageLookupByLibrary.simpleMessage("应答"),
    "app": MessageLookupByLibrary.simpleMessage("应用"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage("应用访问控制"),
    "appDesc": MessageLookupByLibrary.simpleMessage("处理应用相关设置"),
    "appIconDesign": MessageLookupByLibrary.simpleMessage("应用图标设计"),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage("追加系统DNS"),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage("强制为配置附加系统DNS"),
    "application": MessageLookupByLibrary.simpleMessage("应用程序"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage("修改应用程序相关设置"),
    "authentication": MessageLookupByLibrary.simpleMessage("认证"),
    "authenticationDesc": MessageLookupByLibrary.simpleMessage(
      "为本地代理端口启用认证，防止本机其他应用擅自使用",
    ),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "认证启用时不生效",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("授权"),
    "authorized": MessageLookupByLibrary.simpleMessage("已授权"),
    "auto": MessageLookupByLibrary.simpleMessage("自动"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage("自动检查更新"),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage("应用启动时自动检查更新"),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage("自动关闭连接"),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "切换节点后自动关闭连接",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("自启动"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage("跟随系统自启动"),
    "autoRun": MessageLookupByLibrary.simpleMessage("自动运行"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage("应用打开时自动运行"),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage("自动设置系统DNS"),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("自动更新"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage("自动更新间隔（分钟）"),
    "availableCommission": MessageLookupByLibrary.simpleMessage("可用佣金"),
    "back": MessageLookupByLibrary.simpleMessage("返回"),
    "backToLogin": MessageLookupByLibrary.simpleMessage("返回登录"),
    "backup": MessageLookupByLibrary.simpleMessage("备份"),
    "backupAndRecovery": MessageLookupByLibrary.simpleMessage("备份与恢复"),
    "backupAndRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "通过WebDAV或者文件同步数据",
    ),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage("备份与恢复"),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "通过WebDAV或者文件同步数据",
    ),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "该备份来自更高版本的应用，请先更新应用再恢复",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("备份成功"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("基本配置"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage("全局修改基本配置"),
    "basicInfo": MessageLookupByLibrary.simpleMessage("基础信息"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("基础策略"),
    "batchAdd": MessageLookupByLibrary.simpleMessage("批量添加"),
    "batchListInputTip": MessageLookupByLibrary.simpleMessage("每行一项，也可用逗号分隔"),
    "batchMapInputTip": MessageLookupByLibrary.simpleMessage("每行一条，键和值之间用空格分隔"),
    "batchPreviewTip": m0,
    "batteryOptimizationDesc": MessageLookupByLibrary.simpleMessage(
      "为保证后台运行，请关闭本应用的电池优化。点击前往设置。",
    ),
    "batteryOptimizationStatusTip": MessageLookupByLibrary.simpleMessage(
      "由于系统限制，运行状态下无法正确获取电池优化状态",
    ),
    "behavior": MessageLookupByLibrary.simpleMessage("行为"),
    "bind": MessageLookupByLibrary.simpleMessage("绑定"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("黑名单模式"),
    "blockConnection": MessageLookupByLibrary.simpleMessage("阻止连接"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("排除域名"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage("仅在系统代理启用时生效"),
    "cache": MessageLookupByLibrary.simpleMessage("缓存"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage("缓存算法"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage("缓存已损坏，是否清空？"),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("缓存大小"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "请在系统设置中允许访问相机以扫描二维码，或从相册选择二维码图片。",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage("需要相机权限"),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage("相机不可用"),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage("取消过滤系统应用"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("取消全选"),
    "cannotGetWebUrl": MessageLookupByLibrary.simpleMessage("无法获取网页地址，请联系客服"),
    "cannotOpenBrowser": MessageLookupByLibrary.simpleMessage(
      "无法打开浏览器，请手动访问网页版",
    ),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "切换代理失败，已恢复上一次的选择",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage("重大变更"),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("新功能"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage("问题修复"),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage("性能优化"),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("已回滚"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage("校验 TLS 证书"),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "拒绝不受信任的证书。关闭后订阅和备份将暴露于中间人攻击",
    ),
    "checkError": MessageLookupByLibrary.simpleMessage("检测失败"),
    "checkNetwork": MessageLookupByLibrary.simpleMessage("请检查网络连接后重试"),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage("当前应用已经是最新版了"),
    "checking": MessageLookupByLibrary.simpleMessage("检测中..."),
    "clearData": MessageLookupByLibrary.simpleMessage("清除数据"),
    "clearSearch": MessageLookupByLibrary.simpleMessage("清除搜索"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("导出剪贴板"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("剪贴板导入"),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "无法复制到剪贴板，所选内容可能过大",
    ),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "closeConnections": MessageLookupByLibrary.simpleMessage("关闭连接"),
    "color": MessageLookupByLibrary.simpleMessage("颜色"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("配色方案"),
    "columns": MessageLookupByLibrary.simpleMessage("列数"),
    "commissionHistory": MessageLookupByLibrary.simpleMessage("佣金历史"),
    "commissionRate": MessageLookupByLibrary.simpleMessage("佣金比例"),
    "commissionSettled": MessageLookupByLibrary.simpleMessage(
      "佣金将在好友订阅成功后结算到账户",
    ),
    "compatible": MessageLookupByLibrary.simpleMessage("兼容模式"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "开启将失去部分应用能力，获得全量的Clash的支持",
    ),
    "complete": MessageLookupByLibrary.simpleMessage("完成"),
    "completeWithdrawal": MessageLookupByLibrary.simpleMessage(
      "网页版提供更完整的提现功能和支付方式选择",
    ),
    "configDataDetected": MessageLookupByLibrary.simpleMessage("检测到配置中存在数据"),
    "configurationError": MessageLookupByLibrary.simpleMessage("应用配置异常，请联系客服"),
    "confirm": MessageLookupByLibrary.simpleMessage("确定"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage("确定要清除所有数据？"),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "确定要删除当前策略组吗？",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage("确定要退出当前窗口吗？"),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage("确定要强制崩溃核心？"),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("确认登出"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage("确认新密码"),
    "confirmOverwriteTip": MessageLookupByLibrary.simpleMessage("确定后将会覆盖已有数据"),
    "confirmTransfer": MessageLookupByLibrary.simpleMessage("确认划转"),
    "connected": MessageLookupByLibrary.simpleMessage("已连接"),
    "connecting": MessageLookupByLibrary.simpleMessage("连接中…"),
    "connection": MessageLookupByLibrary.simpleMessage("连接"),
    "connections": MessageLookupByLibrary.simpleMessage("连接"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage("查看当前连接数据"),
    "connectivity": MessageLookupByLibrary.simpleMessage("连通性："),
    "contactMe": MessageLookupByLibrary.simpleMessage("联系我"),
    "contactSupport": MessageLookupByLibrary.simpleMessage("联系客服"),
    "content": MessageLookupByLibrary.simpleMessage("内容"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage("内容不能为空"),
    "contentScheme": MessageLookupByLibrary.simpleMessage("内容主题"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage("控制全局附加规则"),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage("已复制到剪贴板"),
    "copy": MessageLookupByLibrary.simpleMessage("复制"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage("复制环境变量"),
    "copyInviteLink": MessageLookupByLibrary.simpleMessage("复制邀请链接"),
    "copyLink": MessageLookupByLibrary.simpleMessage("复制链接"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("复制成功"),
    "core": MessageLookupByLibrary.simpleMessage("内核"),
    "coreBlockedByPolicyTip": m1,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Windows 智能应用控制拦截了未签名的 FlClashCore.exe。请打开 Windows 安全中心 → 应用和浏览器控制 → 智能应用控制设置，选择「关闭」后重新启动 FlClash。智能应用控制关闭后无法再开启，除非重装 Windows。",
    ),
    "coreInfo": MessageLookupByLibrary.simpleMessage("内核信息"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("核心状态"),
    "country": MessageLookupByLibrary.simpleMessage("区域"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("检测到崩溃"),
    "crashDetectedTip": m2,
    "crashTest": MessageLookupByLibrary.simpleMessage("崩溃测试"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("崩溃分析"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "开启后，应用崩溃时自动上传不包含敏感信息的崩溃日志",
    ),
    "create": MessageLookupByLibrary.simpleMessage("创建"),
    "createAccount": MessageLookupByLibrary.simpleMessage("创建账号"),
    "createProfile": MessageLookupByLibrary.simpleMessage("创建配置"),
    "createProfileFromUrlTip": m3,
    "creationTime": MessageLookupByLibrary.simpleMessage("创建时间"),
    "credentialsSaved": MessageLookupByLibrary.simpleMessage("凭据已保存"),
    "currentCommissionRate": m4,
    "custom": MessageLookupByLibrary.simpleMessage("自定义"),
    "customProxiesEmpty": MessageLookupByLibrary.simpleMessage(
      "未添加自定义代理，沿用配置文件自身的代理",
    ),
    "cut": MessageLookupByLibrary.simpleMessage("剪切"),
    "dark": MessageLookupByLibrary.simpleMessage("深色"),
    "dashboard": MessageLookupByLibrary.simpleMessage("仪表盘"),
    "dataChangedSave": MessageLookupByLibrary.simpleMessage("检测到数据有更改，是否保存"),
    "dataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "本应用使用 Firebase Crashlytics 收集崩溃信息以改进应用稳定性。\n收集的数据包括设备信息和崩溃详情，不包含个人敏感数据。\n您可以在设置中关闭此功能。",
    ),
    "dataCollectionTip": MessageLookupByLibrary.simpleMessage("数据收集说明"),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "保存更改失败，已回滚",
    ),
    "days": MessageLookupByLibrary.simpleMessage("天"),
    "daysAgo": m5,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage("默认域名服务器"),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage("用于解析DNS服务器"),
    "defaultSort": MessageLookupByLibrary.simpleMessage("按默认排序"),
    "defaultText": MessageLookupByLibrary.simpleMessage("默认"),
    "delay": MessageLookupByLibrary.simpleMessage("延迟"),
    "delaySort": MessageLookupByLibrary.simpleMessage("按延迟排序"),
    "delayTest": MessageLookupByLibrary.simpleMessage("延迟测试"),
    "delete": MessageLookupByLibrary.simpleMessage("删除"),
    "deleteMultipTip": m6,
    "deleteTip": m7,
    "desc": MessageLookupByLibrary.simpleMessage(
      "基于ClashMeta的多平台代理客户端，简单易用，开源无广告。",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("目标地址"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage("目标地理定位"),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage("目标IP ASN"),
    "details": m8,
    "detectionTip": MessageLookupByLibrary.simpleMessage("依赖第三方api，仅供参考"),
    "developerMode": MessageLookupByLibrary.simpleMessage("开发者模式"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage("开发者模式已启用。"),
    "dialerProxy": MessageLookupByLibrary.simpleMessage("拨号代理"),
    "dialerProxyDesc": MessageLookupByLibrary.simpleMessage("用于连接NTP服务器的出站"),
    "direct": MessageLookupByLibrary.simpleMessage("直连"),
    "disableUDP": MessageLookupByLibrary.simpleMessage("禁用UDP"),
    "disabled": MessageLookupByLibrary.simpleMessage("已关闭"),
    "discardChanges": MessageLookupByLibrary.simpleMessage("是否放弃更改？"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("免责声明"),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "一旦你安装、复制或使用本软件，即视为你已阅读并同意本声明的全部内容。如你不同意本声明的任何条款，请立即停止使用并卸载本软件。",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage("接受声明"),
    "disclaimerAnalyticsContent": MessageLookupByLibrary.simpleMessage(
      "随 Firebase 自动收集基础的应用使用统计。\n\n收集内容：首次启动、应用打开与会话时长、应用更新等基础事件，应用实例标识，设备型号、系统版本、系统语言，以及由 IP 地址推断的国家或地区级大致位置。\n\n用途：仅用于了解活跃设备数、版本分布与系统兼容情况。开发者不会将这些数据用于广告，不会出售，也不会与你的订阅或配置相关联。",
    ),
    "disclaimerAnalyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Firebase Analytics（使用统计）",
    ),
    "disclaimerAndroidOnly": MessageLookupByLibrary.simpleMessage("仅 Android"),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "开发者有权随版本更新修改本声明，修改后的内容随新版本发布即生效。你在更新后继续使用本软件，即视为接受修改后的声明。",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage("声明变更"),
    "disclaimerCrashlyticsContent": MessageLookupByLibrary.simpleMessage(
      "应用发生崩溃时，自动上传崩溃报告。\n\n收集内容：崩溃堆栈与错误信息、崩溃发生时间、应用版本与构建号、设备品牌与型号、Android 系统版本、屏幕方向、剩余内存与存储空间、设备是否已 root，以及一个随安装生成、重装后即重置的随机安装标识。\n\n用途：仅用于定位和修复崩溃问题。\n\n你可以在“工具 > 常规 > 崩溃分析”中随时关闭。",
    ),
    "disclaimerCrashlyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Firebase Crashlytics（崩溃分析）",
    ),
    "disclaimerDataProcessingContent": MessageLookupByLibrary.simpleMessage(
      "上述数据由 Google 代为处理和存储，可能被传输至你所在国家或地区以外（如美国）的服务器，并受 Google 隐私政策与 Firebase 隐私和安全说明约束。崩溃报告最多保留 90 天，统计数据按 Firebase 的默认策略保留。",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "在使用 FlClash（以下简称“本软件”）前，请仔细阅读并充分理解本声明的全部内容。点击“同意”即表示你已阅读、理解并接受以下全部条款；如不同意，请点击“退出”并停止使用本软件。",
    ),
    "disclaimerFirebasePrivacy": MessageLookupByLibrary.simpleMessage(
      "Firebase 隐私和安全说明",
    ),
    "disclaimerGooglePrivacy": MessageLookupByLibrary.simpleMessage(
      "Google 隐私政策",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "在适用法律允许的最大范围内，开发者及所有贡献者均不对因使用或无法使用本软件而产生的任何直接、间接、偶然、特殊、惩罚性或后果性损害承担责任，包括但不限于数据丢失、设备损坏、网络异常、业务中断、利润损失或因此引起的任何法律纠纷，即使已被告知发生此类损害的可能性。",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage("责任限制"),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "本软件以 GPL-3.0 协议开源。你可以在遵守该协议的前提下自由使用、修改和分发本软件，但须同样以 GPL-3.0 协议开源并保留原作者的版权声明。\n\n本软件包含的第三方组件（包括 Clash.Meta 内核）分别遵循其各自的开源协议。基于本软件修改或分发的版本所产生的任何问题，与原作者无关。",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage("开源协议"),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "本软件不会收集或上传你的订阅地址、节点信息、配置内容、访问的网站、连接记录、流量内容和日志，这些数据仅保存在你的设备本地，开发者无法获取。\n\n本软件只会在你使用相应功能时访问外部网络，例如更新订阅时访问你提供的订阅地址、检查更新时访问 GitHub。\n\n桌面版（Windows、macOS、Linux）未集成任何数据统计或崩溃上报服务。Android 版集成了 Google Firebase 的以下两项服务，用于改进应用稳定性：",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage("数据收集与隐私"),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "你应自行确认使用本软件在你所在国家或地区是合法的，并对使用本软件的全部行为及其后果独立承担法律责任。\n\n你导入的订阅、节点与配置由你自行选择和判断，其来源是否合法、内容是否安全、服务是否稳定，均由你与相关提供者自行负责。",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "用户责任",
    ),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "本软件是基于 Clash.Meta（mihomo）内核的开源网络代理客户端，仅提供配置管理、规则分流与流量转发等本地工具功能。\n\n本软件自身不提供任何代理服务器、节点、订阅、机场或网络接入服务，也不与任何此类服务的提供者存在合作、代理或担保关系。",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage("软件性质"),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "订阅链接、配置文件、规则集、脚本、外部资源及外部链接均由第三方提供，开发者无法也不会对其合法性、准确性、安全性和可用性进行审查或担保。\n\n因使用第三方内容导致的数据泄露、财产损失、账号封禁或其他任何损失，由你与第三方自行解决，开发者不承担任何责任。",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage("第三方内容"),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "本软件仅供学习交流、技术研究等非商业用途。严禁将本软件用于任何商业目的，包括但不限于付费分发、捆绑销售、作为商业服务的组成部分或以本软件名义开展经营活动；任何商业行为均与本软件及其开发者无关。\n\n严禁将本软件用于违反你所在国家或地区法律法规的活动，包括但不限于绕过依法设置的网络访问限制、传播违法信息、实施网络攻击或侵犯他人合法权益。",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage("使用限制"),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "本软件按“现状”和“可用”的原则提供，不附带任何明示或默示的担保，包括但不限于适销性、特定用途适用性、不侵权以及持续可用、无错误、无安全漏洞的担保。\n\n开发者不保证本软件能满足你的需求，也不保证本软件的运行不会中断或不会出现错误。",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage("无担保声明"),
    "disconnected": MessageLookupByLibrary.simpleMessage("已断开"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage("发现新版本"),
    "discovery": MessageLookupByLibrary.simpleMessage("发现新版本"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("更新DNS相关设置"),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS劫持"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS模式"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("DNS查询"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage("是否要通过"),
    "docked": MessageLookupByLibrary.simpleMessage("固定"),
    "domain": MessageLookupByLibrary.simpleMessage("域名"),
    "domainStatusAvailable": MessageLookupByLibrary.simpleMessage("服务可用"),
    "domainStatusChecking": MessageLookupByLibrary.simpleMessage("检查中..."),
    "domainStatusUnavailable": MessageLookupByLibrary.simpleMessage("服务不可用"),
    "download": MessageLookupByLibrary.simpleMessage("下载"),
    "edit": MessageLookupByLibrary.simpleMessage("编辑"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage("编辑全局规则"),
    "editProxy": MessageLookupByLibrary.simpleMessage("编辑代理"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage("编辑策略组"),
    "editRule": MessageLookupByLibrary.simpleMessage("编辑规则"),
    "editSsid": MessageLookupByLibrary.simpleMessage("编辑SSID"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage("编辑器不可用"),
    "emailAddress": MessageLookupByLibrary.simpleMessage("邮箱地址"),
    "emailVerificationCode": MessageLookupByLibrary.simpleMessage("邮箱验证码"),
    "emptyTip": m9,
    "en": MessageLookupByLibrary.simpleMessage("英语"),
    "enableOverride": MessageLookupByLibrary.simpleMessage("启用覆写"),
    "enabled": MessageLookupByLibrary.simpleMessage("已开启"),
    "enterEmailForReset": MessageLookupByLibrary.simpleMessage(
      "请输入您的邮箱地址，我们会发送验证码到您的邮箱",
    ),
    "enterTransferAmount": MessageLookupByLibrary.simpleMessage("请输入划转金额"),
    "enterTransferAmountError": MessageLookupByLibrary.simpleMessage("请输入划转金额"),
    "entries": MessageLookupByLibrary.simpleMessage("个条目"),
    "entriesCount": m10,
    "error": MessageLookupByLibrary.simpleMessage("错误"),
    "exclude": MessageLookupByLibrary.simpleMessage("从最近任务中隐藏"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage("应用在后台时，从最近任务中隐藏应用"),
    "excludeProxyFilter": MessageLookupByLibrary.simpleMessage("排除节点过滤器"),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("排除SSIDs"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "连接到被排除SSID的WIFI时，将会自动切换应用运行状态",
    ),
    "excludeType": MessageLookupByLibrary.simpleMessage("排除类型"),
    "existsTip": m11,
    "exit": MessageLookupByLibrary.simpleMessage("退出"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage("退出全屏"),
    "expand": MessageLookupByLibrary.simpleMessage("标准"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("预期状态"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("到期时间"),
    "expireTime": MessageLookupByLibrary.simpleMessage("到期时间"),
    "exportFile": MessageLookupByLibrary.simpleMessage("导出文件"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("导出日志"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("导出成功"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("表现力"),
    "externalController": MessageLookupByLibrary.simpleMessage("外部控制器"),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "开启后将可以通过9090端口控制Clash内核",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("外部获取"),
    "externalLink": MessageLookupByLibrary.simpleMessage("外部链接"),
    "externalResources": MessageLookupByLibrary.simpleMessage("外部资源"),
    "extraLarge": MessageLookupByLibrary.simpleMessage("超大"),
    "fade": MessageLookupByLibrary.simpleMessage("淡入"),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fake-IP过滤"),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage("Fake-IP过滤模式"),
    "fakeipFilterModeDesc": MessageLookupByLibrary.simpleMessage(
      "blacklist排除匹配项，whitelist仅用于匹配项，rule按规则匹配",
    ),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fake-IP范围"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage("Fake-IP范围（IPv6）"),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("Fake-IP TTL"),
    "fallback": MessageLookupByLibrary.simpleMessage("Fallback"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage("一般情况下使用境外DNS"),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Fallback过滤"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("高保真"),
    "file": MessageLookupByLibrary.simpleMessage("文件"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("直接上传配置文件"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage("文件有修改，是否保存修改"),
    "fillInfoToRegister": MessageLookupByLibrary.simpleMessage("请填写以下信息完成注册"),
    "filter": MessageLookupByLibrary.simpleMessage("筛选"),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage("过滤系统应用"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("查找进程"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage("开启后会有一定性能损耗"),
    "floating": MessageLookupByLibrary.simpleMessage("悬浮"),
    "followProfile": MessageLookupByLibrary.simpleMessage("跟随配置"),
    "followSystem": MessageLookupByLibrary.simpleMessage("跟随系统"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("字体"),
    "fontSize": MessageLookupByLibrary.simpleMessage("大小"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage("您确定要强制重启核心吗？"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("忘记密码"),
    "format": MessageLookupByLibrary.simpleMessage("格式"),
    "fourColumns": MessageLookupByLibrary.simpleMessage("四列"),
    "friendInviteReward": MessageLookupByLibrary.simpleMessage(
      "好友邀请的人成功消费，您也能赚取佣金",
    ),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("果缤纷"),
    "general": MessageLookupByLibrary.simpleMessage("常规"),
    "generalDesc": MessageLookupByLibrary.simpleMessage("修改通用设置"),
    "generatingInviteCode": MessageLookupByLibrary.simpleMessage("正在生成邀请码..."),
    "geoAutoUpdate": MessageLookupByLibrary.simpleMessage("自动更新"),
    "geoAutoUpdateInterval": MessageLookupByLibrary.simpleMessage("自动更新间隔"),
    "geoAutoUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "自动更新间隔必须大于0",
    ),
    "geoData": MessageLookupByLibrary.simpleMessage("地理数据"),
    "geoOptions": MessageLookupByLibrary.simpleMessage("Geo 选项"),
    "geoResources": MessageLookupByLibrary.simpleMessage("Geo 资源"),
    "geoSkipped": m12,
    "geoUpdated": m13,
    "geoUpdating": m14,
    "geodataLoader": MessageLookupByLibrary.simpleMessage("Geo低内存模式"),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage("开启将使用Geo低内存加载器"),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Geoip代码"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage("获取原始规则"),
    "global": MessageLookupByLibrary.simpleMessage("全局"),
    "go": MessageLookupByLibrary.simpleMessage("前往"),
    "goDownload": MessageLookupByLibrary.simpleMessage("前往下载"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage("前往配置脚本"),
    "goToWeb": MessageLookupByLibrary.simpleMessage("前往网页"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage("是否缓存修改"),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "Helper 服务不可用，无法启用 TUN 模式，请重新安装 FlClash。",
    ),
    "hideFromList": MessageLookupByLibrary.simpleMessage("从列表中隐藏"),
    "hideIp": MessageLookupByLibrary.simpleMessage("隐藏 IP"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("隐藏密码"),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage("隐藏超时节点"),
    "hideTimeoutProxiesDesc": MessageLookupByLibrary.simpleMessage(
      "不显示上次延迟测试超时的节点",
    ),
    "host": MessageLookupByLibrary.simpleMessage("主机"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("追加Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("快捷键冲突"),
    "hotkeyConflictWith": m15,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "全局快捷键在窗口隐藏时依然生效，点击操作即可录制组合键。",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage("快捷键管理"),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage("使用键盘控制应用程序"),
    "hotkeyNeedsModifier": m16,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("未设置"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "未能注册，可能已被其他应用占用",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("小时"),
    "hoursAgo": m17,
    "hoursCount": m18,
    "iUnderstand": MessageLookupByLibrary.simpleMessage("我知道了"),
    "icon": MessageLookupByLibrary.simpleMessage("图片"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage("图片配置"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("图标记录"),
    "iconStyle": MessageLookupByLibrary.simpleMessage("图标样式"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("色块"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("隐藏"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("纯图标"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("图标链接"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage("忽略电池优化"),
    "import": MessageLookupByLibrary.simpleMessage("导入"),
    "importFile": MessageLookupByLibrary.simpleMessage("通过文件导入"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("从URL导入"),
    "importUrl": MessageLookupByLibrary.simpleMessage("通过URL导入"),
    "inbound": MessageLookupByLibrary.simpleMessage("入站"),
    "includeAllProxies": MessageLookupByLibrary.simpleMessage("包含所有代理"),
    "includeAllProxiesTip": MessageLookupByLibrary.simpleMessage(
      "引入不包含策略组的所有代理，可在下方额外添加策略组",
    ),
    "includeAllProxyProviders": MessageLookupByLibrary.simpleMessage("包含所有代理集"),
    "includeAllProxyProvidersTip": MessageLookupByLibrary.simpleMessage(
      "开启后包含本配置的全部代理集：订阅自带的，以及任一策略组引用的配置和应用代理集",
    ),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("长期有效"),
    "init": MessageLookupByLibrary.simpleMessage("初始化"),
    "initiator": MessageLookupByLibrary.simpleMessage("发起方"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage("请输入正确的快捷键"),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage("输入策略组名称"),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage("输入规则内容"),
    "installedAppsPermissionDeniedMessage":
        MessageLookupByLibrary.simpleMessage(
          "读取应用列表权限已被拒绝，无法获取已安装的应用。请前往系统设置手动开启。",
        ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "当前系统在授权前不会提供已安装的应用列表，授权后即可配置分应用代理。",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "需要读取应用列表权限",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage("智能选择"),
    "interfaceName": MessageLookupByLibrary.simpleMessage("网卡名称"),
    "interfaceNameDesc": MessageLookupByLibrary.simpleMessage("出站连接使用的网卡名称"),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage("出站网卡"),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("清空"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage("自定义"),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage("跟随配置"),
    "internet": MessageLookupByLibrary.simpleMessage("互联网"),
    "interval": MessageLookupByLibrary.simpleMessage("间隔"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("内网 IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage("无效备份文件"),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "DSCP 标记不能超过 63",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "仅支持 tcp 或 udp",
    ),
    "invalidPolicy": m19,
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "该二维码不包含配置文件链接",
    ),
    "invalidProxy": m20,
    "invalidProxyProvider": m21,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "请输入数字或范围，如 80 或 8000-9000，多个用 / 分隔",
    ),
    "invalidRuleSet": m22,
    "invalidSubRule": m23,
    "invalidTransferAmount": MessageLookupByLibrary.simpleMessage("请输入有效的划转金额"),
    "invite": MessageLookupByLibrary.simpleMessage("邀请"),
    "inviteCode": MessageLookupByLibrary.simpleMessage("邀请码"),
    "inviteCodeGenFailed": MessageLookupByLibrary.simpleMessage("邀请码生成失败"),
    "inviteCodeIncorrect": MessageLookupByLibrary.simpleMessage(
      "邀请码可能不正确，请检查后重新输入",
    ),
    "inviteCodeOptional": MessageLookupByLibrary.simpleMessage("邀请码（可选）"),
    "inviteCodeRequired": MessageLookupByLibrary.simpleMessage("需要邀请码"),
    "inviteCodeRequiredMessage": MessageLookupByLibrary.simpleMessage(
      "注册需要邀请码，请联系已注册用户获取邀请码后再进行注册。",
    ),
    "inviteLinkCopied": MessageLookupByLibrary.simpleMessage("邀请链接已复制，可分享给好友"),
    "inviteRegisterReward": MessageLookupByLibrary.simpleMessage(
      "邀请好友注册并成功订阅，即可获得佣金奖励",
    ),
    "inviteRules": MessageLookupByLibrary.simpleMessage("邀请规则"),
    "inviteStats": MessageLookupByLibrary.simpleMessage("邀请统计"),
    "ipAddress": MessageLookupByLibrary.simpleMessage("IP 地址"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("滥用记录"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("代理"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("命中标记"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("组织"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage("类型查询失败"),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("优"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("等级"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("普通"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage("重新查询"),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("风险"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("采用来源"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("各来源"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage("出站 IP 不一致"),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("无法判定类型"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage("限流"),
    "ipType": MessageLookupByLibrary.simpleMessage("类型"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("商业"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("机房"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("移动网络"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("住宅"),
    "ipcidr": MessageLookupByLibrary.simpleMessage("IP/掩码"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage("开启后将可以接收IPv6流量"),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage("允许IPv6入站"),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage("IPv6超时（毫秒）"),
    "ja": MessageLookupByLibrary.simpleMessage("日语"),
    "just": MessageLookupByLibrary.simpleMessage("刚刚"),
    "justNow": MessageLookupByLibrary.simpleMessage("刚刚"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage("TCP保持活动间隔"),
    "key": MessageLookupByLibrary.simpleMessage("键"),
    "language": MessageLookupByLibrary.simpleMessage("语言"),
    "large": MessageLookupByLibrary.simpleMessage("大"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("上次更新"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage("启动未完成"),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "应用上次在启动过程中意外退出。已跳过本次自动配置，你可以手动启动重试。",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("布局"),
    "light": MessageLookupByLibrary.simpleMessage("浅色"),
    "lineIssueTip": m24,
    "lineWrap": MessageLookupByLibrary.simpleMessage("自动换行"),
    "list": MessageLookupByLibrary.simpleMessage("列表"),
    "listen": MessageLookupByLibrary.simpleMessage("监听"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage("监听路由标记"),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage("仅Linux有效"),
    "liveConnections": MessageLookupByLibrary.simpleMessage("实时连接"),
    "loadMore": MessageLookupByLibrary.simpleMessage("加载更多"),
    "loadTest": MessageLookupByLibrary.simpleMessage("加载测试"),
    "loading": MessageLookupByLibrary.simpleMessage("加载中…"),
    "local": MessageLookupByLibrary.simpleMessage("本地"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage("备份数据到本地"),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "本地网络权限被拒绝：已改用 gvisor 栈，局域网无法访问。",
    ),
    "localRecoveryDesc": MessageLookupByLibrary.simpleMessage("通过文件恢复数据"),
    "locationPermission": MessageLookupByLibrary.simpleMessage("位置权限"),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "位置权限已被拒绝，无法获取当前 Wi-Fi 名称。请前往系统设置手动开启位置权限。",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "根据系统要求，获取Wi-Fi名称需要您授予位置权限。Android 上请选择“始终允许”，否则应用在后台时无法获取 Wi-Fi 名称。",
    ),
    "locationPermissionGuide": m25,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "需要位置权限",
    ),
    "log": MessageLookupByLibrary.simpleMessage("日志"),
    "logLevel": MessageLookupByLibrary.simpleMessage("日志等级"),
    "logcat": MessageLookupByLibrary.simpleMessage("日志捕获"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage("禁用将会隐藏日志入口"),
    "loggedOutSuccess": MessageLookupByLibrary.simpleMessage("已成功登出"),
    "loginNow": MessageLookupByLibrary.simpleMessage("立即登录"),
    "logout": MessageLookupByLibrary.simpleMessage("登出"),
    "logoutConfirmMsg": MessageLookupByLibrary.simpleMessage(
      "确定要登出当前账户吗？登出后需要重新登录。",
    ),
    "logoutFailed": m26,
    "logs": MessageLookupByLibrary.simpleMessage("日志"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage("日志与诊断"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("日志捕获记录"),
    "logsTest": MessageLookupByLibrary.simpleMessage("日志测试"),
    "loopback": MessageLookupByLibrary.simpleMessage("UWP 回环解锁"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage("用于UWP回环解锁"),
    "loose": MessageLookupByLibrary.simpleMessage("宽松"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage("匹配来源IP"),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("最大失败次数"),
    "maxLengthTip": m27,
    "maxTransferable": m28,
    "maximize": MessageLookupByLibrary.simpleMessage("最大化"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage("常驻内存"),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage("应用及共享"),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage("堆内存空闲"),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage("堆内存使用中"),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage("内核未运行"),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage("运行时开销"),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage("协程栈"),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "基于进程常驻内存估算，可能与系统显示的数值不同。",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "内核与应用运行在同一进程，内核部分按运行时统计估算，其余计入应用及共享内存。",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("内存信息"),
    "memoryReleased": MessageLookupByLibrary.simpleMessage("内存已释放"),
    "memoryReleasedSize": m29,
    "messageTest": MessageLookupByLibrary.simpleMessage("消息测试"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("这是一条消息。"),
    "min": MessageLookupByLibrary.simpleMessage("最小"),
    "minimize": MessageLookupByLibrary.simpleMessage("最小化"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("退出时最小化"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage("修改系统默认退出事件"),
    "minutes": MessageLookupByLibrary.simpleMessage("分钟"),
    "minutesAgo": m30,
    "mixedPort": MessageLookupByLibrary.simpleMessage("混合端口"),
    "mode": MessageLookupByLibrary.simpleMessage("模式"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("单色"),
    "months": MessageLookupByLibrary.simpleMessage("月"),
    "monthsAgo": m31,
    "more": MessageLookupByLibrary.simpleMessage("更多"),
    "myInviteQr": MessageLookupByLibrary.simpleMessage("我的邀请二维码"),
    "name": MessageLookupByLibrary.simpleMessage("名称"),
    "nameSort": MessageLookupByLibrary.simpleMessage("按名称排序"),
    "nameserver": MessageLookupByLibrary.simpleMessage("域名服务器"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage("用于解析域名"),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage("域名服务器策略"),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage("指定对应域名服务器策略"),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage("底栏"),
    "network": MessageLookupByLibrary.simpleMessage("网络"),
    "networkAccessDeniedError": m32,
    "networkBadResponseError": m33,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage("请求已取消"),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "无法连接到服务器，请检查网络连接或代理设置",
    ),
    "networkDesc": MessageLookupByLibrary.simpleMessage("修改网络相关设置"),
    "networkDetection": MessageLookupByLibrary.simpleMessage("网络检测"),
    "networkException": MessageLookupByLibrary.simpleMessage("网络异常，请检查连接后重试"),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "无法解析服务器地址，请确认链接正确且 DNS 可用",
    ),
    "networkNotFoundError": m34,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "请求过于频繁（HTTP 429），请稍后再试",
    ),
    "networkRequestFailed": m35,
    "networkServerError": m36,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("网络速度"),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "请求超时，请检查网络或代理后重试",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "安全连接失败，服务器证书可能无效，或连接被拦截",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("网络类型"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("中性"),
    "newMessageFromSupport": MessageLookupByLibrary.simpleMessage("客服新消息"),
    "newPassword": MessageLookupByLibrary.simpleMessage("新密码"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("下一个匹配"),
    "no": MessageLookupByLibrary.simpleMessage("否"),
    "noCommissionRecord": MessageLookupByLibrary.simpleMessage("暂无佣金记录"),
    "noData": MessageLookupByLibrary.simpleMessage("暂无数据"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("暂无快捷键"),
    "noIcon": MessageLookupByLibrary.simpleMessage("无图标"),
    "noInfo": MessageLookupByLibrary.simpleMessage("暂无信息"),
    "noInvitationData": MessageLookupByLibrary.simpleMessage("暂无邀请数据"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage("不再提示"),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage("暂无更多信息"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("无网络"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("无网络应用"),
    "noProxy": MessageLookupByLibrary.simpleMessage("暂无代理"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage("请创建配置文件或者添加有效配置文件"),
    "noRecords": MessageLookupByLibrary.simpleMessage("暂无记录"),
    "noResolve": MessageLookupByLibrary.simpleMessage("不解析IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage("不解析主机名"),
    "noSearchResults": MessageLookupByLibrary.simpleMessage("没有匹配的结果"),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage("该外部资源不是文本文件"),
    "none": MessageLookupByLibrary.simpleMessage("无"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage("当前代理组无法选中"),
    "ntpInterval": MessageLookupByLibrary.simpleMessage("同步间隔（分钟）"),
    "ntpStatusDesc": MessageLookupByLibrary.simpleMessage("从NTP服务器获取时间，而非系统时钟"),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage("添加一个配置文件后即可开始使用"),
    "nullTip": m37,
    "numberTip": m38,
    "onDemand": MessageLookupByLibrary.simpleMessage("按需运行"),
    "onDemandDesc": MessageLookupByLibrary.simpleMessage("配置程序特定场景运行状态"),
    "oneColumn": MessageLookupByLibrary.simpleMessage("一列"),
    "onlineSupport": MessageLookupByLibrary.simpleMessage("在线客服"),
    "onlineSupportAddMore": MessageLookupByLibrary.simpleMessage("添加更多"),
    "onlineSupportApiConfigNotFound": MessageLookupByLibrary.simpleMessage(
      "在线客服API配置未找到，请检查配置",
    ),
    "onlineSupportCancel": MessageLookupByLibrary.simpleMessage("取消"),
    "onlineSupportClearHistory": MessageLookupByLibrary.simpleMessage("清除历史记录"),
    "onlineSupportClearHistoryConfirm": MessageLookupByLibrary.simpleMessage(
      "确定要清除所有聊天历史记录吗？此操作不可恢复。",
    ),
    "onlineSupportClickToSelect": MessageLookupByLibrary.simpleMessage(
      "点击选择图片",
    ),
    "onlineSupportConfirm": MessageLookupByLibrary.simpleMessage("确定"),
    "onlineSupportConnected": MessageLookupByLibrary.simpleMessage("成功连接客服系统"),
    "onlineSupportConnecting": MessageLookupByLibrary.simpleMessage("连接中..."),
    "onlineSupportConnectionError": MessageLookupByLibrary.simpleMessage(
      "连接错误",
    ),
    "onlineSupportDisconnected": MessageLookupByLibrary.simpleMessage("已断开"),
    "onlineSupportGetMessagesFailed": m39,
    "onlineSupportInputHint": MessageLookupByLibrary.simpleMessage(
      "请输入您的问题...",
    ),
    "onlineSupportNoMessages": MessageLookupByLibrary.simpleMessage(
      "暂无消息，发送消息开始咨询",
    ),
    "onlineSupportSelectImages": MessageLookupByLibrary.simpleMessage("选择图片"),
    "onlineSupportSelectImagesFailed": m40,
    "onlineSupportSend": MessageLookupByLibrary.simpleMessage("发送"),
    "onlineSupportSendImage": MessageLookupByLibrary.simpleMessage("发送图片"),
    "onlineSupportSendMessageFailed": MessageLookupByLibrary.simpleMessage(
      "发送消息失败: 无法获取认证token",
    ),
    "onlineSupportSupportedFormats": MessageLookupByLibrary.simpleMessage(
      "支持 JPG, PNG, GIF, WebP, BMP\n最大 10MB",
    ),
    "onlineSupportTitle": MessageLookupByLibrary.simpleMessage("在线客服"),
    "onlineSupportTokenNotFound": MessageLookupByLibrary.simpleMessage(
      "未找到认证token",
    ),
    "onlineSupportUnsupportedHttpMethod": m41,
    "onlineSupportUploadFailed": m42,
    "onlineSupportWebSocketConfigNotFound":
        MessageLookupByLibrary.simpleMessage("在线客服WebSocket配置未找到，请检查配置"),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("仅图标"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage("仅第三方应用"),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage("仅统计代理流量"),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "开启后，将只统计代理流量",
    ),
    "openWebFailed": MessageLookupByLibrary.simpleMessage("打开网页失败，请手动访问网页版"),
    "optional": MessageLookupByLibrary.simpleMessage("可选"),
    "options": MessageLookupByLibrary.simpleMessage("选项"),
    "orderAmount": m43,
    "orderNumber": m44,
    "other": MessageLookupByLibrary.simpleMessage("其他"),
    "otherContributors": MessageLookupByLibrary.simpleMessage("其他贡献者"),
    "outboundIp": MessageLookupByLibrary.simpleMessage("出站 IP"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("出站模式"),
    "override": MessageLookupByLibrary.simpleMessage("覆写"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage("覆写代理相关配置"),
    "overrideDns": MessageLookupByLibrary.simpleMessage("覆写DNS"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage("开启后将覆盖配置中的DNS选项"),
    "overrideEntries": MessageLookupByLibrary.simpleMessage("覆写项"),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage("在脚本模式下不生效"),
    "overrideMode": MessageLookupByLibrary.simpleMessage("覆写模式"),
    "overrideNtp": MessageLookupByLibrary.simpleMessage("覆写NTP"),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage("覆盖原始规则"),
    "overrideScript": MessageLookupByLibrary.simpleMessage("覆写脚本"),
    "overwriteIssueCoreRejected": m45,
    "overwriteIssueDuplicateName": m46,
    "overwriteIssueEmptyName": MessageLookupByLibrary.simpleMessage("名称为空"),
    "overwriteIssueGroupLoop": m47,
    "overwriteIssueMissingProviders": m48,
    "overwriteIssueMissingProxies": m49,
    "overwriteIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "未选择任何代理或代理集，内核会拒绝该策略组",
    ),
    "overwriteIssueReservedName": m50,
    "overwriteIssueSubscriptionGroupMissingProxies": m51,
    "overwriteIssuesSummary": m52,
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage("自定义"),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "自定义模式，支持完全自定义修改代理、策略组以及规则",
    ),
    "pageNumber": m53,
    "palette": MessageLookupByLibrary.simpleMessage("调色板"),
    "password": MessageLookupByLibrary.simpleMessage("密码"),
    "passwordMin8Chars": MessageLookupByLibrary.simpleMessage("密码至少需要8位字符"),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage("密码长度至少6位"),
    "passwordMismatch": MessageLookupByLibrary.simpleMessage("两次输入的密码不一致"),
    "passwordResetFailed": MessageLookupByLibrary.simpleMessage("密码重置失败"),
    "passwordResetSuccessful": MessageLookupByLibrary.simpleMessage(
      "密码重置成功！请使用新密码登录",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage("两次输入的密码不一致"),
    "paste": MessageLookupByLibrary.simpleMessage("粘贴"),
    "pendingCommission": MessageLookupByLibrary.simpleMessage("待确认佣金"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage("从相册选择"),
    "pinWindow": MessageLookupByLibrary.simpleMessage("窗口置顶"),
    "plans": MessageLookupByLibrary.simpleMessage("套餐"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage("请绑定WebDAV"),
    "pleaseConfirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "请再次输入新密码",
    ),
    "pleaseConfirmPassword": MessageLookupByLibrary.simpleMessage("请确认密码"),
    "pleaseEnterAtLeast8CharsPassword": MessageLookupByLibrary.simpleMessage(
      "请输入至少8位密码",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage("请输入邮箱地址"),
    "pleaseEnterEmailAddress": MessageLookupByLibrary.simpleMessage("请先输入邮箱地址"),
    "pleaseEnterEmailVerificationCode": MessageLookupByLibrary.simpleMessage(
      "请输入邮箱验证码",
    ),
    "pleaseEnterInviteCode": MessageLookupByLibrary.simpleMessage("请输入邀请码"),
    "pleaseEnterNewPassword": MessageLookupByLibrary.simpleMessage("请输入新密码"),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage("请输入密码"),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage("请输入脚本名称"),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage("请输入有效的邮箱地址"),
    "pleaseEnterValidEmailAddress": MessageLookupByLibrary.simpleMessage(
      "请输入有效的邮箱地址",
    ),
    "pleaseEnterValidVerificationCode": MessageLookupByLibrary.simpleMessage(
      "请输入有效的验证码",
    ),
    "pleaseEnterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "请输入邮箱验证码",
    ),
    "pleaseEnterYourEmailAddress": MessageLookupByLibrary.simpleMessage(
      "请输入您的邮箱地址",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "请输入管理员密码",
    ),
    "pleaseReEnterPassword": MessageLookupByLibrary.simpleMessage("请再次输入密码"),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage("请上传文件"),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "请上传有效的二维码",
    ),
    "port": MessageLookupByLibrary.simpleMessage("端口"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage("请输入不同的端口"),
    "portTip": m54,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage("优先使用DOH的http/3"),
    "prerequisites": MessageLookupByLibrary.simpleMessage("前置条件"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage("请按下组合键"),
    "preview": MessageLookupByLibrary.simpleMessage("预览"),
    "previousMatch": MessageLookupByLibrary.simpleMessage("上一个匹配"),
    "process": MessageLookupByLibrary.simpleMessage("进程"),
    "profile": MessageLookupByLibrary.simpleMessage("配置"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("请输入有效间隔时间格式"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage("请输入自动更新间隔时间"),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "配置文件已经修改，是否关闭自动更新？",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入配置名称",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage("配置文件解析错误"),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入有效配置URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入配置URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("配置"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("配置排序"),
    "project": MessageLookupByLibrary.simpleMessage("项目"),
    "providerInUse": m55,
    "providerRenameShadowed": m56,
    "providerSourceSubscription": MessageLookupByLibrary.simpleMessage("订阅"),
    "providerUrlTip": MessageLookupByLibrary.simpleMessage("仅支持远程资源"),
    "providers": MessageLookupByLibrary.simpleMessage("外部资源"),
    "proxies": MessageLookupByLibrary.simpleMessage("代理"),
    "proxiesCount": m57,
    "proxiesEmpty": MessageLookupByLibrary.simpleMessage("代理为空"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("代理设置"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("代理链"),
    "proxyDefinition": MessageLookupByLibrary.simpleMessage("完整配置"),
    "proxyDefinitionNotMap": MessageLookupByLibrary.simpleMessage(
      "配置必须是包含 name 和 type 的 YAML 映射",
    ),
    "proxyDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "检测到选中的代理存在异常",
    ),
    "proxyFilter": MessageLookupByLibrary.simpleMessage("节点过滤器"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("策略组"),
    "proxyGroupDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "检测到当前策略组异常",
    ),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage("策略组为空"),
    "proxyGroupNameDuplicate": MessageLookupByLibrary.simpleMessage("策略组名称重复"),
    "proxyGroupNameEmpty": MessageLookupByLibrary.simpleMessage("策略组名称不能为空"),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("代理域名服务器"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage("用于解析代理节点的域名"),
    "proxyNode": MessageLookupByLibrary.simpleMessage("代理节点"),
    "proxyPort": MessageLookupByLibrary.simpleMessage("代理端口"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage("设置Clash监听端口"),
    "proxyProviderDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "检测到选中的代理集存在异常",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("代理集"),
    "proxyProvidersEmpty": MessageLookupByLibrary.simpleMessage("代理集为空"),
    "proxyProvidersNotEmpty": MessageLookupByLibrary.simpleMessage("代理集不能为空"),
    "proxyType": MessageLookupByLibrary.simpleMessage("代理类型"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("修剪缓存"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("纯黑"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("纯黑模式"),
    "qrcode": MessageLookupByLibrary.simpleMessage("二维码"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage("扫描二维码获取配置文件"),
    "quickAdd": MessageLookupByLibrary.simpleMessage("快捷添加"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("快速编辑"),
    "quickFill": MessageLookupByLibrary.simpleMessage("一键填入"),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("彩虹"),
    "recentRequests": MessageLookupByLibrary.simpleMessage("最近请求"),
    "recordType": MessageLookupByLibrary.simpleMessage("记录类型"),
    "recovery": MessageLookupByLibrary.simpleMessage("恢复"),
    "recoveryAll": MessageLookupByLibrary.simpleMessage("恢复所有数据"),
    "recoveryProfiles": MessageLookupByLibrary.simpleMessage("仅恢复配置文件"),
    "recoveryStrategy": MessageLookupByLibrary.simpleMessage("恢复策略"),
    "recoveryStrategy_compatible": MessageLookupByLibrary.simpleMessage("兼容"),
    "recoveryStrategy_override": MessageLookupByLibrary.simpleMessage("覆盖"),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage("恢复成功"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir端口"),
    "redo": MessageLookupByLibrary.simpleMessage("重做"),
    "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
    "regExp": MessageLookupByLibrary.simpleMessage("正则"),
    "registerAccount": MessageLookupByLibrary.simpleMessage("注册账号"),
    "registerSuccessSaveCredentials": MessageLookupByLibrary.simpleMessage(
      "注册成功 - 保存凭据:",
    ),
    "registrationFailed": m58,
    "releaseMemory": MessageLookupByLibrary.simpleMessage("释放内存"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage("释放内存失败"),
    "rememberPassword": MessageLookupByLibrary.simpleMessage("记起密码了？"),
    "remote": MessageLookupByLibrary.simpleMessage("远程"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage("备份数据到WebDAV"),
    "remoteDestination": MessageLookupByLibrary.simpleMessage("远程目标"),
    "remoteRecoveryDesc": MessageLookupByLibrary.simpleMessage("通过WebDAV恢复数据"),
    "remove": MessageLookupByLibrary.simpleMessage("移除"),
    "rename": MessageLookupByLibrary.simpleMessage("重命名"),
    "replace": MessageLookupByLibrary.simpleMessage("替换"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("全部替换"),
    "request": MessageLookupByLibrary.simpleMessage("请求"),
    "requests": MessageLookupByLibrary.simpleMessage("请求"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage("请求与更新"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage("查看最近请求记录"),
    "resendVerificationCode": MessageLookupByLibrary.simpleMessage("重新发送验证码"),
    "reset": MessageLookupByLibrary.simpleMessage("重置"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "当前页面存在更改，确定重置吗？",
    ),
    "resetPassword": MessageLookupByLibrary.simpleMessage("重置密码"),
    "resetTip": MessageLookupByLibrary.simpleMessage("确定要重置吗？"),
    "resources": MessageLookupByLibrary.simpleMessage("资源"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage("外部资源相关信息"),
    "respectRules": MessageLookupByLibrary.simpleMessage("遵守规则"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS连接遵守规则，需配置Proxy Server Nameserver",
    ),
    "responseCode": MessageLookupByLibrary.simpleMessage("响应码"),
    "restart": MessageLookupByLibrary.simpleMessage("重启"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage("您确定要重启核心吗？"),
    "restore": MessageLookupByLibrary.simpleMessage("恢复"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("恢复所有数据"),
    "restoreException": MessageLookupByLibrary.simpleMessage("恢复异常"),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage("通过文件恢复数据"),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "通过WebDAV恢复数据",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage("仅恢复配置文件"),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("恢复策略"),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage("兼容"),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage("覆盖"),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage("兼容"),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage("覆盖"),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage("恢复成功"),
    "retry": MessageLookupByLibrary.simpleMessage("重试"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("路由地址"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage("配置监听路由地址"),
    "routeMode": MessageLookupByLibrary.simpleMessage("路由模式"),
    "routeModeBypassPrivate": MessageLookupByLibrary.simpleMessage("绕过私有路由地址"),
    "routeModeConfig": MessageLookupByLibrary.simpleMessage("使用配置"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage("绕过私有路由地址"),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("使用配置"),
    "ru": MessageLookupByLibrary.simpleMessage("俄语"),
    "rule": MessageLookupByLibrary.simpleMessage("规则"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage("逻辑规则 AND"),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage("匹配完整域名"),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "匹配域名关键字",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "使用域名正则表达式匹配",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "匹配域名后缀",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "通配符匹配，仅支持*和?通配符",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "匹配DSCP标记（仅限 tproxy udp 入站）",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage("匹配请求目标端口范围"),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage("匹配 IP 所属国家代码"),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "匹配 Geosite 内的域名",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage("匹配入站名称"),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage("匹配入站端口"),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage("匹配入站类型"),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "匹配入站用户名，支持使用 / 分隔多个用户名",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage("匹配 IP 所属 ASN"),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "匹配 IP 地址范围，IP-CIDR6 只是一个别名",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage("匹配 IP 地址范围"),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "匹配 IP 后缀范围",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage("匹配所有请求，无需条件"),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage("匹配TCP或者UDP"),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage("逻辑规则 NOT"),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage("逻辑规则 OR"),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程匹配，在Android平台可以匹配包名",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程名称正则表达式匹配，在Android平台可以匹配包名",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程名称通配符匹配，仅支持*和?通配符",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "使用完整进程路径匹配",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程路径正则表达式匹配",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程路径通配符匹配，仅支持*和?通配符",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "匹配重匹配名称，多个名称用/分隔",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "引用规则集合，需配置rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 所属国家代码",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 所属 ASN",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 地址范围",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 后缀范围",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage("匹配请求来源端口范围"),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "匹配至子规则，需要注意括号的使用",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "匹配 Linux USER ID",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("规则为空"),
    "ruleName": MessageLookupByLibrary.simpleMessage("规则名称"),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BT 下载直连",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "屏蔽 DNS over TLS",
    ),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage("屏蔽 QUIC"),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage("屏蔽 STUN"),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage("局域网直连"),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple 与 Microsoft 直连",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("规则集"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("规则集"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("规则目标"),
    "rules": MessageLookupByLibrary.simpleMessage("规则"),
    "rulesCount": m59,
    "runTime": MessageLookupByLibrary.simpleMessage("启动时间"),
    "safeMode": MessageLookupByLibrary.simpleMessage("安全模式"),
    "safeModeAppTitle": m60,
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("是否保存更改？"),
    "saveQr": MessageLookupByLibrary.simpleMessage("保存二维码"),
    "saveQrCodeFeature": MessageLookupByLibrary.simpleMessage(
      "保存二维码功能开发中，敬请期待",
    ),
    "saveTip": MessageLookupByLibrary.simpleMessage("确定要保存吗？"),
    "script": MessageLookupByLibrary.simpleMessage("脚本"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "脚本模式，使用外部扩展脚本，提供一键覆写配置的能力",
    ),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage("滚动到已选"),
    "search": MessageLookupByLibrary.simpleMessage("搜索"),
    "seconds": MessageLookupByLibrary.simpleMessage("秒"),
    "secondsCount": m61,
    "selectAll": MessageLookupByLibrary.simpleMessage("全选"),
    "selectProxies": MessageLookupByLibrary.simpleMessage("选择代理"),
    "selectProxyProviders": MessageLookupByLibrary.simpleMessage("选择代理集"),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage("请选择规则集"),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage("请选择分流策略"),
    "selectSubRule": MessageLookupByLibrary.simpleMessage("请选择子规则"),
    "selectTheme": MessageLookupByLibrary.simpleMessage("选择主题"),
    "selected": MessageLookupByLibrary.simpleMessage("已选择"),
    "selectedCountTitle": m62,
    "sendCodeFailed": MessageLookupByLibrary.simpleMessage("发送验证码失败"),
    "sendVerificationCode": MessageLookupByLibrary.simpleMessage("发送验证码"),
    "sendVerificationCodeFailed": m63,
    "server": MessageLookupByLibrary.simpleMessage("服务器"),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("可用"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("已被封禁"),
    "serviceCheck": MessageLookupByLibrary.simpleMessage("检测"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("全部检测"),
    "serviceCheckedAt": m64,
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("即将上线"),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage("不允许的 ISP"),
    "serviceFailed": MessageLookupByLibrary.simpleMessage("检测失败"),
    "serviceManage": MessageLookupByLibrary.simpleMessage("管理服务"),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage("仅限自制内容"),
    "servicePending": MessageLookupByLibrary.simpleMessage("待检测"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage("访问受限"),
    "serviceStatus": MessageLookupByLibrary.simpleMessage("服务状态"),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("不可用"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage("地区不支持"),
    "setNewPassword": MessageLookupByLibrary.simpleMessage("设置新密码"),
    "settings": MessageLookupByLibrary.simpleMessage("设置"),
    "show": MessageLookupByLibrary.simpleMessage("显示"),
    "showLess": MessageLookupByLibrary.simpleMessage("收起"),
    "showMore": MessageLookupByLibrary.simpleMessage("展开"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "通知栏显示停止按钮",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage("显示密码"),
    "shrink": MessageLookupByLibrary.simpleMessage("紧凑"),
    "sidebarBlur": MessageLookupByLibrary.simpleMessage("侧边栏背景模糊"),
    "sidebarBlurDesc": MessageLookupByLibrary.simpleMessage("侧边栏透出窗口后方模糊的桌面"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("静默启动"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage("启动时不显示窗口"),
    "singleAdd": MessageLookupByLibrary.simpleMessage("单条添加"),
    "singleValueTip": m65,
    "size": MessageLookupByLibrary.simpleMessage("尺寸"),
    "slide": MessageLookupByLibrary.simpleMessage("滑动"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socks端口"),
    "sort": MessageLookupByLibrary.simpleMessage("排序"),
    "source": MessageLookupByLibrary.simpleMessage("来源"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("源IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("特殊代理"),
    "specialRules": MessageLookupByLibrary.simpleMessage("特殊规则"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("网速统计"),
    "splitStrategy": MessageLookupByLibrary.simpleMessage("分流策略"),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage("分流策略不能为空"),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("SSIDs为空"),
    "stackMode": MessageLookupByLibrary.simpleMessage("栈模式"),
    "standard": MessageLookupByLibrary.simpleMessage("标准"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "标准模式，覆写基础配置，提供简单追加规则能力",
    ),
    "start": MessageLookupByLibrary.simpleMessage("启动"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage("从零开始"),
    "startVpn": MessageLookupByLibrary.simpleMessage("正在启动VPN…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage("启动与后台"),
    "status": MessageLookupByLibrary.simpleMessage("状态"),
    "statusDesc": MessageLookupByLibrary.simpleMessage("关闭后将使用系统DNS"),
    "stop": MessageLookupByLibrary.simpleMessage("暂停"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("正在停止VPN…"),
    "strategy": MessageLookupByLibrary.simpleMessage("策略"),
    "style": MessageLookupByLibrary.simpleMessage("风格"),
    "subRule": MessageLookupByLibrary.simpleMessage("子规则"),
    "subRuleEmpty": MessageLookupByLibrary.simpleMessage("子规则为空"),
    "subRuleNotEmpty": MessageLookupByLibrary.simpleMessage("子规则不能为空"),
    "submit": MessageLookupByLibrary.simpleMessage("提交"),
    "subscriptionExpired": MessageLookupByLibrary.simpleMessage("订阅已过期"),
    "subscriptionExpiredDetail": m66,
    "subscriptionExpiresToday": MessageLookupByLibrary.simpleMessage("订阅今日过期"),
    "subscriptionExpiresTodayDetail": MessageLookupByLibrary.simpleMessage(
      "套餐将在今日过期，请立即续费以免影响使用",
    ),
    "subscriptionExpiringInDays": MessageLookupByLibrary.simpleMessage(
      "订阅即将过期",
    ),
    "subscriptionExpiringInDaysDetail": m67,
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage("订阅信息"),
    "subscriptionNoSubscription": MessageLookupByLibrary.simpleMessage("无订阅套餐"),
    "subscriptionNoSubscriptionDetail": MessageLookupByLibrary.simpleMessage(
      "当前账户暂无可用的订阅套餐，请购买套餐后使用",
    ),
    "subscriptionNotLoggedIn": MessageLookupByLibrary.simpleMessage("未登录"),
    "subscriptionNotLoggedInDetail": MessageLookupByLibrary.simpleMessage(
      "请先登录账户",
    ),
    "subscriptionTrafficExhausted": MessageLookupByLibrary.simpleMessage(
      "流量已用完",
    ),
    "subscriptionTrafficExhaustedDetail": MessageLookupByLibrary.simpleMessage(
      "套餐流量已用完，请购买更多流量或升级套餐",
    ),
    "subscriptionValid": MessageLookupByLibrary.simpleMessage("订阅有效"),
    "subscriptionValidDetail": m68,
    "suspended": MessageLookupByLibrary.simpleMessage("挂起中…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("切换配置"),
    "switchTheme": MessageLookupByLibrary.simpleMessage("切换主题"),
    "sync": MessageLookupByLibrary.simpleMessage("同步"),
    "system": MessageLookupByLibrary.simpleMessage("系统"),
    "systemApp": MessageLookupByLibrary.simpleMessage("系统应用"),
    "systemFont": MessageLookupByLibrary.simpleMessage("系统字体"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage("设置系统代理"),
    "tab": MessageLookupByLibrary.simpleMessage("标签页"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("选项卡动画"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage("仅在移动视图中有效"),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage("点击授权"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP并发"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage("开启后允许TCP并发"),
    "testInterval": MessageLookupByLibrary.simpleMessage("测试间隔"),
    "testUrl": MessageLookupByLibrary.simpleMessage("测速链接"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage("使用时测试"),
    "textScale": MessageLookupByLibrary.simpleMessage("文本缩放"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage("应用内的文字将以这个大小显示"),
    "theme": MessageLookupByLibrary.simpleMessage("主题"),
    "themeColor": MessageLookupByLibrary.simpleMessage("主题色彩"),
    "themeDesc": MessageLookupByLibrary.simpleMessage("设置深色模式，调整色彩"),
    "themeMode": MessageLookupByLibrary.simpleMessage("主题模式"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("三列"),
    "tight": MessageLookupByLibrary.simpleMessage("紧凑"),
    "time": MessageLookupByLibrary.simpleMessage("时间"),
    "timeout": MessageLookupByLibrary.simpleMessage("超时"),
    "tip": MessageLookupByLibrary.simpleMessage("提示"),
    "toggle": MessageLookupByLibrary.simpleMessage("切换"),
    "tolerance": MessageLookupByLibrary.simpleMessage("容差"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("调性点缀"),
    "tools": MessageLookupByLibrary.simpleMessage("工具"),
    "torch": MessageLookupByLibrary.simpleMessage("手电筒"),
    "total": MessageLookupByLibrary.simpleMessage("总计"),
    "totalCommission": MessageLookupByLibrary.simpleMessage("累计佣金"),
    "totalInvites": MessageLookupByLibrary.simpleMessage("总邀请数"),
    "totalRecords": m69,
    "totalTraffic": MessageLookupByLibrary.simpleMessage("总流量"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxy端口"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("流量统计"),
    "transfer": MessageLookupByLibrary.simpleMessage("划转"),
    "transferAmount": MessageLookupByLibrary.simpleMessage("划转金额"),
    "transferAmountExceeded": m70,
    "transferFailed": m71,
    "transferNote": MessageLookupByLibrary.simpleMessage("划转到钱包的余额可以抵扣app内消费"),
    "transferSuccess": MessageLookupByLibrary.simpleMessage("划转成功！"),
    "transferSuccessMsg": m72,
    "transferToWallet": MessageLookupByLibrary.simpleMessage("划转到钱包"),
    "transferring": MessageLookupByLibrary.simpleMessage("正在划转..."),
    "tun": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "tunDesc": MessageLookupByLibrary.simpleMessage("仅在管理员模式生效"),
    "turnOff": MessageLookupByLibrary.simpleMessage("关闭"),
    "turnOn": MessageLookupByLibrary.simpleMessage("开启"),
    "twoColumns": MessageLookupByLibrary.simpleMessage("两列"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "无法更新当前配置文件",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("撤销"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("统一延迟"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage("去除握手等额外延迟"),
    "unknown": MessageLookupByLibrary.simpleMessage("未知"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage("未知网络错误"),
    "unmaximize": MessageLookupByLibrary.simpleMessage("向下还原"),
    "unnamed": MessageLookupByLibrary.simpleMessage("未命名"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage("取消置顶"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "updateCheckAllServersUnavailable": MessageLookupByLibrary.simpleMessage(
      "所有配置的更新服务器都不可用",
    ),
    "updateCheckCurrentVersion": m73,
    "updateCheckForceUpdate": m74,
    "updateCheckMustUpdate": MessageLookupByLibrary.simpleMessage("必须更新"),
    "updateCheckNewVersionFound": m75,
    "updateCheckNoServerUrlsConfigured": MessageLookupByLibrary.simpleMessage(
      "未配置任何更新服务器URL，请检查配置",
    ),
    "updateCheckReleaseNotes": MessageLookupByLibrary.simpleMessage("更新内容："),
    "updateCheckServerError": m76,
    "updateCheckServerTemporarilyUnavailable":
        MessageLookupByLibrary.simpleMessage("服务器暂时不可用，请稍后重试"),
    "updateCheckServerUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "未配置更新服务器URL，请检查配置",
    ),
    "updateCheckUpdateLater": MessageLookupByLibrary.simpleMessage("稍后更新"),
    "updateCheckUpdateNow": MessageLookupByLibrary.simpleMessage("立即更新"),
    "upload": MessageLookupByLibrary.simpleMessage("上传"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage("通过URL获取配置文件"),
    "urlTip": m77,
    "useHosts": MessageLookupByLibrary.simpleMessage("使用Hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("使用系统Hosts"),
    "usedTraffic": MessageLookupByLibrary.simpleMessage("已用流量"),
    "userAgent": MessageLookupByLibrary.simpleMessage("用户代理"),
    "userCenter": MessageLookupByLibrary.simpleMessage("个人中心"),
    "value": MessageLookupByLibrary.simpleMessage("值"),
    "verificationCode": MessageLookupByLibrary.simpleMessage("验证码"),
    "verificationCode6Digits": MessageLookupByLibrary.simpleMessage(
      "验证码应为6位数字",
    ),
    "verificationCodeSent": MessageLookupByLibrary.simpleMessage(
      "验证码已发送到您的邮箱，请查收",
    ),
    "verificationCodeSentCheckEmail": MessageLookupByLibrary.simpleMessage(
      "验证码已发送，请查收邮箱",
    ),
    "verificationCodeSentTo": m78,
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("活力"),
    "view": MessageLookupByLibrary.simpleMessage("查看"),
    "viewHistory": MessageLookupByLibrary.simpleMessage("查看历史记录"),
    "visitWebVersion": MessageLookupByLibrary.simpleMessage("请前往网页版提交提现申请"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "检测到VPN相关配置改动",
    ),
    "vpnDesc": MessageLookupByLibrary.simpleMessage("修改VPN相关设置"),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "通过VpnService自动路由系统所有流量",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "为VpnService附加HTTP代理",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage("重启VPN后改变生效"),
    "walletBalance": MessageLookupByLibrary.simpleMessage("钱包余额"),
    "walletDetails": MessageLookupByLibrary.simpleMessage("钱包详情"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage("WebDAV配置"),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("白名单模式"),
    "withdraw": MessageLookupByLibrary.simpleMessage("提现"),
    "withdrawCommission": MessageLookupByLibrary.simpleMessage("提现佣金"),
    "withdrawableAmount": m79,
    "withdrawalAvailable": MessageLookupByLibrary.simpleMessage("可用佣金可申请提现"),
    "writeToSystem": MessageLookupByLibrary.simpleMessage("写入系统"),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "同时设置系统时钟，Android上不生效",
    ),
    "xboard": MessageLookupByLibrary.simpleMessage("我的"),
    "xboard24HourCustomerService": MessageLookupByLibrary.simpleMessage(
      "24小时客服支持",
    ),
    "xboardAccountBalance": MessageLookupByLibrary.simpleMessage("账户余额"),
    "xboardAddLinkToConfig": MessageLookupByLibrary.simpleMessage(
      "在配置文件中添加此订阅链接",
    ),
    "xboardAddingToConfigList": MessageLookupByLibrary.simpleMessage("添加到配置列表"),
    "xboardAfterPurchasingPlan": MessageLookupByLibrary.simpleMessage(
      "购买套餐后您将享受：",
    ),
    "xboardApiUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "API地址未配置",
    ),
    "xboardAutoCheckEvery5Seconds": MessageLookupByLibrary.simpleMessage(
      "系统每5秒自动检查一次，支付完成后会自动跳转",
    ),
    "xboardAutoDetectPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "自动检测支付状态",
    ),
    "xboardAutoOpeningPaymentPage": MessageLookupByLibrary.simpleMessage(
      "正在自动打开支付页面，完成支付后请返回应用",
    ),
    "xboardAutoTesting": MessageLookupByLibrary.simpleMessage("自动测试中"),
    "xboardBack": MessageLookupByLibrary.simpleMessage("返回"),
    "xboardBrowserNotOpenedTip": MessageLookupByLibrary.simpleMessage(
      "如果浏览器未自动打开，可以点击\\\"重新打开\\\"或复制链接手动打开",
    ),
    "xboardBuyMoreTrafficOrUpgrade": MessageLookupByLibrary.simpleMessage(
      "请购买更多流量或升级套餐",
    ),
    "xboardBuyNow": MessageLookupByLibrary.simpleMessage("立即购买"),
    "xboardBuyoutPlan": MessageLookupByLibrary.simpleMessage("买断制"),
    "xboardCancel": MessageLookupByLibrary.simpleMessage("取消"),
    "xboardCancelPayment": MessageLookupByLibrary.simpleMessage("取消支付"),
    "xboardCheckPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "检查支付状态失败",
    ),
    "xboardCheckStatus": MessageLookupByLibrary.simpleMessage("检查状态"),
    "xboardChecking": MessageLookupByLibrary.simpleMessage("检查中"),
    "xboardCleaningOldConfig": MessageLookupByLibrary.simpleMessage("清理旧配置"),
    "xboardClearError": MessageLookupByLibrary.simpleMessage("清除错误"),
    "xboardClickToCopy": MessageLookupByLibrary.simpleMessage("点击复制"),
    "xboardClickToSetupNodes": MessageLookupByLibrary.simpleMessage("点击设置节点"),
    "xboardCompletePaymentInBrowser": MessageLookupByLibrary.simpleMessage(
      "2. 请在浏览器中完成支付操作",
    ),
    "xboardConfigDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "配置文件下载失败，请检查订阅链接",
    ),
    "xboardConfigFormatError": MessageLookupByLibrary.simpleMessage(
      "配置文件格式错误，请联系服务提供商",
    ),
    "xboardConfigSaveFailed": MessageLookupByLibrary.simpleMessage(
      "保存配置失败，请检查存储空间",
    ),
    "xboardConfigurationError": MessageLookupByLibrary.simpleMessage("配置错误"),
    "xboardConfirm": MessageLookupByLibrary.simpleMessage("确定"),
    "xboardConfirmAction": MessageLookupByLibrary.simpleMessage("确定"),
    "xboardConfirmPassword": MessageLookupByLibrary.simpleMessage("确认密码"),
    "xboardConfirmPurchase": MessageLookupByLibrary.simpleMessage("确认购买"),
    "xboardCongratulationsSubscriptionActivated":
        MessageLookupByLibrary.simpleMessage("恭喜！您的套餐已成功购买并生效"),
    "xboardConnectGlobalQualityNodes": MessageLookupByLibrary.simpleMessage(
      "连接全球优质节点",
    ),
    "xboardConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "连接超时，请检查网络连接",
    ),
    "xboardCopyFailed": MessageLookupByLibrary.simpleMessage("复制失败"),
    "xboardCopyLink": MessageLookupByLibrary.simpleMessage("复制链接"),
    "xboardCopyPaymentLink": MessageLookupByLibrary.simpleMessage("复制链接"),
    "xboardCopySubscriptionLinkAbove": MessageLookupByLibrary.simpleMessage(
      "复制上方的订阅链接",
    ),
    "xboardCouponExpired": MessageLookupByLibrary.simpleMessage("优惠券已过期"),
    "xboardCouponNotYetActive": MessageLookupByLibrary.simpleMessage("优惠券尚未生效"),
    "xboardCouponOptional": MessageLookupByLibrary.simpleMessage("优惠券（可选）"),
    "xboardCreatingOrder": MessageLookupByLibrary.simpleMessage("正在创建订单"),
    "xboardCreatingOrderPleaseWait": MessageLookupByLibrary.simpleMessage(
      "我们正在为您创建新订单，请稍候",
    ),
    "xboardCurrentNode": MessageLookupByLibrary.simpleMessage("当前节点"),
    "xboardCurrentVersion": MessageLookupByLibrary.simpleMessage("当前版本"),
    "xboardDays": MessageLookupByLibrary.simpleMessage("天"),
    "xboardDeductibleDuringPayment": MessageLookupByLibrary.simpleMessage(
      "支付时可抵扣",
    ),
    "xboardDiscounted": MessageLookupByLibrary.simpleMessage("已优惠"),
    "xboardDownloadingConfig": MessageLookupByLibrary.simpleMessage("下载配置文件"),
    "xboardEmail": MessageLookupByLibrary.simpleMessage("邮箱"),
    "xboardEnableTun": MessageLookupByLibrary.simpleMessage("开启 TUN"),
    "xboardEnjoyFastNetworkExperience": MessageLookupByLibrary.simpleMessage(
      "享受极速网络体验",
    ),
    "xboardEnterCouponCode": MessageLookupByLibrary.simpleMessage("请输入优惠券代码"),
    "xboardExcellent": MessageLookupByLibrary.simpleMessage("优秀"),
    "xboardExpiryTime": MessageLookupByLibrary.simpleMessage("过期时间"),
    "xboardFailedToCheckPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "检查支付状态失败",
    ),
    "xboardFailedToGetSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "获取订阅信息失败",
    ),
    "xboardFailedToOpenPaymentLink": MessageLookupByLibrary.simpleMessage(
      "打开支付链接失败",
    ),
    "xboardFailedToOpenPaymentPage": MessageLookupByLibrary.simpleMessage(
      "打开支付页面失败",
    ),
    "xboardFair": MessageLookupByLibrary.simpleMessage("一般"),
    "xboardForceUpdate": MessageLookupByLibrary.simpleMessage("强制更新"),
    "xboardForgotPassword": MessageLookupByLibrary.simpleMessage("忘记密码"),
    "xboardGettingIP": MessageLookupByLibrary.simpleMessage("获取中..."),
    "xboardGlobalNodes": MessageLookupByLibrary.simpleMessage("全球节点"),
    "xboardGood": MessageLookupByLibrary.simpleMessage("良好"),
    "xboardGroup": MessageLookupByLibrary.simpleMessage("所属组"),
    "xboardHalfYearlyPayment": MessageLookupByLibrary.simpleMessage("半年付"),
    "xboardHandleLater": MessageLookupByLibrary.simpleMessage("稍后再说"),
    "xboardHandlingFee": MessageLookupByLibrary.simpleMessage("手续费"),
    "xboardHighSpeedNetwork": MessageLookupByLibrary.simpleMessage("高速网络"),
    "xboardHome": MessageLookupByLibrary.simpleMessage("首页"),
    "xboardImportFailed": MessageLookupByLibrary.simpleMessage("导入失败"),
    "xboardImportSuccess": MessageLookupByLibrary.simpleMessage("导入成功"),
    "xboardInsufficientBalance": MessageLookupByLibrary.simpleMessage("余额不足"),
    "xboardInvalidCredentials": MessageLookupByLibrary.simpleMessage(
      "用户名或密码错误",
    ),
    "xboardInvalidOrExpiredCoupon": MessageLookupByLibrary.simpleMessage(
      "优惠券代码无效或已过期",
    ),
    "xboardInvalidResponseFormat": MessageLookupByLibrary.simpleMessage(
      "服务器返回数据格式错误",
    ),
    "xboardInviteCode": MessageLookupByLibrary.simpleMessage("邀请码"),
    "xboardKeepSubscriptionLinkSafe": MessageLookupByLibrary.simpleMessage(
      "请妥善保管您的订阅链接，不要分享给他人",
    ),
    "xboardLater": MessageLookupByLibrary.simpleMessage("稍后处理"),
    "xboardLoadingFailed": MessageLookupByLibrary.simpleMessage("加载失败"),
    "xboardLoadingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "正在加载支付页面",
    ),
    "xboardLocalIP": MessageLookupByLibrary.simpleMessage("本机IP"),
    "xboardLoggedIn": MessageLookupByLibrary.simpleMessage("已登录"),
    "xboardLogin": MessageLookupByLibrary.simpleMessage("登录"),
    "xboardLoginExpired": MessageLookupByLibrary.simpleMessage("登录已过期，请重新登录"),
    "xboardLoginFailed": MessageLookupByLibrary.simpleMessage("登录失败"),
    "xboardLoginSuccess": MessageLookupByLibrary.simpleMessage("登录成功"),
    "xboardLoginToViewSubscription": MessageLookupByLibrary.simpleMessage(
      "请登录后查看套餐使用情况",
    ),
    "xboardLogout": MessageLookupByLibrary.simpleMessage("登出"),
    "xboardLogoutConfirmContent": MessageLookupByLibrary.simpleMessage(
      "您确定要登出吗？登出后需要重新输入账号密码。",
    ),
    "xboardLogoutConfirmTitle": MessageLookupByLibrary.simpleMessage("确认登出"),
    "xboardLogoutFailed": MessageLookupByLibrary.simpleMessage("登出失败"),
    "xboardLogoutSuccess": MessageLookupByLibrary.simpleMessage("已成功登出"),
    "xboardMissingRequiredField": MessageLookupByLibrary.simpleMessage(
      "缺少必要字段",
    ),
    "xboardMonthlyPayment": MessageLookupByLibrary.simpleMessage("月付"),
    "xboardMonthlyRenewal": MessageLookupByLibrary.simpleMessage("每月续费"),
    "xboardMustUpdate": MessageLookupByLibrary.simpleMessage("必须更新"),
    "xboardNetworkConnectionFailed": MessageLookupByLibrary.simpleMessage(
      "网络连接失败，请检查网络设置",
    ),
    "xboardNewVersionFound": MessageLookupByLibrary.simpleMessage("发现新版本"),
    "xboardNext": MessageLookupByLibrary.simpleMessage("下一条"),
    "xboardNoAvailableNodes": MessageLookupByLibrary.simpleMessage("无可用节点"),
    "xboardNoAvailablePlan": MessageLookupByLibrary.simpleMessage("无可用套餐"),
    "xboardNoAvailableSubscription": MessageLookupByLibrary.simpleMessage(
      "无可用套餐",
    ),
    "xboardNoInternetConnection": MessageLookupByLibrary.simpleMessage(
      "无网络连接，请检查网络设置",
    ),
    "xboardNoSubscriptionInfo": MessageLookupByLibrary.simpleMessage("暂无套餐信息"),
    "xboardNoSubscriptionPlans": MessageLookupByLibrary.simpleMessage("暂无套餐信息"),
    "xboardNodeName": MessageLookupByLibrary.simpleMessage("节点名称"),
    "xboardNone": MessageLookupByLibrary.simpleMessage("无"),
    "xboardNotLoggedIn": MessageLookupByLibrary.simpleMessage("未登录"),
    "xboardOneTimePayment": MessageLookupByLibrary.simpleMessage("一次性"),
    "xboardOpenPaymentFailed": MessageLookupByLibrary.simpleMessage("打开支付页面失败"),
    "xboardOpenPaymentLinkFailed": MessageLookupByLibrary.simpleMessage(
      "打开支付链接失败",
    ),
    "xboardOperationFailed": MessageLookupByLibrary.simpleMessage("操作失败"),
    "xboardOperationTips": MessageLookupByLibrary.simpleMessage("操作提示"),
    "xboardOrderCreationFailed": MessageLookupByLibrary.simpleMessage("创建订单失败"),
    "xboardOrderNotFound": MessageLookupByLibrary.simpleMessage("订单不存在"),
    "xboardOrderNumber": MessageLookupByLibrary.simpleMessage("订单号"),
    "xboardOrderStatusPending": MessageLookupByLibrary.simpleMessage(
      "订单状态：待支付",
    ),
    "xboardPassword": MessageLookupByLibrary.simpleMessage("密码"),
    "xboardPaymentCancelled": MessageLookupByLibrary.simpleMessage("支付已取消"),
    "xboardPaymentComplete": MessageLookupByLibrary.simpleMessage("支付完成"),
    "xboardPaymentCompleted": MessageLookupByLibrary.simpleMessage("支付完成！"),
    "xboardPaymentFailed": MessageLookupByLibrary.simpleMessage("支付失败"),
    "xboardPaymentGateway": MessageLookupByLibrary.simpleMessage("支付网关"),
    "xboardPaymentInfo": MessageLookupByLibrary.simpleMessage("支付信息"),
    "xboardPaymentInstructions1": MessageLookupByLibrary.simpleMessage(
      "1. 系统已自动为您打开支付页面",
    ),
    "xboardPaymentInstructions2": MessageLookupByLibrary.simpleMessage(
      "2. 请在浏览器中完成支付操作",
    ),
    "xboardPaymentInstructions3": MessageLookupByLibrary.simpleMessage(
      "3. 支付完成后返回应用，系统将自动检测",
    ),
    "xboardPaymentLink": MessageLookupByLibrary.simpleMessage("支付链接"),
    "xboardPaymentLinkCopied": MessageLookupByLibrary.simpleMessage(
      "支付链接已复制到剪贴板",
    ),
    "xboardPaymentMethodVerified": MessageLookupByLibrary.simpleMessage(
      "支付方式验证通过",
    ),
    "xboardPaymentMethodVerifiedPreparing":
        MessageLookupByLibrary.simpleMessage("支付方式已验证，准备跳转到支付页面"),
    "xboardPaymentPageAutoOpened": MessageLookupByLibrary.simpleMessage(
      "1. 系统已自动为您打开支付页面",
    ),
    "xboardPaymentPageOpenedCompleteAndReturn":
        MessageLookupByLibrary.simpleMessage("支付页面已打开，请完成支付并返回应用"),
    "xboardPaymentPageOpenedInBrowser": MessageLookupByLibrary.simpleMessage(
      "已在浏览器中打开支付页面，完成支付后请返回应用",
    ),
    "xboardPaymentSuccess": MessageLookupByLibrary.simpleMessage("支付成功"),
    "xboardPaymentSuccessful": MessageLookupByLibrary.simpleMessage("🎉 支付成功！"),
    "xboardPlanInfo": MessageLookupByLibrary.simpleMessage("购买订阅"),
    "xboardPlanNotFound": MessageLookupByLibrary.simpleMessage("套餐不存在"),
    "xboardPlans": MessageLookupByLibrary.simpleMessage("套餐"),
    "xboardPleaseSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage(
      "请选择购买周期",
    ),
    "xboardPoor": MessageLookupByLibrary.simpleMessage("较差"),
    "xboardPreparingImport": MessageLookupByLibrary.simpleMessage("准备导入"),
    "xboardPreparingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "正在准备支付页面，即将跳转",
    ),
    "xboardPrevious": MessageLookupByLibrary.simpleMessage("上一条"),
    "xboardProcessing": MessageLookupByLibrary.simpleMessage("处理中..."),
    "xboardProfessionalSupport": MessageLookupByLibrary.simpleMessage("专业客服"),
    "xboardProfile": MessageLookupByLibrary.simpleMessage("配置文件"),
    "xboardProtectNetworkPrivacy": MessageLookupByLibrary.simpleMessage(
      "保护您的网络隐私",
    ),
    "xboardProxy": MessageLookupByLibrary.simpleMessage("代理"),
    "xboardProxyMode": MessageLookupByLibrary.simpleMessage("代理模式"),
    "xboardProxyModeDirectDescription": MessageLookupByLibrary.simpleMessage(
      "所有流量都直接连接，不使用代理",
    ),
    "xboardProxyModeGlobalDescription": MessageLookupByLibrary.simpleMessage(
      "所有流量都通过代理服务器",
    ),
    "xboardProxyModeRuleDescription": MessageLookupByLibrary.simpleMessage(
      "根据规则自动选择直连或代理",
    ),
    "xboardPurchasePlan": MessageLookupByLibrary.simpleMessage("购买套餐"),
    "xboardPurchaseSubscription": MessageLookupByLibrary.simpleMessage("购买套餐"),
    "xboardPurchaseSubscriptionToUse": MessageLookupByLibrary.simpleMessage(
      "请购买套餐后使用",
    ),
    "xboardPurchaseTraffic": MessageLookupByLibrary.simpleMessage("购买流量"),
    "xboardQuarterlyPayment": MessageLookupByLibrary.simpleMessage("季付"),
    "xboardRefresh": MessageLookupByLibrary.simpleMessage("刷新"),
    "xboardRefreshStatus": MessageLookupByLibrary.simpleMessage("刷新状态"),
    "xboardRegister": MessageLookupByLibrary.simpleMessage("注册"),
    "xboardRegisterFailed": MessageLookupByLibrary.simpleMessage("注册失败"),
    "xboardRegisterSuccess": MessageLookupByLibrary.simpleMessage(
      "注册成功！正在跳转到登录页面...",
    ),
    "xboardReload": MessageLookupByLibrary.simpleMessage("重新获取"),
    "xboardRelogin": MessageLookupByLibrary.simpleMessage("重新登录"),
    "xboardRememberPassword": MessageLookupByLibrary.simpleMessage("记住密码"),
    "xboardRenewPlan": MessageLookupByLibrary.simpleMessage("续费套餐"),
    "xboardRenewToContinue": MessageLookupByLibrary.simpleMessage("请续费后继续使用"),
    "xboardReopen": MessageLookupByLibrary.simpleMessage("重新打开"),
    "xboardReopenPayment": MessageLookupByLibrary.simpleMessage("重新打开"),
    "xboardReopenPaymentPageTip": MessageLookupByLibrary.simpleMessage(
      "如需重新打开，可点击下方\\\"重新打开\\\"按钮",
    ),
    "xboardRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "xboardRetryGet": MessageLookupByLibrary.simpleMessage("重新获取"),
    "xboardReturn": MessageLookupByLibrary.simpleMessage("返回"),
    "xboardReturnAfterPaymentAutoDetect": MessageLookupByLibrary.simpleMessage(
      "3. 支付完成后返回应用，系统将自动检测",
    ),
    "xboardRunningTime": m80,
    "xboardSecureEncryption": MessageLookupByLibrary.simpleMessage("安全加密"),
    "xboardSelectPaymentMethod": MessageLookupByLibrary.simpleMessage("选择支付方式"),
    "xboardSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage("选择购买周期"),
    "xboardSelectPeriod": MessageLookupByLibrary.simpleMessage("请选择购买周期"),
    "xboardSendVerificationCode": MessageLookupByLibrary.simpleMessage("发送验证码"),
    "xboardServerError": MessageLookupByLibrary.simpleMessage("服务器错误"),
    "xboardSetup": MessageLookupByLibrary.simpleMessage("设置"),
    "xboardSixMonthCycle": MessageLookupByLibrary.simpleMessage("6个月周期"),
    "xboardSpeedLimit": MessageLookupByLibrary.simpleMessage("限速"),
    "xboardStartProxy": MessageLookupByLibrary.simpleMessage("启动代理"),
    "xboardStartProxyToSelectNode": MessageLookupByLibrary.simpleMessage(
      "启动代理后可选节点",
    ),
    "xboardStop": MessageLookupByLibrary.simpleMessage("停止"),
    "xboardStopProxy": MessageLookupByLibrary.simpleMessage("停止代理"),
    "xboardSubscription": MessageLookupByLibrary.simpleMessage("订阅"),
    "xboardSubscriptionCopied": MessageLookupByLibrary.simpleMessage(
      "订阅链接已复制到剪贴板",
    ),
    "xboardSubscriptionExpired": MessageLookupByLibrary.simpleMessage("订阅已过期"),
    "xboardSubscriptionHasExpired": MessageLookupByLibrary.simpleMessage(
      "订阅已过期",
    ),
    "xboardSubscriptionInfo": MessageLookupByLibrary.simpleMessage("订阅信息"),
    "xboardSubscriptionLink": MessageLookupByLibrary.simpleMessage("订阅链接"),
    "xboardSubscriptionLinkCopied": MessageLookupByLibrary.simpleMessage(
      "订阅链接已复制到剪贴板",
    ),
    "xboardSubscriptionPurchase": MessageLookupByLibrary.simpleMessage("订阅购买"),
    "xboardSubscriptionStatus": MessageLookupByLibrary.simpleMessage("订阅状态"),
    "xboardSwitch": MessageLookupByLibrary.simpleMessage("切换"),
    "xboardTesting": MessageLookupByLibrary.simpleMessage("测试中"),
    "xboardThirtySixMonthCycle": MessageLookupByLibrary.simpleMessage("36个月周期"),
    "xboardThreeMonthCycle": MessageLookupByLibrary.simpleMessage("3个月周期"),
    "xboardThreeYearPayment": MessageLookupByLibrary.simpleMessage("三年付"),
    "xboardTimeout": MessageLookupByLibrary.simpleMessage("超时"),
    "xboardTokenExpiredContent": MessageLookupByLibrary.simpleMessage(
      "您的登录状态已过期，请重新登录以继续使用。",
    ),
    "xboardTokenExpiredTitle": MessageLookupByLibrary.simpleMessage("登录已过期"),
    "xboardTraffic": MessageLookupByLibrary.simpleMessage("流量"),
    "xboardTrafficExhausted": MessageLookupByLibrary.simpleMessage("流量已用完"),
    "xboardTrafficUsedUp": MessageLookupByLibrary.simpleMessage("流量已用完"),
    "xboardTunEnabled": MessageLookupByLibrary.simpleMessage("TUN已启用"),
    "xboardTwelveMonthCycle": MessageLookupByLibrary.simpleMessage("12个月周期"),
    "xboardTwentyFourMonthCycle": MessageLookupByLibrary.simpleMessage(
      "24个月周期",
    ),
    "xboardTwoYearPayment": MessageLookupByLibrary.simpleMessage("两年付"),
    "xboardUnauthorizedAccess": MessageLookupByLibrary.simpleMessage(
      "未授权访问，请先登录",
    ),
    "xboardUnknownErrorRetry": MessageLookupByLibrary.simpleMessage("未知错误，请重试"),
    "xboardUnknownUser": MessageLookupByLibrary.simpleMessage("未知用户"),
    "xboardUnlimited": MessageLookupByLibrary.simpleMessage("不限速"),
    "xboardUnselected": MessageLookupByLibrary.simpleMessage("未选择"),
    "xboardUnsupportedCouponType": MessageLookupByLibrary.simpleMessage(
      "不支持的优惠券类型",
    ),
    "xboardUpdateContent": MessageLookupByLibrary.simpleMessage("更新内容："),
    "xboardUpdateLater": MessageLookupByLibrary.simpleMessage("稍后更新"),
    "xboardUpdateNow": MessageLookupByLibrary.simpleMessage("立即更新"),
    "xboardUpdateSubscription": MessageLookupByLibrary.simpleMessage("更新订阅"),
    "xboardUpdateSubscriptionRegularly": MessageLookupByLibrary.simpleMessage(
      "定期更新订阅获取最新节点",
    ),
    "xboardUsageInstructions": MessageLookupByLibrary.simpleMessage("使用说明"),
    "xboardUsed": MessageLookupByLibrary.simpleMessage("已用"),
    "xboardUsedTraffic": MessageLookupByLibrary.simpleMessage("已用"),
    "xboardValidatingConfigFormat": MessageLookupByLibrary.simpleMessage(
      "验证配置格式",
    ),
    "xboardValidationFailed": MessageLookupByLibrary.simpleMessage("验证失败"),
    "xboardValidityPeriod": MessageLookupByLibrary.simpleMessage("有效期"),
    "xboardVerify": MessageLookupByLibrary.simpleMessage("核验"),
    "xboardVeryPoor": MessageLookupByLibrary.simpleMessage("很差"),
    "xboardWaitingForPayment": MessageLookupByLibrary.simpleMessage("正在等待支付"),
    "xboardWaitingPaymentCompletion": MessageLookupByLibrary.simpleMessage(
      "等待支付完成",
    ),
    "xboardYearlyPayment": MessageLookupByLibrary.simpleMessage("年付"),
    "years": MessageLookupByLibrary.simpleMessage("年"),
    "yearsAgo": m81,
    "yes": MessageLookupByLibrary.simpleMessage("是"),
    "zhCN": MessageLookupByLibrary.simpleMessage("中文简体"),
    "zh_CN": MessageLookupByLibrary.simpleMessage("中文简体"),
  };
}
