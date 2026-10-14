// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(count, skipped) => "${count}件を追加、${skipped}件は既存のためスキップ";

  static String m1(code) =>
      "Windows が FlClashCore.exe の実行を拒否しました（エラー ${code}）。スマート アプリ コントロールや AppLocker などのアプリ制御ポリシーは未署名のプログラムをブロックします。ポリシーで ToWorld を許可するか、ポリシーを無効にしてから再試行してください。";

  static String m2(name) =>
      "アプリの起動が2回連続で完了しませんでした。クラッシュループを断ち切るため、プロファイル ${name} の選択を解除し、今回の自動セットアップをスキップしました。いつでも選択し直せます。";

  static String m3(url) => "${url} からプロファイルを作成しますか？";

  static String m4(rate) => "現在の報酬率: ${rate}%";

  static String m5(count) => "${count} 日前";

  static String m6(label) => "選択した${label}を削除してもよろしいですか？";

  static String m7(label) => "この${label}を削除してもよろしいですか？";

  static String m8(label) => "${label}の詳細";

  static String m9(label) => "${label}は空にできません";

  static String m10(count) => "${count} エントリ";

  static String m11(label) => "${label}はすでに存在します";

  static String m12(name) => "${name} はすでに最新です";

  static String m13(name) => "${name} を更新しました";

  static String m14(name) => "${name}を更新中...";

  static String m15(action) => "「${action}」で使用中です。保存するとこちらに移動します。";

  static String m16(modifiers) => "${modifiers} のいずれかを含めてください";

  static String m17(count) => "${count} 時間前";

  static String m18(count) => "${count} 時間";

  static String m19(target) => "${target} は無効なポリシーです";

  static String m20(proxyName) => "${proxyName} は無効なプロキシです";

  static String m21(providerName) => "${providerName} は無効なプロキシプロバイダーです";

  static String m22(ruleSet) => "${ruleSet} は無効なルールセットです";

  static String m23(subRule) => "${subRule} は無効な SUB_RULE です";

  static String m24(line, message) => "${line}行目：${message}";

  static String m25(appName) =>
      "1. システム設定 > プライバシーとセキュリティ を開く\n2. 位置情報サービス を選択\n3. リストで ${appName} を見つけてチェックを入れる\n\n設定が完了したらアプリに戻ると、通常どおり使用できます。ご協力ありがとうございます。";

  static String m26(error) => "ログアウトに失敗しました: ${error}";

  static String m27(label, max) => "${label}は最大${max}文字です";

  static String m28(amount) => "最大送金額: ¥${amount}";

  static String m29(size) => "${size} を解放しました";

  static String m30(count) => "${count} 分前";

  static String m31(count) => "${count} か月前";

  static String m32(code) =>
      "サーバーがアクセスを拒否しました（HTTP ${code}）。リンクの期限切れか、認証情報が誤っている可能性があります";

  static String m33(code) => "サーバーがリクエストを拒否しました（HTTP ${code}）";

  static String m34(code) =>
      "このアドレスには何も見つかりませんでした（HTTP ${code}）。URL が正しいか確認してください";

  static String m35(detail) => "ネットワークリクエストに失敗しました：${detail}";

  static String m36(code) => "サーバーで問題が発生しました（HTTP ${code}）。しばらくしてから再試行してください";

  static String m37(label) => "${label}はまだありません";

  static String m38(label) => "${label}は数値である必要があります";

  static String m39(statusCode) => "メッセージの取得に失敗しました: ${statusCode}";

  static String m40(error) => "画像の選択に失敗しました: ${error}";

  static String m41(method) => "サポートされていないHTTPメソッド: ${method}";

  static String m42(error) => "アップロードに失敗しました: ${error}";

  static String m43(amount) => "注文金額: ${amount}";

  static String m44(orderNo) => "注文番号: ${orderNo}";

  static String m45(message) => "コアがこのプロキシを解析できません：${message}";

  static String m46(name) => "名前 ${name} は他のプロキシまたはプロキシグループで使用されています";

  static String m47(path) => "プロキシグループが循環参照しています：${path}";

  static String m48(names) => "次のプロキシプロバイダーは存在しません：${names}";

  static String m49(names) => "次のプロキシまたはポリシーは存在しません：${names}";

  static String m50(name) => "${name} は組み込みポリシー名のため使用できません";

  static String m51(names) =>
      "プロファイル自身のプロキシグループが、カスタムプロキシに含まれないプロキシを参照しています：${names}";

  static String m52(count) => "${count} 件に問題があり、上書きの適用に失敗する可能性があります";

  static String m53(page) => "ページ ${page}";

  static String m54(label) => "${label} は 1024〜49151 の範囲で指定してください";

  static String m55(label, profiles) =>
      "${label} は ${profiles} のカスタムプロキシグループまたはルールでまだ使用されています。先にそこから外してください";

  static String m56(profiles, label) =>
      "${profiles} のサブスクリプションには既に ${label} があるため、名前を変えるとそちらが使われます。別の名前にしてください";

  static String m57(count) => "プロキシ ${count} 件";

  static String m58(e) => "登録に失敗しました: ${e}";

  static String m59(count) => "ルール ${count} 件";

  static String m60(appName) => "${appName}（セーフモード）";

  static String m61(count) => "${count} 秒";

  static String m62(count) => "${count} 件選択中";

  static String m63(e) => "認証コードの送信に失敗しました: ${e}";

  static String m64(time) => "${time} に検査";

  static String m65(label) => "${label}は1項目のみ指定できます";

  static String m66(date) => "プランは${date}に期限切れになりました。継続利用には更新してください";

  static String m67(days) => "プランは${days}日後に期限切れになります。タイムリーに更新してください";

  static String m68(days) => "サブスクリプションは${days}日後に期限切れになります";

  static String m69(count) => "合計 ${count} 件";

  static String m70(amount) => "送金額は ¥${amount} を超えることはできません";

  static String m71(error) => "送金に失敗しました: ${error}";

  static String m72(amount) => "送金が完了しました！ウォレットに ¥${amount} 送金しました";

  static String m73(version) => "現在のバージョン: ${version}";

  static String m74(version) => "強制アップデート: ${version}";

  static String m75(version) => "新しいバージョンが見つかりました: ${version}";

  static String m76(statusCode) => "サーバーがエラーステータスコード ${statusCode} を返しました";

  static String m77(label) => "${label}はURLである必要があります";

  static String m78(email) => "認証コードを ${email} に送信しました。認証コードと新しいパスワードを入力してください";

  static String m79(amount) => "出金可能額: ${amount}";

  static String m80(time) => "実行時間: ${time}";

  static String m81(count) => "${count} 年前";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("アプリについて"),
    "accessControl": MessageLookupByLibrary.simpleMessage("アクセス制御"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "選択したアプリのみVPNを経由します",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "プロキシを利用するアプリを設定します",
    ),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "アプリアクセス制御は無効です",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "選択したアプリはVPNから除外されます",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage("アクセス制御の設定"),
    "account": MessageLookupByLibrary.simpleMessage("アカウント"),
    "action": MessageLookupByLibrary.simpleMessage("アクション"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage("すべての遅延をテスト"),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("ダイレクトモード"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage("グローバルモード"),
    "actionMode": MessageLookupByLibrary.simpleMessage("モード切替"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("システムプロキシ"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("ルールモード"),
    "actionStart": MessageLookupByLibrary.simpleMessage("開始/停止"),
    "actionTun": MessageLookupByLibrary.simpleMessage("TUN"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage("プロファイルを更新"),
    "actionView": MessageLookupByLibrary.simpleMessage("表示/非表示"),
    "action_mode": MessageLookupByLibrary.simpleMessage("モード切替"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("システムプロキシ"),
    "action_start": MessageLookupByLibrary.simpleMessage("開始/停止"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("表示/非表示"),
    "add": MessageLookupByLibrary.simpleMessage("追加"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("プロキシを追加"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage("上書き項目を追加"),
    "addProfile": MessageLookupByLibrary.simpleMessage("プロファイルを追加"),
    "addProxies": MessageLookupByLibrary.simpleMessage("プロキシを追加"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage("プロキシグループを追加"),
    "addProxyProviders": MessageLookupByLibrary.simpleMessage("プロキシプロバイダーを追加"),
    "addRule": MessageLookupByLibrary.simpleMessage("ルールを追加"),
    "addSsid": MessageLookupByLibrary.simpleMessage("SSIDを追加"),
    "addWidget": MessageLookupByLibrary.simpleMessage("ウィジェットを追加"),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage("元のルールに追加"),
    "addedRules": MessageLookupByLibrary.simpleMessage("追加ルール"),
    "additionalParameters": MessageLookupByLibrary.simpleMessage("追加パラメータ"),
    "address": MessageLookupByLibrary.simpleMessage("アドレス"),
    "addressHelp": MessageLookupByLibrary.simpleMessage("WebDAVサーバーのアドレス"),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "有効なWebDAVアドレスを入力してください",
    ),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage("管理者自動起動"),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage("管理者モードで起動"),
    "advancedConfig": MessageLookupByLibrary.simpleMessage("詳細設定"),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage(
      "ネットワーク、DNS、追加ルール、スクリプト",
    ),
    "ago": MessageLookupByLibrary.simpleMessage("前"),
    "agree": MessageLookupByLibrary.simpleMessage("同意する"),
    "allApps": MessageLookupByLibrary.simpleMessage("全アプリ"),
    "allowBypass": MessageLookupByLibrary.simpleMessage("アプリによるVPNバイパスを許可"),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "有効化すると一部アプリがVPNをバイパス",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("LANプロキシ"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage("LAN経由でのプロキシアクセスを許可"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage("アカウントをお持ちですか？"),
    "answers": MessageLookupByLibrary.simpleMessage("応答"),
    "app": MessageLookupByLibrary.simpleMessage("アプリ"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage("アプリアクセス制御"),
    "appDesc": MessageLookupByLibrary.simpleMessage("アプリ関連設定の処理"),
    "appIconDesign": MessageLookupByLibrary.simpleMessage("アプリアイコンのデザイン"),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage("システムDNSを追加"),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage(
      "設定にシステムDNSを強制的に追加します",
    ),
    "application": MessageLookupByLibrary.simpleMessage("アプリケーション"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage("アプリ関連設定を変更"),
    "authentication": MessageLookupByLibrary.simpleMessage("認証"),
    "authenticationDesc": MessageLookupByLibrary.simpleMessage(
      "ローカルプロキシポートに認証を要求し、他のアプリによる無断利用を防ぎます",
    ),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "認証が有効な間は適用されません",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("許可"),
    "authorized": MessageLookupByLibrary.simpleMessage("許可済み"),
    "auto": MessageLookupByLibrary.simpleMessage("自動"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage("更新の自動チェック"),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "起動時に更新を自動チェック",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage("接続を自動的に閉じる"),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "ノードの切り替え後、接続を自動的に閉じます",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("自動起動"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage("システム起動時に自動的に起動します"),
    "autoRun": MessageLookupByLibrary.simpleMessage("自動実行"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage("アプリを開いたときに自動的に実行します"),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage("システムDNSを自動設定"),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("自動更新"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage("自動更新間隔（分）"),
    "availableCommission": MessageLookupByLibrary.simpleMessage("利用可能"),
    "back": MessageLookupByLibrary.simpleMessage("戻る"),
    "backToLogin": MessageLookupByLibrary.simpleMessage("ログインに戻る"),
    "backup": MessageLookupByLibrary.simpleMessage("バックアップ"),
    "backupAndRecovery": MessageLookupByLibrary.simpleMessage("バックアップと復元"),
    "backupAndRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "WebDAVまたはファイルでデータを同期",
    ),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage("バックアップと復元"),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "WebDAVまたはファイルでデータを同期します",
    ),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "このバックアップは新しいバージョンのアプリで作成されています。アプリを更新してから復元してください",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("バックアップが完了しました"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("基本設定"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage("基本設定をグローバルに変更"),
    "basicInfo": MessageLookupByLibrary.simpleMessage("基本情報"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("基本ポリシー"),
    "batchAdd": MessageLookupByLibrary.simpleMessage("一括追加"),
    "batchListInputTip": MessageLookupByLibrary.simpleMessage(
      "1行に1項目、またはカンマ区切りで入力してください",
    ),
    "batchMapInputTip": MessageLookupByLibrary.simpleMessage(
      "1行に1件、キーと値はスペースで区切ってください",
    ),
    "batchPreviewTip": m0,
    "batteryOptimizationDesc": MessageLookupByLibrary.simpleMessage(
      "バックグラウンドでの動作を維持するため、このアプリの電池の最適化を無効にしてください。タップすると設定を開きます。",
    ),
    "batteryOptimizationStatusTip": MessageLookupByLibrary.simpleMessage(
      "システムの制限により、実行中は電池の最適化の状態を正しく取得できません",
    ),
    "behavior": MessageLookupByLibrary.simpleMessage("動作"),
    "bind": MessageLookupByLibrary.simpleMessage("連携"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("ブラックリストモード"),
    "blockConnection": MessageLookupByLibrary.simpleMessage("接続をブロック"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("除外ドメイン"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "システムプロキシが有効な場合のみ適用されます",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("キャッシュ"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage("キャッシュアルゴリズム"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "キャッシュが破損しています。クリアしますか？",
    ),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("キャッシュサイズ"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "QRコードをスキャンするには、システム設定でカメラへのアクセスを許可するか、アルバムからQRコード画像を選択してください。",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "カメラの権限が必要です",
    ),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage("カメラを使用できません"),
    "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage(
      "システムアプリの除外を解除",
    ),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("すべて選択解除"),
    "cannotGetWebUrl": MessageLookupByLibrary.simpleMessage(
      "Web URLを取得できません。サポートにお問い合わせください",
    ),
    "cannotOpenBrowser": MessageLookupByLibrary.simpleMessage(
      "ブラウザを開けません。手動でWebにアクセスしてください",
    ),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "プロキシの切り替えに失敗したため、前回の選択に戻しました",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage("破壊的変更"),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("新機能"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage("不具合修正"),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage("パフォーマンス"),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("取り消し"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage("TLS証明書を検証"),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "信頼できない証明書を拒否します。無効にすると、サブスクリプションやバックアップが中間者攻撃にさらされます",
    ),
    "checkError": MessageLookupByLibrary.simpleMessage("確認エラー"),
    "checkNetwork": MessageLookupByLibrary.simpleMessage(
      "ネットワークを確認して再試行してください",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("更新を確認"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage("すでに最新バージョンです"),
    "checking": MessageLookupByLibrary.simpleMessage("確認中..."),
    "clearData": MessageLookupByLibrary.simpleMessage("データを消去"),
    "clearSearch": MessageLookupByLibrary.simpleMessage("検索をクリア"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("クリップボードへエクスポート"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("クリップボードからインポート"),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "クリップボードにコピーできませんでした。選択範囲が大きすぎる可能性があります",
    ),
    "close": MessageLookupByLibrary.simpleMessage("閉じる"),
    "closeConnections": MessageLookupByLibrary.simpleMessage("接続を閉じる"),
    "color": MessageLookupByLibrary.simpleMessage("カラー"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("カラースキーム"),
    "columns": MessageLookupByLibrary.simpleMessage("列数"),
    "commissionHistory": MessageLookupByLibrary.simpleMessage("報酬履歴"),
    "commissionRate": MessageLookupByLibrary.simpleMessage("手数料率"),
    "commissionSettled": MessageLookupByLibrary.simpleMessage(
      "友人の購読後に報酬が確定します",
    ),
    "compatible": MessageLookupByLibrary.simpleMessage("互換モード"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "有効化すると一部機能を失いますが、Clashの完全サポートを獲得",
    ),
    "complete": MessageLookupByLibrary.simpleMessage("完了"),
    "completeWithdrawal": MessageLookupByLibrary.simpleMessage(
      "Web版では完全な出金機能を提供しています",
    ),
    "configDataDetected": MessageLookupByLibrary.simpleMessage(
      "設定内にデータが見つかりました",
    ),
    "configurationError": MessageLookupByLibrary.simpleMessage(
      "アプリケーション設定エラー、サポートにお問い合わせください",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("OK"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "すべてのデータを消去してもよろしいですか？",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "このプロキシグループを削除してもよろしいですか？",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "現在のウィンドウを閉じてもよろしいですか？",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "コアを強制クラッシュさせてもよろしいですか？",
    ),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("ログアウトを確認"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage("新しいパスワードを確認"),
    "confirmOverwriteTip": MessageLookupByLibrary.simpleMessage(
      "確定すると既存のデータを上書きします",
    ),
    "confirmTransfer": MessageLookupByLibrary.simpleMessage("送金を確認"),
    "connected": MessageLookupByLibrary.simpleMessage("接続済み"),
    "connecting": MessageLookupByLibrary.simpleMessage("接続中…"),
    "connection": MessageLookupByLibrary.simpleMessage("接続"),
    "connections": MessageLookupByLibrary.simpleMessage("接続"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage("現在の接続データを表示"),
    "connectivity": MessageLookupByLibrary.simpleMessage("接続状態："),
    "contactMe": MessageLookupByLibrary.simpleMessage("連絡する"),
    "contactSupport": MessageLookupByLibrary.simpleMessage("サポートに連絡"),
    "content": MessageLookupByLibrary.simpleMessage("内容"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage("内容は空にできません"),
    "contentScheme": MessageLookupByLibrary.simpleMessage("コンテンツ"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "グローバル追加ルールを管理",
    ),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "クリップボードにコピーしました",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("コピー"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage("環境変数をコピー"),
    "copyInviteLink": MessageLookupByLibrary.simpleMessage("リンクをコピー"),
    "copyLink": MessageLookupByLibrary.simpleMessage("リンクをコピー"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("コピーしました"),
    "core": MessageLookupByLibrary.simpleMessage("コア"),
    "coreBlockedByPolicyTip": m1,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Windows のスマート アプリ コントロールが、署名されていない FlClashCore.exe をブロックしました。Windows セキュリティ → アプリとブラウザーの制御 → スマート アプリ コントロールの設定で「オフ」を選び、ToWorld を再起動してください。一度オフにすると、Windows を再インストールしない限り再度オンにはできません。",
    ),
    "coreInfo": MessageLookupByLibrary.simpleMessage("コア情報"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("コアの状態"),
    "country": MessageLookupByLibrary.simpleMessage("地域"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("クラッシュを検出しました"),
    "crashDetectedTip": m2,
    "crashTest": MessageLookupByLibrary.simpleMessage("クラッシュテスト"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("クラッシュ分析"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "有効にすると、アプリのクラッシュ時に機密情報を含まないクラッシュログを自動的にアップロードします",
    ),
    "create": MessageLookupByLibrary.simpleMessage("作成"),
    "createAccount": MessageLookupByLibrary.simpleMessage("アカウント作成"),
    "createProfile": MessageLookupByLibrary.simpleMessage("Create Profile"),
    "createProfileFromUrlTip": m3,
    "creationTime": MessageLookupByLibrary.simpleMessage("作成日時"),
    "credentialsSaved": MessageLookupByLibrary.simpleMessage("資格情報を保存しました"),
    "currentCommissionRate": m4,
    "custom": MessageLookupByLibrary.simpleMessage("カスタム"),
    "customProxiesEmpty": MessageLookupByLibrary.simpleMessage(
      "カスタムプロキシがないため、プロファイル自身のプロキシを使用します",
    ),
    "cut": MessageLookupByLibrary.simpleMessage("切り取り"),
    "dark": MessageLookupByLibrary.simpleMessage("ダーク"),
    "dashboard": MessageLookupByLibrary.simpleMessage("ダッシュボード"),
    "dataChangedSave": MessageLookupByLibrary.simpleMessage(
      "データの変更を検出しました。保存しますか？",
    ),
    "dataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "本アプリは、安定性向上のために Firebase Crashlytics を使用してクラッシュ情報を収集します。\n収集されるデータにはデバイス情報とクラッシュの詳細が含まれますが、個人の機密データは含まれません。\nこの機能は設定で無効にできます。",
    ),
    "dataCollectionTip": MessageLookupByLibrary.simpleMessage("データ収集について"),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "変更の保存に失敗したため、元に戻しました",
    ),
    "days": MessageLookupByLibrary.simpleMessage("日"),
    "daysAgo": m5,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage("デフォルトネームサーバー"),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "DNSサーバーの解決用",
    ),
    "defaultSort": MessageLookupByLibrary.simpleMessage("デフォルト順"),
    "defaultText": MessageLookupByLibrary.simpleMessage("デフォルト"),
    "delay": MessageLookupByLibrary.simpleMessage("遅延"),
    "delaySort": MessageLookupByLibrary.simpleMessage("遅延順"),
    "delayTest": MessageLookupByLibrary.simpleMessage("遅延テスト"),
    "delete": MessageLookupByLibrary.simpleMessage("削除"),
    "deleteMultipTip": m6,
    "deleteTip": m7,
    "desc": MessageLookupByLibrary.simpleMessage(
      "ClashMetaベースのマルチプラットフォーム対応プロキシクライアント。シンプルで使いやすく、オープンソースで広告もありません。",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("宛先"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage("宛先GeoIP"),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage("宛先IP ASN"),
    "details": m8,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "サードパーティAPIに依存しているため、参考値です",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("開発者モード"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "開発者モードが有効になりました。",
    ),
    "dialerProxy": MessageLookupByLibrary.simpleMessage("ダイヤラープロキシ"),
    "dialerProxyDesc": MessageLookupByLibrary.simpleMessage(
      "NTPサーバーへの接続に使用するアウトバウンド",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("ダイレクト"),
    "disableUDP": MessageLookupByLibrary.simpleMessage("UDPを無効化"),
    "disabled": MessageLookupByLibrary.simpleMessage("無効"),
    "discardChanges": MessageLookupByLibrary.simpleMessage("変更を破棄しますか？"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("免責事項"),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアをインストール、複製または使用した時点で、本声明のすべての内容を読み、同意したものとみなされます。いずれかの条項に同意いただけない場合は、直ちに使用を中止し、本ソフトウェアをアンインストールしてください。",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage("声明への同意"),
    "disclaimerAnalyticsContent": MessageLookupByLibrary.simpleMessage(
      "Firebase により基本的なアプリ利用統計が自動的に収集されます。\n\n収集内容：初回起動、アプリの起動とセッション時間、アプリの更新などの基本イベント、アプリインスタンス ID、端末のモデル、OS のバージョン、システム言語、および IP アドレスから推定される国または地域レベルのおおよその位置情報。\n\n目的：アクティブな端末数、バージョン分布、OS の互換性を把握するためにのみ使用します。開発者はこれらのデータを広告に使用したり、販売したり、サブスクリプションや設定と関連付けたりすることはありません。",
    ),
    "disclaimerAnalyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Firebase Analytics（利用統計）",
    ),
    "disclaimerAndroidOnly": MessageLookupByLibrary.simpleMessage("Android のみ"),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "開発者はバージョンの更新に伴い本声明を変更することがあり、変更内容は新しいバージョンの公開とともに効力を生じます。更新後も本ソフトウェアを引き続き使用した場合、変更後の声明に同意したものとみなされます。",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage("本声明の変更"),
    "disclaimerCrashlyticsContent": MessageLookupByLibrary.simpleMessage(
      "アプリがクラッシュした際に、クラッシュレポートを自動的に送信します。\n\n収集内容：クラッシュのスタックトレースとエラー情報、発生日時、アプリのバージョンとビルド番号、端末のメーカーとモデル、Android のバージョン、画面の向き、空きメモリと空きストレージ、root 化の有無、およびインストール時に生成され再インストールでリセットされるランダムなインストール ID。\n\n目的：クラッシュの特定と修正のためにのみ使用します。\n\n「ツール > 一般 > クラッシュ分析」からいつでもオフにできます。",
    ),
    "disclaimerCrashlyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Firebase Crashlytics（クラッシュ分析）",
    ),
    "disclaimerDataProcessingContent": MessageLookupByLibrary.simpleMessage(
      "これらのデータは Google が代わりに処理・保存し、お住まいの国または地域外（米国など）のサーバーに転送される場合があり、Google のプライバシーポリシーおよび Firebase のプライバシーとセキュリティに関する説明に従って取り扱われます。クラッシュレポートは最大 90 日間保存され、統計データは Firebase の既定の保存ポリシーに従って保存されます。",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "ToWorld（以下「本ソフトウェア」）をご利用になる前に、本声明の内容をよくお読みになり、十分にご理解ください。「同意する」をタップすると、以下のすべての条項を読み、理解し、承諾したものとみなされます。同意いただけない場合は「終了」をタップし、本ソフトウェアの使用を中止してください。",
    ),
    "disclaimerFirebasePrivacy": MessageLookupByLibrary.simpleMessage(
      "Firebase のプライバシーとセキュリティ",
    ),
    "disclaimerGooglePrivacy": MessageLookupByLibrary.simpleMessage(
      "Google プライバシーポリシー",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "適用法で認められる最大限の範囲において、開発者およびすべての貢献者は、本ソフトウェアの使用または使用不能に起因する直接的、間接的、偶発的、特別、懲罰的または結果的な損害（データの消失、機器の損傷、ネットワーク障害、業務の中断、逸失利益、およびそれに起因する法的紛争を含むがこれらに限らない）について、その可能性を知らされていた場合であっても、一切責任を負いません。",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage("責任の制限"),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアは GPL-3.0 ライセンスのもとでオープンソースとして公開されています。同ライセンスを遵守する限り、自由に使用、改変、再配布できますが、派生物も GPL-3.0 で公開し、原著作者の著作権表示を保持する必要があります。\n\n本ソフトウェアに含まれるサードパーティのコンポーネント（Clash.Meta コアを含む）は、それぞれのライセンスに従います。改変版や再配布版に起因する問題について、原著作者は責任を負いません。",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage(
      "オープンソースライセンス",
    ),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアは、サブスクリプション URL、ノード情報、設定内容、閲覧したウェブサイト、接続記録、通信内容、ログを収集またはアップロードしません。これらのデータは端末内にのみ保存され、開発者がアクセスすることはできません。\n\n本ソフトウェアが外部ネットワークにアクセスするのは、プロファイル更新時に指定されたサブスクリプション URL へアクセスする場合や、アップデート確認時に GitHub へアクセスする場合など、該当する機能を使用したときのみです。\n\nデスクトップ版（Windows、macOS、Linux）には、統計やクラッシュレポートのサービスは一切組み込まれていません。Android 版には、安定性向上のため以下の 2 つの Google Firebase サービスが組み込まれています。",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "データ収集とプライバシー",
    ),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "お住まいの国または地域で本ソフトウェアの使用が合法であることはご自身で確認する必要があり、本ソフトウェアを使用したすべての行為とその結果について、ご自身が単独で法的責任を負います。\n\nインポートするサブスクリプション、ノード、設定はご自身の判断で選択したものです。その出所の適法性、内容の安全性、サービスの安定性については、利用者と各提供者の間で解決してください。",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "利用者の責任",
    ),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアは Clash.Meta（mihomo）コアをベースとしたオープンソースのネットワークプロキシクライアントであり、設定管理、ルールによる振り分け、トラフィック転送などのローカルツール機能のみを提供します。\n\n本ソフトウェア自体は、プロキシサーバー、ノード、サブスクリプション、ネットワーク接続サービスを一切提供しておらず、それらのサービス提供者と提携、代理、保証の関係はありません。",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage(
      "ソフトウェアの性質",
    ),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンク、設定ファイル、ルールセット、スクリプト、外部リソース、外部リンクはすべて第三者が提供するものであり、開発者はその適法性、正確性、安全性、可用性を審査または保証することはできず、また行いません。\n\nサードパーティのコンテンツの使用に起因する情報漏えい、財産上の損失、アカウント停止その他の損失は、利用者と第三者の間で解決するものとし、開発者は一切責任を負いません。",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "サードパーティのコンテンツ",
    ),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアは学習、交流、技術研究などの非商用目的でのみ使用できます。有償配布、抱き合わせ販売、商用サービスの一部としての利用、本ソフトウェアの名義での事業活動など、あらゆる商用目的での使用を固く禁じます。いかなる商業行為も本ソフトウェアおよび開発者とは一切関係ありません。\n\nお住まいの国または地域の法令に違反する目的での使用を固く禁じます。これには、法に基づくネットワークアクセス制限の回避、違法情報の拡散、サイバー攻撃、他者の権利の侵害などが含まれますが、これらに限りません。",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage("使用の制限"),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアは「現状のまま」かつ「提供可能な範囲で」提供され、商品性、特定目的への適合性、非侵害、継続的な可用性、エラーやセキュリティ上の脆弱性がないことの保証を含め、明示または黙示を問わずいかなる保証も伴いません。\n\n開発者は、本ソフトウェアが利用者の要件を満たすこと、また中断やエラーなく動作することを保証しません。",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage("無保証"),
    "disconnected": MessageLookupByLibrary.simpleMessage("切断済み"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "新しいバージョンが見つかりました",
    ),
    "discovery": MessageLookupByLibrary.simpleMessage("新しいバージョンを発見"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("DNS関連設定の更新"),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNSハイジャック"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNSモード"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("DNSクエリ"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage("通過させますか？"),
    "docked": MessageLookupByLibrary.simpleMessage("固定"),
    "domain": MessageLookupByLibrary.simpleMessage("ドメイン"),
    "domainStatusAvailable": MessageLookupByLibrary.simpleMessage("サービス利用可能"),
    "domainStatusChecking": MessageLookupByLibrary.simpleMessage("確認中..."),
    "domainStatusUnavailable": MessageLookupByLibrary.simpleMessage("サービス利用不可"),
    "download": MessageLookupByLibrary.simpleMessage("ダウンロード"),
    "edit": MessageLookupByLibrary.simpleMessage("編集"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage("グローバルルールを編集"),
    "editProxy": MessageLookupByLibrary.simpleMessage("プロキシを編集"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage("プロキシグループを編集"),
    "editRule": MessageLookupByLibrary.simpleMessage("ルールを編集"),
    "editSsid": MessageLookupByLibrary.simpleMessage("SSIDを編集"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage("エディターを利用できません"),
    "emailAddress": MessageLookupByLibrary.simpleMessage("メールアドレス"),
    "emailVerificationCode": MessageLookupByLibrary.simpleMessage("メール認証コード"),
    "emptyTip": m9,
    "en": MessageLookupByLibrary.simpleMessage("英語"),
    "enableOverride": MessageLookupByLibrary.simpleMessage("上書きを有効化"),
    "enabled": MessageLookupByLibrary.simpleMessage("有効"),
    "enterEmailForReset": MessageLookupByLibrary.simpleMessage(
      "メールアドレスを入力してください。認証コードをメールに送信します",
    ),
    "enterTransferAmount": MessageLookupByLibrary.simpleMessage("送金額を入力してください"),
    "enterTransferAmountError": MessageLookupByLibrary.simpleMessage(
      "送金額を入力してください",
    ),
    "entries": MessageLookupByLibrary.simpleMessage(" 件"),
    "entriesCount": m10,
    "error": MessageLookupByLibrary.simpleMessage("エラー"),
    "exclude": MessageLookupByLibrary.simpleMessage("最近のタスクから隠す"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "バックグラウンド時に、最近のタスクからアプリを隠します",
    ),
    "excludeProxyFilter": MessageLookupByLibrary.simpleMessage("除外ノードフィルター"),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("除外SSID"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "除外したSSIDのWi-Fiに接続すると、アプリの実行状態が自動的に切り替わります",
    ),
    "excludeType": MessageLookupByLibrary.simpleMessage("除外タイプ"),
    "existsTip": m11,
    "exit": MessageLookupByLibrary.simpleMessage("終了"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage("全画面表示を終了"),
    "expand": MessageLookupByLibrary.simpleMessage("標準"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("期待するステータス"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("有効期限"),
    "expireTime": MessageLookupByLibrary.simpleMessage("有効期限"),
    "exportFile": MessageLookupByLibrary.simpleMessage("ファイルをエクスポート"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("ログをエクスポート"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("エクスポートが完了しました"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("エクスプレッシブ"),
    "externalController": MessageLookupByLibrary.simpleMessage("外部コントローラー"),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "有効にすると、ポート9090でClashコアを制御できます",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("外部取得"),
    "externalLink": MessageLookupByLibrary.simpleMessage("外部リンク"),
    "externalResources": MessageLookupByLibrary.simpleMessage("外部リソース"),
    "extraLarge": MessageLookupByLibrary.simpleMessage("特大"),
    "fade": MessageLookupByLibrary.simpleMessage("フェード"),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fake-IPフィルター"),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage("Fake-IPフィルターモード"),
    "fakeipFilterModeDesc": MessageLookupByLibrary.simpleMessage(
      "blacklistは一致を除外、whitelistは一致のみ、ruleはルールで判定",
    ),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fake-IP範囲"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage("Fake-IP範囲（IPv6）"),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("Fake-IP TTL"),
    "fallback": MessageLookupByLibrary.simpleMessage("フォールバック"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage("通常はオフショアDNSを使用"),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("フォールバックフィルター"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("フィデリティ"),
    "file": MessageLookupByLibrary.simpleMessage("ファイル"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("プロファイルファイルを直接アップロードします"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "ファイルが変更されています。変更を保存しますか？",
    ),
    "fillInfoToRegister": MessageLookupByLibrary.simpleMessage(
      "登録を完了するには以下の情報を入力してください",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("フィルター"),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage("システムアプリを除外"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("プロセス検出"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "有効化するとパフォーマンスが若干低下します",
    ),
    "floating": MessageLookupByLibrary.simpleMessage("フローティング"),
    "followProfile": MessageLookupByLibrary.simpleMessage("プロファイルに従う"),
    "followSystem": MessageLookupByLibrary.simpleMessage("システムに従う"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("フォント"),
    "fontSize": MessageLookupByLibrary.simpleMessage("サイズ"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "コアを強制再起動してもよろしいですか？",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("パスワードを忘れた場合"),
    "format": MessageLookupByLibrary.simpleMessage("形式"),
    "fourColumns": MessageLookupByLibrary.simpleMessage("4列"),
    "friendInviteReward": MessageLookupByLibrary.simpleMessage(
      "招待した友人の利用に応じて報酬が得られます",
    ),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("フルーツサラダ"),
    "general": MessageLookupByLibrary.simpleMessage("一般"),
    "generalDesc": MessageLookupByLibrary.simpleMessage("一般設定を変更"),
    "generatingInviteCode": MessageLookupByLibrary.simpleMessage(
      "招待コードを生成中...",
    ),
    "geoAutoUpdate": MessageLookupByLibrary.simpleMessage("自動更新"),
    "geoAutoUpdateInterval": MessageLookupByLibrary.simpleMessage("自動更新間隔"),
    "geoAutoUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "自動更新間隔は0より大きくしてください",
    ),
    "geoData": MessageLookupByLibrary.simpleMessage("地域データ"),
    "geoOptions": MessageLookupByLibrary.simpleMessage("Geoオプション"),
    "geoResources": MessageLookupByLibrary.simpleMessage("Geoリソース"),
    "geoSkipped": m12,
    "geoUpdated": m13,
    "geoUpdating": m14,
    "geodataLoader": MessageLookupByLibrary.simpleMessage("Geo低メモリモード"),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "有効化するとGeo低メモリローダーを使用",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("GeoIPコード"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage("元のルールを取得"),
    "global": MessageLookupByLibrary.simpleMessage("グローバル"),
    "go": MessageLookupByLibrary.simpleMessage("開く"),
    "goDownload": MessageLookupByLibrary.simpleMessage("ダウンロードへ"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage("スクリプト設定へ移動"),
    "goToWeb": MessageLookupByLibrary.simpleMessage("Webへ移動"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage("変更をキャッシュしますか？"),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "Helper サービスが利用できないため、TUN モードを有効にできません。ToWorld を再インストールしてください。",
    ),
    "hideFromList": MessageLookupByLibrary.simpleMessage("リストから隠す"),
    "hideIp": MessageLookupByLibrary.simpleMessage("IP を隠す"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("パスワードを隠す"),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage(
      "タイムアウトしたノードを隠す",
    ),
    "hideTimeoutProxiesDesc": MessageLookupByLibrary.simpleMessage(
      "前回の遅延テストがタイムアウトしたノードを表示しない",
    ),
    "host": MessageLookupByLibrary.simpleMessage("ホスト"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("ホストを追加"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("ホットキー競合"),
    "hotkeyConflictWith": m15,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "グローバルホットキーはウィンドウが非表示でも有効です。アクションをタップしてキーの組み合わせを記録します。",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage("ホットキー管理"),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "キーボードでアプリを制御",
    ),
    "hotkeyNeedsModifier": m16,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("未設定"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "登録できませんでした。他のアプリが使用している可能性があります",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("時間"),
    "hoursAgo": m17,
    "hoursCount": m18,
    "iUnderstand": MessageLookupByLibrary.simpleMessage("理解しました"),
    "icon": MessageLookupByLibrary.simpleMessage("アイコン"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage("アイコン設定"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("アイコン履歴"),
    "iconStyle": MessageLookupByLibrary.simpleMessage("アイコンスタイル"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("背景あり"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("非表示"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("背景なし"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("アイコンURL"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "電池の最適化を無視",
    ),
    "import": MessageLookupByLibrary.simpleMessage("インポート"),
    "importFile": MessageLookupByLibrary.simpleMessage("ファイルからインポート"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("URLからインポート"),
    "importUrl": MessageLookupByLibrary.simpleMessage("URLからインポート"),
    "inbound": MessageLookupByLibrary.simpleMessage("インバウンド"),
    "includeAllProxies": MessageLookupByLibrary.simpleMessage("すべてのプロキシを含める"),
    "includeAllProxiesTip": MessageLookupByLibrary.simpleMessage(
      "プロキシグループに属さないすべてのプロキシを取り込みます。下でプロキシグループを追加できます",
    ),
    "includeAllProxyProviders": MessageLookupByLibrary.simpleMessage(
      "すべてのプロキシプロバイダーを含める",
    ),
    "includeAllProxyProvidersTip": MessageLookupByLibrary.simpleMessage(
      "有効にすると、このプロファイルのすべてのプロキシプロバイダーを含めます。サブスクリプション自身のものに加え、いずれかのプロキシグループが使うプロファイルとアプリのプロキシプロバイダーも含みます",
    ),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("無期限"),
    "init": MessageLookupByLibrary.simpleMessage("初期化"),
    "initiator": MessageLookupByLibrary.simpleMessage("発信元"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage("正しいホットキーを入力"),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "プロキシグループ名を入力してください",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage("ルールの内容を入力してください"),
    "installedAppsPermissionDeniedMessage":
        MessageLookupByLibrary.simpleMessage(
          "アプリ一覧の権限が拒否されたため、インストール済みアプリを取得できません。システム設定から手動で許可してください。",
        ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "このシステムでは、許可するまでインストール済みアプリの一覧が提供されません。許可すると、アプリごとのプロキシを設定できます。",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "アプリ一覧の権限が必要です",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage("スマート選択"),
    "interfaceName": MessageLookupByLibrary.simpleMessage("インターフェース名"),
    "interfaceNameDesc": MessageLookupByLibrary.simpleMessage(
      "アウトバウンド接続に使用するネットワークインターフェース名",
    ),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage(
      "アウトバウンドインターフェース",
    ),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("クリア"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage("カスタム"),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage("設定に従う"),
    "internet": MessageLookupByLibrary.simpleMessage("インターネット"),
    "interval": MessageLookupByLibrary.simpleMessage("間隔"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("イントラネットIP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage("無効なバックアップファイル"),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "DSCP マークは 63 を超えられません",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "tcp または udp のみ対応しています",
    ),
    "invalidPolicy": m19,
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "このQRコードにはプロファイルのリンクが含まれていません",
    ),
    "invalidProxy": m20,
    "invalidProxyProvider": m21,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "80 や 8000-9000 のような数値または範囲を / 区切りで入力してください",
    ),
    "invalidRuleSet": m22,
    "invalidSubRule": m23,
    "invalidTransferAmount": MessageLookupByLibrary.simpleMessage(
      "有効な送金額を入力してください",
    ),
    "invite": MessageLookupByLibrary.simpleMessage("招待"),
    "inviteCode": MessageLookupByLibrary.simpleMessage("招待コード"),
    "inviteCodeGenFailed": MessageLookupByLibrary.simpleMessage(
      "招待コードの生成に失敗しました",
    ),
    "inviteCodeIncorrect": MessageLookupByLibrary.simpleMessage(
      "招待コードが正しくない可能性があります。確認して再入力してください",
    ),
    "inviteCodeOptional": MessageLookupByLibrary.simpleMessage("招待コード（任意）"),
    "inviteCodeRequired": MessageLookupByLibrary.simpleMessage("招待コードが必要です"),
    "inviteCodeRequiredMessage": MessageLookupByLibrary.simpleMessage(
      "登録には招待コードが必要です。登録前に登録済みユーザーに連絡して招待コードを入手してください。",
    ),
    "inviteLinkCopied": MessageLookupByLibrary.simpleMessage(
      "招待リンクをコピーしました。友達と共有しましょう",
    ),
    "inviteRegisterReward": MessageLookupByLibrary.simpleMessage(
      "友達を招待して登録・購読してもらうと報酬が得られます",
    ),
    "inviteRules": MessageLookupByLibrary.simpleMessage("招待ルール"),
    "inviteStats": MessageLookupByLibrary.simpleMessage("招待統計"),
    "ipAddress": MessageLookupByLibrary.simpleMessage("IP アドレス"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("不正利用の履歴"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("プロキシ"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("検出"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("組織"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage(
      "IP タイプを判定できませんでした",
    ),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("良好"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("レベル"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("普通"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage("再確認"),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("リスクあり"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("採用したソース"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("各ソース"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage(
      "アウトバウンド IP が不一致",
    ),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("判定不可"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage("レート制限"),
    "ipType": MessageLookupByLibrary.simpleMessage("タイプ"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("ビジネス"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("データセンター"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("モバイル回線"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("住宅"),
    "ipcidr": MessageLookupByLibrary.simpleMessage("IPCIDR"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "有効にすると、IPv6トラフィックを受信できます",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage("IPv6インバウンドを許可します"),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage("IPv6タイムアウト（ms）"),
    "ja": MessageLookupByLibrary.simpleMessage("日本語"),
    "just": MessageLookupByLibrary.simpleMessage("たった今"),
    "justNow": MessageLookupByLibrary.simpleMessage("たった今"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "TCPキープアライブ間隔",
    ),
    "key": MessageLookupByLibrary.simpleMessage("キー"),
    "language": MessageLookupByLibrary.simpleMessage("言語"),
    "large": MessageLookupByLibrary.simpleMessage("大"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("最終更新"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage("起動が完了しませんでした"),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "前回、アプリは起動中に予期せず終了しました。今回の自動セットアップはスキップしました。手動で起動して再試行できます。",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("レイアウト"),
    "light": MessageLookupByLibrary.simpleMessage("ライト"),
    "lineIssueTip": m24,
    "lineWrap": MessageLookupByLibrary.simpleMessage("折り返し"),
    "list": MessageLookupByLibrary.simpleMessage("リスト"),
    "listen": MessageLookupByLibrary.simpleMessage("リッスン"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage("リッスンのルーティングマーク"),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage("Linuxのみ"),
    "liveConnections": MessageLookupByLibrary.simpleMessage("リアルタイム接続"),
    "loadMore": MessageLookupByLibrary.simpleMessage("もっと読み込む"),
    "loadTest": MessageLookupByLibrary.simpleMessage("読み込みテスト"),
    "loading": MessageLookupByLibrary.simpleMessage("読み込み中…"),
    "local": MessageLookupByLibrary.simpleMessage("ローカル"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage("ローカルにデータをバックアップ"),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "ローカルネットワークの権限が拒否されたため gvisor スタックを使用します。LAN にはアクセスできません。",
    ),
    "localRecoveryDesc": MessageLookupByLibrary.simpleMessage("ファイルからデータを復元"),
    "locationPermission": MessageLookupByLibrary.simpleMessage("位置情報の権限"),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "位置情報の権限が拒否されたため、現在の Wi-Fi 名を取得できません。システム設定で位置情報の権限を手動で有効にしてください。",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "システムの要件により、Wi-Fi 名の取得には位置情報の権限が必要です。Android では「常に許可」を選択してください。そうしないと、アプリがバックグラウンドにあるときに Wi-Fi 名を取得できません。",
    ),
    "locationPermissionGuide": m25,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "位置情報の権限が必要です",
    ),
    "log": MessageLookupByLibrary.simpleMessage("ログ"),
    "logLevel": MessageLookupByLibrary.simpleMessage("ログレベル"),
    "logcat": MessageLookupByLibrary.simpleMessage("ログキャプチャ"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage("無効にするとログの入り口が非表示になります"),
    "loggedOutSuccess": MessageLookupByLibrary.simpleMessage("ログアウトしました"),
    "loginNow": MessageLookupByLibrary.simpleMessage("今すぐログイン"),
    "logout": MessageLookupByLibrary.simpleMessage("ログアウト"),
    "logoutConfirmMsg": MessageLookupByLibrary.simpleMessage(
      "ログアウトしますか？再度ログインが必要です。",
    ),
    "logoutFailed": m26,
    "logs": MessageLookupByLibrary.simpleMessage("ログ"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage("ログと診断"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("ログキャプチャ記録"),
    "logsTest": MessageLookupByLibrary.simpleMessage("ログテスト"),
    "loopback": MessageLookupByLibrary.simpleMessage("UWP ループバック解除"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage("UWPループバック解除用"),
    "loose": MessageLookupByLibrary.simpleMessage("ゆったり"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage("送信元IPにマッチ"),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("最大失敗回数"),
    "maxLengthTip": m27,
    "maxTransferable": m28,
    "maximize": MessageLookupByLibrary.simpleMessage("最大化"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage("常駐メモリ"),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage("アプリと共有"),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage("未使用のヒープ"),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage("使用中のヒープ"),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage(
      "コアは実行されていません",
    ),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage("ランタイムのオーバーヘッド"),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage("ゴルーチンスタック"),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "プロセスの常駐メモリからの推定値で、システムの表示とは異なる場合があります。",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "コアはアプリと同じプロセスで動作します。コア分はランタイム統計から推定し、残りはアプリと共有メモリとして計上します。",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("メモリ情報"),
    "memoryReleased": MessageLookupByLibrary.simpleMessage("メモリを解放しました"),
    "memoryReleasedSize": m29,
    "messageTest": MessageLookupByLibrary.simpleMessage("メッセージテスト"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("これはメッセージです。"),
    "min": MessageLookupByLibrary.simpleMessage("最小"),
    "minimize": MessageLookupByLibrary.simpleMessage("最小化"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("終了時に最小化"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "システムの終了イベントを変更",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("分"),
    "minutesAgo": m30,
    "mixedPort": MessageLookupByLibrary.simpleMessage("Mixedポート"),
    "mode": MessageLookupByLibrary.simpleMessage("モード"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("モノクローム"),
    "months": MessageLookupByLibrary.simpleMessage("月"),
    "monthsAgo": m31,
    "more": MessageLookupByLibrary.simpleMessage("その他"),
    "myInviteQr": MessageLookupByLibrary.simpleMessage("マイ招待QR"),
    "name": MessageLookupByLibrary.simpleMessage("名前"),
    "nameSort": MessageLookupByLibrary.simpleMessage("名前順"),
    "nameserver": MessageLookupByLibrary.simpleMessage("ネームサーバー"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage("ドメイン解決用"),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage("ネームサーバーポリシー"),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "対応するネームサーバーポリシーを指定",
    ),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage("ボトムバー"),
    "network": MessageLookupByLibrary.simpleMessage("ネットワーク"),
    "networkAccessDeniedError": m32,
    "networkBadResponseError": m33,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage(
      "リクエストはキャンセルされました",
    ),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "サーバーに接続できませんでした。ネットワーク接続またはプロキシ設定を確認してください",
    ),
    "networkDesc": MessageLookupByLibrary.simpleMessage("ネットワーク関連設定の変更"),
    "networkDetection": MessageLookupByLibrary.simpleMessage("ネットワーク検出"),
    "networkException": MessageLookupByLibrary.simpleMessage(
      "ネットワーク例外、接続を確認してもう一度お試しください",
    ),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "サーバーのアドレスを解決できませんでした。URL が正しいこと、DNS が使えることを確認してください",
    ),
    "networkNotFoundError": m34,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "リクエストが多すぎます（HTTP 429）。しばらく待ってから再試行してください",
    ),
    "networkRequestFailed": m35,
    "networkServerError": m36,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("ネットワーク速度"),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "リクエストがタイムアウトしました。ネットワークまたはプロキシを確認してから再試行してください",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "安全な接続に失敗しました。サーバー証明書が無効か、接続が傍受されている可能性があります",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("ネットワーク種別"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("ニュートラル"),
    "newMessageFromSupport": MessageLookupByLibrary.simpleMessage(
      "サポートから新しいメッセージがあります",
    ),
    "newPassword": MessageLookupByLibrary.simpleMessage("新しいパスワード"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("次の一致"),
    "no": MessageLookupByLibrary.simpleMessage("いいえ"),
    "noCommissionRecord": MessageLookupByLibrary.simpleMessage("報酬記録がありません"),
    "noData": MessageLookupByLibrary.simpleMessage("データがありません"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("ホットキーなし"),
    "noIcon": MessageLookupByLibrary.simpleMessage("なし"),
    "noInfo": MessageLookupByLibrary.simpleMessage("情報がありません"),
    "noInvitationData": MessageLookupByLibrary.simpleMessage("招待データがありません"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage("今後表示しない"),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage("追加情報なし"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("ネットワークがありません"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("ネットワーク不使用アプリ"),
    "noProxy": MessageLookupByLibrary.simpleMessage("プロキシなし"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイルを作成するか、有効なプロファイルを追加してください",
    ),
    "noRecords": MessageLookupByLibrary.simpleMessage("記録がありません"),
    "noResolve": MessageLookupByLibrary.simpleMessage("IPを解決しない"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage("ホスト名を解決しない"),
    "noSearchResults": MessageLookupByLibrary.simpleMessage("一致する結果はありません"),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage(
      "この外部リソースはテキストファイルではありません",
    ),
    "none": MessageLookupByLibrary.simpleMessage("なし"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "現在のプロキシグループは選択できません",
    ),
    "ntpInterval": MessageLookupByLibrary.simpleMessage("同期間隔（分）"),
    "ntpStatusDesc": MessageLookupByLibrary.simpleMessage(
      "システムクロックではなくNTPサーバーから時刻を取得します",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイルを追加して始めましょう",
    ),
    "nullTip": m37,
    "numberTip": m38,
    "onDemand": MessageLookupByLibrary.simpleMessage("オンデマンド"),
    "onDemandDesc": MessageLookupByLibrary.simpleMessage(
      "特定のシナリオでのアプリの実行状態を設定します",
    ),
    "oneColumn": MessageLookupByLibrary.simpleMessage("1列"),
    "onlineSupport": MessageLookupByLibrary.simpleMessage("オンラインサポート"),
    "onlineSupportAddMore": MessageLookupByLibrary.simpleMessage("さらに追加"),
    "onlineSupportApiConfigNotFound": MessageLookupByLibrary.simpleMessage(
      "オンラインサポートAPI設定が見つかりません。設定を確認してください",
    ),
    "onlineSupportCancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "onlineSupportClearHistory": MessageLookupByLibrary.simpleMessage("履歴をクリア"),
    "onlineSupportClearHistoryConfirm": MessageLookupByLibrary.simpleMessage(
      "すべてのチャット履歴をクリアしてもよろしいですか？この操作は元に戻せません。",
    ),
    "onlineSupportClickToSelect": MessageLookupByLibrary.simpleMessage(
      "クリックして画像を選択",
    ),
    "onlineSupportConfirm": MessageLookupByLibrary.simpleMessage("確認"),
    "onlineSupportConnected": MessageLookupByLibrary.simpleMessage(
      "サポートシステムに正常に接続しました",
    ),
    "onlineSupportConnecting": MessageLookupByLibrary.simpleMessage("接続中..."),
    "onlineSupportConnectionError": MessageLookupByLibrary.simpleMessage(
      "接続エラー",
    ),
    "onlineSupportDisconnected": MessageLookupByLibrary.simpleMessage(
      "切断されました",
    ),
    "onlineSupportGetMessagesFailed": m39,
    "onlineSupportInputHint": MessageLookupByLibrary.simpleMessage(
      "ご質問を入力してください...",
    ),
    "onlineSupportNoMessages": MessageLookupByLibrary.simpleMessage(
      "メッセージがありません。メッセージを送信して相談を開始してください",
    ),
    "onlineSupportSelectImages": MessageLookupByLibrary.simpleMessage("画像を選択"),
    "onlineSupportSelectImagesFailed": m40,
    "onlineSupportSend": MessageLookupByLibrary.simpleMessage("送信"),
    "onlineSupportSendImage": MessageLookupByLibrary.simpleMessage("画像を送信"),
    "onlineSupportSendMessageFailed": MessageLookupByLibrary.simpleMessage(
      "メッセージの送信に失敗しました: 認証トークンを取得できません",
    ),
    "onlineSupportSupportedFormats": MessageLookupByLibrary.simpleMessage(
      "JPG、PNG、GIF、WebP、BMP対応\n最大10MB",
    ),
    "onlineSupportTitle": MessageLookupByLibrary.simpleMessage("オンラインサポート"),
    "onlineSupportTokenNotFound": MessageLookupByLibrary.simpleMessage(
      "認証トークンが見つかりません",
    ),
    "onlineSupportUnsupportedHttpMethod": m41,
    "onlineSupportUploadFailed": m42,
    "onlineSupportWebSocketConfigNotFound":
        MessageLookupByLibrary.simpleMessage(
          "オンラインサポートWebSocket設定が見つかりません。設定を確認してください",
        ),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("アイコンのみ"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage("サードパーティアプリのみ"),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "プロキシトラフィックのみ集計",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "有効化するとプロキシトラフィックのみ統計",
    ),
    "openWebFailed": MessageLookupByLibrary.simpleMessage(
      "Webを開けませんでした。手動でアクセスしてください",
    ),
    "optional": MessageLookupByLibrary.simpleMessage("任意"),
    "options": MessageLookupByLibrary.simpleMessage("オプション"),
    "orderAmount": m43,
    "orderNumber": m44,
    "other": MessageLookupByLibrary.simpleMessage("その他"),
    "otherContributors": MessageLookupByLibrary.simpleMessage("その他の貢献者"),
    "outboundIp": MessageLookupByLibrary.simpleMessage("アウトバウンド IP"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("アウトバウンドモード"),
    "override": MessageLookupByLibrary.simpleMessage("上書き"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage("プロキシ関連設定を上書き"),
    "overrideDns": MessageLookupByLibrary.simpleMessage("DNSを上書き"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "有効化するとプロファイルのDNS設定を上書き",
    ),
    "overrideEntries": MessageLookupByLibrary.simpleMessage("上書き項目"),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage(
      "スクリプトモードでは有効になりません",
    ),
    "overrideMode": MessageLookupByLibrary.simpleMessage("上書きモード"),
    "overrideNtp": MessageLookupByLibrary.simpleMessage("NTPを上書き"),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage("元のルールを上書き"),
    "overrideScript": MessageLookupByLibrary.simpleMessage("上書きスクリプト"),
    "overwriteIssueCoreRejected": m45,
    "overwriteIssueDuplicateName": m46,
    "overwriteIssueEmptyName": MessageLookupByLibrary.simpleMessage("名前が空です"),
    "overwriteIssueGroupLoop": m47,
    "overwriteIssueMissingProviders": m48,
    "overwriteIssueMissingProxies": m49,
    "overwriteIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "プロキシもプロキシプロバイダーも選択されていないため、コアはこのグループを拒否します",
    ),
    "overwriteIssueReservedName": m50,
    "overwriteIssueSubscriptionGroupMissingProxies": m51,
    "overwriteIssuesSummary": m52,
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage("カスタム"),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "カスタムモード：プロキシ、プロキシグループ、ルールを完全にカスタマイズできます",
    ),
    "pageNumber": m53,
    "palette": MessageLookupByLibrary.simpleMessage("パレット"),
    "password": MessageLookupByLibrary.simpleMessage("パスワード"),
    "passwordMin8Chars": MessageLookupByLibrary.simpleMessage(
      "パスワードは8文字以上である必要があります",
    ),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "パスワードは6文字以上である必要があります",
    ),
    "passwordMismatch": MessageLookupByLibrary.simpleMessage("パスワードが一致しません"),
    "passwordResetFailed": MessageLookupByLibrary.simpleMessage(
      "パスワードのリセットに失敗しました",
    ),
    "passwordResetSuccessful": MessageLookupByLibrary.simpleMessage(
      "パスワードのリセットが完了しました。新しいパスワードでログインしてください",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage("パスワードが一致しません"),
    "paste": MessageLookupByLibrary.simpleMessage("貼り付け"),
    "pendingCommission": MessageLookupByLibrary.simpleMessage("保留中"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage("アルバムから選択"),
    "pinWindow": MessageLookupByLibrary.simpleMessage("最前面に固定"),
    "plans": MessageLookupByLibrary.simpleMessage("プラン"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage("WebDAVを連携してください"),
    "pleaseConfirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "新しいパスワードをもう一度入力してください",
    ),
    "pleaseConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "パスワードを確認してください",
    ),
    "pleaseEnterAtLeast8CharsPassword": MessageLookupByLibrary.simpleMessage(
      "8文字以上のパスワードを入力してください",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "メールアドレスを入力してください",
    ),
    "pleaseEnterEmailAddress": MessageLookupByLibrary.simpleMessage(
      "メールアドレスを入力してください",
    ),
    "pleaseEnterEmailVerificationCode": MessageLookupByLibrary.simpleMessage(
      "メール認証コードを入力してください",
    ),
    "pleaseEnterInviteCode": MessageLookupByLibrary.simpleMessage(
      "招待コードを入力してください",
    ),
    "pleaseEnterNewPassword": MessageLookupByLibrary.simpleMessage(
      "新しいパスワードを入力してください",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "パスワードを入力してください",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "スクリプト名を入力してください",
    ),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "有効なメールアドレスを入力してください",
    ),
    "pleaseEnterValidEmailAddress": MessageLookupByLibrary.simpleMessage(
      "有効なメールアドレスを入力してください",
    ),
    "pleaseEnterValidVerificationCode": MessageLookupByLibrary.simpleMessage(
      "有効な認証コードを入力してください",
    ),
    "pleaseEnterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "メール認証コードを入力してください",
    ),
    "pleaseEnterYourEmailAddress": MessageLookupByLibrary.simpleMessage(
      "メールアドレスを入力してください",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "管理者パスワードを入力",
    ),
    "pleaseReEnterPassword": MessageLookupByLibrary.simpleMessage(
      "パスワードをもう一度入力してください",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage(
      "ファイルをアップロードしてください",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "有効なQRコードをアップロードしてください",
    ),
    "port": MessageLookupByLibrary.simpleMessage("ポート"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage("別のポートを入力してください"),
    "portTip": m54,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage("DOHのHTTP/3を優先使用"),
    "prerequisites": MessageLookupByLibrary.simpleMessage("前提条件"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage("キーの組み合わせを押してください"),
    "preview": MessageLookupByLibrary.simpleMessage("プレビュー"),
    "previousMatch": MessageLookupByLibrary.simpleMessage("前の一致"),
    "process": MessageLookupByLibrary.simpleMessage("プロセス"),
    "profile": MessageLookupByLibrary.simpleMessage("プロファイル"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("有効な間隔を入力してください"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage("自動更新間隔を入力してください"),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "プロファイルが変更されています。自動更新を無効にしますか？",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイル名を入力してください",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイル解析エラー",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "有効なプロファイルURLを入力してください",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイルのURLを入力してください",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("プロファイル"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("プロファイルの並べ替え"),
    "project": MessageLookupByLibrary.simpleMessage("プロジェクト"),
    "providerInUse": m55,
    "providerRenameShadowed": m56,
    "providerSourceSubscription": MessageLookupByLibrary.simpleMessage(
      "サブスクリプション",
    ),
    "providerUrlTip": MessageLookupByLibrary.simpleMessage("リモートリソースのみ対応しています"),
    "providers": MessageLookupByLibrary.simpleMessage("外部リソース"),
    "proxies": MessageLookupByLibrary.simpleMessage("プロキシ"),
    "proxiesCount": m57,
    "proxiesEmpty": MessageLookupByLibrary.simpleMessage("プロキシが空です"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("プロキシ設定"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("プロキシチェーン"),
    "proxyDefinition": MessageLookupByLibrary.simpleMessage("完全な設定"),
    "proxyDefinitionNotMap": MessageLookupByLibrary.simpleMessage(
      "設定は name と type を含む YAML マッピングである必要があります",
    ),
    "proxyDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "選択されたプロキシに異常があることを検出しました",
    ),
    "proxyFilter": MessageLookupByLibrary.simpleMessage("ノードフィルター"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("プロキシグループ"),
    "proxyGroupDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "現在のプロキシグループが異常であることを検出しました",
    ),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage("プロキシグループが空です"),
    "proxyGroupNameDuplicate": MessageLookupByLibrary.simpleMessage(
      "プロキシグループ名が重複しています",
    ),
    "proxyGroupNameEmpty": MessageLookupByLibrary.simpleMessage(
      "プロキシグループ名は空にできません",
    ),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("プロキシネームサーバー"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "プロキシノード解決用ドメイン",
    ),
    "proxyNode": MessageLookupByLibrary.simpleMessage("プロキシノード"),
    "proxyPort": MessageLookupByLibrary.simpleMessage("プロキシポート"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage("Clashのリスニングポートを設定"),
    "proxyProviderDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "選択されたプロキシプロバイダーに異常があることを検出しました",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("プロキシプロバイダー"),
    "proxyProvidersEmpty": MessageLookupByLibrary.simpleMessage(
      "プロキシプロバイダーが空です",
    ),
    "proxyProvidersNotEmpty": MessageLookupByLibrary.simpleMessage(
      "プロキシプロバイダーは空にできません",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("プロキシタイプ"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("キャッシュを整理"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("ピュアブラック"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("ピュアブラックモード"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QRコード"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "QRコードをスキャンしてプロファイルを取得します",
    ),
    "quickAdd": MessageLookupByLibrary.simpleMessage("クイック追加"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("クイック編集"),
    "quickFill": MessageLookupByLibrary.simpleMessage("クイック入力"),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("レインボー"),
    "recentRequests": MessageLookupByLibrary.simpleMessage("最近のリクエスト"),
    "recordType": MessageLookupByLibrary.simpleMessage("レコードタイプ"),
    "recovery": MessageLookupByLibrary.simpleMessage("復元"),
    "recoveryAll": MessageLookupByLibrary.simpleMessage("全データ復元"),
    "recoveryProfiles": MessageLookupByLibrary.simpleMessage("プロファイルのみ復元"),
    "recoveryStrategy": MessageLookupByLibrary.simpleMessage("リカバリー戦略"),
    "recoveryStrategy_compatible": MessageLookupByLibrary.simpleMessage("互換性"),
    "recoveryStrategy_override": MessageLookupByLibrary.simpleMessage(
      "オーバーライド",
    ),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage("復元成功"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redirポート"),
    "redo": MessageLookupByLibrary.simpleMessage("やり直す"),
    "refresh": MessageLookupByLibrary.simpleMessage("更新"),
    "regExp": MessageLookupByLibrary.simpleMessage("正規表現"),
    "registerAccount": MessageLookupByLibrary.simpleMessage("アカウント登録"),
    "registerSuccessSaveCredentials": MessageLookupByLibrary.simpleMessage(
      "登録が完了しました - 資格情報を保存中:",
    ),
    "registrationFailed": m58,
    "releaseMemory": MessageLookupByLibrary.simpleMessage("メモリを解放"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage(
      "メモリの解放に失敗しました",
    ),
    "rememberPassword": MessageLookupByLibrary.simpleMessage("パスワードを記憶しますか？"),
    "remote": MessageLookupByLibrary.simpleMessage("リモート"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "WebDAVにデータをバックアップ",
    ),
    "remoteDestination": MessageLookupByLibrary.simpleMessage("リモート宛先"),
    "remoteRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "WebDAVからデータを復元",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("削除"),
    "rename": MessageLookupByLibrary.simpleMessage("リネーム"),
    "replace": MessageLookupByLibrary.simpleMessage("置換"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("すべて置換"),
    "request": MessageLookupByLibrary.simpleMessage("リクエスト"),
    "requests": MessageLookupByLibrary.simpleMessage("リクエスト"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage("リクエストと更新"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage("最近のリクエスト記録を表示"),
    "resendVerificationCode": MessageLookupByLibrary.simpleMessage("認証コードを再送信"),
    "reset": MessageLookupByLibrary.simpleMessage("リセット"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "このページには変更があります。リセットしてもよろしいですか？",
    ),
    "resetPassword": MessageLookupByLibrary.simpleMessage("パスワードをリセット"),
    "resetTip": MessageLookupByLibrary.simpleMessage("リセットしてもよろしいですか？"),
    "resources": MessageLookupByLibrary.simpleMessage("リソース"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage("外部リソース関連情報"),
    "respectRules": MessageLookupByLibrary.simpleMessage("ルールに従う"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS接続がルールに従います。Proxy Server Nameserverの設定が必要です",
    ),
    "responseCode": MessageLookupByLibrary.simpleMessage("応答コード"),
    "restart": MessageLookupByLibrary.simpleMessage("再起動"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage("コアを再起動してもよろしいですか？"),
    "restore": MessageLookupByLibrary.simpleMessage("復元"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("すべてのデータを復元"),
    "restoreException": MessageLookupByLibrary.simpleMessage("復元例外"),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage(
      "ファイルを介してデータを復元する",
    ),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "WebDAVを介してデータを復元する",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage("プロファイルのみ復元"),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("復元方式"),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage("互換"),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage("上書き"),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage("互換"),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage("上書き"),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage("復元が完了しました"),
    "retry": MessageLookupByLibrary.simpleMessage("再試行"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("ルートアドレス"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage("ルートアドレスを設定"),
    "routeMode": MessageLookupByLibrary.simpleMessage("ルートモード"),
    "routeModeBypassPrivate": MessageLookupByLibrary.simpleMessage(
      "プライベートアドレスをバイパス",
    ),
    "routeModeConfig": MessageLookupByLibrary.simpleMessage("設定を使用"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "プライベートルートをバイパス",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("設定を使用"),
    "ru": MessageLookupByLibrary.simpleMessage("ロシア語"),
    "rule": MessageLookupByLibrary.simpleMessage("ルール"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage("論理ルール AND"),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage("完全なドメインにマッチ"),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "ドメインキーワードにマッチ",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "ドメインの正規表現でマッチ",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "ドメインサフィックスにマッチ",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "ワイルドカードでマッチ（* と ? のみ対応）",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "DSCPマークにマッチ（tproxy udpインバウンドのみ）",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "宛先ポート範囲にマッチ",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage("IPの国コードにマッチ"),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Geosite 内のドメインにマッチ",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage("インバウンド名にマッチ"),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "インバウンドポートにマッチ",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "インバウンドタイプにマッチ",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "インバウンドユーザー名にマッチ（/ で複数指定可）",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "IPが属するASNにマッチ",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "IPアドレス範囲にマッチ（IP-CIDR6 は別名です）",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "IPアドレス範囲にマッチ",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "IPサフィックス範囲にマッチ",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "すべてのリクエストにマッチ（条件不要）",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "TCPまたはUDPにマッチ",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage("論理ルール NOT"),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage("論理ルール OR"),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "プロセス名でマッチ（Androidではパッケージ名にマッチ）",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "プロセス名の正規表現でマッチ（Androidではパッケージ名にマッチ）",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "プロセス名のワイルドカードでマッチ（* と ? のみ対応）",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "プロセスのフルパスでマッチ",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "プロセスパスの正規表現でマッチ",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "プロセスパスのワイルドカードでマッチ（* と ? のみ対応）",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "再マッチ名にマッチ（複数は / で区切る）",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "ルールセットを参照します。rule-providersの設定が必要です",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "送信元IPの国コードにマッチ",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "送信元IPが属するASNにマッチ",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "送信元IPアドレス範囲にマッチ",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "送信元IPサフィックス範囲にマッチ",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "送信元ポート範囲にマッチ",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "サブルールへマッチします。括弧の使い方に注意してください",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "LinuxのユーザーIDにマッチ",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("ルールが空です"),
    "ruleName": MessageLookupByLibrary.simpleMessage("ルール名"),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BitTorrent を直接接続",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "DNS over TLS をブロック",
    ),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage("QUIC をブロック"),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage("STUN をブロック"),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage("LAN 直接接続"),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple と Microsoft に直接接続",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("ルールプロバイダー"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("ルールセット"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("ルールターゲット"),
    "rules": MessageLookupByLibrary.simpleMessage("ルール"),
    "rulesCount": m59,
    "runTime": MessageLookupByLibrary.simpleMessage("起動時間"),
    "safeMode": MessageLookupByLibrary.simpleMessage("セーフモード"),
    "safeModeAppTitle": m60,
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("変更を保存しますか？"),
    "saveQr": MessageLookupByLibrary.simpleMessage("QRを保存"),
    "saveQrCodeFeature": MessageLookupByLibrary.simpleMessage(
      "QR保存機能は近日公開予定です",
    ),
    "saveTip": MessageLookupByLibrary.simpleMessage("保存してもよろしいですか？"),
    "script": MessageLookupByLibrary.simpleMessage("スクリプト"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "スクリプトモード：外部の拡張スクリプトを使用し、ワンクリックで設定を上書きします",
    ),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage("選択項目へスクロール"),
    "search": MessageLookupByLibrary.simpleMessage("検索"),
    "seconds": MessageLookupByLibrary.simpleMessage("秒"),
    "secondsCount": m61,
    "selectAll": MessageLookupByLibrary.simpleMessage("すべて選択"),
    "selectProxies": MessageLookupByLibrary.simpleMessage("プロキシを選択"),
    "selectProxyProviders": MessageLookupByLibrary.simpleMessage(
      "プロキシプロバイダーを選択",
    ),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage("ルールセットを選択してください"),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "振り分け戦略を選択してください",
    ),
    "selectSubRule": MessageLookupByLibrary.simpleMessage("サブルールを選択してください"),
    "selectTheme": MessageLookupByLibrary.simpleMessage("テーマを選択"),
    "selected": MessageLookupByLibrary.simpleMessage("選択済み"),
    "selectedCountTitle": m62,
    "sendCodeFailed": MessageLookupByLibrary.simpleMessage("認証コードの送信に失敗しました"),
    "sendVerificationCode": MessageLookupByLibrary.simpleMessage("認証コードを送信"),
    "sendVerificationCodeFailed": m63,
    "server": MessageLookupByLibrary.simpleMessage("サーバー"),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("利用可能"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("ブロック済み"),
    "serviceCheck": MessageLookupByLibrary.simpleMessage("検査"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("すべて検査"),
    "serviceCheckedAt": m64,
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("近日提供予定"),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage(
      "許可されていない ISP",
    ),
    "serviceFailed": MessageLookupByLibrary.simpleMessage("検出に失敗しました"),
    "serviceManage": MessageLookupByLibrary.simpleMessage("サービスを管理"),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage("オリジナル作品のみ"),
    "servicePending": MessageLookupByLibrary.simpleMessage("未検査"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage("アクセス制限"),
    "serviceStatus": MessageLookupByLibrary.simpleMessage("サービスの状態"),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("利用不可"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage("対象外の地域"),
    "setNewPassword": MessageLookupByLibrary.simpleMessage("新しいパスワードを設定"),
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "show": MessageLookupByLibrary.simpleMessage("表示"),
    "showLess": MessageLookupByLibrary.simpleMessage("折りたたむ"),
    "showMore": MessageLookupByLibrary.simpleMessage("展開"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "通知に停止ボタンを表示",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage("パスワードを表示"),
    "shrink": MessageLookupByLibrary.simpleMessage("コンパクト"),
    "sidebarBlur": MessageLookupByLibrary.simpleMessage("サイドバーのぼかし"),
    "sidebarBlurDesc": MessageLookupByLibrary.simpleMessage(
      "ウィンドウ背後のデスクトップをぼかしてサイドバーに透過します",
    ),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("サイレント起動"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "起動時にウィンドウを表示しません",
    ),
    "singleAdd": MessageLookupByLibrary.simpleMessage("個別追加"),
    "singleValueTip": m65,
    "size": MessageLookupByLibrary.simpleMessage("サイズ"),
    "slide": MessageLookupByLibrary.simpleMessage("スライド"),
    "socksPort": MessageLookupByLibrary.simpleMessage("SOCKSポート"),
    "sort": MessageLookupByLibrary.simpleMessage("並べ替え"),
    "source": MessageLookupByLibrary.simpleMessage("ソース"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("送信元IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("特殊プロキシ"),
    "specialRules": MessageLookupByLibrary.simpleMessage("特殊ルール"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("速度統計"),
    "splitStrategy": MessageLookupByLibrary.simpleMessage("振り分け戦略"),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "振り分け戦略は空にできません",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("SSIDが空です"),
    "stackMode": MessageLookupByLibrary.simpleMessage("スタックモード"),
    "standard": MessageLookupByLibrary.simpleMessage("標準"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "標準モード：基本設定を上書きし、シンプルなルール追加機能を提供します",
    ),
    "start": MessageLookupByLibrary.simpleMessage("開始"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage("最初から作成"),
    "startVpn": MessageLookupByLibrary.simpleMessage("VPNを起動しています…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage("起動とバックグラウンド"),
    "status": MessageLookupByLibrary.simpleMessage("状態"),
    "statusDesc": MessageLookupByLibrary.simpleMessage("無効にすると、システムDNSを使用します"),
    "stop": MessageLookupByLibrary.simpleMessage("停止"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("VPNを停止しています…"),
    "strategy": MessageLookupByLibrary.simpleMessage("戦略"),
    "style": MessageLookupByLibrary.simpleMessage("スタイル"),
    "subRule": MessageLookupByLibrary.simpleMessage("サブルール"),
    "subRuleEmpty": MessageLookupByLibrary.simpleMessage("サブルールが空です"),
    "subRuleNotEmpty": MessageLookupByLibrary.simpleMessage("サブルールは空にできません"),
    "submit": MessageLookupByLibrary.simpleMessage("送信"),
    "subscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションが期限切れです",
    ),
    "subscriptionExpiredDetail": m66,
    "subscriptionExpiresToday": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションが本日期限切れ",
    ),
    "subscriptionExpiresTodayDetail": MessageLookupByLibrary.simpleMessage(
      "プランが本日期限切れになります。サービス中断を避けるため即座に更新してください",
    ),
    "subscriptionExpiringInDays": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションがまもなく期限切れ",
    ),
    "subscriptionExpiringInDaysDetail": m67,
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage("サブスクリプション情報"),
    "subscriptionNoSubscription": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションがありません",
    ),
    "subscriptionNoSubscriptionDetail": MessageLookupByLibrary.simpleMessage(
      "利用可能なサブスクリプションプランが見つかりません。ご利用にはプランをご購入ください",
    ),
    "subscriptionNotLoggedIn": MessageLookupByLibrary.simpleMessage("未ログイン"),
    "subscriptionNotLoggedInDetail": MessageLookupByLibrary.simpleMessage(
      "まずログインしてください",
    ),
    "subscriptionTrafficExhausted": MessageLookupByLibrary.simpleMessage(
      "トラフィックを使い切りました",
    ),
    "subscriptionTrafficExhaustedDetail": MessageLookupByLibrary.simpleMessage(
      "プランのトラフィックを使い切りました。より多くのトラフィックを購入するかプランをアップグレードしてください",
    ),
    "subscriptionValid": MessageLookupByLibrary.simpleMessage("サブスクリプション有効"),
    "subscriptionValidDetail": m68,
    "suspended": MessageLookupByLibrary.simpleMessage("一時停止中…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("プロファイルを切り替え"),
    "switchTheme": MessageLookupByLibrary.simpleMessage("テーマを切り替え"),
    "sync": MessageLookupByLibrary.simpleMessage("同期"),
    "system": MessageLookupByLibrary.simpleMessage("システム"),
    "systemApp": MessageLookupByLibrary.simpleMessage("システムアプリ"),
    "systemFont": MessageLookupByLibrary.simpleMessage("システムフォント"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("システムプロキシ"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "HTTPプロキシをVpnServiceに接続",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("タブ"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("タブアニメーション"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage("モバイル表示でのみ有効"),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage("タップして許可"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP同時接続"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage("TCP並列処理を許可"),
    "testInterval": MessageLookupByLibrary.simpleMessage("テスト間隔"),
    "testUrl": MessageLookupByLibrary.simpleMessage("テストURL"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage("使用時にテスト"),
    "textScale": MessageLookupByLibrary.simpleMessage("テキストの拡大縮小"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage(
      "アプリ内の文字はこの大きさで表示されます",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("テーマ"),
    "themeColor": MessageLookupByLibrary.simpleMessage("テーマカラー"),
    "themeDesc": MessageLookupByLibrary.simpleMessage("ダークモードの設定と色の調整"),
    "themeMode": MessageLookupByLibrary.simpleMessage("テーマモード"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("3列"),
    "tight": MessageLookupByLibrary.simpleMessage("コンパクト"),
    "time": MessageLookupByLibrary.simpleMessage("時刻"),
    "timeout": MessageLookupByLibrary.simpleMessage("タイムアウト"),
    "tip": MessageLookupByLibrary.simpleMessage("ヒント"),
    "toggle": MessageLookupByLibrary.simpleMessage("切り替え"),
    "tolerance": MessageLookupByLibrary.simpleMessage("許容値"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("トーナルスポット"),
    "tools": MessageLookupByLibrary.simpleMessage("ツール"),
    "torch": MessageLookupByLibrary.simpleMessage("ライト"),
    "total": MessageLookupByLibrary.simpleMessage("合計"),
    "totalCommission": MessageLookupByLibrary.simpleMessage("収益"),
    "totalInvites": MessageLookupByLibrary.simpleMessage("招待数"),
    "totalRecords": m69,
    "totalTraffic": MessageLookupByLibrary.simpleMessage("合計トラフィック"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("TProxyポート"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("トラフィック統計"),
    "transfer": MessageLookupByLibrary.simpleMessage("送金"),
    "transferAmount": MessageLookupByLibrary.simpleMessage("送金額"),
    "transferAmountExceeded": m70,
    "transferFailed": m71,
    "transferNote": MessageLookupByLibrary.simpleMessage(
      "送金した残高はアプリ内購入に利用できます",
    ),
    "transferSuccess": MessageLookupByLibrary.simpleMessage("送金が完了しました！"),
    "transferSuccessMsg": m72,
    "transferToWallet": MessageLookupByLibrary.simpleMessage("ウォレットへ送金"),
    "transferring": MessageLookupByLibrary.simpleMessage("送金中..."),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage("管理者モードでのみ有効"),
    "turnOff": MessageLookupByLibrary.simpleMessage("オフにする"),
    "turnOn": MessageLookupByLibrary.simpleMessage("オンにする"),
    "twoColumns": MessageLookupByLibrary.simpleMessage("2列"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "現在のプロファイルを更新できません",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("元に戻す"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("統一遅延"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "ハンドシェイクなどの余分な遅延を削除",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("不明"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage("不明なネットワークエラー"),
    "unmaximize": MessageLookupByLibrary.simpleMessage("元に戻す"),
    "unnamed": MessageLookupByLibrary.simpleMessage("名称未設定"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage("固定を解除"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "updateCheckAllServersUnavailable": MessageLookupByLibrary.simpleMessage(
      "設定されたすべてのアップデートサーバーが利用できません",
    ),
    "updateCheckCurrentVersion": m73,
    "updateCheckForceUpdate": m74,
    "updateCheckMustUpdate": MessageLookupByLibrary.simpleMessage("アップデート必須"),
    "updateCheckNewVersionFound": m75,
    "updateCheckNoServerUrlsConfigured": MessageLookupByLibrary.simpleMessage(
      "アップデートサーバーURLが設定されていません。設定を確認してください",
    ),
    "updateCheckReleaseNotes": MessageLookupByLibrary.simpleMessage("リリースノート："),
    "updateCheckServerError": m76,
    "updateCheckServerTemporarilyUnavailable":
        MessageLookupByLibrary.simpleMessage(
          "サーバーが一時的に利用できません。しばらくしてから再試行してください",
        ),
    "updateCheckServerUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "アップデートサーバーURLが設定されていません。設定を確認してください",
    ),
    "updateCheckUpdateLater": MessageLookupByLibrary.simpleMessage("後でアップデート"),
    "updateCheckUpdateNow": MessageLookupByLibrary.simpleMessage("今すぐアップデート"),
    "upload": MessageLookupByLibrary.simpleMessage("アップロード"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage("URLからプロファイルを取得します"),
    "urlTip": m77,
    "useHosts": MessageLookupByLibrary.simpleMessage("Hostsを使用"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("システムのHostsを使用"),
    "usedTraffic": MessageLookupByLibrary.simpleMessage("使用済みトラフィック"),
    "userAgent": MessageLookupByLibrary.simpleMessage("User-Agent"),
    "userCenter": MessageLookupByLibrary.simpleMessage("ユーザーセンター"),
    "value": MessageLookupByLibrary.simpleMessage("値"),
    "verificationCode": MessageLookupByLibrary.simpleMessage("認証コード"),
    "verificationCode6Digits": MessageLookupByLibrary.simpleMessage(
      "認証コードは6桁である必要があります",
    ),
    "verificationCodeSent": MessageLookupByLibrary.simpleMessage(
      "認証コードをメールに送信しました。ご確認ください",
    ),
    "verificationCodeSentCheckEmail": MessageLookupByLibrary.simpleMessage(
      "認証コードを送信しました。メールをご確認ください",
    ),
    "verificationCodeSentTo": m78,
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("ビブラント"),
    "view": MessageLookupByLibrary.simpleMessage("表示"),
    "viewHistory": MessageLookupByLibrary.simpleMessage("履歴を見る"),
    "visitWebVersion": MessageLookupByLibrary.simpleMessage(
      "出金するにはWeb版にアクセスしてください",
    ),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "VPN関連の設定変更を検出しました",
    ),
    "vpnDesc": MessageLookupByLibrary.simpleMessage("VPN関連設定の変更"),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "VpnServiceでシステムの全トラフィックを自動的にルーティングします",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "HTTPプロキシをVpnServiceに接続",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage("変更はVPNの再起動後に有効になります"),
    "walletBalance": MessageLookupByLibrary.simpleMessage("残高"),
    "walletDetails": MessageLookupByLibrary.simpleMessage("ウォレット詳細"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage("WebDAV設定"),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("ホワイトリストモード"),
    "withdraw": MessageLookupByLibrary.simpleMessage("出金"),
    "withdrawCommission": MessageLookupByLibrary.simpleMessage("報酬を出金"),
    "withdrawableAmount": m79,
    "withdrawalAvailable": MessageLookupByLibrary.simpleMessage(
      "利用可能な報酬は出金できます",
    ),
    "writeToSystem": MessageLookupByLibrary.simpleMessage("システムに書き込む"),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "システムクロックも設定します。Androidでは無視されます",
    ),
    "xboard": MessageLookupByLibrary.simpleMessage("マイ"),
    "xboard24HourCustomerService": MessageLookupByLibrary.simpleMessage(
      "24時間カスタマーサービスサポート",
    ),
    "xboardAccountBalance": MessageLookupByLibrary.simpleMessage("アカウント残高"),
    "xboardAddLinkToConfig": MessageLookupByLibrary.simpleMessage(
      "設定にこのサブスクリプションリンクを追加",
    ),
    "xboardAddingToConfigList": MessageLookupByLibrary.simpleMessage(
      "設定リストに追加中",
    ),
    "xboardAfterPurchasingPlan": MessageLookupByLibrary.simpleMessage(
      "プラン購入後、あなたは以下を享受できます：",
    ),
    "xboardApiUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "API URLが設定されていません",
    ),
    "xboardAutoCheckEvery5Seconds": MessageLookupByLibrary.simpleMessage(
      "システムが5秒ごとに自動チェックし、支払い完了後に自動リダイレクトします",
    ),
    "xboardAutoDetectPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "支払い状況を自動検出",
    ),
    "xboardAutoOpeningPaymentPage": MessageLookupByLibrary.simpleMessage(
      "支払いページを自動的に開いています。支払い完了後はアプリに戻ってください",
    ),
    "xboardAutoTesting": MessageLookupByLibrary.simpleMessage("自動テスト中"),
    "xboardBack": MessageLookupByLibrary.simpleMessage("戻る"),
    "xboardBrowserNotOpenedTip": MessageLookupByLibrary.simpleMessage(
      "ブラウザが自動的に開かない場合は、\\\"再開\\\"をクリックするかリンクを手動でコピーしてください",
    ),
    "xboardBuyMoreTrafficOrUpgrade": MessageLookupByLibrary.simpleMessage(
      "より多くのトラフィックを購入するかプランをアップグレードしてください",
    ),
    "xboardBuyNow": MessageLookupByLibrary.simpleMessage("今すぐ購入"),
    "xboardBuyoutPlan": MessageLookupByLibrary.simpleMessage("買い切りプラン"),
    "xboardCancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "xboardCancelPayment": MessageLookupByLibrary.simpleMessage("支払いキャンセル"),
    "xboardCheckPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "支払い状況の確認に失敗しました",
    ),
    "xboardCheckStatus": MessageLookupByLibrary.simpleMessage("ステータス確認"),
    "xboardChecking": MessageLookupByLibrary.simpleMessage("確認中"),
    "xboardCleaningOldConfig": MessageLookupByLibrary.simpleMessage(
      "古い設定をクリーン中",
    ),
    "xboardClearError": MessageLookupByLibrary.simpleMessage("エラーをクリア"),
    "xboardClickToCopy": MessageLookupByLibrary.simpleMessage("クリックしてコピー"),
    "xboardClickToSetupNodes": MessageLookupByLibrary.simpleMessage(
      "クリックしてノードを設定",
    ),
    "xboardCompletePaymentInBrowser": MessageLookupByLibrary.simpleMessage(
      "2. ブラウザで支払いを完了してください",
    ),
    "xboardConfigDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "設定のダウンロードに失敗しました、サブスクリプションリンクを確認してください",
    ),
    "xboardConfigFormatError": MessageLookupByLibrary.simpleMessage(
      "設定形式エラー、サービスプロバイダーにお問い合わせください",
    ),
    "xboardConfigSaveFailed": MessageLookupByLibrary.simpleMessage(
      "設定の保存に失敗しました、ストレージ容量を確認してください",
    ),
    "xboardConfigurationError": MessageLookupByLibrary.simpleMessage("設定エラー"),
    "xboardConfirm": MessageLookupByLibrary.simpleMessage("確認"),
    "xboardConfirmAction": MessageLookupByLibrary.simpleMessage("確認"),
    "xboardConfirmPassword": MessageLookupByLibrary.simpleMessage("パスワード確認"),
    "xboardConfirmPurchase": MessageLookupByLibrary.simpleMessage("購入を確認"),
    "xboardCongratulationsSubscriptionActivated":
        MessageLookupByLibrary.simpleMessage(
          "おめでとうございます！サブスクリプションが正常に購入され、有効化されました",
        ),
    "xboardConnectGlobalQualityNodes": MessageLookupByLibrary.simpleMessage(
      "グローバル品質ノードに接続",
    ),
    "xboardConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "接続タイムアウト、ネットワーク接続を確認してください",
    ),
    "xboardCopyFailed": MessageLookupByLibrary.simpleMessage("コピーに失敗しました"),
    "xboardCopyLink": MessageLookupByLibrary.simpleMessage("リンクをコピー"),
    "xboardCopyPaymentLink": MessageLookupByLibrary.simpleMessage("リンクをコピー"),
    "xboardCopySubscriptionLinkAbove": MessageLookupByLibrary.simpleMessage(
      "上記のサブスクリプションリンクをコピー",
    ),
    "xboardCouponExpired": MessageLookupByLibrary.simpleMessage("クーポンが期限切れです"),
    "xboardCouponNotYetActive": MessageLookupByLibrary.simpleMessage(
      "クーポンはまだ有効ではありません",
    ),
    "xboardCouponOptional": MessageLookupByLibrary.simpleMessage("クーポン（オプション）"),
    "xboardCreatingOrder": MessageLookupByLibrary.simpleMessage("注文を作成中"),
    "xboardCreatingOrderPleaseWait": MessageLookupByLibrary.simpleMessage(
      "新しい注文を作成しています。お待ちください",
    ),
    "xboardCurrentNode": MessageLookupByLibrary.simpleMessage("現在のノード"),
    "xboardCurrentVersion": MessageLookupByLibrary.simpleMessage("現在のバージョン"),
    "xboardDays": MessageLookupByLibrary.simpleMessage("日"),
    "xboardDeductibleDuringPayment": MessageLookupByLibrary.simpleMessage(
      "支払い時に控除可能",
    ),
    "xboardDiscounted": MessageLookupByLibrary.simpleMessage("割引済み"),
    "xboardDownloadingConfig": MessageLookupByLibrary.simpleMessage(
      "設定ファイルをダウンロード中",
    ),
    "xboardEmail": MessageLookupByLibrary.simpleMessage("メール"),
    "xboardEnableTun": MessageLookupByLibrary.simpleMessage("TUNを有効化"),
    "xboardEnjoyFastNetworkExperience": MessageLookupByLibrary.simpleMessage(
      "高速ネットワーク体験をお楽しみください",
    ),
    "xboardEnterCouponCode": MessageLookupByLibrary.simpleMessage("クーポンコードを入力"),
    "xboardExcellent": MessageLookupByLibrary.simpleMessage("優秀"),
    "xboardExpiryTime": MessageLookupByLibrary.simpleMessage("有効期限"),
    "xboardFailedToCheckPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "支払い状況の確認に失敗しました",
    ),
    "xboardFailedToGetSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "サブスクリプション情報の取得に失敗しました",
    ),
    "xboardFailedToOpenPaymentLink": MessageLookupByLibrary.simpleMessage(
      "支払いリンクを開けませんでした",
    ),
    "xboardFailedToOpenPaymentPage": MessageLookupByLibrary.simpleMessage(
      "支払いページを開けませんでした",
    ),
    "xboardFair": MessageLookupByLibrary.simpleMessage("普通"),
    "xboardForceUpdate": MessageLookupByLibrary.simpleMessage("強制更新"),
    "xboardForgotPassword": MessageLookupByLibrary.simpleMessage("パスワードを忘れた"),
    "xboardGettingIP": MessageLookupByLibrary.simpleMessage("取得中..."),
    "xboardGlobalNodes": MessageLookupByLibrary.simpleMessage("グローバルノード"),
    "xboardGood": MessageLookupByLibrary.simpleMessage("良好"),
    "xboardGroup": MessageLookupByLibrary.simpleMessage("グループ"),
    "xboardHalfYearlyPayment": MessageLookupByLibrary.simpleMessage("半年払い"),
    "xboardHandleLater": MessageLookupByLibrary.simpleMessage("後で処理"),
    "xboardHandlingFee": MessageLookupByLibrary.simpleMessage("手数料"),
    "xboardHighSpeedNetwork": MessageLookupByLibrary.simpleMessage("高速ネットワーク"),
    "xboardHome": MessageLookupByLibrary.simpleMessage("ホーム"),
    "xboardImportFailed": MessageLookupByLibrary.simpleMessage("インポート失敗"),
    "xboardImportSuccess": MessageLookupByLibrary.simpleMessage("インポート成功"),
    "xboardInsufficientBalance": MessageLookupByLibrary.simpleMessage("残高不足"),
    "xboardInvalidCredentials": MessageLookupByLibrary.simpleMessage(
      "無効なユーザー名またはパスワード",
    ),
    "xboardInvalidOrExpiredCoupon": MessageLookupByLibrary.simpleMessage(
      "無効または期限切れのクーポンコード",
    ),
    "xboardInvalidResponseFormat": MessageLookupByLibrary.simpleMessage(
      "サーバーからの無効なレスポンス形式",
    ),
    "xboardInviteCode": MessageLookupByLibrary.simpleMessage("招待コード"),
    "xboardKeepSubscriptionLinkSafe": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンクを安全に保管し、他人と共有しないでください",
    ),
    "xboardLater": MessageLookupByLibrary.simpleMessage("後で"),
    "xboardLoadingFailed": MessageLookupByLibrary.simpleMessage("読み込みに失敗しました"),
    "xboardLoadingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "支払いページを読み込み中",
    ),
    "xboardLocalIP": MessageLookupByLibrary.simpleMessage("ローカルIP"),
    "xboardLoggedIn": MessageLookupByLibrary.simpleMessage("ログイン済み"),
    "xboardLogin": MessageLookupByLibrary.simpleMessage("ログイン"),
    "xboardLoginExpired": MessageLookupByLibrary.simpleMessage(
      "ログインが期限切れです、再度ログインしてください",
    ),
    "xboardLoginFailed": MessageLookupByLibrary.simpleMessage("ログイン失敗"),
    "xboardLoginSuccess": MessageLookupByLibrary.simpleMessage("ログイン成功"),
    "xboardLoginToViewSubscription": MessageLookupByLibrary.simpleMessage(
      "サブスクリプション使用状況を確認するにはログインしてください",
    ),
    "xboardLogout": MessageLookupByLibrary.simpleMessage("ログアウト"),
    "xboardLogoutConfirmContent": MessageLookupByLibrary.simpleMessage(
      "ログアウトしますか？再度認証情報を入力する必要があります。",
    ),
    "xboardLogoutConfirmTitle": MessageLookupByLibrary.simpleMessage("ログアウト確認"),
    "xboardLogoutFailed": MessageLookupByLibrary.simpleMessage("ログアウト失敗"),
    "xboardLogoutSuccess": MessageLookupByLibrary.simpleMessage("ログアウト成功"),
    "xboardMissingRequiredField": MessageLookupByLibrary.simpleMessage(
      "必須フィールドが不足しています",
    ),
    "xboardMonthlyPayment": MessageLookupByLibrary.simpleMessage("月払い"),
    "xboardMonthlyRenewal": MessageLookupByLibrary.simpleMessage("毎月更新"),
    "xboardMustUpdate": MessageLookupByLibrary.simpleMessage("更新必須"),
    "xboardNetworkConnectionFailed": MessageLookupByLibrary.simpleMessage(
      "ネットワーク接続に失敗しました、ネットワーク設定を確認してください",
    ),
    "xboardNewVersionFound": MessageLookupByLibrary.simpleMessage(
      "新しいバージョンが見つかりました",
    ),
    "xboardNext": MessageLookupByLibrary.simpleMessage("次へ"),
    "xboardNoAvailableNodes": MessageLookupByLibrary.simpleMessage(
      "利用可能なノードがありません",
    ),
    "xboardNoAvailablePlan": MessageLookupByLibrary.simpleMessage(
      "利用可能なプランがありません",
    ),
    "xboardNoAvailableSubscription": MessageLookupByLibrary.simpleMessage(
      "利用可能なサブスクリプションがありません",
    ),
    "xboardNoInternetConnection": MessageLookupByLibrary.simpleMessage(
      "インターネット接続がありません、ネットワーク設定を確認してください",
    ),
    "xboardNoSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "サブスクリプション情報がありません",
    ),
    "xboardNoSubscriptionPlans": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションプランがありません",
    ),
    "xboardNodeName": MessageLookupByLibrary.simpleMessage("ノード名"),
    "xboardNone": MessageLookupByLibrary.simpleMessage("なし"),
    "xboardNotLoggedIn": MessageLookupByLibrary.simpleMessage("未ログイン"),
    "xboardOneTimePayment": MessageLookupByLibrary.simpleMessage("一回払い"),
    "xboardOpenPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "支払いページを開けませんでした",
    ),
    "xboardOpenPaymentLinkFailed": MessageLookupByLibrary.simpleMessage(
      "支払いリンクを開けませんでした",
    ),
    "xboardOperationFailed": MessageLookupByLibrary.simpleMessage("操作に失敗しました"),
    "xboardOperationTips": MessageLookupByLibrary.simpleMessage("操作のヒント"),
    "xboardOrderCreationFailed": MessageLookupByLibrary.simpleMessage(
      "注文作成に失敗しました",
    ),
    "xboardOrderNotFound": MessageLookupByLibrary.simpleMessage("注文が見つかりません"),
    "xboardOrderNumber": MessageLookupByLibrary.simpleMessage("注文番号"),
    "xboardOrderStatusPending": MessageLookupByLibrary.simpleMessage(
      "注文状況：支払い待ち",
    ),
    "xboardPassword": MessageLookupByLibrary.simpleMessage("パスワード"),
    "xboardPaymentCancelled": MessageLookupByLibrary.simpleMessage(
      "支払いがキャンセルされました",
    ),
    "xboardPaymentComplete": MessageLookupByLibrary.simpleMessage("支払い完了"),
    "xboardPaymentCompleted": MessageLookupByLibrary.simpleMessage("支払い完了！"),
    "xboardPaymentFailed": MessageLookupByLibrary.simpleMessage("支払いに失敗しました"),
    "xboardPaymentGateway": MessageLookupByLibrary.simpleMessage("支払いゲートウェイ"),
    "xboardPaymentInfo": MessageLookupByLibrary.simpleMessage("支払い情報"),
    "xboardPaymentInstructions1": MessageLookupByLibrary.simpleMessage(
      "1. 支払いページが自動的に開かれました",
    ),
    "xboardPaymentInstructions2": MessageLookupByLibrary.simpleMessage(
      "2. ブラウザで支払いを完了してください",
    ),
    "xboardPaymentInstructions3": MessageLookupByLibrary.simpleMessage(
      "3. 支払い後にアプリに戻ると、システムが自動検出します",
    ),
    "xboardPaymentLink": MessageLookupByLibrary.simpleMessage("支払いリンク"),
    "xboardPaymentLinkCopied": MessageLookupByLibrary.simpleMessage(
      "支払いリンクをクリップボードにコピーしました",
    ),
    "xboardPaymentMethodVerified": MessageLookupByLibrary.simpleMessage(
      "支払い方法が確認されました",
    ),
    "xboardPaymentMethodVerifiedPreparing":
        MessageLookupByLibrary.simpleMessage(
          "支払い方法が確認されました。支払いページにリダイレクトする準備中です",
        ),
    "xboardPaymentPageAutoOpened": MessageLookupByLibrary.simpleMessage(
      "1. 支払いページが自動的に開かれました",
    ),
    "xboardPaymentPageOpenedCompleteAndReturn":
        MessageLookupByLibrary.simpleMessage(
          "支払いページが開かれました。支払いを完了してアプリに戻ってください",
        ),
    "xboardPaymentPageOpenedInBrowser": MessageLookupByLibrary.simpleMessage(
      "ブラウザで支払いページが開かれました。支払い完了後はアプリに戻ってください",
    ),
    "xboardPaymentSuccess": MessageLookupByLibrary.simpleMessage("支払い成功"),
    "xboardPaymentSuccessful": MessageLookupByLibrary.simpleMessage(
      "🎉 支払い成功！",
    ),
    "xboardPlanInfo": MessageLookupByLibrary.simpleMessage("プラン情報"),
    "xboardPlanNotFound": MessageLookupByLibrary.simpleMessage("プランが見つかりません"),
    "xboardPlans": MessageLookupByLibrary.simpleMessage("プラン"),
    "xboardPleaseSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage(
      "支払い期間を選択してください",
    ),
    "xboardPoor": MessageLookupByLibrary.simpleMessage("悪い"),
    "xboardPreparingImport": MessageLookupByLibrary.simpleMessage("インポートを準備中"),
    "xboardPreparingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "支払いページを準備中、まもなくリダイレクトします",
    ),
    "xboardPrevious": MessageLookupByLibrary.simpleMessage("前へ"),
    "xboardProcessing": MessageLookupByLibrary.simpleMessage("処理中..."),
    "xboardProfessionalSupport": MessageLookupByLibrary.simpleMessage(
      "プロフェッショナルサポート",
    ),
    "xboardProfile": MessageLookupByLibrary.simpleMessage("プロファイル"),
    "xboardProtectNetworkPrivacy": MessageLookupByLibrary.simpleMessage(
      "ネットワークプライバシーを保護",
    ),
    "xboardProxy": MessageLookupByLibrary.simpleMessage("プロキシ"),
    "xboardProxyMode": MessageLookupByLibrary.simpleMessage("プロキシモード"),
    "xboardProxyModeDirectDescription": MessageLookupByLibrary.simpleMessage(
      "すべてのトラフィックがプロキシなしで直接接続",
    ),
    "xboardProxyModeGlobalDescription": MessageLookupByLibrary.simpleMessage(
      "すべてのトラフィックがプロキシサーバーを通過",
    ),
    "xboardProxyModeRuleDescription": MessageLookupByLibrary.simpleMessage(
      "ルールに基づいて直接またはプロキシを自動選択",
    ),
    "xboardPurchasePlan": MessageLookupByLibrary.simpleMessage("プランを購入"),
    "xboardPurchaseSubscription": MessageLookupByLibrary.simpleMessage(
      "サブスクリプション購入",
    ),
    "xboardPurchaseSubscriptionToUse": MessageLookupByLibrary.simpleMessage(
      "使用するにはサブスクリプションを購入してください",
    ),
    "xboardPurchaseTraffic": MessageLookupByLibrary.simpleMessage("トラフィックを購入"),
    "xboardQuarterlyPayment": MessageLookupByLibrary.simpleMessage("四半期払い"),
    "xboardRefresh": MessageLookupByLibrary.simpleMessage("更新"),
    "xboardRefreshStatus": MessageLookupByLibrary.simpleMessage("ステータスを更新"),
    "xboardRegister": MessageLookupByLibrary.simpleMessage("登録"),
    "xboardRegisterFailed": MessageLookupByLibrary.simpleMessage("登録失敗"),
    "xboardRegisterSuccess": MessageLookupByLibrary.simpleMessage(
      "登録成功！ログインページにリダイレクトしています...",
    ),
    "xboardReload": MessageLookupByLibrary.simpleMessage("再読み込み"),
    "xboardRelogin": MessageLookupByLibrary.simpleMessage("再ログイン"),
    "xboardRememberPassword": MessageLookupByLibrary.simpleMessage("パスワードを記憶"),
    "xboardRenewPlan": MessageLookupByLibrary.simpleMessage("プランを更新"),
    "xboardRenewToContinue": MessageLookupByLibrary.simpleMessage(
      "引き続き使用するには更新してください",
    ),
    "xboardReopen": MessageLookupByLibrary.simpleMessage("再開"),
    "xboardReopenPayment": MessageLookupByLibrary.simpleMessage("支払いを再開"),
    "xboardReopenPaymentPageTip": MessageLookupByLibrary.simpleMessage(
      "再度開くには、下の\\\"再開\\\"ボタンをクリックしてください",
    ),
    "xboardRetry": MessageLookupByLibrary.simpleMessage("再試行"),
    "xboardRetryGet": MessageLookupByLibrary.simpleMessage("再試行"),
    "xboardReturn": MessageLookupByLibrary.simpleMessage("戻る"),
    "xboardReturnAfterPaymentAutoDetect": MessageLookupByLibrary.simpleMessage(
      "3. 支払い後にアプリに戻ると、システムが自動検出します",
    ),
    "xboardRunningTime": m80,
    "xboardSecureEncryption": MessageLookupByLibrary.simpleMessage("セキュア暗号化"),
    "xboardSelectPaymentMethod": MessageLookupByLibrary.simpleMessage(
      "支払い方法を選択",
    ),
    "xboardSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage(
      "支払い期間を選択",
    ),
    "xboardSelectPeriod": MessageLookupByLibrary.simpleMessage("購入期間を選択してください"),
    "xboardSendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "認証コードを送信",
    ),
    "xboardServerError": MessageLookupByLibrary.simpleMessage("サーバーエラー"),
    "xboardSetup": MessageLookupByLibrary.simpleMessage("設定"),
    "xboardSixMonthCycle": MessageLookupByLibrary.simpleMessage("6ヶ月サイクル"),
    "xboardSpeedLimit": MessageLookupByLibrary.simpleMessage("速度制限"),
    "xboardStartProxy": MessageLookupByLibrary.simpleMessage("プロキシ開始"),
    "xboardStartProxyToSelectNode": MessageLookupByLibrary.simpleMessage(
      "プロキシを起動するとノードを選択できます",
    ),
    "xboardStop": MessageLookupByLibrary.simpleMessage("停止"),
    "xboardStopProxy": MessageLookupByLibrary.simpleMessage("プロキシ停止"),
    "xboardSubscription": MessageLookupByLibrary.simpleMessage("サブスクリプション"),
    "xboardSubscriptionCopied": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンクをクリップボードにコピーしました",
    ),
    "xboardSubscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションが期限切れです",
    ),
    "xboardSubscriptionHasExpired": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションが期限切れです",
    ),
    "xboardSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "サブスクリプション情報",
    ),
    "xboardSubscriptionLink": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンク",
    ),
    "xboardSubscriptionLinkCopied": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンクをクリップボードにコピーしました",
    ),
    "xboardSubscriptionPurchase": MessageLookupByLibrary.simpleMessage(
      "サブスクリプション購入",
    ),
    "xboardSubscriptionStatus": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションステータス",
    ),
    "xboardSwitch": MessageLookupByLibrary.simpleMessage("切り替え"),
    "xboardTesting": MessageLookupByLibrary.simpleMessage("テスト中"),
    "xboardThirtySixMonthCycle": MessageLookupByLibrary.simpleMessage(
      "36ヶ月サイクル",
    ),
    "xboardThreeMonthCycle": MessageLookupByLibrary.simpleMessage("3ヶ月サイクル"),
    "xboardThreeYearPayment": MessageLookupByLibrary.simpleMessage("3年払い"),
    "xboardTimeout": MessageLookupByLibrary.simpleMessage("タイムアウト"),
    "xboardTokenExpiredContent": MessageLookupByLibrary.simpleMessage(
      "ログインセッションが期限切れです。続行するには再度ログインしてください。",
    ),
    "xboardTokenExpiredTitle": MessageLookupByLibrary.simpleMessage("ログイン期限切れ"),
    "xboardTraffic": MessageLookupByLibrary.simpleMessage("トラフィック"),
    "xboardTrafficExhausted": MessageLookupByLibrary.simpleMessage(
      "トラフィックを使い切りました",
    ),
    "xboardTrafficUsedUp": MessageLookupByLibrary.simpleMessage(
      "トラフィックを使い切りました",
    ),
    "xboardTunEnabled": MessageLookupByLibrary.simpleMessage("TUNが有効"),
    "xboardTwelveMonthCycle": MessageLookupByLibrary.simpleMessage("12ヶ月サイクル"),
    "xboardTwentyFourMonthCycle": MessageLookupByLibrary.simpleMessage(
      "24ヶ月サイクル",
    ),
    "xboardTwoYearPayment": MessageLookupByLibrary.simpleMessage("2年払い"),
    "xboardUnauthorizedAccess": MessageLookupByLibrary.simpleMessage(
      "認証されていないアクセス、まずログインしてください",
    ),
    "xboardUnknownErrorRetry": MessageLookupByLibrary.simpleMessage(
      "不明なエラー、再試行してください",
    ),
    "xboardUnknownUser": MessageLookupByLibrary.simpleMessage("不明なユーザー"),
    "xboardUnlimited": MessageLookupByLibrary.simpleMessage("無制限"),
    "xboardUnselected": MessageLookupByLibrary.simpleMessage("未選択"),
    "xboardUnsupportedCouponType": MessageLookupByLibrary.simpleMessage(
      "サポートされていないクーポンタイプ",
    ),
    "xboardUpdateContent": MessageLookupByLibrary.simpleMessage("更新内容："),
    "xboardUpdateLater": MessageLookupByLibrary.simpleMessage("後で更新"),
    "xboardUpdateNow": MessageLookupByLibrary.simpleMessage("今すぐ更新"),
    "xboardUpdateSubscription": MessageLookupByLibrary.simpleMessage("サブスク更新"),
    "xboardUpdateSubscriptionRegularly": MessageLookupByLibrary.simpleMessage(
      "定期的にサブスクリプションを更新して最新のノードを取得",
    ),
    "xboardUsageInstructions": MessageLookupByLibrary.simpleMessage("使用方法"),
    "xboardUsed": MessageLookupByLibrary.simpleMessage("使用済み"),
    "xboardUsedTraffic": MessageLookupByLibrary.simpleMessage("使用済み"),
    "xboardValidatingConfigFormat": MessageLookupByLibrary.simpleMessage(
      "設定形式を検証中",
    ),
    "xboardValidationFailed": MessageLookupByLibrary.simpleMessage("検証に失敗しました"),
    "xboardValidityPeriod": MessageLookupByLibrary.simpleMessage("有効期間"),
    "xboardVerify": MessageLookupByLibrary.simpleMessage("検証"),
    "xboardVeryPoor": MessageLookupByLibrary.simpleMessage("非常に悪い"),
    "xboardWaitingForPayment": MessageLookupByLibrary.simpleMessage(
      "支払いを待っています",
    ),
    "xboardWaitingPaymentCompletion": MessageLookupByLibrary.simpleMessage(
      "支払い完了を待機中",
    ),
    "xboardYearlyPayment": MessageLookupByLibrary.simpleMessage("年払い"),
    "years": MessageLookupByLibrary.simpleMessage("年"),
    "yearsAgo": m81,
    "yes": MessageLookupByLibrary.simpleMessage("はい"),
    "zhCN": MessageLookupByLibrary.simpleMessage("簡体字中国語"),
    "zh_CN": MessageLookupByLibrary.simpleMessage("簡体字中国語"),
  };
}
