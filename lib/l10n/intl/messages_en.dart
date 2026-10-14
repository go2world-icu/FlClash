// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(count, skipped) =>
      "${count} to add, ${skipped} skipped as existing";

  static String m1(code) =>
      "Windows refused to run FlClashCore.exe (error ${code}). An app control policy such as Smart App Control or AppLocker blocks unsigned programs; allow ToWorld in that policy or turn it off, then try again.";

  static String m2(name) =>
      "The app failed to finish launching twice in a row. To break the loop, the profile ${name} has been deselected and automatic setup was skipped. You can select it again at any time.";

  static String m3(url) => "Do you want to create a profile from ${url}?";

  static String m4(rate) => "Current commission rate: ${rate}%";

  static String m5(count) =>
      "${Intl.plural(count, one: '1 day ago', other: '${count} days ago')}";

  static String m6(label) =>
      "Are you sure you want to delete the selected ${label}?";

  static String m7(label) => "Are you sure you want to delete this ${label}?";

  static String m8(label) => "${label} details";

  static String m9(label) => "${label} cannot be empty";

  static String m10(count) => "${count} entries";

  static String m11(label) => "${label} already exists";

  static String m12(name) => "${name} is already up to date";

  static String m13(name) => "${name} updated";

  static String m14(name) => "Updating ${name}...";

  static String m15(action) =>
      "Already used by “${action}”. Saving moves it here.";

  static String m16(modifiers) => "Include at least one of ${modifiers}";

  static String m17(count) =>
      "${Intl.plural(count, one: '1 hour ago', other: '${count} hours ago')}";

  static String m18(count) =>
      "${Intl.plural(count, one: '1 hour', other: '${count} hours')}";

  static String m19(target) => "${target} is an invalid policy";

  static String m20(proxyName) => "${proxyName} is an invalid proxy";

  static String m21(providerName) =>
      "${providerName} is an invalid proxy provider";

  static String m22(ruleSet) => "${ruleSet} is an invalid rule set";

  static String m23(subRule) => "${subRule} is an invalid SUB_RULE";

  static String m24(line, message) => "Line ${line}: ${message}";

  static String m25(appName) =>
      "1. Open System Settings > Privacy & Security\n2. Choose Location Services\n3. Find and check ${appName} in the list\n\nWhen you are done, return to the app to continue. Thank you for your cooperation.";

  static String m26(error) => "Logout failed: ${error}";

  static String m27(label, max) => "${label} must be at most ${max} characters";

  static String m28(amount) => "Max transferable: ¥${amount}";

  static String m29(size) => "Released ${size}";

  static String m30(count) =>
      "${Intl.plural(count, one: '1 minute ago', other: '${count} minutes ago')}";

  static String m31(count) =>
      "${Intl.plural(count, one: '1 month ago', other: '${count} months ago')}";

  static String m32(code) =>
      "The server denied access (HTTP ${code}). The link may have expired, or the credentials are wrong";

  static String m33(code) => "The server rejected the request (HTTP ${code})";

  static String m34(code) =>
      "Nothing was found at this address (HTTP ${code}). Check that the URL is correct";

  static String m35(detail) => "Network request failed: ${detail}";

  static String m36(code) =>
      "The server ran into a problem (HTTP ${code}). Try again later";

  static String m37(label) => "No ${label} yet";

  static String m38(label) => "${label} must be a number";

  static String m39(statusCode) => "Failed to get messages: ${statusCode}";

  static String m40(error) => "Failed to select images: ${error}";

  static String m41(method) => "Unsupported HTTP method: ${method}";

  static String m42(error) => "Upload failed: ${error}";

  static String m43(amount) => "Order amount: ${amount}";

  static String m44(orderNo) => "Order: ${orderNo}";

  static String m45(message) => "The core cannot parse this proxy: ${message}";

  static String m46(name) =>
      "The name ${name} is already used by another proxy or proxy group";

  static String m47(path) =>
      "Proxy groups reference each other in a loop: ${path}";

  static String m48(names) => "These proxy providers do not exist: ${names}";

  static String m49(names) =>
      "These proxies or policies do not exist: ${names}";

  static String m50(name) =>
      "${name} is a built-in policy name and cannot be used here";

  static String m51(names) =>
      "The profile\'s own proxy groups name proxies that the custom proxies no longer include: ${names}";

  static String m52(count) =>
      "${count} items have problems, and applying this override may fail";

  static String m53(page) => "Page ${page}";

  static String m54(label) => "${label} must be between 1024 and 49151";

  static String m55(label, profiles) =>
      "${label} is still used by the custom proxy groups or rules of ${profiles}. Remove it there first";

  static String m56(profiles, label) =>
      "The subscriptions of ${profiles} already have ${label}, so those profiles would switch to theirs. Choose another name";

  static String m57(count) =>
      "${Intl.plural(count, one: '1 proxy', other: '${count} proxies')}";

  static String m58(e) => "Registration failed: ${e}";

  static String m59(count) =>
      "${Intl.plural(count, one: '1 rule', other: '${count} rules')}";

  static String m60(appName) => "${appName} (Safe mode)";

  static String m61(count) =>
      "${Intl.plural(count, one: '1 second', other: '${count} seconds')}";

  static String m62(count) => "${count} selected";

  static String m63(e) => "Failed to send verification code: ${e}";

  static String m64(time) => "Checked at ${time}";

  static String m65(label) => "${label} must be a single item";

  static String m66(date) =>
      "Plan expired on ${date}, please renew to continue using";

  static String m67(days) =>
      "Plan will expire in ${days} days, please renew in time";

  static String m68(days) => "Subscription will expire in ${days} days";

  static String m69(count) => "Total ${count} records";

  static String m70(amount) => "Transfer amount cannot exceed ¥${amount}";

  static String m71(error) => "Transfer failed: ${error}";

  static String m72(amount) =>
      "Transfer success! Transferred ¥${amount} to wallet";

  static String m73(version) => "Current version: ${version}";

  static String m74(version) => "Force update: ${version}";

  static String m75(version) => "New version found: ${version}";

  static String m76(statusCode) =>
      "Server returned error status code ${statusCode}";

  static String m77(label) => "${label} must be a URL";

  static String m78(email) =>
      "Verification code has been sent to ${email}, please check and enter the verification code and new password";

  static String m79(amount) => "Withdrawable amount: ${amount}";

  static String m80(time) => "Running time: ${time}";

  static String m81(count) =>
      "${Intl.plural(count, one: '1 year ago', other: '${count} years ago')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "accessControl": MessageLookupByLibrary.simpleMessage("Access control"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Only selected apps go through the VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "Control which apps use the proxy",
    ),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "App access control is disabled",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Selected apps are excluded from the VPN",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage(
      "Access control settings",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "action": MessageLookupByLibrary.simpleMessage("Action"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage("Test all delays"),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("Direct mode"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage("Global mode"),
    "actionMode": MessageLookupByLibrary.simpleMessage("Switch mode"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("Rule mode"),
    "actionStart": MessageLookupByLibrary.simpleMessage("Start/Stop"),
    "actionTun": MessageLookupByLibrary.simpleMessage("TUN"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage(
      "Update profiles",
    ),
    "actionView": MessageLookupByLibrary.simpleMessage("Show/Hide"),
    "action_mode": MessageLookupByLibrary.simpleMessage("Switch mode"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "action_start": MessageLookupByLibrary.simpleMessage("Start/Stop"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("Show/Hide"),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("Add proxy"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage(
      "Add override entry",
    ),
    "addProfile": MessageLookupByLibrary.simpleMessage("Add profile"),
    "addProxies": MessageLookupByLibrary.simpleMessage("Add proxies"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage("Add proxy group"),
    "addProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Add proxy providers",
    ),
    "addRule": MessageLookupByLibrary.simpleMessage("Add rule"),
    "addSsid": MessageLookupByLibrary.simpleMessage("Add SSID"),
    "addWidget": MessageLookupByLibrary.simpleMessage("Add widget"),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage(
      "Attach on the original rules",
    ),
    "addedRules": MessageLookupByLibrary.simpleMessage("Added rules"),
    "additionalParameters": MessageLookupByLibrary.simpleMessage(
      "Additional parameters",
    ),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "addressHelp": MessageLookupByLibrary.simpleMessage(
      "WebDAV server address",
    ),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid WebDAV address",
    ),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage(
      "Admin auto launch",
    ),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Boot up by using admin mode",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Advanced configuration",
    ),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Network, DNS, added rules, and scripts",
    ),
    "ago": MessageLookupByLibrary.simpleMessage(" Ago"),
    "agree": MessageLookupByLibrary.simpleMessage("Agree"),
    "allApps": MessageLookupByLibrary.simpleMessage("All apps"),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Allow apps to bypass VPN",
    ),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "Some apps can bypass VPN when turned on",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("Allow LAN"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage(
      "Allow access proxy through the LAN",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "answers": MessageLookupByLibrary.simpleMessage("Answers"),
    "app": MessageLookupByLibrary.simpleMessage("App"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "App access control",
    ),
    "appDesc": MessageLookupByLibrary.simpleMessage(
      "Processing app related settings",
    ),
    "appIconDesign": MessageLookupByLibrary.simpleMessage("App icon design"),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Append system DNS",
    ),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage(
      "Forcefully append system DNS to the configuration",
    ),
    "application": MessageLookupByLibrary.simpleMessage("Application"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage(
      "Modify application related settings",
    ),
    "authentication": MessageLookupByLibrary.simpleMessage("Authentication"),
    "authenticationDesc": MessageLookupByLibrary.simpleMessage(
      "Require credentials on the local proxy port to keep other local apps from using it",
    ),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Not applied while authentication is enabled",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("Authorize"),
    "authorized": MessageLookupByLibrary.simpleMessage("Authorized"),
    "auto": MessageLookupByLibrary.simpleMessage("Auto"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Auto check for updates",
    ),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Auto check for updates when the app starts",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Auto close connections",
    ),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Close connections automatically after switching nodes",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Auto launch"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Launch automatically at system startup",
    ),
    "autoRun": MessageLookupByLibrary.simpleMessage("Auto run"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Run automatically when the app opens",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Auto-set system DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Auto update"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Auto-update interval (minutes)",
    ),
    "availableCommission": MessageLookupByLibrary.simpleMessage("Available"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Back to Login"),
    "backup": MessageLookupByLibrary.simpleMessage("Backup"),
    "backupAndRecovery": MessageLookupByLibrary.simpleMessage(
      "Backup and Recovery",
    ),
    "backupAndRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Sync data via WebDAV or file",
    ),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Backup and restore",
    ),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "Sync data via WebDAV or files",
    ),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "This backup comes from a newer version of the app. Update the app before restoring it",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("Backup successful"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("Basic configuration"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Modify the basic configuration globally",
    ),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Basic info"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("Basic strategies"),
    "batchAdd": MessageLookupByLibrary.simpleMessage("Batch add"),
    "batchListInputTip": MessageLookupByLibrary.simpleMessage(
      "One item per line, or separated by commas",
    ),
    "batchMapInputTip": MessageLookupByLibrary.simpleMessage(
      "One entry per line: key, a space, then value",
    ),
    "batchPreviewTip": m0,
    "batteryOptimizationDesc": MessageLookupByLibrary.simpleMessage(
      "To keep the app running in the background, disable battery optimization for it. Tap to open settings.",
    ),
    "batteryOptimizationStatusTip": MessageLookupByLibrary.simpleMessage(
      "Due to system limitations, the battery optimization status cannot be read correctly while running",
    ),
    "behavior": MessageLookupByLibrary.simpleMessage("Behavior"),
    "bind": MessageLookupByLibrary.simpleMessage("Bind"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("Blacklist mode"),
    "blockConnection": MessageLookupByLibrary.simpleMessage("Block connection"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Bypass domains"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Only takes effect while the system proxy is enabled",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("Cache"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage("Cache algorithm"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "The cache is corrupted. Clear it?",
    ),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("Cache size"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Allow camera access in system settings to scan QR codes, or choose a QR code image from the album.",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Camera permission required",
    ),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage(
      "Camera unavailable",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Cancel filter system app",
    ),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("Deselect all"),
    "cannotGetWebUrl": MessageLookupByLibrary.simpleMessage(
      "Cannot get web URL, please contact support",
    ),
    "cannotOpenBrowser": MessageLookupByLibrary.simpleMessage(
      "Cannot open browser, please visit web manually",
    ),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "Failed to switch proxy; the previous selection has been restored",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage(
      "Breaking changes",
    ),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("New features"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage("Bug fixes"),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage("Performance"),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("Reverts"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage(
      "Verify TLS certificates",
    ),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "Reject untrusted certificates. Turning this off exposes subscriptions and backups to man-in-the-middle attacks",
    ),
    "checkError": MessageLookupByLibrary.simpleMessage("Check error"),
    "checkNetwork": MessageLookupByLibrary.simpleMessage(
      "Please check network and retry",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("Check for updates"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "The app is already up to date",
    ),
    "checking": MessageLookupByLibrary.simpleMessage("Checking..."),
    "clearData": MessageLookupByLibrary.simpleMessage("Clear data"),
    "clearSearch": MessageLookupByLibrary.simpleMessage("Clear search"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage(
      "Export to clipboard",
    ),
    "clipboardImport": MessageLookupByLibrary.simpleMessage(
      "Import from clipboard",
    ),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t copy to the clipboard. The selection may be too large",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "closeConnections": MessageLookupByLibrary.simpleMessage(
      "Close connections",
    ),
    "color": MessageLookupByLibrary.simpleMessage("Color"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("Color schemes"),
    "columns": MessageLookupByLibrary.simpleMessage("Columns"),
    "commissionHistory": MessageLookupByLibrary.simpleMessage(
      "Commission History",
    ),
    "commissionRate": MessageLookupByLibrary.simpleMessage("Rate"),
    "commissionSettled": MessageLookupByLibrary.simpleMessage(
      "Commission settled after friend subscription",
    ),
    "compatible": MessageLookupByLibrary.simpleMessage("Compatibility mode"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "Opening it will lose part of its application ability and gain the support of full amount of Clash.",
    ),
    "complete": MessageLookupByLibrary.simpleMessage("Complete"),
    "completeWithdrawal": MessageLookupByLibrary.simpleMessage(
      "Web version provides complete withdrawal features",
    ),
    "configDataDetected": MessageLookupByLibrary.simpleMessage(
      "Data detected in the configuration",
    ),
    "configurationError": MessageLookupByLibrary.simpleMessage(
      "Application configuration error, please contact support",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to clear all data?",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this proxy group?",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to exit the current window?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to force crash the core?",
    ),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("Confirm Logout"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Confirm New Password",
    ),
    "confirmOverwriteTip": MessageLookupByLibrary.simpleMessage(
      "Confirming will overwrite existing data",
    ),
    "confirmTransfer": MessageLookupByLibrary.simpleMessage("Confirm Transfer"),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connecting…"),
    "connection": MessageLookupByLibrary.simpleMessage("Connection"),
    "connections": MessageLookupByLibrary.simpleMessage("Connections"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage(
      "View current connections data",
    ),
    "connectivity": MessageLookupByLibrary.simpleMessage("Connectivity: "),
    "contactMe": MessageLookupByLibrary.simpleMessage("Contact me"),
    "contactSupport": MessageLookupByLibrary.simpleMessage("Support"),
    "content": MessageLookupByLibrary.simpleMessage("Content"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Content cannot be empty",
    ),
    "contentScheme": MessageLookupByLibrary.simpleMessage("Content"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Control global added rules",
    ),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Copied to clipboard",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copy"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Copy environment variables",
    ),
    "copyInviteLink": MessageLookupByLibrary.simpleMessage("Copy Link"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copy link"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Copied successfully"),
    "core": MessageLookupByLibrary.simpleMessage("Core"),
    "coreBlockedByPolicyTip": m1,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Windows Smart App Control blocked FlClashCore.exe because it is not signed. Open Windows Security → App & browser control → Smart App Control settings, choose Off, then start ToWorld again. Smart App Control cannot be turned back on without reinstalling Windows.",
    ),
    "coreInfo": MessageLookupByLibrary.simpleMessage("Core info"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("Core status"),
    "country": MessageLookupByLibrary.simpleMessage("Region"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("Crash detected"),
    "crashDetectedTip": m2,
    "crashTest": MessageLookupByLibrary.simpleMessage("Crash test"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("Crash analytics"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "When enabled, crash logs without sensitive information are uploaded automatically when the app crashes",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "createProfile": MessageLookupByLibrary.simpleMessage("Create Profile"),
    "createProfileFromUrlTip": m3,
    "creationTime": MessageLookupByLibrary.simpleMessage("Creation time"),
    "credentialsSaved": MessageLookupByLibrary.simpleMessage(
      "Credentials saved",
    ),
    "currentCommissionRate": m4,
    "custom": MessageLookupByLibrary.simpleMessage("Custom"),
    "customProxiesEmpty": MessageLookupByLibrary.simpleMessage(
      "No custom proxies, so the profile\'s own proxies are used",
    ),
    "cut": MessageLookupByLibrary.simpleMessage("Cut"),
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "dataChangedSave": MessageLookupByLibrary.simpleMessage(
      "Data changes detected. Save them?",
    ),
    "dataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "This app uses Firebase Crashlytics to collect crash information to improve stability.\nThe collected data includes device information and crash details, and contains no personally sensitive data.\nYou can turn this off in settings.",
    ),
    "dataCollectionTip": MessageLookupByLibrary.simpleMessage(
      "Data collection notice",
    ),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "Failed to save the change; it has been rolled back",
    ),
    "days": MessageLookupByLibrary.simpleMessage("Days"),
    "daysAgo": m5,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage(
      "Default nameserver",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "For resolving DNS server",
    ),
    "defaultSort": MessageLookupByLibrary.simpleMessage("Sort by default"),
    "defaultText": MessageLookupByLibrary.simpleMessage("Default"),
    "delay": MessageLookupByLibrary.simpleMessage("Delay"),
    "delaySort": MessageLookupByLibrary.simpleMessage("Sort by delay"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Delay test"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteMultipTip": m6,
    "deleteTip": m7,
    "desc": MessageLookupByLibrary.simpleMessage(
      "A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free.",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Destination"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "Destination GeoIP",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage(
      "Destination IP ASN",
    ),
    "details": m8,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Relies on a third-party API; for reference only",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Developer mode"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Developer mode is enabled.",
    ),
    "dialerProxy": MessageLookupByLibrary.simpleMessage("Dialer proxy"),
    "dialerProxyDesc": MessageLookupByLibrary.simpleMessage(
      "The outbound used to reach the NTP server",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("Direct"),
    "disableUDP": MessageLookupByLibrary.simpleMessage("Disable UDP"),
    "disabled": MessageLookupByLibrary.simpleMessage("Disabled"),
    "discardChanges": MessageLookupByLibrary.simpleMessage(
      "Discard the changes?",
    ),
    "disclaimer": MessageLookupByLibrary.simpleMessage("Disclaimer"),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "By installing, copying, or using the Software, you are deemed to have read and agreed to this entire statement. If you disagree with any of its terms, stop using and uninstall the Software immediately.",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage("Acceptance"),
    "disclaimerAnalyticsContent": MessageLookupByLibrary.simpleMessage(
      "Basic app usage statistics are collected automatically with Firebase.\n\nWhat is collected: basic events such as first launch, app opens and session length, and app updates; an app instance ID; the device model, OS version, and system language; and an approximate country- or region-level location inferred from the IP address.\n\nPurpose: only to understand the number of active devices, version distribution, and OS compatibility. The developers do not use this data for advertising, do not sell it, and do not link it to your subscriptions or configurations.",
    ),
    "disclaimerAnalyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Firebase Analytics (usage statistics)",
    ),
    "disclaimerAndroidOnly": MessageLookupByLibrary.simpleMessage(
      "Android only",
    ),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "The developers may revise this statement with any release, and the revision takes effect when that release is published. Continuing to use the Software after updating means you accept the revised statement.",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Changes to this statement",
    ),
    "disclaimerCrashlyticsContent": MessageLookupByLibrary.simpleMessage(
      "When the app crashes, a crash report is uploaded automatically.\n\nWhat is collected: the crash stack trace and error message, the time of the crash, the app version and build number, the device brand and model, the Android version, screen orientation, free memory and storage, whether the device is rooted, and a random installation ID that is created on install and reset on reinstall.\n\nPurpose: only to locate and fix crashes.\n\nYou can turn it off at any time under \"Tools > General > Crash analytics\".",
    ),
    "disclaimerCrashlyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Firebase Crashlytics (crash analytics)",
    ),
    "disclaimerDataProcessingContent": MessageLookupByLibrary.simpleMessage(
      "This data is processed and stored by Google on our behalf, may be transferred to servers outside your country or region (such as in the United States), and is governed by the Google Privacy Policy and the Firebase privacy and security documentation. Crash reports are kept for up to 90 days; statistics are kept under the Firebase default retention policy.",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "Before using ToWorld (\"the Software\"), please read this statement carefully and make sure you understand all of it. Tapping \"Agree\" means you have read, understood, and accept every term below. If you do not agree, tap \"Exit\" and stop using the Software.",
    ),
    "disclaimerFirebasePrivacy": MessageLookupByLibrary.simpleMessage(
      "Firebase privacy and security",
    ),
    "disclaimerGooglePrivacy": MessageLookupByLibrary.simpleMessage(
      "Google Privacy Policy",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "To the maximum extent permitted by applicable law, neither the developers nor any contributor shall be liable for any direct, indirect, incidental, special, punitive, or consequential damages arising from the use of or inability to use the Software, including but not limited to data loss, device damage, network failures, business interruption, lost profits, or any resulting legal dispute, even if advised of the possibility of such damages.",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage(
      "Limitation of liability",
    ),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "The Software is open source under the GPL-3.0 license. You may use, modify, and distribute it freely as long as you comply with that license, which requires derivative works to be released under GPL-3.0 as well and the original copyright notices to be kept.\n\nThird-party components in the Software, including the Clash.Meta core, follow their own licenses. The original authors are not responsible for any issue arising from modified or redistributed versions.",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage(
      "Open-source license",
    ),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "The Software does not collect or upload your subscription URLs, node details, configuration content, visited websites, connection records, traffic content, or logs. This data stays on your device and the developers have no access to it.\n\nThe Software only reaches the network when you use a feature that needs it, such as fetching the subscription URL you provided when updating a profile, or contacting GitHub when checking for updates.\n\nThe desktop versions (Windows, macOS, Linux) include no analytics or crash reporting service. The Android version includes the following two Google Firebase services to improve stability:",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "Data collection and privacy",
    ),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "You are responsible for making sure that using the Software is lawful where you live, and you alone bear the legal responsibility for everything you do with it and its consequences.\n\nThe subscriptions, nodes, and configurations you import are your own choice. Whether their source is lawful, their content is safe, and their service is reliable is a matter between you and their providers.",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "Your responsibility",
    ),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "The Software is an open-source network proxy client built on the Clash.Meta (mihomo) core. It only provides local tooling such as configuration management, rule-based routing, and traffic forwarding.\n\nThe Software itself does not provide any proxy server, node, subscription, or network access service, and has no partnership, agency, or guarantee relationship with any provider of such services.",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage(
      "Nature of the software",
    ),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "Subscription links, configuration files, rule sets, scripts, external resources, and external links are all provided by third parties. The developers cannot and do not review or guarantee their legality, accuracy, security, or availability.\n\nAny data leak, financial loss, account ban, or other loss caused by third-party content is to be settled between you and the third party; the developers bear no responsibility for it.",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "Third-party content",
    ),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "The Software is intended only for non-commercial uses such as learning, exchange, and technical research. Using it for any commercial purpose is strictly prohibited, including but not limited to paid distribution, bundled sales, use as part of a commercial service, or doing business in the name of the Software. Any commercial activity is unrelated to the Software and its developers.\n\nUsing the Software for anything that violates the laws and regulations of your country or region is strictly prohibited, including but not limited to bypassing lawfully imposed network access restrictions, spreading illegal content, launching network attacks, or infringing the lawful rights of others.",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage(
      "Restrictions on use",
    ),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "The Software is provided \"as is\" and \"as available\", without warranty of any kind, express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, non-infringement, uninterrupted availability, freedom from errors, or freedom from security vulnerabilities.\n\nThe developers do not guarantee that the Software will meet your needs or that it will run without interruption or error.",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage(
      "No warranty",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "New version found",
    ),
    "discovery": MessageLookupByLibrary.simpleMessage(
      "Discovery a new version",
    ),
    "dnsDesc": MessageLookupByLibrary.simpleMessage(
      "Update DNS related settings",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS hijacking"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS mode"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("DNS queries"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage(
      "Do you want to pass",
    ),
    "docked": MessageLookupByLibrary.simpleMessage("Docked"),
    "domain": MessageLookupByLibrary.simpleMessage("Domain"),
    "domainStatusAvailable": MessageLookupByLibrary.simpleMessage(
      "Service Available",
    ),
    "domainStatusChecking": MessageLookupByLibrary.simpleMessage("Checking..."),
    "domainStatusUnavailable": MessageLookupByLibrary.simpleMessage(
      "Service Unavailable",
    ),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Edit global rules",
    ),
    "editProxy": MessageLookupByLibrary.simpleMessage("Edit proxy"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage("Edit proxy group"),
    "editRule": MessageLookupByLibrary.simpleMessage("Edit rule"),
    "editSsid": MessageLookupByLibrary.simpleMessage("Edit SSID"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage(
      "Editor unavailable",
    ),
    "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
    "emailVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Email Verification Code",
    ),
    "emptyTip": m9,
    "en": MessageLookupByLibrary.simpleMessage("English"),
    "enableOverride": MessageLookupByLibrary.simpleMessage("Enable override"),
    "enabled": MessageLookupByLibrary.simpleMessage("Enabled"),
    "enterEmailForReset": MessageLookupByLibrary.simpleMessage(
      "Please enter your email address and we will send a verification code to your email",
    ),
    "enterTransferAmount": MessageLookupByLibrary.simpleMessage(
      "Enter transfer amount",
    ),
    "enterTransferAmountError": MessageLookupByLibrary.simpleMessage(
      "Please enter transfer amount",
    ),
    "entries": MessageLookupByLibrary.simpleMessage(" entries"),
    "entriesCount": m10,
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "exclude": MessageLookupByLibrary.simpleMessage("Hide from recent tasks"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "Hide the app from recent tasks while it is in the background",
    ),
    "excludeProxyFilter": MessageLookupByLibrary.simpleMessage(
      "Exclude proxy filter",
    ),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("Exclude SSIDs"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "When connected to Wi-Fi with an excluded SSID, the app\'s running state switches automatically",
    ),
    "excludeType": MessageLookupByLibrary.simpleMessage("Exclude type"),
    "existsTip": m11,
    "exit": MessageLookupByLibrary.simpleMessage("Exit"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage("Exit full screen"),
    "expand": MessageLookupByLibrary.simpleMessage("Standard"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("Expected status"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("Expiration time"),
    "expireTime": MessageLookupByLibrary.simpleMessage("Expiration time"),
    "exportFile": MessageLookupByLibrary.simpleMessage("Export file"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Export logs"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Export successful"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("Expressive"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "External controller",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "When enabled, the Clash core can be controlled on port 9090",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("External fetch"),
    "externalLink": MessageLookupByLibrary.simpleMessage("External link"),
    "externalResources": MessageLookupByLibrary.simpleMessage(
      "External resources",
    ),
    "extraLarge": MessageLookupByLibrary.simpleMessage("Extra large"),
    "fade": MessageLookupByLibrary.simpleMessage("Fade"),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fake-IP filter"),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage(
      "Fake-IP filter mode",
    ),
    "fakeipFilterModeDesc": MessageLookupByLibrary.simpleMessage(
      "blacklist excludes matches, whitelist fakes only matches, rule matches as rules",
    ),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fake-IP range"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage(
      "Fake-IP range (IPv6)",
    ),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("Fake-IP TTL"),
    "fallback": MessageLookupByLibrary.simpleMessage("Fallback"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Generally use offshore DNS",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Fallback filter"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("Fidelity"),
    "file": MessageLookupByLibrary.simpleMessage("File"),
    "fileDesc": MessageLookupByLibrary.simpleMessage(
      "Upload a profile file directly",
    ),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "The file has been modified. Save the changes?",
    ),
    "fillInfoToRegister": MessageLookupByLibrary.simpleMessage(
      "Please fill in the following information to complete registration",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Filter system app",
    ),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("Find process"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "There is a certain performance loss after opening",
    ),
    "floating": MessageLookupByLibrary.simpleMessage("Floating"),
    "followProfile": MessageLookupByLibrary.simpleMessage("Follow profile"),
    "followSystem": MessageLookupByLibrary.simpleMessage("Follow system"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("Font family"),
    "fontSize": MessageLookupByLibrary.simpleMessage("Size"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to force restart the core?",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password"),
    "format": MessageLookupByLibrary.simpleMessage("Format"),
    "fourColumns": MessageLookupByLibrary.simpleMessage("Four columns"),
    "friendInviteReward": MessageLookupByLibrary.simpleMessage(
      "Earn commission when your invited friends spend",
    ),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("Fruit salad"),
    "general": MessageLookupByLibrary.simpleMessage("General"),
    "generalDesc": MessageLookupByLibrary.simpleMessage(
      "Modify general settings",
    ),
    "generatingInviteCode": MessageLookupByLibrary.simpleMessage(
      "Generating invite code...",
    ),
    "geoAutoUpdate": MessageLookupByLibrary.simpleMessage("Auto update"),
    "geoAutoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Auto-update interval",
    ),
    "geoAutoUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "The auto-update interval must be greater than 0",
    ),
    "geoData": MessageLookupByLibrary.simpleMessage("GeoData"),
    "geoOptions": MessageLookupByLibrary.simpleMessage("Geo options"),
    "geoResources": MessageLookupByLibrary.simpleMessage("Geo resources"),
    "geoSkipped": m12,
    "geoUpdated": m13,
    "geoUpdating": m14,
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Geo low-memory mode",
    ),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "Enabling will use the Geo low memory loader",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Geoip code"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage(
      "Get original rules",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Global"),
    "go": MessageLookupByLibrary.simpleMessage("Go"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Download"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Go to script configuration",
    ),
    "goToWeb": MessageLookupByLibrary.simpleMessage("Go to Web"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Cache the changes?",
    ),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "Helper service unavailable; TUN mode cannot be enabled. Reinstall ToWorld to restore it.",
    ),
    "hideFromList": MessageLookupByLibrary.simpleMessage("Hide from list"),
    "hideIp": MessageLookupByLibrary.simpleMessage("Hide IP"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("Hide password"),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage(
      "Hide timed-out nodes",
    ),
    "hideTimeoutProxiesDesc": MessageLookupByLibrary.simpleMessage(
      "Leave out nodes whose last delay test timed out",
    ),
    "host": MessageLookupByLibrary.simpleMessage("Host"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("Add Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("Hotkey conflict"),
    "hotkeyConflictWith": m15,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "Global hotkeys work even while the window is hidden. Tap an action to record its key combination.",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Hotkey management",
    ),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "Use keyboard to control applications",
    ),
    "hotkeyNeedsModifier": m16,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("Not set"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "Not registered, it may be taken by another app",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("hours"),
    "hoursAgo": m17,
    "hoursCount": m18,
    "iUnderstand": MessageLookupByLibrary.simpleMessage("I Understand"),
    "icon": MessageLookupByLibrary.simpleMessage("Icon"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage(
      "Icon configuration",
    ),
    "iconRecords": MessageLookupByLibrary.simpleMessage("Icon records"),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Icon style"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("Filled"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("Hidden"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("Plain"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("Icon URL"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "Ignore battery optimization",
    ),
    "import": MessageLookupByLibrary.simpleMessage("Import"),
    "importFile": MessageLookupByLibrary.simpleMessage("Import from file"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("Import from URL"),
    "importUrl": MessageLookupByLibrary.simpleMessage("Import from URL"),
    "inbound": MessageLookupByLibrary.simpleMessage("Inbound"),
    "includeAllProxies": MessageLookupByLibrary.simpleMessage(
      "Include all proxies",
    ),
    "includeAllProxiesTip": MessageLookupByLibrary.simpleMessage(
      "Imports all proxies outside proxy groups; extra proxy groups can be added below",
    ),
    "includeAllProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Include all proxy providers",
    ),
    "includeAllProxyProvidersTip": MessageLookupByLibrary.simpleMessage(
      "When enabled, the group takes every proxy provider of this profile: the subscription\'s own, plus the profiles and app proxy providers any proxy group uses",
    ),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("Never expires"),
    "init": MessageLookupByLibrary.simpleMessage("Init"),
    "initiator": MessageLookupByLibrary.simpleMessage("Initiator"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage(
      "Please enter the correct hotkey",
    ),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "Enter the proxy group name",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage(
      "Enter the rule content",
    ),
    "installedAppsPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "The app list permission was denied, so installed apps cannot be listed. Please grant it manually in system settings.",
    ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "This system hides the installed app list until the permission is granted. Authorize it to configure the per-app proxy.",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "App list permission required",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Smart selection",
    ),
    "interfaceName": MessageLookupByLibrary.simpleMessage("Interface name"),
    "interfaceNameDesc": MessageLookupByLibrary.simpleMessage(
      "Network interface used for outbound connections",
    ),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage(
      "Outbound interface",
    ),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("Clear"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage("Custom"),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage(
      "Follow config",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Internet"),
    "interval": MessageLookupByLibrary.simpleMessage("Interval"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("Intranet IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Invalid backup file",
    ),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "A DSCP mark cannot exceed 63",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "Only tcp or udp is supported",
    ),
    "invalidPolicy": m19,
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "This QR code doesn\'t contain a profile link",
    ),
    "invalidProxy": m20,
    "invalidProxyProvider": m21,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "Enter numbers or ranges such as 80 or 8000-9000, separated by /",
    ),
    "invalidRuleSet": m22,
    "invalidSubRule": m23,
    "invalidTransferAmount": MessageLookupByLibrary.simpleMessage(
      "Please enter valid transfer amount",
    ),
    "invite": MessageLookupByLibrary.simpleMessage("Invite"),
    "inviteCode": MessageLookupByLibrary.simpleMessage("Invite Code"),
    "inviteCodeGenFailed": MessageLookupByLibrary.simpleMessage(
      "Invite code generation failed",
    ),
    "inviteCodeIncorrect": MessageLookupByLibrary.simpleMessage(
      "Invite code may be incorrect, please check and re-enter",
    ),
    "inviteCodeOptional": MessageLookupByLibrary.simpleMessage(
      "Invite Code (optional)",
    ),
    "inviteCodeRequired": MessageLookupByLibrary.simpleMessage(
      "Invite Code Required",
    ),
    "inviteCodeRequiredMessage": MessageLookupByLibrary.simpleMessage(
      "Registration requires an invite code. Please contact a registered user to get an invite code before registering.",
    ),
    "inviteLinkCopied": MessageLookupByLibrary.simpleMessage(
      "Invite link copied, share with friends",
    ),
    "inviteRegisterReward": MessageLookupByLibrary.simpleMessage(
      "Invite friends to register and subscribe to earn commission",
    ),
    "inviteRules": MessageLookupByLibrary.simpleMessage("Invite Rules"),
    "inviteStats": MessageLookupByLibrary.simpleMessage("Invite Stats"),
    "ipAddress": MessageLookupByLibrary.simpleMessage("IP address"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("Abuse history"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("Proxy"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("Flags"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("Organization"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t determine the IP type",
    ),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("Good"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("Level"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("Normal"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage("Check again"),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("Risky"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("Answered by"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("Sources"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage(
      "Different outbound IP",
    ),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("No type"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage("Rate limited"),
    "ipType": MessageLookupByLibrary.simpleMessage("Type"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("Business"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("Data center"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("Mobile network"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Residential"),
    "ipcidr": MessageLookupByLibrary.simpleMessage("Ipcidr"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "When enabled, IPv6 traffic can be received",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage(
      "Allow IPv6 inbound",
    ),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage("IPv6 timeout (ms)"),
    "ja": MessageLookupByLibrary.simpleMessage("Japanese"),
    "just": MessageLookupByLibrary.simpleMessage("Just"),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "TCP keep-alive interval",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Key"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "large": MessageLookupByLibrary.simpleMessage("Large"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("Last updated"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage(
      "Launch did not finish",
    ),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "The app exited unexpectedly while it was starting up last time. Automatic setup was skipped for this launch; you can start it manually to retry.",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("Layout"),
    "light": MessageLookupByLibrary.simpleMessage("Light"),
    "lineIssueTip": m24,
    "lineWrap": MessageLookupByLibrary.simpleMessage("Word wrap"),
    "list": MessageLookupByLibrary.simpleMessage("List"),
    "listen": MessageLookupByLibrary.simpleMessage("Listen"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage(
      "Listen routing mark",
    ),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage("Linux only"),
    "liveConnections": MessageLookupByLibrary.simpleMessage("Live connections"),
    "loadMore": MessageLookupByLibrary.simpleMessage("Load More"),
    "loadTest": MessageLookupByLibrary.simpleMessage("Load test"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading…"),
    "local": MessageLookupByLibrary.simpleMessage("Local"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Backup local data to local",
    ),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "Local network permission denied: using the gvisor stack, LAN is unreachable.",
    ),
    "localRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Recovery data from file",
    ),
    "locationPermission": MessageLookupByLibrary.simpleMessage(
      "Location permission",
    ),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Location permission was denied, so the current Wi-Fi name cannot be read. Please enable location permission manually in system settings.",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "The system requires location permission to read the Wi-Fi name. On Android choose \"Allow all the time\", otherwise the Wi-Fi name cannot be read while the app is in the background.",
    ),
    "locationPermissionGuide": m25,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Location permission required",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Log"),
    "logLevel": MessageLookupByLibrary.simpleMessage("Log level"),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Disabling hides the log entry point",
    ),
    "loggedOutSuccess": MessageLookupByLibrary.simpleMessage(
      "Logged out successfully",
    ),
    "loginNow": MessageLookupByLibrary.simpleMessage("Login Now"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutConfirmMsg": MessageLookupByLibrary.simpleMessage(
      "Are you sure to logout? You need to login again.",
    ),
    "logoutFailed": m26,
    "logs": MessageLookupByLibrary.simpleMessage("Logs"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage(
      "Logs and diagnostics",
    ),
    "logsDesc": MessageLookupByLibrary.simpleMessage("Log capture records"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Logs test"),
    "loopback": MessageLookupByLibrary.simpleMessage("UWP loopback exemption"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage(
      "Used for UWP loopback unlocking",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Loose"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage("Match source IP"),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("Max failures"),
    "maxLengthTip": m27,
    "maxTransferable": m28,
    "maximize": MessageLookupByLibrary.simpleMessage("Maximize"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage(
      "Resident memory",
    ),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage("App & shared"),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage("Heap idle"),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage("Heap in use"),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage(
      "Core is not running",
    ),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage(
      "Runtime overhead",
    ),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage("Goroutine stacks"),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "Estimated from process resident memory; it may differ from what the system reports.",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "The Core runs inside the app process. Its share is estimated from runtime stats, and the rest counts as app and shared memory.",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Memory info"),
    "memoryReleased": MessageLookupByLibrary.simpleMessage("Memory released"),
    "memoryReleasedSize": m29,
    "messageTest": MessageLookupByLibrary.simpleMessage("Message test"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage(
      "This is a message.",
    ),
    "min": MessageLookupByLibrary.simpleMessage("Minimal"),
    "minimize": MessageLookupByLibrary.simpleMessage("Minimize"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("Minimize on exit"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "Modify the default system exit event",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("Minutes"),
    "minutesAgo": m30,
    "mixedPort": MessageLookupByLibrary.simpleMessage("Mixed port"),
    "mode": MessageLookupByLibrary.simpleMessage("Mode"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Monochrome"),
    "months": MessageLookupByLibrary.simpleMessage("Months"),
    "monthsAgo": m31,
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "myInviteQr": MessageLookupByLibrary.simpleMessage("My Invite QR"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameSort": MessageLookupByLibrary.simpleMessage("Sort by name"),
    "nameserver": MessageLookupByLibrary.simpleMessage("Nameserver"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "For resolving domain",
    ),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage(
      "Nameserver policy",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Specify the corresponding nameserver policy",
    ),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage("Bottom bar"),
    "network": MessageLookupByLibrary.simpleMessage("Network"),
    "networkAccessDeniedError": m32,
    "networkBadResponseError": m33,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage(
      "The request was cancelled",
    ),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t connect to the server. Check your network connection or proxy settings",
    ),
    "networkDesc": MessageLookupByLibrary.simpleMessage(
      "Modify network-related settings",
    ),
    "networkDetection": MessageLookupByLibrary.simpleMessage(
      "Network detection",
    ),
    "networkException": MessageLookupByLibrary.simpleMessage(
      "Network exception, please check your connection and try again",
    ),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t resolve the server address. Check that the URL is correct and DNS is working",
    ),
    "networkNotFoundError": m34,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "Too many requests (HTTP 429). Wait a moment and try again",
    ),
    "networkRequestFailed": m35,
    "networkServerError": m36,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Network speed"),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "The request timed out. Check your network or proxy, then try again",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "Secure connection failed. The server\'s certificate may be invalid, or the connection is being intercepted",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("Network type"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("Neutral"),
    "newMessageFromSupport": MessageLookupByLibrary.simpleMessage(
      "New message from support",
    ),
    "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("Next match"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noCommissionRecord": MessageLookupByLibrary.simpleMessage(
      "No commission records",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("No data"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("No HotKey"),
    "noIcon": MessageLookupByLibrary.simpleMessage("None"),
    "noInfo": MessageLookupByLibrary.simpleMessage("No info"),
    "noInvitationData": MessageLookupByLibrary.simpleMessage(
      "No invitation data",
    ),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "Don\'t remind me again",
    ),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage("No more info"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("No network"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("No-network apps"),
    "noProxy": MessageLookupByLibrary.simpleMessage("No proxy"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Please create a profile or add a valid profile",
    ),
    "noRecords": MessageLookupByLibrary.simpleMessage("No records"),
    "noResolve": MessageLookupByLibrary.simpleMessage("Don\'t resolve IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage(
      "Don\'t resolve hostname",
    ),
    "noSearchResults": MessageLookupByLibrary.simpleMessage(
      "No matching results",
    ),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage(
      "This external resource is not a text file",
    ),
    "none": MessageLookupByLibrary.simpleMessage("None"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "The current proxy group cannot be selected",
    ),
    "ntpInterval": MessageLookupByLibrary.simpleMessage(
      "Sync interval (minutes)",
    ),
    "ntpStatusDesc": MessageLookupByLibrary.simpleMessage(
      "Take the time from an NTP server instead of the system clock",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "Add a profile to get started",
    ),
    "nullTip": m37,
    "numberTip": m38,
    "onDemand": MessageLookupByLibrary.simpleMessage("On demand"),
    "onDemandDesc": MessageLookupByLibrary.simpleMessage(
      "Configure the app\'s running state for specific scenarios",
    ),
    "oneColumn": MessageLookupByLibrary.simpleMessage("One column"),
    "onlineSupport": MessageLookupByLibrary.simpleMessage("Support"),
    "onlineSupportAddMore": MessageLookupByLibrary.simpleMessage("Add More"),
    "onlineSupportApiConfigNotFound": MessageLookupByLibrary.simpleMessage(
      "Online support API configuration not found, please check configuration",
    ),
    "onlineSupportCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "onlineSupportClearHistory": MessageLookupByLibrary.simpleMessage(
      "Clear history",
    ),
    "onlineSupportClearHistoryConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to clear all chat history? This action cannot be undone.",
    ),
    "onlineSupportClickToSelect": MessageLookupByLibrary.simpleMessage(
      "Click to select images",
    ),
    "onlineSupportConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "onlineSupportConnected": MessageLookupByLibrary.simpleMessage(
      "Successfully connected to support system",
    ),
    "onlineSupportConnecting": MessageLookupByLibrary.simpleMessage(
      "Connecting...",
    ),
    "onlineSupportConnectionError": MessageLookupByLibrary.simpleMessage(
      "Connection error",
    ),
    "onlineSupportDisconnected": MessageLookupByLibrary.simpleMessage(
      "Disconnected",
    ),
    "onlineSupportGetMessagesFailed": m39,
    "onlineSupportInputHint": MessageLookupByLibrary.simpleMessage(
      "Please enter your question...",
    ),
    "onlineSupportNoMessages": MessageLookupByLibrary.simpleMessage(
      "No messages yet, send a message to start consultation",
    ),
    "onlineSupportSelectImages": MessageLookupByLibrary.simpleMessage(
      "Select Images",
    ),
    "onlineSupportSelectImagesFailed": m40,
    "onlineSupportSend": MessageLookupByLibrary.simpleMessage("Send"),
    "onlineSupportSendImage": MessageLookupByLibrary.simpleMessage(
      "Send image",
    ),
    "onlineSupportSendMessageFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to send message: Unable to get authentication token",
    ),
    "onlineSupportSupportedFormats": MessageLookupByLibrary.simpleMessage(
      "Supports JPG, PNG, GIF, WebP, BMP\nMax 10MB",
    ),
    "onlineSupportTitle": MessageLookupByLibrary.simpleMessage(
      "Online Support",
    ),
    "onlineSupportTokenNotFound": MessageLookupByLibrary.simpleMessage(
      "Authentication token not found",
    ),
    "onlineSupportUnsupportedHttpMethod": m41,
    "onlineSupportUploadFailed": m42,
    "onlineSupportWebSocketConfigNotFound": MessageLookupByLibrary.simpleMessage(
      "Online support WebSocket configuration not found, please check configuration",
    ),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("Icon"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage(
      "Only third-party apps",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Only count proxy traffic",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "When turned on, only statistics proxy traffic",
    ),
    "openWebFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to open web, please visit manually",
    ),
    "optional": MessageLookupByLibrary.simpleMessage("Optional"),
    "options": MessageLookupByLibrary.simpleMessage("Options"),
    "orderAmount": m43,
    "orderNumber": m44,
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Other contributors",
    ),
    "outboundIp": MessageLookupByLibrary.simpleMessage("Outbound IP"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("Outbound mode"),
    "override": MessageLookupByLibrary.simpleMessage("Override"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage(
      "Override Proxy related config",
    ),
    "overrideDns": MessageLookupByLibrary.simpleMessage("Override DNS"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "Turning it on will override the DNS options in the profile",
    ),
    "overrideEntries": MessageLookupByLibrary.simpleMessage("Override entries"),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage(
      "Does not take effect in script mode",
    ),
    "overrideMode": MessageLookupByLibrary.simpleMessage("Override mode"),
    "overrideNtp": MessageLookupByLibrary.simpleMessage("Override NTP"),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage(
      "Override the original rule",
    ),
    "overrideScript": MessageLookupByLibrary.simpleMessage("Override script"),
    "overwriteIssueCoreRejected": m45,
    "overwriteIssueDuplicateName": m46,
    "overwriteIssueEmptyName": MessageLookupByLibrary.simpleMessage(
      "The name is empty",
    ),
    "overwriteIssueGroupLoop": m47,
    "overwriteIssueMissingProviders": m48,
    "overwriteIssueMissingProxies": m49,
    "overwriteIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "No proxies or proxy providers are selected, so the core rejects this group",
    ),
    "overwriteIssueReservedName": m50,
    "overwriteIssueSubscriptionGroupMissingProxies": m51,
    "overwriteIssuesSummary": m52,
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage("Custom"),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "Custom mode: fully customize proxies, proxy groups and rules",
    ),
    "pageNumber": m53,
    "palette": MessageLookupByLibrary.simpleMessage("Palette"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordMin8Chars": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 8 characters",
    ),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "passwordMismatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "passwordResetFailed": MessageLookupByLibrary.simpleMessage(
      "Password reset failed",
    ),
    "passwordResetSuccessful": MessageLookupByLibrary.simpleMessage(
      "Password reset successful! Please login with your new password",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "paste": MessageLookupByLibrary.simpleMessage("Paste"),
    "pendingCommission": MessageLookupByLibrary.simpleMessage("Pending"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage("Choose from album"),
    "pinWindow": MessageLookupByLibrary.simpleMessage("Pin window"),
    "plans": MessageLookupByLibrary.simpleMessage("Plans"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Please bind WebDAV",
    ),
    "pleaseConfirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Please re-enter new password",
    ),
    "pleaseConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Please confirm password",
    ),
    "pleaseEnterAtLeast8CharsPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter at least 8 characters password",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter email address",
    ),
    "pleaseEnterEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Please enter email address",
    ),
    "pleaseEnterEmailVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Please enter email verification code",
    ),
    "pleaseEnterInviteCode": MessageLookupByLibrary.simpleMessage(
      "Please enter invite code",
    ),
    "pleaseEnterNewPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter new password",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter password",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Please enter a script name",
    ),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "pleaseEnterValidEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "pleaseEnterValidVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid verification code",
    ),
    "pleaseEnterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Please enter email verification code",
    ),
    "pleaseEnterYourEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Please enter your email address",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter the admin password",
    ),
    "pleaseReEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Please re-enter password",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage(
      "Please upload file",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Please upload a valid QR code",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Port"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a different port",
    ),
    "portTip": m54,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage(
      "Prioritize the use of DOH\'s http/3",
    ),
    "prerequisites": MessageLookupByLibrary.simpleMessage("Prerequisites"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Press a key combination",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "previousMatch": MessageLookupByLibrary.simpleMessage("Previous match"),
    "process": MessageLookupByLibrary.simpleMessage("Process"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("Please enter a valid interval"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Please enter the auto-update interval",
        ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "The profile has been modified. Turn off auto update?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please enter the profile name",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage(
      "profile parse error",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid profile URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please enter the profile URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Profiles"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Sort profiles"),
    "project": MessageLookupByLibrary.simpleMessage("Project"),
    "providerInUse": m55,
    "providerRenameShadowed": m56,
    "providerSourceSubscription": MessageLookupByLibrary.simpleMessage(
      "Subscription",
    ),
    "providerUrlTip": MessageLookupByLibrary.simpleMessage(
      "Only remote providers are supported",
    ),
    "providers": MessageLookupByLibrary.simpleMessage("External resources"),
    "proxies": MessageLookupByLibrary.simpleMessage("Proxies"),
    "proxiesCount": m57,
    "proxiesEmpty": MessageLookupByLibrary.simpleMessage("Proxies are empty"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("Proxies setting"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("Proxy chain"),
    "proxyDefinition": MessageLookupByLibrary.simpleMessage(
      "Full configuration",
    ),
    "proxyDefinitionNotMap": MessageLookupByLibrary.simpleMessage(
      "The configuration must be a YAML mapping with a name and a type",
    ),
    "proxyDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Detected selected proxies are abnormal",
    ),
    "proxyFilter": MessageLookupByLibrary.simpleMessage("Proxy filter"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Proxy group"),
    "proxyGroupDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Detected current proxy group is abnormal",
    ),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage(
      "Proxy group is empty",
    ),
    "proxyGroupNameDuplicate": MessageLookupByLibrary.simpleMessage(
      "Duplicate proxy group name",
    ),
    "proxyGroupNameEmpty": MessageLookupByLibrary.simpleMessage(
      "Proxy group name cannot be empty",
    ),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("Proxy nameserver"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Domain for resolving proxy nodes",
    ),
    "proxyNode": MessageLookupByLibrary.simpleMessage("Proxy node"),
    "proxyPort": MessageLookupByLibrary.simpleMessage("ProxyPort"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage(
      "Set the Clash listening port",
    ),
    "proxyProviderDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Detected selected proxy providers are abnormal",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("Proxy providers"),
    "proxyProvidersEmpty": MessageLookupByLibrary.simpleMessage(
      "Proxy providers are empty",
    ),
    "proxyProvidersNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Proxy providers cannot be empty",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("Proxy type"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Prune cache"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("Pure black"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Pure black mode"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR code"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Scan a QR code to obtain a profile",
    ),
    "quickAdd": MessageLookupByLibrary.simpleMessage("Quick add"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("Quick edit"),
    "quickFill": MessageLookupByLibrary.simpleMessage("Quick fill"),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("Rainbow"),
    "recentRequests": MessageLookupByLibrary.simpleMessage("Recent requests"),
    "recordType": MessageLookupByLibrary.simpleMessage("Record type"),
    "recovery": MessageLookupByLibrary.simpleMessage("Recovery"),
    "recoveryAll": MessageLookupByLibrary.simpleMessage("Recovery all data"),
    "recoveryProfiles": MessageLookupByLibrary.simpleMessage(
      "Only recovery profiles",
    ),
    "recoveryStrategy": MessageLookupByLibrary.simpleMessage(
      "Recovery strategy",
    ),
    "recoveryStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Compatible",
    ),
    "recoveryStrategy_override": MessageLookupByLibrary.simpleMessage(
      "Override",
    ),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage("Recovery success"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir port"),
    "redo": MessageLookupByLibrary.simpleMessage("Redo"),
    "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "regExp": MessageLookupByLibrary.simpleMessage("RegExp"),
    "registerAccount": MessageLookupByLibrary.simpleMessage("Register Account"),
    "registerSuccessSaveCredentials": MessageLookupByLibrary.simpleMessage(
      "Registration successful - Saving credentials:",
    ),
    "registrationFailed": m58,
    "releaseMemory": MessageLookupByLibrary.simpleMessage("Release memory"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to release memory",
    ),
    "rememberPassword": MessageLookupByLibrary.simpleMessage(
      "Remember your password?",
    ),
    "remote": MessageLookupByLibrary.simpleMessage("Remote"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Backup local data to WebDAV",
    ),
    "remoteDestination": MessageLookupByLibrary.simpleMessage(
      "Remote destination",
    ),
    "remoteRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Recovery data from WebDAV",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "rename": MessageLookupByLibrary.simpleMessage("Rename"),
    "replace": MessageLookupByLibrary.simpleMessage("Replace"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("Replace all"),
    "request": MessageLookupByLibrary.simpleMessage("Request"),
    "requests": MessageLookupByLibrary.simpleMessage("Requests"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage(
      "Requests and updates",
    ),
    "requestsDesc": MessageLookupByLibrary.simpleMessage(
      "View recently request records",
    ),
    "resendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Resend Verification Code",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "This page has changes. Are you sure you want to reset?",
    ),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "resetTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to reset?",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("Resources"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage(
      "External resource related info",
    ),
    "respectRules": MessageLookupByLibrary.simpleMessage("Respect rules"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS connections follow rules; requires Proxy Server Nameserver",
    ),
    "responseCode": MessageLookupByLibrary.simpleMessage("Response code"),
    "restart": MessageLookupByLibrary.simpleMessage("Restart"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to restart the core?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Restore"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("Restore all data"),
    "restoreException": MessageLookupByLibrary.simpleMessage(
      "Recovery exception",
    ),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage(
      "Restore data via file",
    ),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "Restore data via WebDAV",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Restore profiles only",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("Restore strategy"),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage(
      "Compatible",
    ),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage("Override"),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Compatible",
    ),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage(
      "Override",
    ),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage(
      "Restore successful",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Route addresses"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage(
      "Config listen route address",
    ),
    "routeMode": MessageLookupByLibrary.simpleMessage("Route mode"),
    "routeModeBypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Bypass private addresses",
    ),
    "routeModeConfig": MessageLookupByLibrary.simpleMessage("Use config"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Bypass private route address",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("Use config"),
    "ru": MessageLookupByLibrary.simpleMessage("Russian"),
    "rule": MessageLookupByLibrary.simpleMessage("Rule"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage(
      "Logical rule AND",
    ),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Match the full domain",
    ),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "Match a domain keyword",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Match a domain regex",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Match a domain suffix",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Wildcard match; only * and ? are supported",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "Match the DSCP mark (tproxy UDP inbound only)",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "Match the destination port range",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Match the IP\'s country code",
    ),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Match domains in Geosite",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage(
      "Match the inbound name",
    ),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "Match the inbound port",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "Match the inbound type",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "Match the inbound username; separate multiple usernames with /",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Match the IP\'s ASN",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "Match an IP address range; IP-CIDR6 is just an alias",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Match an IP address range",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Match an IP suffix range",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "Match all requests, no conditions needed",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "Match TCP or UDP",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage(
      "Logical rule NOT",
    ),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage("Logical rule OR"),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process name; matches the package name on Android",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process name regex; matches the package name on Android",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process name wildcard; only * and ? are supported",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "Match by the full process path",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process path regex",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process path wildcard; only * and ? are supported",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "Match the rematch name; separate multiple names with /",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "Reference a rule set; requires rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Match the source IP\'s country code",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Match the source IP\'s ASN",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Match a source IP address range",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Match a source IP suffix range",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "Match the source port range",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "Match into a sub-rule; mind the parentheses",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "Match the Linux user ID",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("Rule is empty"),
    "ruleName": MessageLookupByLibrary.simpleMessage("Rule name"),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BitTorrent direct",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "Block DNS over TLS",
    ),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage("Block QUIC"),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage("Block STUN"),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage("LAN direct"),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple and Microsoft direct",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("Rule providers"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("Rule set"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Rule target"),
    "rules": MessageLookupByLibrary.simpleMessage("Rules"),
    "rulesCount": m59,
    "runTime": MessageLookupByLibrary.simpleMessage("Run time"),
    "safeMode": MessageLookupByLibrary.simpleMessage("Safe mode"),
    "safeModeAppTitle": m60,
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save the changes?"),
    "saveQr": MessageLookupByLibrary.simpleMessage("Save QR"),
    "saveQrCodeFeature": MessageLookupByLibrary.simpleMessage(
      "Save QR feature coming soon",
    ),
    "saveTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to save?",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Script"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Script mode: uses external extension scripts to override the configuration in one click",
    ),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage(
      "Scroll to selected",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "seconds": MessageLookupByLibrary.simpleMessage("seconds"),
    "secondsCount": m61,
    "selectAll": MessageLookupByLibrary.simpleMessage("Select all"),
    "selectProxies": MessageLookupByLibrary.simpleMessage("Select proxies"),
    "selectProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Select proxy providers",
    ),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage(
      "Please select a rule set",
    ),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "Please select a split strategy",
    ),
    "selectSubRule": MessageLookupByLibrary.simpleMessage(
      "Please select a sub-rule",
    ),
    "selectTheme": MessageLookupByLibrary.simpleMessage("Select Theme"),
    "selected": MessageLookupByLibrary.simpleMessage("Selected"),
    "selectedCountTitle": m62,
    "sendCodeFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to send verification code",
    ),
    "sendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Send Verification Code",
    ),
    "sendVerificationCodeFailed": m63,
    "server": MessageLookupByLibrary.simpleMessage("Server"),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("Available"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("Blocked"),
    "serviceCheck": MessageLookupByLibrary.simpleMessage("Check"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("Check all"),
    "serviceCheckedAt": m64,
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("Coming soon"),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage(
      "Disallowed ISP",
    ),
    "serviceFailed": MessageLookupByLibrary.simpleMessage("Check failed"),
    "serviceManage": MessageLookupByLibrary.simpleMessage("Manage services"),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage(
      "Originals only",
    ),
    "servicePending": MessageLookupByLibrary.simpleMessage("Not checked"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage(
      "Access restricted",
    ),
    "serviceStatus": MessageLookupByLibrary.simpleMessage("Service status"),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("Unavailable"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage(
      "Region not supported",
    ),
    "setNewPassword": MessageLookupByLibrary.simpleMessage("Set New Password"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "show": MessageLookupByLibrary.simpleMessage("Show"),
    "showLess": MessageLookupByLibrary.simpleMessage("Collapse"),
    "showMore": MessageLookupByLibrary.simpleMessage("Expand"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "Stop button in notification",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage("Show password"),
    "shrink": MessageLookupByLibrary.simpleMessage("Compact"),
    "sidebarBlur": MessageLookupByLibrary.simpleMessage("Sidebar blur"),
    "sidebarBlurDesc": MessageLookupByLibrary.simpleMessage(
      "Show the blurred desktop behind the window through the sidebar",
    ),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("Silent launch"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Start without showing the window",
    ),
    "singleAdd": MessageLookupByLibrary.simpleMessage("Single add"),
    "singleValueTip": m65,
    "size": MessageLookupByLibrary.simpleMessage("Size"),
    "slide": MessageLookupByLibrary.simpleMessage("Slide"),
    "socksPort": MessageLookupByLibrary.simpleMessage("SOCKS port"),
    "sort": MessageLookupByLibrary.simpleMessage("Sort"),
    "source": MessageLookupByLibrary.simpleMessage("Source"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("Source IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Special proxy"),
    "specialRules": MessageLookupByLibrary.simpleMessage("Special rules"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("Speed statistics"),
    "splitStrategy": MessageLookupByLibrary.simpleMessage("Split strategy"),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Split strategy cannot be empty",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("SSIDs are empty"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Stack mode"),
    "standard": MessageLookupByLibrary.simpleMessage("Standard"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Standard mode: overrides the basic configuration and offers simple rule additions",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage(
      "Start from scratch",
    ),
    "startVpn": MessageLookupByLibrary.simpleMessage("Starting VPN…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage(
      "Startup and background",
    ),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "When disabled, the system DNS is used",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Stop"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Stopping VPN…"),
    "strategy": MessageLookupByLibrary.simpleMessage("Strategy"),
    "style": MessageLookupByLibrary.simpleMessage("Style"),
    "subRule": MessageLookupByLibrary.simpleMessage("Sub-rule"),
    "subRuleEmpty": MessageLookupByLibrary.simpleMessage("Sub-rule is empty"),
    "subRuleNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Sub-rule cannot be empty",
    ),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "subscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "Subscription expired",
    ),
    "subscriptionExpiredDetail": m66,
    "subscriptionExpiresToday": MessageLookupByLibrary.simpleMessage(
      "Subscription expires today",
    ),
    "subscriptionExpiresTodayDetail": MessageLookupByLibrary.simpleMessage(
      "Plan will expire today, please renew immediately to avoid service interruption",
    ),
    "subscriptionExpiringInDays": MessageLookupByLibrary.simpleMessage(
      "Subscription expiring soon",
    ),
    "subscriptionExpiringInDaysDetail": m67,
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Subscription info",
    ),
    "subscriptionNoSubscription": MessageLookupByLibrary.simpleMessage(
      "No subscription",
    ),
    "subscriptionNoSubscriptionDetail": MessageLookupByLibrary.simpleMessage(
      "No available subscription plan found, please purchase a plan to use",
    ),
    "subscriptionNotLoggedIn": MessageLookupByLibrary.simpleMessage(
      "Not logged in",
    ),
    "subscriptionNotLoggedInDetail": MessageLookupByLibrary.simpleMessage(
      "Please login first",
    ),
    "subscriptionTrafficExhausted": MessageLookupByLibrary.simpleMessage(
      "Traffic exhausted",
    ),
    "subscriptionTrafficExhaustedDetail": MessageLookupByLibrary.simpleMessage(
      "Plan traffic has been used up, please purchase more traffic or upgrade plan",
    ),
    "subscriptionValid": MessageLookupByLibrary.simpleMessage(
      "Subscription valid",
    ),
    "subscriptionValidDetail": m68,
    "suspended": MessageLookupByLibrary.simpleMessage("Suspended…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("Switch profile"),
    "switchTheme": MessageLookupByLibrary.simpleMessage("Switch Theme"),
    "sync": MessageLookupByLibrary.simpleMessage("Sync"),
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "systemApp": MessageLookupByLibrary.simpleMessage("System apps"),
    "systemFont": MessageLookupByLibrary.simpleMessage("System font"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Attach HTTP proxy to VpnService",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Tab"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Tab animation"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage(
      "Effective only in mobile view",
    ),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage("Tap to authorize"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP concurrent"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage(
      "Enabling it will allow TCP concurrency",
    ),
    "testInterval": MessageLookupByLibrary.simpleMessage("Test interval"),
    "testUrl": MessageLookupByLibrary.simpleMessage("Test URL"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage("Test when used"),
    "textScale": MessageLookupByLibrary.simpleMessage("Text scaling"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage(
      "Text in the app will look like this",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Theme color"),
    "themeDesc": MessageLookupByLibrary.simpleMessage(
      "Set dark mode and adjust colors",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme mode"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("Three columns"),
    "tight": MessageLookupByLibrary.simpleMessage("Tight"),
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "timeout": MessageLookupByLibrary.simpleMessage("Timeout"),
    "tip": MessageLookupByLibrary.simpleMessage("Tip"),
    "toggle": MessageLookupByLibrary.simpleMessage("Toggle"),
    "tolerance": MessageLookupByLibrary.simpleMessage("Tolerance"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("Tonal spot"),
    "tools": MessageLookupByLibrary.simpleMessage("Tools"),
    "torch": MessageLookupByLibrary.simpleMessage("Flashlight"),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalCommission": MessageLookupByLibrary.simpleMessage("Earnings"),
    "totalInvites": MessageLookupByLibrary.simpleMessage("Invites"),
    "totalRecords": m69,
    "totalTraffic": MessageLookupByLibrary.simpleMessage("Total traffic"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("TProxy port"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("Traffic usage"),
    "transfer": MessageLookupByLibrary.simpleMessage("Transfer"),
    "transferAmount": MessageLookupByLibrary.simpleMessage("Transfer Amount"),
    "transferAmountExceeded": m70,
    "transferFailed": m71,
    "transferNote": MessageLookupByLibrary.simpleMessage(
      "Transferred balance can be used for in-app purchases",
    ),
    "transferSuccess": MessageLookupByLibrary.simpleMessage(
      "Transfer Success!",
    ),
    "transferSuccessMsg": m72,
    "transferToWallet": MessageLookupByLibrary.simpleMessage(
      "Transfer to Wallet",
    ),
    "transferring": MessageLookupByLibrary.simpleMessage("Transferring..."),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "Only effective in administrator mode",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Turn off"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Turn on"),
    "twoColumns": MessageLookupByLibrary.simpleMessage("Two columns"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "unable to update current profile",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("Undo"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Unified delay"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "Remove extra delays such as handshaking",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Unknown network error",
    ),
    "unmaximize": MessageLookupByLibrary.simpleMessage("Restore down"),
    "unnamed": MessageLookupByLibrary.simpleMessage("Unnamed"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage("Unpin window"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updateCheckAllServersUnavailable": MessageLookupByLibrary.simpleMessage(
      "All configured update servers are unavailable",
    ),
    "updateCheckCurrentVersion": m73,
    "updateCheckForceUpdate": m74,
    "updateCheckMustUpdate": MessageLookupByLibrary.simpleMessage(
      "Must Update",
    ),
    "updateCheckNewVersionFound": m75,
    "updateCheckNoServerUrlsConfigured": MessageLookupByLibrary.simpleMessage(
      "No update server URLs configured, please check configuration",
    ),
    "updateCheckReleaseNotes": MessageLookupByLibrary.simpleMessage(
      "Release Notes:",
    ),
    "updateCheckServerError": m76,
    "updateCheckServerTemporarilyUnavailable":
        MessageLookupByLibrary.simpleMessage(
          "Server temporarily unavailable, please try again later",
        ),
    "updateCheckServerUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "Update server URL not configured, please check configuration",
    ),
    "updateCheckUpdateLater": MessageLookupByLibrary.simpleMessage(
      "Update Later",
    ),
    "updateCheckUpdateNow": MessageLookupByLibrary.simpleMessage("Update Now"),
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage(
      "Obtain a profile from a URL",
    ),
    "urlTip": m77,
    "useHosts": MessageLookupByLibrary.simpleMessage("Use hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("Use system hosts"),
    "usedTraffic": MessageLookupByLibrary.simpleMessage("Used traffic"),
    "userAgent": MessageLookupByLibrary.simpleMessage("User-Agent"),
    "userCenter": MessageLookupByLibrary.simpleMessage("User Center"),
    "value": MessageLookupByLibrary.simpleMessage("Value"),
    "verificationCode": MessageLookupByLibrary.simpleMessage(
      "Verification Code",
    ),
    "verificationCode6Digits": MessageLookupByLibrary.simpleMessage(
      "Verification code should be 6 digits",
    ),
    "verificationCodeSent": MessageLookupByLibrary.simpleMessage(
      "Verification code has been sent to your email, please check",
    ),
    "verificationCodeSentCheckEmail": MessageLookupByLibrary.simpleMessage(
      "Verification code sent, please check your email",
    ),
    "verificationCodeSentTo": m78,
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("Vibrant"),
    "view": MessageLookupByLibrary.simpleMessage("View"),
    "viewHistory": MessageLookupByLibrary.simpleMessage("View History"),
    "visitWebVersion": MessageLookupByLibrary.simpleMessage(
      "Please visit web version to withdraw",
    ),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "VPN-related configuration change detected",
    ),
    "vpnDesc": MessageLookupByLibrary.simpleMessage(
      "Modify VPN related settings",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "Route all system traffic through VpnService automatically",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Attach HTTP proxy to VpnService",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage(
      "Changes take effect after restarting the VPN",
    ),
    "walletBalance": MessageLookupByLibrary.simpleMessage("Balance"),
    "walletDetails": MessageLookupByLibrary.simpleMessage("Wallet Details"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "WebDAV configuration",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("Whitelist mode"),
    "withdraw": MessageLookupByLibrary.simpleMessage("Withdraw"),
    "withdrawCommission": MessageLookupByLibrary.simpleMessage(
      "Withdraw Commission",
    ),
    "withdrawableAmount": m79,
    "withdrawalAvailable": MessageLookupByLibrary.simpleMessage(
      "Available commission can be withdrawn",
    ),
    "writeToSystem": MessageLookupByLibrary.simpleMessage("Write to system"),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "Also set the system clock; Android ignores it",
    ),
    "xboard": MessageLookupByLibrary.simpleMessage("My"),
    "xboard24HourCustomerService": MessageLookupByLibrary.simpleMessage(
      "24-hour customer service support",
    ),
    "xboardAccountBalance": MessageLookupByLibrary.simpleMessage(
      "Account balance",
    ),
    "xboardAddLinkToConfig": MessageLookupByLibrary.simpleMessage(
      "Add this subscription link to your configuration",
    ),
    "xboardAddingToConfigList": MessageLookupByLibrary.simpleMessage(
      "Adding to configuration list",
    ),
    "xboardAfterPurchasingPlan": MessageLookupByLibrary.simpleMessage(
      "After purchasing a plan, you will enjoy:",
    ),
    "xboardApiUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "API URL not configured",
    ),
    "xboardAutoCheckEvery5Seconds": MessageLookupByLibrary.simpleMessage(
      "System checks every 5 seconds, will redirect automatically after payment",
    ),
    "xboardAutoDetectPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "Auto-detect payment status",
    ),
    "xboardAutoOpeningPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Auto-opening payment page, please return to app after payment",
    ),
    "xboardAutoTesting": MessageLookupByLibrary.simpleMessage("Auto testing"),
    "xboardBack": MessageLookupByLibrary.simpleMessage("Back"),
    "xboardBrowserNotOpenedTip": MessageLookupByLibrary.simpleMessage(
      "If browser doesn\'t open automatically, click \\\"Reopen\\\" or copy link manually",
    ),
    "xboardBuyMoreTrafficOrUpgrade": MessageLookupByLibrary.simpleMessage(
      "Please buy more traffic or upgrade plan",
    ),
    "xboardBuyNow": MessageLookupByLibrary.simpleMessage("Buy Now"),
    "xboardBuyoutPlan": MessageLookupByLibrary.simpleMessage("Buyout plan"),
    "xboardCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "xboardCancelPayment": MessageLookupByLibrary.simpleMessage(
      "Cancel payment",
    ),
    "xboardCheckPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to check payment status",
    ),
    "xboardCheckStatus": MessageLookupByLibrary.simpleMessage("Check status"),
    "xboardChecking": MessageLookupByLibrary.simpleMessage("Checking"),
    "xboardCleaningOldConfig": MessageLookupByLibrary.simpleMessage(
      "Cleaning old configuration",
    ),
    "xboardClearError": MessageLookupByLibrary.simpleMessage("Clear error"),
    "xboardClickToCopy": MessageLookupByLibrary.simpleMessage("Click to copy"),
    "xboardClickToSetupNodes": MessageLookupByLibrary.simpleMessage(
      "Click to setup nodes",
    ),
    "xboardCompletePaymentInBrowser": MessageLookupByLibrary.simpleMessage(
      "2. Please complete payment in your browser",
    ),
    "xboardConfigDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "Configuration download failed, please check subscription link",
    ),
    "xboardConfigFormatError": MessageLookupByLibrary.simpleMessage(
      "Configuration format error, please contact service provider",
    ),
    "xboardConfigSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Configuration save failed, please check storage space",
    ),
    "xboardConfigurationError": MessageLookupByLibrary.simpleMessage(
      "Configuration error",
    ),
    "xboardConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "xboardConfirmAction": MessageLookupByLibrary.simpleMessage("Confirm"),
    "xboardConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Confirm Password",
    ),
    "xboardConfirmPurchase": MessageLookupByLibrary.simpleMessage(
      "Confirm purchase",
    ),
    "xboardCongratulationsSubscriptionActivated":
        MessageLookupByLibrary.simpleMessage(
          "Congratulations! Your subscription has been successfully purchased and activated",
        ),
    "xboardConnectGlobalQualityNodes": MessageLookupByLibrary.simpleMessage(
      "Connect to global quality nodes",
    ),
    "xboardConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Connection timeout, please check network connection",
    ),
    "xboardCopyFailed": MessageLookupByLibrary.simpleMessage("Copy failed"),
    "xboardCopyLink": MessageLookupByLibrary.simpleMessage("Copy Link"),
    "xboardCopyPaymentLink": MessageLookupByLibrary.simpleMessage("Copy Link"),
    "xboardCopySubscriptionLinkAbove": MessageLookupByLibrary.simpleMessage(
      "Copy the subscription link above",
    ),
    "xboardCouponExpired": MessageLookupByLibrary.simpleMessage(
      "Coupon expired",
    ),
    "xboardCouponNotYetActive": MessageLookupByLibrary.simpleMessage(
      "Coupon not yet active",
    ),
    "xboardCouponOptional": MessageLookupByLibrary.simpleMessage(
      "Coupon (optional)",
    ),
    "xboardCreatingOrder": MessageLookupByLibrary.simpleMessage(
      "Creating order",
    ),
    "xboardCreatingOrderPleaseWait": MessageLookupByLibrary.simpleMessage(
      "We are creating a new order for you, please wait",
    ),
    "xboardCurrentNode": MessageLookupByLibrary.simpleMessage("Current Node"),
    "xboardCurrentVersion": MessageLookupByLibrary.simpleMessage(
      "Current version",
    ),
    "xboardDays": MessageLookupByLibrary.simpleMessage("days"),
    "xboardDeductibleDuringPayment": MessageLookupByLibrary.simpleMessage(
      "Deductible during payment",
    ),
    "xboardDiscounted": MessageLookupByLibrary.simpleMessage("Discounted"),
    "xboardDownloadingConfig": MessageLookupByLibrary.simpleMessage(
      "Downloading configuration file",
    ),
    "xboardEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "xboardEnableTun": MessageLookupByLibrary.simpleMessage("Enable TUN"),
    "xboardEnjoyFastNetworkExperience": MessageLookupByLibrary.simpleMessage(
      "Enjoy fast network experience",
    ),
    "xboardEnterCouponCode": MessageLookupByLibrary.simpleMessage(
      "Enter coupon code",
    ),
    "xboardExcellent": MessageLookupByLibrary.simpleMessage("Excellent"),
    "xboardExpiryTime": MessageLookupByLibrary.simpleMessage("Expiry time"),
    "xboardFailedToCheckPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "Failed to check payment status",
    ),
    "xboardFailedToGetSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Failed to get subscription information",
    ),
    "xboardFailedToOpenPaymentLink": MessageLookupByLibrary.simpleMessage(
      "Failed to open payment link",
    ),
    "xboardFailedToOpenPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Failed to open payment page",
    ),
    "xboardFair": MessageLookupByLibrary.simpleMessage("Fair"),
    "xboardForceUpdate": MessageLookupByLibrary.simpleMessage("Force update"),
    "xboardForgotPassword": MessageLookupByLibrary.simpleMessage(
      "Forgot Password",
    ),
    "xboardGettingIP": MessageLookupByLibrary.simpleMessage("Getting..."),
    "xboardGlobalNodes": MessageLookupByLibrary.simpleMessage("Global nodes"),
    "xboardGood": MessageLookupByLibrary.simpleMessage("Good"),
    "xboardGroup": MessageLookupByLibrary.simpleMessage("Group"),
    "xboardHalfYearlyPayment": MessageLookupByLibrary.simpleMessage(
      "Half-yearly",
    ),
    "xboardHandleLater": MessageLookupByLibrary.simpleMessage("Handle later"),
    "xboardHandlingFee": MessageLookupByLibrary.simpleMessage("Handling fee"),
    "xboardHighSpeedNetwork": MessageLookupByLibrary.simpleMessage(
      "High-speed network",
    ),
    "xboardHome": MessageLookupByLibrary.simpleMessage("Home"),
    "xboardImportFailed": MessageLookupByLibrary.simpleMessage("Import failed"),
    "xboardImportSuccess": MessageLookupByLibrary.simpleMessage(
      "Import successful",
    ),
    "xboardInsufficientBalance": MessageLookupByLibrary.simpleMessage(
      "Insufficient balance",
    ),
    "xboardInvalidCredentials": MessageLookupByLibrary.simpleMessage(
      "Invalid username or password",
    ),
    "xboardInvalidOrExpiredCoupon": MessageLookupByLibrary.simpleMessage(
      "Invalid or expired coupon code",
    ),
    "xboardInvalidResponseFormat": MessageLookupByLibrary.simpleMessage(
      "Invalid response format from server",
    ),
    "xboardInviteCode": MessageLookupByLibrary.simpleMessage("Invite Code"),
    "xboardKeepSubscriptionLinkSafe": MessageLookupByLibrary.simpleMessage(
      "Please keep your subscription link safe and don\'t share with others",
    ),
    "xboardLater": MessageLookupByLibrary.simpleMessage("Later"),
    "xboardLoadingFailed": MessageLookupByLibrary.simpleMessage(
      "Loading failed",
    ),
    "xboardLoadingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Loading payment page",
    ),
    "xboardLocalIP": MessageLookupByLibrary.simpleMessage("Local IP"),
    "xboardLoggedIn": MessageLookupByLibrary.simpleMessage("Logged In"),
    "xboardLogin": MessageLookupByLibrary.simpleMessage("Login"),
    "xboardLoginExpired": MessageLookupByLibrary.simpleMessage(
      "Login expired, please login again",
    ),
    "xboardLoginFailed": MessageLookupByLibrary.simpleMessage("Login failed"),
    "xboardLoginSuccess": MessageLookupByLibrary.simpleMessage(
      "Login successful",
    ),
    "xboardLoginToViewSubscription": MessageLookupByLibrary.simpleMessage(
      "Please login to view subscription usage",
    ),
    "xboardLogout": MessageLookupByLibrary.simpleMessage("Logout"),
    "xboardLogoutConfirmContent": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout? You will need to re-enter your credentials.",
    ),
    "xboardLogoutConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Confirm Logout",
    ),
    "xboardLogoutFailed": MessageLookupByLibrary.simpleMessage("Logout failed"),
    "xboardLogoutSuccess": MessageLookupByLibrary.simpleMessage(
      "Successfully logged out",
    ),
    "xboardMissingRequiredField": MessageLookupByLibrary.simpleMessage(
      "Missing required field",
    ),
    "xboardMonthlyPayment": MessageLookupByLibrary.simpleMessage("Monthly"),
    "xboardMonthlyRenewal": MessageLookupByLibrary.simpleMessage(
      "Monthly renewal",
    ),
    "xboardMustUpdate": MessageLookupByLibrary.simpleMessage("Must update"),
    "xboardNetworkConnectionFailed": MessageLookupByLibrary.simpleMessage(
      "Network connection failed, please check network settings",
    ),
    "xboardNewVersionFound": MessageLookupByLibrary.simpleMessage(
      "New version found",
    ),
    "xboardNext": MessageLookupByLibrary.simpleMessage("Next"),
    "xboardNoAvailableNodes": MessageLookupByLibrary.simpleMessage(
      "No available nodes",
    ),
    "xboardNoAvailablePlan": MessageLookupByLibrary.simpleMessage(
      "No available plan",
    ),
    "xboardNoAvailableSubscription": MessageLookupByLibrary.simpleMessage(
      "No available subscription",
    ),
    "xboardNoInternetConnection": MessageLookupByLibrary.simpleMessage(
      "No internet connection, please check network settings",
    ),
    "xboardNoSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "No subscription information",
    ),
    "xboardNoSubscriptionPlans": MessageLookupByLibrary.simpleMessage(
      "No subscription plans",
    ),
    "xboardNodeName": MessageLookupByLibrary.simpleMessage("Node Name"),
    "xboardNone": MessageLookupByLibrary.simpleMessage("None"),
    "xboardNotLoggedIn": MessageLookupByLibrary.simpleMessage("Not Logged In"),
    "xboardOneTimePayment": MessageLookupByLibrary.simpleMessage("One-time"),
    "xboardOpenPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to open payment page",
    ),
    "xboardOpenPaymentLinkFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to open payment link",
    ),
    "xboardOperationFailed": MessageLookupByLibrary.simpleMessage(
      "Operation failed",
    ),
    "xboardOperationTips": MessageLookupByLibrary.simpleMessage(
      "Operation tips",
    ),
    "xboardOrderCreationFailed": MessageLookupByLibrary.simpleMessage(
      "Order creation failed",
    ),
    "xboardOrderNotFound": MessageLookupByLibrary.simpleMessage(
      "Order not found",
    ),
    "xboardOrderNumber": MessageLookupByLibrary.simpleMessage("Order number"),
    "xboardOrderStatusPending": MessageLookupByLibrary.simpleMessage(
      "Order status: Pending payment",
    ),
    "xboardPassword": MessageLookupByLibrary.simpleMessage("Password"),
    "xboardPaymentCancelled": MessageLookupByLibrary.simpleMessage(
      "Payment cancelled",
    ),
    "xboardPaymentComplete": MessageLookupByLibrary.simpleMessage(
      "Payment Complete",
    ),
    "xboardPaymentCompleted": MessageLookupByLibrary.simpleMessage(
      "Payment completed!",
    ),
    "xboardPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Payment failed",
    ),
    "xboardPaymentGateway": MessageLookupByLibrary.simpleMessage(
      "Payment gateway",
    ),
    "xboardPaymentInfo": MessageLookupByLibrary.simpleMessage(
      "Payment information",
    ),
    "xboardPaymentInstructions1": MessageLookupByLibrary.simpleMessage(
      "1. Payment page has been opened automatically",
    ),
    "xboardPaymentInstructions2": MessageLookupByLibrary.simpleMessage(
      "2. Please complete payment in your browser",
    ),
    "xboardPaymentInstructions3": MessageLookupByLibrary.simpleMessage(
      "3. Return to app after payment, system will detect automatically",
    ),
    "xboardPaymentLink": MessageLookupByLibrary.simpleMessage("Payment link"),
    "xboardPaymentLinkCopied": MessageLookupByLibrary.simpleMessage(
      "Payment link copied to clipboard",
    ),
    "xboardPaymentMethodVerified": MessageLookupByLibrary.simpleMessage(
      "Payment method verified",
    ),
    "xboardPaymentMethodVerifiedPreparing":
        MessageLookupByLibrary.simpleMessage(
          "Payment method verified, preparing to redirect to payment page",
        ),
    "xboardPaymentPageAutoOpened": MessageLookupByLibrary.simpleMessage(
      "1. Payment page has been opened automatically",
    ),
    "xboardPaymentPageOpenedCompleteAndReturn":
        MessageLookupByLibrary.simpleMessage(
          "Payment page opened, please complete payment and return to app",
        ),
    "xboardPaymentPageOpenedInBrowser": MessageLookupByLibrary.simpleMessage(
      "Payment page opened in browser, please return to app after payment",
    ),
    "xboardPaymentSuccess": MessageLookupByLibrary.simpleMessage(
      "Payment successful",
    ),
    "xboardPaymentSuccessful": MessageLookupByLibrary.simpleMessage(
      "🎉 Payment successful!",
    ),
    "xboardPlanInfo": MessageLookupByLibrary.simpleMessage("Plans"),
    "xboardPlanNotFound": MessageLookupByLibrary.simpleMessage(
      "Plan not found",
    ),
    "xboardPlans": MessageLookupByLibrary.simpleMessage("Plans"),
    "xboardPleaseSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage(
      "Please select payment period",
    ),
    "xboardPoor": MessageLookupByLibrary.simpleMessage("Poor"),
    "xboardPreparingImport": MessageLookupByLibrary.simpleMessage(
      "Preparing import",
    ),
    "xboardPreparingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Preparing payment page, redirecting soon",
    ),
    "xboardPrevious": MessageLookupByLibrary.simpleMessage("Previous"),
    "xboardProcessing": MessageLookupByLibrary.simpleMessage("Processing..."),
    "xboardProfessionalSupport": MessageLookupByLibrary.simpleMessage(
      "Professional support",
    ),
    "xboardProfile": MessageLookupByLibrary.simpleMessage("Profile"),
    "xboardProtectNetworkPrivacy": MessageLookupByLibrary.simpleMessage(
      "Protect your network privacy",
    ),
    "xboardProxy": MessageLookupByLibrary.simpleMessage("Proxy"),
    "xboardProxyMode": MessageLookupByLibrary.simpleMessage("Proxy Mode"),
    "xboardProxyModeDirectDescription": MessageLookupByLibrary.simpleMessage(
      "All traffic connects directly without proxy",
    ),
    "xboardProxyModeGlobalDescription": MessageLookupByLibrary.simpleMessage(
      "All traffic goes through proxy server",
    ),
    "xboardProxyModeRuleDescription": MessageLookupByLibrary.simpleMessage(
      "Automatically select direct or proxy based on rules",
    ),
    "xboardPurchasePlan": MessageLookupByLibrary.simpleMessage("Purchase plan"),
    "xboardPurchaseSubscription": MessageLookupByLibrary.simpleMessage(
      "Purchase subscription",
    ),
    "xboardPurchaseSubscriptionToUse": MessageLookupByLibrary.simpleMessage(
      "Please purchase a subscription to use",
    ),
    "xboardPurchaseTraffic": MessageLookupByLibrary.simpleMessage(
      "Purchase traffic",
    ),
    "xboardQuarterlyPayment": MessageLookupByLibrary.simpleMessage("Quarterly"),
    "xboardRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "xboardRefreshStatus": MessageLookupByLibrary.simpleMessage(
      "Refresh status",
    ),
    "xboardRegister": MessageLookupByLibrary.simpleMessage("Register"),
    "xboardRegisterFailed": MessageLookupByLibrary.simpleMessage(
      "Registration failed",
    ),
    "xboardRegisterSuccess": MessageLookupByLibrary.simpleMessage(
      "Registration successful! Redirecting to login page...",
    ),
    "xboardReload": MessageLookupByLibrary.simpleMessage("Reload"),
    "xboardRelogin": MessageLookupByLibrary.simpleMessage("Login Again"),
    "xboardRememberPassword": MessageLookupByLibrary.simpleMessage(
      "Remember Password",
    ),
    "xboardRenewPlan": MessageLookupByLibrary.simpleMessage("Renew plan"),
    "xboardRenewToContinue": MessageLookupByLibrary.simpleMessage(
      "Please renew to continue using",
    ),
    "xboardReopen": MessageLookupByLibrary.simpleMessage("Reopen"),
    "xboardReopenPayment": MessageLookupByLibrary.simpleMessage(
      "Reopen Payment",
    ),
    "xboardReopenPaymentPageTip": MessageLookupByLibrary.simpleMessage(
      "To reopen, click the \\\"Reopen\\\" button below",
    ),
    "xboardRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "xboardRetryGet": MessageLookupByLibrary.simpleMessage("Retry"),
    "xboardReturn": MessageLookupByLibrary.simpleMessage("Return"),
    "xboardReturnAfterPaymentAutoDetect": MessageLookupByLibrary.simpleMessage(
      "3. Return to app after payment, system will detect automatically",
    ),
    "xboardRunningTime": m80,
    "xboardSecureEncryption": MessageLookupByLibrary.simpleMessage(
      "Secure encryption",
    ),
    "xboardSelectPaymentMethod": MessageLookupByLibrary.simpleMessage(
      "Select payment method",
    ),
    "xboardSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage(
      "Select payment period",
    ),
    "xboardSelectPeriod": MessageLookupByLibrary.simpleMessage(
      "Please select purchase period",
    ),
    "xboardSendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Send Verification Code",
    ),
    "xboardServerError": MessageLookupByLibrary.simpleMessage("Server error"),
    "xboardSetup": MessageLookupByLibrary.simpleMessage("Setup"),
    "xboardSixMonthCycle": MessageLookupByLibrary.simpleMessage(
      "6-month cycle",
    ),
    "xboardSpeedLimit": MessageLookupByLibrary.simpleMessage("Speed"),
    "xboardStartProxy": MessageLookupByLibrary.simpleMessage("Start Proxy"),
    "xboardStartProxyToSelectNode": MessageLookupByLibrary.simpleMessage(
      "Start the proxy to select nodes",
    ),
    "xboardStop": MessageLookupByLibrary.simpleMessage("Stop"),
    "xboardStopProxy": MessageLookupByLibrary.simpleMessage("Stop Proxy"),
    "xboardSubscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "xboardSubscriptionCopied": MessageLookupByLibrary.simpleMessage(
      "Subscription link copied to clipboard",
    ),
    "xboardSubscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "Subscription expired",
    ),
    "xboardSubscriptionHasExpired": MessageLookupByLibrary.simpleMessage(
      "Subscription has expired",
    ),
    "xboardSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Subscription information",
    ),
    "xboardSubscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Subscription link",
    ),
    "xboardSubscriptionLinkCopied": MessageLookupByLibrary.simpleMessage(
      "Subscription link copied to clipboard",
    ),
    "xboardSubscriptionPurchase": MessageLookupByLibrary.simpleMessage(
      "Subscription purchase",
    ),
    "xboardSubscriptionStatus": MessageLookupByLibrary.simpleMessage(
      "Subscription status",
    ),
    "xboardSwitch": MessageLookupByLibrary.simpleMessage("Switch"),
    "xboardTesting": MessageLookupByLibrary.simpleMessage("Testing"),
    "xboardThirtySixMonthCycle": MessageLookupByLibrary.simpleMessage(
      "36-month cycle",
    ),
    "xboardThreeMonthCycle": MessageLookupByLibrary.simpleMessage(
      "3-month cycle",
    ),
    "xboardThreeYearPayment": MessageLookupByLibrary.simpleMessage(
      "Three-year",
    ),
    "xboardTimeout": MessageLookupByLibrary.simpleMessage("Timeout"),
    "xboardTokenExpiredContent": MessageLookupByLibrary.simpleMessage(
      "Your login session has expired. Please login again to continue.",
    ),
    "xboardTokenExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "Login Expired",
    ),
    "xboardTraffic": MessageLookupByLibrary.simpleMessage("Traffic"),
    "xboardTrafficExhausted": MessageLookupByLibrary.simpleMessage(
      "Traffic exhausted",
    ),
    "xboardTrafficUsedUp": MessageLookupByLibrary.simpleMessage(
      "Traffic used up",
    ),
    "xboardTunEnabled": MessageLookupByLibrary.simpleMessage("TUN enabled"),
    "xboardTwelveMonthCycle": MessageLookupByLibrary.simpleMessage(
      "12-month cycle",
    ),
    "xboardTwentyFourMonthCycle": MessageLookupByLibrary.simpleMessage(
      "24-month cycle",
    ),
    "xboardTwoYearPayment": MessageLookupByLibrary.simpleMessage("Two-year"),
    "xboardUnauthorizedAccess": MessageLookupByLibrary.simpleMessage(
      "Unauthorized access, please login first",
    ),
    "xboardUnknownErrorRetry": MessageLookupByLibrary.simpleMessage(
      "Unknown error, please retry",
    ),
    "xboardUnknownUser": MessageLookupByLibrary.simpleMessage("Unknown User"),
    "xboardUnlimited": MessageLookupByLibrary.simpleMessage("Unlimited"),
    "xboardUnselected": MessageLookupByLibrary.simpleMessage("Unselected"),
    "xboardUnsupportedCouponType": MessageLookupByLibrary.simpleMessage(
      "Unsupported coupon type",
    ),
    "xboardUpdateContent": MessageLookupByLibrary.simpleMessage(
      "Update content:",
    ),
    "xboardUpdateLater": MessageLookupByLibrary.simpleMessage("Update Later"),
    "xboardUpdateNow": MessageLookupByLibrary.simpleMessage("Update Now"),
    "xboardUpdateSubscription": MessageLookupByLibrary.simpleMessage(
      "Update subscription",
    ),
    "xboardUpdateSubscriptionRegularly": MessageLookupByLibrary.simpleMessage(
      "Update subscription regularly to get latest nodes",
    ),
    "xboardUsageInstructions": MessageLookupByLibrary.simpleMessage(
      "Usage instructions",
    ),
    "xboardUsed": MessageLookupByLibrary.simpleMessage("Used"),
    "xboardUsedTraffic": MessageLookupByLibrary.simpleMessage("Used"),
    "xboardValidatingConfigFormat": MessageLookupByLibrary.simpleMessage(
      "Validating configuration format",
    ),
    "xboardValidationFailed": MessageLookupByLibrary.simpleMessage(
      "Validation failed",
    ),
    "xboardValidityPeriod": MessageLookupByLibrary.simpleMessage("Expires"),
    "xboardVerify": MessageLookupByLibrary.simpleMessage("Verify"),
    "xboardVeryPoor": MessageLookupByLibrary.simpleMessage("Very poor"),
    "xboardWaitingForPayment": MessageLookupByLibrary.simpleMessage(
      "Waiting for payment",
    ),
    "xboardWaitingPaymentCompletion": MessageLookupByLibrary.simpleMessage(
      "Waiting for payment completion",
    ),
    "xboardYearlyPayment": MessageLookupByLibrary.simpleMessage("Yearly"),
    "years": MessageLookupByLibrary.simpleMessage("Years"),
    "yearsAgo": m81,
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "zhCN": MessageLookupByLibrary.simpleMessage("Simplified Chinese"),
    "zh_CN": MessageLookupByLibrary.simpleMessage("Simplified Chinese"),
  };
}
