// The panel's own strings.
//
// They lived in upstream's `arb/` until the fork's copy of them made
// `lib/l10n/l10n.dart` the largest conflict in the repository on every
// merge. The keys are unchanged, so the call sites read the same — only the
// receiver moved.
//
// Generated once from `arb/intl_*.arb`; the arb copies are gone now, so edit
// this file directly.
// ignore_for_file: lines_longer_than_80_chars

import 'package:intl/intl.dart';

class XBoardStrings {
  const XBoardStrings(this._locale);

  final String _locale;

  static const _values = <String, Map<String, String>>{
    'en': <String, String>{
      'alreadyHaveAccount': 'Already have an account?',
      'appDesc': 'Processing app related settings',
      'application': 'Application',
      'availableCommission': 'Available',
      'backToLogin': 'Back to Login',
      'checkNetwork': 'Please check network and retry',
      'checking': 'Checking...',
      'commissionHistory': 'Commission History',
      'commissionRate': 'Rate',
      'commissionSettled': 'Commission settled after friend subscription',
      'complete': 'Complete',
      'confirmLogout': 'Confirm Logout',
      'confirmNewPassword': 'Confirm New Password',
      'confirmTransfer': 'Confirm Transfer',
      'copiedToClipboard': 'Copied to clipboard',
      'copyInviteLink': 'Copy Link',
      'createAccount': 'Create Account',
      'createProfile': 'Create Profile',
      'currentCommissionRate': 'Current commission rate: {rate}%',
      'days': 'Days',
      'defaultNameserver': 'Default nameserver',
      'emailAddress': 'Email Address',
      'emailVerificationCode': 'Email Verification Code',
      'enterEmailForReset':
          'Please enter your email address and we will send a verification code to your email',
      'enterTransferAmount': 'Enter transfer amount',
      'enterTransferAmountError': 'Please enter transfer amount',
      'fallback': 'Fallback',
      'fillInfoToRegister':
          'Please fill in the following information to complete registration',
      'filterSystemApp': 'Filter system app',
      'forgotPassword': 'Forgot Password',
      'friendInviteReward': 'Earn commission when your invited friends spend',
      'generatingInviteCode': 'Generating invite code...',
      'geoipCode': 'Geoip code',
      'hotkeyConflict': 'Hotkey conflict',
      'iUnderstand': 'I Understand',
      'invalidTransferAmount': 'Please enter valid transfer amount',
      'invite': 'Invite',
      'inviteCode': 'Invite Code',
      'inviteCodeGenFailed': 'Invite code generation failed',
      'inviteCodeIncorrect':
          'Invite code may be incorrect, please check and re-enter',
      'inviteCodeOptional': 'Invite Code (optional)',
      'inviteCodeRequired': 'Invite Code Required',
      'inviteCodeRequiredMessage':
          'Registration requires an invite code. Please contact a registered user to get an invite code before registering.',
      'inviteRegisterReward':
          'Invite friends to register and subscribe to earn commission',
      'inviteRules': 'Invite Rules',
      'inviteStats': 'Invite Stats',
      'ipcidr': 'Ipcidr',
      'iosChannel': 'Link',
      'iosCore': 'Core',
      'iosTunnel': 'Tunnel',
      'notReady': 'Not ready',
      'ready': 'Ready',
      'just': 'Just',
      'loadMore': 'Load More',
      'loggedOutSuccess': 'Logged out successfully',
      'loginNow': 'Login Now',
      'logout': 'Logout',
      'logoutConfirmMsg': 'Are you sure to logout? You need to login again.',
      'logoutFailed': 'Logout failed: {error}',
      'maxTransferable': 'Max transferable: ¥{amount}',
      'minutes': 'Minutes',
      'months': 'Months',
      'myInviteQr': 'My Invite QR',
      'nameserver': 'Nameserver',
      'nameserverPolicy': 'Nameserver policy',
      'newPassword': 'New Password',
      'noCommissionRecord': 'No commission records',
      'noInvitationData': 'No invitation data',
      'noProxy': 'No proxy',
      'orderAmount': 'Order amount: {amount}',
      'orderNumber': 'Order: {orderNo}',
      'pageNumber': 'Page {page}',
      'passwordMin8Chars': 'Password must be at least 8 characters',
      'passwordMinLength': 'Password must be at least 6 characters',
      'passwordMismatch': 'Passwords do not match',
      'passwordResetFailed': 'Password reset failed',
      'passwordResetSuccessful':
          'Password reset successful! Please login with your new password',
      'passwordsDoNotMatch': 'Passwords do not match',
      'pendingCommission': 'Pending',
      'pleaseConfirmNewPassword': 'Please re-enter new password',
      'pleaseConfirmPassword': 'Please confirm password',
      'pleaseEnterAtLeast8CharsPassword':
          'Please enter at least 8 characters password',
      'pleaseEnterEmail': 'Please enter email address',
      'pleaseEnterEmailAddress': 'Please enter email address',
      'pleaseEnterEmailVerificationCode':
          'Please enter email verification code',
      'pleaseEnterInviteCode': 'Please enter invite code',
      'pleaseEnterNewPassword': 'Please enter new password',
      'pleaseEnterPassword': 'Please enter password',
      'pleaseEnterValidEmail': 'Please enter a valid email address',
      'pleaseEnterValidEmailAddress': 'Please enter a valid email address',
      'pleaseEnterValidVerificationCode':
          'Please enter a valid verification code',
      'pleaseEnterVerificationCode': 'Please enter email verification code',
      'pleaseEnterYourEmailAddress': 'Please enter your email address',
      'pleaseReEnterPassword': 'Please re-enter password',
      'recovery': 'Recovery',
      'refresh': 'Refresh',
      'registerAccount': 'Register Account',
      'rememberPassword': 'Remember your password?',
      'rename': 'Rename',
      'resendVerificationCode': 'Resend Verification Code',
      'resetPassword': 'Reset Password',
      'saveQr': 'Save QR',
      'saveQrCodeFeature': 'Save QR feature coming soon',
      'selectTheme': 'Select Theme',
      'sendCodeFailed': 'Failed to send verification code',
      'sendVerificationCode': 'Send Verification Code',
      'sendVerificationCodeFailed': 'Failed to send verification code: {e}',
      'setNewPassword': 'Set New Password',
      'subscriptionExpired': 'Subscription expired',
      'subscriptionExpiredDetail':
          'Plan expired on {date}, please renew to continue using',
      'subscriptionExpiresToday': 'Subscription expires today',
      'subscriptionExpiresTodayDetail':
          'Plan will expire today, please renew immediately to avoid service interruption',
      'subscriptionExpiringInDays': 'Subscription expiring soon',
      'subscriptionExpiringInDaysDetail':
          'Plan will expire in {days} days, please renew in time',
      'subscriptionNoSubscription': 'No subscription',
      'subscriptionNoSubscriptionDetail':
          'No available subscription plan found, please purchase a plan to use',
      'subscriptionNotLoggedIn': 'Not logged in',
      'subscriptionNotLoggedInDetail': 'Please login first',
      'subscriptionTrafficExhausted': 'Traffic exhausted',
      'subscriptionTrafficExhaustedDetail':
          'Plan traffic has been used up, please purchase more traffic or upgrade plan',
      'subscriptionValid': 'Subscription valid',
      'subscriptionValidDetail': 'Subscription will expire in {days} days',
      'switchTheme': 'Switch Theme',
      'totalCommission': 'Earnings',
      'totalInvites': 'Invites',
      'totalRecords': 'Total {count} records',
      'transfer': 'Transfer',
      'transferAmount': 'Transfer Amount',
      'transferAmountExceeded': 'Transfer amount cannot exceed ¥{amount}',
      'transferFailed': 'Transfer failed: {error}',
      'transferNote': 'Transferred balance can be used for in-app purchases',
      'transferSuccess': 'Transfer Success!',
      'transferSuccessMsg': 'Transfer success! Transferred ¥{amount} to wallet',
      'transferToWallet': 'Transfer to Wallet',
      'transferring': 'Transferring...',
      'userCenter': 'User Center',
      'verificationCode': 'Verification Code',
      'verificationCode6Digits': 'Verification code should be 6 digits',
      'verificationCodeSent':
          'Verification code has been sent to your email, please check',
      'verificationCodeSentCheckEmail':
          'Verification code sent, please check your email',
      'verificationCodeSentTo':
          'Verification code has been sent to {email}, please check and enter the verification code and new password',
      'viewHistory': 'View History',
      'walletBalance': 'Balance',
      'walletDetails': 'Wallet Details',
      'withdraw': 'Withdraw',
      'withdrawCommission': 'Withdraw Commission',
      'withdrawalAvailable': 'Available commission can be withdrawn',
      'xboard': 'My',
      'xboard24HourCustomerService': '24-hour customer service support',
      'xboardAfterPurchasingPlan': 'After purchasing a plan, you will enjoy:',
      'xboardBuyMoreTrafficOrUpgrade':
          'Please buy more traffic or upgrade plan',
      'xboardConfirm': 'Confirm',
      'xboardConfirmAction': 'Confirm',
      'xboardConnectGlobalQualityNodes': 'Connect to global quality nodes',
      'xboardDays': 'days',
      'xboardEmail': 'Email',
      'xboardEnjoyFastNetworkExperience': 'Enjoy fast network experience',
      'xboardExpiryTime': 'Expiry time',
      'xboardForgotPassword': 'Forgot Password',
      'xboardGlobalNodes': 'Global nodes',
      'xboardHandleLater': 'Handle later',
      'xboardHighSpeedNetwork': 'High-speed network',
      'xboardHome': 'Home',
      'xboardInviteCode': 'Invite Code',
      'xboardLogin': 'Login',
      'xboardLoginSuccess': 'Login successful',
      'xboardLoginToViewSubscription':
          'Please login to view subscription usage',
      'xboardNoAvailablePlan': 'No available plan',
      'xboardNoAvailableSubscription': 'No available subscription',
      'xboardNoSubscriptionInfo': 'No subscription information',
      'xboardPassword': 'Password',
      'xboardProfessionalSupport': 'Professional support',
      'xboardProtectNetworkPrivacy': 'Protect your network privacy',
      'xboardPurchasePlan': 'Purchase plan',
      'xboardPurchaseSubscription': 'Purchase subscription',
      'xboardPurchaseSubscriptionToUse':
          'Please purchase a subscription to use',
      'xboardPurchaseTraffic': 'Purchase traffic',
      'xboardRefresh': 'Refresh',
      'xboardRefreshStatus': 'Refresh status',
      'xboardRegister': 'Register',
      'xboardRegisterSuccess':
          'Registration successful! Redirecting to login page...',
      'xboardRememberPassword': 'Remember Password',
      'xboardRenewPlan': 'Renew plan',
      'xboardRenewToContinue': 'Please renew to continue using',
      'xboardRunningTime': 'Running time: {time}',
      'xboardSecureEncryption': 'Secure encryption',
      'xboardStartProxy': 'Start Proxy',
      'xboardStop': 'Stop',
      'xboardStopProxy': 'Stop Proxy',
      'xboardSubscription': 'Subscription',
      'xboardSubscriptionExpired': 'Subscription expired',
      'xboardSubscriptionHasExpired': 'Subscription has expired',
      'xboardSubscriptionStatus': 'Subscription status',
      'xboardSwitch': 'Switch',
      'xboardTokenExpiredContent':
          'Your login session has expired. Please login again to continue.',
      'xboardTraffic': 'Traffic',
      'xboardTrafficExhausted': 'Traffic exhausted',
      'xboardTrafficUsedUp': 'Traffic used up',
      'xboardUpdateSubscription': 'Update subscription',
      'xboardUsed': 'Used',
      'xboardUsedTraffic': 'Used',
      'xboardValidityPeriod': 'Expires',
      'years': 'Years',
    },
    'ja': <String, String>{
      'alreadyHaveAccount': 'アカウントをお持ちですか？',
      'appDesc': 'アプリ関連設定の処理',
      'application': 'アプリケーション',
      'availableCommission': '利用可能',
      'backToLogin': 'ログインに戻る',
      'checkNetwork': 'ネットワークを確認して再試行してください',
      'checking': '確認中...',
      'commissionHistory': '報酬履歴',
      'commissionRate': '手数料率',
      'commissionSettled': '友人の購読後に報酬が確定します',
      'complete': '完了',
      'confirmLogout': 'ログアウトを確認',
      'confirmNewPassword': '新しいパスワードを確認',
      'confirmTransfer': '送金を確認',
      'copiedToClipboard': 'クリップボードにコピーしました',
      'copyInviteLink': 'リンクをコピー',
      'createAccount': 'アカウント作成',
      'createProfile': 'Create Profile',
      'currentCommissionRate': '現在の報酬率: {rate}%',
      'days': '日',
      'defaultNameserver': 'デフォルトネームサーバー',
      'emailAddress': 'メールアドレス',
      'emailVerificationCode': 'メール認証コード',
      'enterEmailForReset': 'メールアドレスを入力してください。認証コードをメールに送信します',
      'enterTransferAmount': '送金額を入力してください',
      'enterTransferAmountError': '送金額を入力してください',
      'fallback': 'フォールバック',
      'fillInfoToRegister': '登録を完了するには以下の情報を入力してください',
      'filterSystemApp': 'システムアプリを除外',
      'forgotPassword': 'パスワードを忘れた場合',
      'friendInviteReward': '招待した友人の利用に応じて報酬が得られます',
      'generatingInviteCode': '招待コードを生成中...',
      'geoipCode': 'GeoIPコード',
      'hotkeyConflict': 'ホットキー競合',
      'iUnderstand': '理解しました',
      'invalidTransferAmount': '有効な送金額を入力してください',
      'invite': '招待',
      'inviteCode': '招待コード',
      'inviteCodeGenFailed': '招待コードの生成に失敗しました',
      'inviteCodeIncorrect': '招待コードが正しくない可能性があります。確認して再入力してください',
      'inviteCodeOptional': '招待コード（任意）',
      'inviteCodeRequired': '招待コードが必要です',
      'inviteCodeRequiredMessage':
          '登録には招待コードが必要です。登録前に登録済みユーザーに連絡して招待コードを入手してください。',
      'inviteRegisterReward': '友達を招待して登録・購読してもらうと報酬が得られます',
      'inviteRules': '招待ルール',
      'inviteStats': '招待統計',
      'ipcidr': 'IPCIDR',
      'iosChannel': '接続',
      'iosCore': 'コア',
      'iosTunnel': 'トンネル',
      'notReady': '未準備',
      'ready': '準備完了',
      'just': 'たった今',
      'loadMore': 'もっと読み込む',
      'loggedOutSuccess': 'ログアウトしました',
      'loginNow': '今すぐログイン',
      'logout': 'ログアウト',
      'logoutConfirmMsg': 'ログアウトしますか？再度ログインが必要です。',
      'logoutFailed': 'ログアウトに失敗しました: {error}',
      'maxTransferable': '最大送金額: ¥{amount}',
      'minutes': '分',
      'months': '月',
      'myInviteQr': 'マイ招待QR',
      'nameserver': 'ネームサーバー',
      'nameserverPolicy': 'ネームサーバーポリシー',
      'newPassword': '新しいパスワード',
      'noCommissionRecord': '報酬記録がありません',
      'noInvitationData': '招待データがありません',
      'noProxy': 'プロキシなし',
      'orderAmount': '注文金額: {amount}',
      'orderNumber': '注文番号: {orderNo}',
      'pageNumber': 'ページ {page}',
      'passwordMin8Chars': 'パスワードは8文字以上である必要があります',
      'passwordMinLength': 'パスワードは6文字以上である必要があります',
      'passwordMismatch': 'パスワードが一致しません',
      'passwordResetFailed': 'パスワードのリセットに失敗しました',
      'passwordResetSuccessful': 'パスワードのリセットが完了しました。新しいパスワードでログインしてください',
      'passwordsDoNotMatch': 'パスワードが一致しません',
      'pendingCommission': '保留中',
      'pleaseConfirmNewPassword': '新しいパスワードをもう一度入力してください',
      'pleaseConfirmPassword': 'パスワードを確認してください',
      'pleaseEnterAtLeast8CharsPassword': '8文字以上のパスワードを入力してください',
      'pleaseEnterEmail': 'メールアドレスを入力してください',
      'pleaseEnterEmailAddress': 'メールアドレスを入力してください',
      'pleaseEnterEmailVerificationCode': 'メール認証コードを入力してください',
      'pleaseEnterInviteCode': '招待コードを入力してください',
      'pleaseEnterNewPassword': '新しいパスワードを入力してください',
      'pleaseEnterPassword': 'パスワードを入力してください',
      'pleaseEnterValidEmail': '有効なメールアドレスを入力してください',
      'pleaseEnterValidEmailAddress': '有効なメールアドレスを入力してください',
      'pleaseEnterValidVerificationCode': '有効な認証コードを入力してください',
      'pleaseEnterVerificationCode': 'メール認証コードを入力してください',
      'pleaseEnterYourEmailAddress': 'メールアドレスを入力してください',
      'pleaseReEnterPassword': 'パスワードをもう一度入力してください',
      'recovery': '復元',
      'refresh': '更新',
      'registerAccount': 'アカウント登録',
      'rememberPassword': 'パスワードを記憶しますか？',
      'rename': 'リネーム',
      'resendVerificationCode': '認証コードを再送信',
      'resetPassword': 'パスワードをリセット',
      'saveQr': 'QRを保存',
      'saveQrCodeFeature': 'QR保存機能は近日公開予定です',
      'selectTheme': 'テーマを選択',
      'sendCodeFailed': '認証コードの送信に失敗しました',
      'sendVerificationCode': '認証コードを送信',
      'sendVerificationCodeFailed': '認証コードの送信に失敗しました: {e}',
      'setNewPassword': '新しいパスワードを設定',
      'subscriptionExpired': 'サブスクリプションが期限切れです',
      'subscriptionExpiredDetail': 'プランは{date}に期限切れになりました。継続利用には更新してください',
      'subscriptionExpiresToday': 'サブスクリプションが本日期限切れ',
      'subscriptionExpiresTodayDetail':
          'プランが本日期限切れになります。サービス中断を避けるため即座に更新してください',
      'subscriptionExpiringInDays': 'サブスクリプションがまもなく期限切れ',
      'subscriptionExpiringInDaysDetail':
          'プランは{days}日後に期限切れになります。タイムリーに更新してください',
      'subscriptionNoSubscription': 'サブスクリプションがありません',
      'subscriptionNoSubscriptionDetail':
          '利用可能なサブスクリプションプランが見つかりません。ご利用にはプランをご購入ください',
      'subscriptionNotLoggedIn': '未ログイン',
      'subscriptionNotLoggedInDetail': 'まずログインしてください',
      'subscriptionTrafficExhausted': 'トラフィックを使い切りました',
      'subscriptionTrafficExhaustedDetail':
          'プランのトラフィックを使い切りました。より多くのトラフィックを購入するかプランをアップグレードしてください',
      'subscriptionValid': 'サブスクリプション有効',
      'subscriptionValidDetail': 'サブスクリプションは{days}日後に期限切れになります',
      'switchTheme': 'テーマを切り替え',
      'totalCommission': '収益',
      'totalInvites': '招待数',
      'totalRecords': '合計 {count} 件',
      'transfer': '送金',
      'transferAmount': '送金額',
      'transferAmountExceeded': '送金額は ¥{amount} を超えることはできません',
      'transferFailed': '送金に失敗しました: {error}',
      'transferNote': '送金した残高はアプリ内購入に利用できます',
      'transferSuccess': '送金が完了しました！',
      'transferSuccessMsg': '送金が完了しました！ウォレットに ¥{amount} 送金しました',
      'transferToWallet': 'ウォレットへ送金',
      'transferring': '送金中...',
      'userCenter': 'ユーザーセンター',
      'verificationCode': '認証コード',
      'verificationCode6Digits': '認証コードは6桁である必要があります',
      'verificationCodeSent': '認証コードをメールに送信しました。ご確認ください',
      'verificationCodeSentCheckEmail': '認証コードを送信しました。メールをご確認ください',
      'verificationCodeSentTo':
          '認証コードを {email} に送信しました。認証コードと新しいパスワードを入力してください',
      'viewHistory': '履歴を見る',
      'walletBalance': '残高',
      'walletDetails': 'ウォレット詳細',
      'withdraw': '出金',
      'withdrawCommission': '報酬を出金',
      'withdrawalAvailable': '利用可能な報酬は出金できます',
      'xboard': 'マイ',
      'xboard24HourCustomerService': '24時間カスタマーサービスサポート',
      'xboardAfterPurchasingPlan': 'プラン購入後、あなたは以下を享受できます：',
      'xboardBuyMoreTrafficOrUpgrade': 'より多くのトラフィックを購入するかプランをアップグレードしてください',
      'xboardConfirm': '確認',
      'xboardConfirmAction': '確認',
      'xboardConnectGlobalQualityNodes': 'グローバル品質ノードに接続',
      'xboardDays': '日',
      'xboardEmail': 'メール',
      'xboardEnjoyFastNetworkExperience': '高速ネットワーク体験をお楽しみください',
      'xboardExpiryTime': '有効期限',
      'xboardForgotPassword': 'パスワードを忘れた',
      'xboardGlobalNodes': 'グローバルノード',
      'xboardHandleLater': '後で処理',
      'xboardHighSpeedNetwork': '高速ネットワーク',
      'xboardHome': 'ホーム',
      'xboardInviteCode': '招待コード',
      'xboardLogin': 'ログイン',
      'xboardLoginSuccess': 'ログイン成功',
      'xboardLoginToViewSubscription': 'サブスクリプション使用状況を確認するにはログインしてください',
      'xboardNoAvailablePlan': '利用可能なプランがありません',
      'xboardNoAvailableSubscription': '利用可能なサブスクリプションがありません',
      'xboardNoSubscriptionInfo': 'サブスクリプション情報がありません',
      'xboardPassword': 'パスワード',
      'xboardProfessionalSupport': 'プロフェッショナルサポート',
      'xboardProtectNetworkPrivacy': 'ネットワークプライバシーを保護',
      'xboardPurchasePlan': 'プランを購入',
      'xboardPurchaseSubscription': 'サブスクリプション購入',
      'xboardPurchaseSubscriptionToUse': '使用するにはサブスクリプションを購入してください',
      'xboardPurchaseTraffic': 'トラフィックを購入',
      'xboardRefresh': '更新',
      'xboardRefreshStatus': 'ステータスを更新',
      'xboardRegister': '登録',
      'xboardRegisterSuccess': '登録成功！ログインページにリダイレクトしています...',
      'xboardRememberPassword': 'パスワードを記憶',
      'xboardRenewPlan': 'プランを更新',
      'xboardRenewToContinue': '引き続き使用するには更新してください',
      'xboardRunningTime': '実行時間: {time}',
      'xboardSecureEncryption': 'セキュア暗号化',
      'xboardStartProxy': 'プロキシ開始',
      'xboardStop': '停止',
      'xboardStopProxy': 'プロキシ停止',
      'xboardSubscription': 'サブスクリプション',
      'xboardSubscriptionExpired': 'サブスクリプションが期限切れです',
      'xboardSubscriptionHasExpired': 'サブスクリプションが期限切れです',
      'xboardSubscriptionStatus': 'サブスクリプションステータス',
      'xboardSwitch': '切り替え',
      'xboardTokenExpiredContent': 'ログインセッションが期限切れです。続行するには再度ログインしてください。',
      'xboardTraffic': 'トラフィック',
      'xboardTrafficExhausted': 'トラフィックを使い切りました',
      'xboardTrafficUsedUp': 'トラフィックを使い切りました',
      'xboardUpdateSubscription': 'サブスク更新',
      'xboardUsed': '使用済み',
      'xboardUsedTraffic': '使用済み',
      'xboardValidityPeriod': '有効期間',
      'years': '年',
    },
    'ru': <String, String>{
      'alreadyHaveAccount': 'Уже есть аккаунт?',
      'appDesc': 'Обработка настроек, связанных с приложением',
      'application': 'Приложение',
      'availableCommission': 'Доступно',
      'backToLogin': 'Вернуться ко входу',
      'checkNetwork': 'Проверьте сеть и повторите попытку',
      'checking': 'Проверка...',
      'commissionHistory': 'История комиссий',
      'commissionRate': 'Ставка',
      'commissionSettled': 'Комиссия начисляется после подписки друга',
      'complete': 'Завершить',
      'confirmLogout': 'Подтвердить выход',
      'confirmNewPassword': 'Подтвердите новый пароль',
      'confirmTransfer': 'Подтвердить перевод',
      'copiedToClipboard': 'Скопировано в буфер обмена',
      'copyInviteLink': 'Скопировать ссылку',
      'createAccount': 'Создать аккаунт',
      'createProfile': 'Create Profile',
      'currentCommissionRate': 'Текущая ставка комиссии: {rate}%',
      'days': 'Дней',
      'defaultNameserver': 'Сервер имен по умолчанию',
      'emailAddress': 'Адрес электронной почты',
      'emailVerificationCode': 'Код подтверждения по email',
      'enterEmailForReset':
          'Введите адрес электронной почты, мы отправим код подтверждения на вашу почту',
      'enterTransferAmount': 'Введите сумму перевода',
      'enterTransferAmountError': 'Введите сумму перевода',
      'fallback': 'Резервный',
      'fillInfoToRegister':
          'Заполните следующую информацию для завершения регистрации',
      'filterSystemApp': 'Фильтровать системные приложения',
      'forgotPassword': 'Забыли пароль?',
      'friendInviteReward':
          'Получайте комиссию, когда ваши приглашённые друзья тратят средства',
      'generatingInviteCode': 'Генерация пригласительного кода...',
      'geoipCode': 'Код Geoip',
      'hotkeyConflict': 'Конфликт горячих клавиш',
      'iUnderstand': 'Я понимаю',
      'invalidTransferAmount': 'Введите корректную сумму перевода',
      'invite': 'Пригласить',
      'inviteCode': 'Пригласительный код',
      'inviteCodeGenFailed': 'Не удалось сгенерировать пригласительный код',
      'inviteCodeIncorrect':
          'Пригласительный код может быть неверным, проверьте и введите заново',
      'inviteCodeOptional': 'Пригласительный код (необязательно)',
      'inviteCodeRequired': 'Требуется пригласительный код',
      'inviteCodeRequiredMessage':
          'Для регистрации требуется пригласительный код. Свяжитесь с зарегистрированным пользователем, чтобы получить его перед регистрацией.',
      'inviteRegisterReward':
          'Приглашайте друзей регистрироваться и подписываться, чтобы получать комиссию',
      'inviteRules': 'Правила приглашения',
      'inviteStats': 'Статистика приглашений',
      'ipcidr': 'IPCIDR',
      'iosChannel': 'Канал',
      'iosCore': 'Ядро',
      'iosTunnel': 'Туннель',
      'notReady': 'Не готово',
      'ready': 'Готово',
      'just': 'Только что',
      'loadMore': 'Загрузить ещё',
      'loggedOutSuccess': 'Вы вышли из системы',
      'loginNow': 'Войти сейчас',
      'logout': 'Выйти',
      'logoutConfirmMsg':
          'Вы уверены, что хотите выйти? Потребуется повторный вход.',
      'logoutFailed': 'Не удалось выйти: {error}',
      'maxTransferable': 'Максимальный перевод: ¥{amount}',
      'minutes': 'Минут',
      'months': 'Месяцев',
      'myInviteQr': 'Мой QR-код приглашения',
      'nameserver': 'Сервер имен',
      'nameserverPolicy': 'Политика сервера имен',
      'newPassword': 'Новый пароль',
      'noCommissionRecord': 'Нет записей о комиссиях',
      'noInvitationData': 'Нет данных о приглашениях',
      'noProxy': 'Нет прокси',
      'orderAmount': 'Сумма заказа: {amount}',
      'orderNumber': 'Заказ: {orderNo}',
      'pageNumber': 'Страница {page}',
      'passwordMin8Chars': 'Пароль должен содержать не менее 8 символов',
      'passwordMinLength': 'Пароль должен содержать не менее 6 символов',
      'passwordMismatch': 'Пароли не совпадают',
      'passwordResetFailed': 'Не удалось сбросить пароль',
      'passwordResetSuccessful':
          'Пароль успешно сброшен! Войдите с новым паролем',
      'passwordsDoNotMatch': 'Пароли не совпадают',
      'pendingCommission': 'Ожидает',
      'pleaseConfirmNewPassword': 'Повторите новый пароль',
      'pleaseConfirmPassword': 'Подтвердите пароль',
      'pleaseEnterAtLeast8CharsPassword': 'Введите пароль не менее 8 символов',
      'pleaseEnterEmail': 'Введите адрес электронной почты',
      'pleaseEnterEmailAddress': 'Введите адрес электронной почты',
      'pleaseEnterEmailVerificationCode': 'Введите код подтверждения по email',
      'pleaseEnterInviteCode': 'Введите пригласительный код',
      'pleaseEnterNewPassword': 'Введите новый пароль',
      'pleaseEnterPassword': 'Введите пароль',
      'pleaseEnterValidEmail': 'Введите корректный адрес электронной почты',
      'pleaseEnterValidEmailAddress':
          'Введите корректный адрес электронной почты',
      'pleaseEnterValidVerificationCode':
          'Введите корректный код подтверждения',
      'pleaseEnterVerificationCode': 'Введите код подтверждения по email',
      'pleaseEnterYourEmailAddress': 'Введите ваш адрес электронной почты',
      'pleaseReEnterPassword': 'Повторите пароль',
      'recovery': 'Восстановление',
      'refresh': 'Обновить',
      'registerAccount': 'Зарегистрировать аккаунт',
      'rememberPassword': 'Запомнить пароль?',
      'rename': 'Переименовать',
      'resendVerificationCode': 'Отправить код подтверждения повторно',
      'resetPassword': 'Сбросить пароль',
      'saveQr': 'Сохранить QR',
      'saveQrCodeFeature': 'Функция сохранения QR скоро появится',
      'selectTheme': 'Выбрать тему',
      'sendCodeFailed': 'Не удалось отправить код подтверждения',
      'sendVerificationCode': 'Отправить код подтверждения',
      'sendVerificationCodeFailed':
          'Не удалось отправить код подтверждения: {e}',
      'setNewPassword': 'Задать новый пароль',
      'subscriptionExpired': 'Подписка истекла',
      'subscriptionExpiredDetail':
          'План истёк {date}, пожалуйста продлите для продолжения использования',
      'subscriptionExpiresToday': 'Подписка истекает сегодня',
      'subscriptionExpiresTodayDetail':
          'План истёк сегодня, пожалуйста немедленно продлите чтобы избежать прерывания сервиса',
      'subscriptionExpiringInDays': 'Подписка скоро истекает',
      'subscriptionExpiringInDaysDetail':
          'План истёк через {days} дней, пожалуйста продлите вовремя',
      'subscriptionNoSubscription': 'Нет подписки',
      'subscriptionNoSubscriptionDetail':
          'Не найдено доступных планов подписок, пожалуйста купите план для использования',
      'subscriptionNotLoggedIn': 'Не авторизован',
      'subscriptionNotLoggedInDetail': 'Сначала войдите в систему',
      'subscriptionTrafficExhausted': 'Трафик исчерпан',
      'subscriptionTrafficExhaustedDetail':
          'Трафик плана использован полностью, пожалуйста купите больше трафика или обновите план',
      'subscriptionValid': 'Подписка действительна',
      'subscriptionValidDetail': 'Подписка истёк через {days} дней',
      'switchTheme': 'Переключить тему',
      'totalCommission': 'Заработок',
      'totalInvites': 'Приглашения',
      'totalRecords': 'Всего {count} записей',
      'transfer': 'Перевод',
      'transferAmount': 'Сумма перевода',
      'transferAmountExceeded': 'Сумма перевода не может превышать ¥{amount}',
      'transferFailed': 'Не удалось выполнить перевод: {error}',
      'transferNote':
          'Переведённый баланс можно использовать для покупок в приложении',
      'transferSuccess': 'Перевод выполнен успешно!',
      'transferSuccessMsg': 'Перевод успешен! Переведено ¥{amount} в кошелёк',
      'transferToWallet': 'Перевести в кошелёк',
      'transferring': 'Перевод...',
      'userCenter': 'Личный кабинет',
      'verificationCode': 'Код подтверждения',
      'verificationCode6Digits': 'Код подтверждения должен содержать 6 цифр',
      'verificationCodeSent':
          'Код подтверждения отправлен на вашу почту, проверьте',
      'verificationCodeSentCheckEmail':
          'Код подтверждения отправлен, проверьте вашу почту',
      'verificationCodeSentTo':
          'Код подтверждения отправлен на {email}. Введите код и новый пароль',
      'viewHistory': 'Просмотреть историю',
      'walletBalance': 'Баланс',
      'walletDetails': 'Детали кошелька',
      'withdraw': 'Вывести',
      'withdrawCommission': 'Вывести комиссию',
      'withdrawalAvailable': 'Доступную комиссию можно вывести',
      'xboard': 'Мой',
      'xboard24HourCustomerService': '24-часовая поддержка клиентов',
      'xboardAfterPurchasingPlan': 'После покупки плана вы получите:',
      'xboardBuyMoreTrafficOrUpgrade':
          'Купите больше трафика или обновите план',
      'xboardConfirm': 'Подтвердить',
      'xboardConfirmAction': 'Подтвердить',
      'xboardConnectGlobalQualityNodes':
          'Подключитесь к глобальным качественным узлам',
      'xboardDays': 'дней',
      'xboardEmail': 'Электронная почта',
      'xboardEnjoyFastNetworkExperience':
          'Наслаждайтесь быстрым сетевым опытом',
      'xboardExpiryTime': 'Время истечения',
      'xboardForgotPassword': 'Забыли пароль',
      'xboardGlobalNodes': 'Глобальные узлы',
      'xboardHandleLater': 'Обработать позже',
      'xboardHighSpeedNetwork': 'Высокоскоростная сеть',
      'xboardHome': 'Главная',
      'xboardInviteCode': 'Код приглашения',
      'xboardLogin': 'Вход',
      'xboardLoginSuccess': 'Успешный вход',
      'xboardLoginToViewSubscription':
          'Войдите в систему для просмотра использования подписки',
      'xboardNoAvailablePlan': 'Нет доступных планов',
      'xboardNoAvailableSubscription': 'Нет доступных подписок',
      'xboardNoSubscriptionInfo': 'Нет информации о подписке',
      'xboardPassword': 'Пароль',
      'xboardProfessionalSupport': 'Профессиональная поддержка',
      'xboardProtectNetworkPrivacy': 'Защитите вашу сетевую конфиденциальность',
      'xboardPurchasePlan': 'Купить план',
      'xboardPurchaseSubscription': 'Купить подписку',
      'xboardPurchaseSubscriptionToUse': 'Купите подписку для использования',
      'xboardPurchaseTraffic': 'Купить трафик',
      'xboardRefresh': 'Обновить',
      'xboardRefreshStatus': 'Обновить статус',
      'xboardRegister': 'Регистрация',
      'xboardRegisterSuccess':
          'Регистрация успешна! Перенаправление на страницу входа...',
      'xboardRememberPassword': 'Запомнить пароль',
      'xboardRenewPlan': 'Продлить план',
      'xboardRenewToContinue':
          'Продлите подписку для продолжения использования',
      'xboardRunningTime': 'Время работы: {time}',
      'xboardSecureEncryption': 'Безопасное шифрование',
      'xboardStartProxy': 'Запустить прокси',
      'xboardStop': 'Остановить',
      'xboardStopProxy': 'Остановить прокси',
      'xboardSubscription': 'Подписка',
      'xboardSubscriptionExpired': 'Срок подписки истёк',
      'xboardSubscriptionHasExpired': 'Подписка истекла',
      'xboardSubscriptionStatus': 'Статус подписки',
      'xboardSwitch': 'Переключить',
      'xboardTokenExpiredContent':
          'Срок вашей сессии истёк. Пожалуйста, войдите снова для продолжения.',
      'xboardTraffic': 'Трафик',
      'xboardTrafficExhausted': 'Трафик исчерпан',
      'xboardTrafficUsedUp': 'Трафик исчерпан',
      'xboardUpdateSubscription': 'Обновить подписку',
      'xboardUsed': 'Использовано',
      'xboardUsedTraffic': 'Использовано',
      'xboardValidityPeriod': 'Период действия',
      'years': 'Лет',
    },
    'zh_CN': <String, String>{
      'alreadyHaveAccount': '已有账号？',
      'appDesc': '处理应用相关设置',
      'application': '应用程序',
      'availableCommission': '可用佣金',
      'backToLogin': '返回登录',
      'checkNetwork': '请检查网络连接后重试',
      'checking': '检测中...',
      'commissionHistory': '佣金历史',
      'commissionRate': '佣金比例',
      'commissionSettled': '佣金将在好友订阅成功后结算到账户',
      'complete': '完成',
      'confirmLogout': '确认登出',
      'confirmNewPassword': '确认新密码',
      'confirmTransfer': '确认划转',
      'copiedToClipboard': '已复制到剪贴板',
      'copyInviteLink': '复制邀请链接',
      'createAccount': '创建账号',
      'createProfile': '创建配置',
      'currentCommissionRate': '当前综合佣金返利比例：{rate}%',
      'days': '天',
      'defaultNameserver': '默认域名服务器',
      'emailAddress': '邮箱地址',
      'emailVerificationCode': '邮箱验证码',
      'enterEmailForReset': '请输入您的邮箱地址，我们会发送验证码到您的邮箱',
      'enterTransferAmount': '请输入划转金额',
      'enterTransferAmountError': '请输入划转金额',
      'fallback': 'Fallback',
      'fillInfoToRegister': '请填写以下信息完成注册',
      'filterSystemApp': '过滤系统应用',
      'forgotPassword': '忘记密码',
      'friendInviteReward': '好友邀请的人成功消费，您也能赚取佣金',
      'generatingInviteCode': '正在生成邀请码...',
      'geoipCode': 'Geoip代码',
      'hotkeyConflict': '快捷键冲突',
      'iUnderstand': '我知道了',
      'invalidTransferAmount': '请输入有效的划转金额',
      'invite': '邀请',
      'inviteCode': '邀请码',
      'inviteCodeGenFailed': '邀请码生成失败',
      'inviteCodeIncorrect': '邀请码可能不正确，请检查后重新输入',
      'inviteCodeOptional': '邀请码（可选）',
      'inviteCodeRequired': '需要邀请码',
      'inviteCodeRequiredMessage': '注册需要邀请码，请联系已注册用户获取邀请码后再进行注册。',
      'inviteRegisterReward': '邀请好友注册并成功订阅，即可获得佣金奖励',
      'inviteRules': '邀请规则',
      'inviteStats': '邀请统计',
      'ipcidr': 'IP/掩码',
      'iosChannel': '通道',
      'iosCore': '内核',
      'iosTunnel': '隧道',
      'notReady': '未就绪',
      'ready': '就绪',
      'just': '刚刚',
      'loadMore': '加载更多',
      'loggedOutSuccess': '已成功登出',
      'loginNow': '立即登录',
      'logout': '登出',
      'logoutConfirmMsg': '确定要登出当前账户吗？登出后需要重新登录。',
      'logoutFailed': '登出失败：{error}',
      'maxTransferable': '最大可划转: ¥{amount}',
      'minutes': '分钟',
      'months': '月',
      'myInviteQr': '我的邀请二维码',
      'nameserver': '域名服务器',
      'nameserverPolicy': '域名服务器策略',
      'newPassword': '新密码',
      'noCommissionRecord': '暂无佣金记录',
      'noInvitationData': '暂无邀请数据',
      'noProxy': '暂无代理',
      'orderAmount': '订单金额: {amount}',
      'orderNumber': '订单: {orderNo}',
      'pageNumber': '第 {page} 页',
      'passwordMin8Chars': '密码至少需要8位字符',
      'passwordMinLength': '密码长度至少6位',
      'passwordMismatch': '两次输入的密码不一致',
      'passwordResetFailed': '密码重置失败',
      'passwordResetSuccessful': '密码重置成功！请使用新密码登录',
      'passwordsDoNotMatch': '两次输入的密码不一致',
      'pendingCommission': '待确认佣金',
      'pleaseConfirmNewPassword': '请再次输入新密码',
      'pleaseConfirmPassword': '请确认密码',
      'pleaseEnterAtLeast8CharsPassword': '请输入至少8位密码',
      'pleaseEnterEmail': '请输入邮箱地址',
      'pleaseEnterEmailAddress': '请先输入邮箱地址',
      'pleaseEnterEmailVerificationCode': '请输入邮箱验证码',
      'pleaseEnterInviteCode': '请输入邀请码',
      'pleaseEnterNewPassword': '请输入新密码',
      'pleaseEnterPassword': '请输入密码',
      'pleaseEnterValidEmail': '请输入有效的邮箱地址',
      'pleaseEnterValidEmailAddress': '请输入有效的邮箱地址',
      'pleaseEnterValidVerificationCode': '请输入有效的验证码',
      'pleaseEnterVerificationCode': '请输入邮箱验证码',
      'pleaseEnterYourEmailAddress': '请输入您的邮箱地址',
      'pleaseReEnterPassword': '请再次输入密码',
      'recovery': '恢复',
      'refresh': '刷新',
      'registerAccount': '注册账号',
      'rememberPassword': '记起密码了？',
      'rename': '重命名',
      'resendVerificationCode': '重新发送验证码',
      'resetPassword': '重置密码',
      'saveQr': '保存二维码',
      'saveQrCodeFeature': '保存二维码功能开发中，敬请期待',
      'selectTheme': '选择主题',
      'sendCodeFailed': '发送验证码失败',
      'sendVerificationCode': '发送验证码',
      'sendVerificationCodeFailed': '发送验证码失败: {e}',
      'setNewPassword': '设置新密码',
      'subscriptionExpired': '订阅已过期',
      'subscriptionExpiredDetail': '套餐已于 {date} 过期，请续费后继续使用',
      'subscriptionExpiresToday': '订阅今日过期',
      'subscriptionExpiresTodayDetail': '套餐将在今日过期，请立即续费以免影响使用',
      'subscriptionExpiringInDays': '订阅即将过期',
      'subscriptionExpiringInDaysDetail': '套餐将在 {days} 天后过期，建议及时续费',
      'subscriptionNoSubscription': '无订阅套餐',
      'subscriptionNoSubscriptionDetail': '当前账户暂无可用的订阅套餐，请购买套餐后使用',
      'subscriptionNotLoggedIn': '未登录',
      'subscriptionNotLoggedInDetail': '请先登录账户',
      'subscriptionTrafficExhausted': '流量已用完',
      'subscriptionTrafficExhaustedDetail': '套餐流量已用完，请购买更多流量或升级套餐',
      'subscriptionValid': '订阅有效',
      'subscriptionValidDetail': '订阅将在 {days} 天后过期',
      'switchTheme': '切换主题',
      'totalCommission': '累计佣金',
      'totalInvites': '总邀请数',
      'totalRecords': '共 {count} 条记录',
      'transfer': '划转',
      'transferAmount': '划转金额',
      'transferAmountExceeded': '划转金额不能超过 ¥{amount}',
      'transferFailed': '划转失败：{error}',
      'transferNote': '划转到钱包的余额可以抵扣app内消费',
      'transferSuccess': '划转成功！',
      'transferSuccessMsg': '划转成功！已划转 ¥{amount} 到钱包',
      'transferToWallet': '划转到钱包',
      'transferring': '正在划转...',
      'userCenter': '个人中心',
      'verificationCode': '验证码',
      'verificationCode6Digits': '验证码应为6位数字',
      'verificationCodeSent': '验证码已发送到您的邮箱，请查收',
      'verificationCodeSentCheckEmail': '验证码已发送，请查收邮箱',
      'verificationCodeSentTo': '验证码已发送到 {email}，请查收并输入验证码和新密码',
      'viewHistory': '查看历史记录',
      'walletBalance': '钱包余额',
      'walletDetails': '钱包详情',
      'withdraw': '提现',
      'withdrawCommission': '提现佣金',
      'withdrawalAvailable': '可用佣金可申请提现',
      'xboard': '我的',
      'xboard24HourCustomerService': '24小时客服支持',
      'xboardAfterPurchasingPlan': '购买套餐后您将享受：',
      'xboardBuyMoreTrafficOrUpgrade': '请购买更多流量或升级套餐',
      'xboardConfirm': '确定',
      'xboardConfirmAction': '确定',
      'xboardConnectGlobalQualityNodes': '连接全球优质节点',
      'xboardDays': '天',
      'xboardEmail': '邮箱',
      'xboardEnjoyFastNetworkExperience': '享受极速网络体验',
      'xboardExpiryTime': '过期时间',
      'xboardForgotPassword': '忘记密码',
      'xboardGlobalNodes': '全球节点',
      'xboardHandleLater': '稍后再说',
      'xboardHighSpeedNetwork': '高速网络',
      'xboardHome': '首页',
      'xboardInviteCode': '邀请码',
      'xboardLogin': '登录',
      'xboardLoginSuccess': '登录成功',
      'xboardLoginToViewSubscription': '请登录后查看套餐使用情况',
      'xboardNoAvailablePlan': '无可用套餐',
      'xboardNoAvailableSubscription': '无可用套餐',
      'xboardNoSubscriptionInfo': '暂无套餐信息',
      'xboardPassword': '密码',
      'xboardProfessionalSupport': '专业客服',
      'xboardProtectNetworkPrivacy': '保护您的网络隐私',
      'xboardPurchasePlan': '购买套餐',
      'xboardPurchaseSubscription': '购买套餐',
      'xboardPurchaseSubscriptionToUse': '请购买套餐后使用',
      'xboardPurchaseTraffic': '购买流量',
      'xboardRefresh': '刷新',
      'xboardRefreshStatus': '刷新状态',
      'xboardRegister': '注册',
      'xboardRegisterSuccess': '注册成功！正在跳转到登录页面...',
      'xboardRememberPassword': '记住密码',
      'xboardRenewPlan': '续费套餐',
      'xboardRenewToContinue': '请续费后继续使用',
      'xboardRunningTime': '运行时间: {time}',
      'xboardSecureEncryption': '安全加密',
      'xboardStartProxy': '启动代理',
      'xboardStop': '停止',
      'xboardStopProxy': '停止代理',
      'xboardSubscription': '订阅',
      'xboardSubscriptionExpired': '订阅已过期',
      'xboardSubscriptionHasExpired': '订阅已过期',
      'xboardSubscriptionStatus': '订阅状态',
      'xboardSwitch': '切换',
      'xboardTokenExpiredContent': '您的登录状态已过期，请重新登录以继续使用。',
      'xboardTraffic': '流量',
      'xboardTrafficExhausted': '流量已用完',
      'xboardTrafficUsedUp': '流量已用完',
      'xboardUpdateSubscription': '更新订阅',
      'xboardUsed': '已用',
      'xboardUsedTraffic': '已用',
      'xboardValidityPeriod': '有效期',
      'years': '年',
    },
  };

  static final _cache = <String, XBoardStrings>{};

  static XBoardStrings forLocale(String locale) =>
      _cache.putIfAbsent(locale, () => XBoardStrings(locale));

  /// The keys this table carries for [locale] — empty for one it does not
  /// carry, which is what falls back to English at lookup time.
  static Set<String> keysFor(String locale) =>
      _values[locale]?.keys.toSet() ?? const {};

  /// English is the fallback, which is what the arb pipeline did for a
  /// locale that had no translation for a key.
  String _s(String key) => _values[_locale]?[key] ?? _values['en']![key]!;

  String get alreadyHaveAccount => _s('alreadyHaveAccount');
  String get appDesc => _s('appDesc');
  String get application => _s('application');
  String get availableCommission => _s('availableCommission');
  String get backToLogin => _s('backToLogin');
  String get checkNetwork => _s('checkNetwork');
  String get checking => _s('checking');
  String get commissionHistory => _s('commissionHistory');
  String get commissionRate => _s('commissionRate');
  String get commissionSettled => _s('commissionSettled');
  String get complete => _s('complete');
  String get confirmLogout => _s('confirmLogout');
  String get confirmNewPassword => _s('confirmNewPassword');
  String get confirmTransfer => _s('confirmTransfer');
  String get copiedToClipboard => _s('copiedToClipboard');
  String get copyInviteLink => _s('copyInviteLink');
  String get createAccount => _s('createAccount');
  String get createProfile => _s('createProfile');
  String currentCommissionRate(Object rate) =>
      _s('currentCommissionRate').replaceAll('{rate}', '$rate');
  String get days => _s('days');
  String get defaultNameserver => _s('defaultNameserver');
  String get emailAddress => _s('emailAddress');
  String get emailVerificationCode => _s('emailVerificationCode');
  String get enterEmailForReset => _s('enterEmailForReset');
  String get enterTransferAmount => _s('enterTransferAmount');
  String get enterTransferAmountError => _s('enterTransferAmountError');
  String get fallback => _s('fallback');
  String get fillInfoToRegister => _s('fillInfoToRegister');
  String get filterSystemApp => _s('filterSystemApp');
  String get forgotPassword => _s('forgotPassword');
  String get friendInviteReward => _s('friendInviteReward');
  String get generatingInviteCode => _s('generatingInviteCode');
  String get geoipCode => _s('geoipCode');
  String get hotkeyConflict => _s('hotkeyConflict');
  String get iUnderstand => _s('iUnderstand');
  String get invalidTransferAmount => _s('invalidTransferAmount');
  String get invite => _s('invite');
  String get inviteCode => _s('inviteCode');
  String get inviteCodeGenFailed => _s('inviteCodeGenFailed');
  String get inviteCodeIncorrect => _s('inviteCodeIncorrect');
  String get inviteCodeOptional => _s('inviteCodeOptional');
  String get inviteCodeRequired => _s('inviteCodeRequired');
  String get inviteCodeRequiredMessage => _s('inviteCodeRequiredMessage');
  String get inviteRegisterReward => _s('inviteRegisterReward');
  String get inviteRules => _s('inviteRules');
  String get inviteStats => _s('inviteStats');
  String get ipcidr => _s('ipcidr');
  String get just => _s('just');
  String get loadMore => _s('loadMore');
  String get loggedOutSuccess => _s('loggedOutSuccess');
  String get loginNow => _s('loginNow');
  String get logout => _s('logout');
  String get logoutConfirmMsg => _s('logoutConfirmMsg');
  String logoutFailed(Object error) =>
      _s('logoutFailed').replaceAll('{error}', '$error');
  String maxTransferable(Object amount) =>
      _s('maxTransferable').replaceAll('{amount}', '$amount');
  String get minutes => _s('minutes');
  String get months => _s('months');
  String get myInviteQr => _s('myInviteQr');
  String get nameserver => _s('nameserver');
  String get nameserverPolicy => _s('nameserverPolicy');
  String get newPassword => _s('newPassword');
  String get noCommissionRecord => _s('noCommissionRecord');
  String get noInvitationData => _s('noInvitationData');
  String get noProxy => _s('noProxy');
  String orderAmount(Object amount) =>
      _s('orderAmount').replaceAll('{amount}', '$amount');
  String orderNumber(Object orderNo) =>
      _s('orderNumber').replaceAll('{orderNo}', '$orderNo');
  String pageNumber(Object page) =>
      _s('pageNumber').replaceAll('{page}', '$page');
  String get passwordMin8Chars => _s('passwordMin8Chars');
  String get passwordMinLength => _s('passwordMinLength');
  String get passwordMismatch => _s('passwordMismatch');
  String get passwordResetFailed => _s('passwordResetFailed');
  String get passwordResetSuccessful => _s('passwordResetSuccessful');
  String get passwordsDoNotMatch => _s('passwordsDoNotMatch');
  String get pendingCommission => _s('pendingCommission');
  String get pleaseConfirmNewPassword => _s('pleaseConfirmNewPassword');
  String get pleaseConfirmPassword => _s('pleaseConfirmPassword');
  String get pleaseEnterAtLeast8CharsPassword =>
      _s('pleaseEnterAtLeast8CharsPassword');
  String get pleaseEnterEmail => _s('pleaseEnterEmail');
  String get pleaseEnterEmailAddress => _s('pleaseEnterEmailAddress');
  String get pleaseEnterEmailVerificationCode =>
      _s('pleaseEnterEmailVerificationCode');
  String get pleaseEnterInviteCode => _s('pleaseEnterInviteCode');
  String get pleaseEnterNewPassword => _s('pleaseEnterNewPassword');
  String get pleaseEnterPassword => _s('pleaseEnterPassword');
  String get pleaseEnterValidEmail => _s('pleaseEnterValidEmail');
  String get pleaseEnterValidEmailAddress => _s('pleaseEnterValidEmailAddress');
  String get pleaseEnterValidVerificationCode =>
      _s('pleaseEnterValidVerificationCode');
  String get pleaseEnterVerificationCode => _s('pleaseEnterVerificationCode');
  String get pleaseEnterYourEmailAddress => _s('pleaseEnterYourEmailAddress');
  String get pleaseReEnterPassword => _s('pleaseReEnterPassword');
  String get recovery => _s('recovery');
  String get refresh => _s('refresh');
  String get registerAccount => _s('registerAccount');
  String get rememberPassword => _s('rememberPassword');
  String get rename => _s('rename');
  String get resendVerificationCode => _s('resendVerificationCode');
  String get resetPassword => _s('resetPassword');
  String get saveQr => _s('saveQr');
  String get saveQrCodeFeature => _s('saveQrCodeFeature');
  String get selectTheme => _s('selectTheme');
  String get sendCodeFailed => _s('sendCodeFailed');
  String get sendVerificationCode => _s('sendVerificationCode');
  String sendVerificationCodeFailed(Object e) =>
      _s('sendVerificationCodeFailed').replaceAll('{e}', '$e');
  String get setNewPassword => _s('setNewPassword');
  String get subscriptionExpired => _s('subscriptionExpired');
  String subscriptionExpiredDetail(Object date) =>
      _s('subscriptionExpiredDetail').replaceAll('{date}', '$date');
  String get subscriptionExpiresToday => _s('subscriptionExpiresToday');
  String get subscriptionExpiresTodayDetail =>
      _s('subscriptionExpiresTodayDetail');
  String get subscriptionExpiringInDays => _s('subscriptionExpiringInDays');
  String subscriptionExpiringInDaysDetail(Object days) =>
      _s('subscriptionExpiringInDaysDetail').replaceAll('{days}', '$days');
  String get subscriptionNoSubscription => _s('subscriptionNoSubscription');
  String get subscriptionNoSubscriptionDetail =>
      _s('subscriptionNoSubscriptionDetail');
  String get subscriptionNotLoggedIn => _s('subscriptionNotLoggedIn');
  String get subscriptionNotLoggedInDetail =>
      _s('subscriptionNotLoggedInDetail');
  String get subscriptionTrafficExhausted => _s('subscriptionTrafficExhausted');
  String get subscriptionTrafficExhaustedDetail =>
      _s('subscriptionTrafficExhaustedDetail');
  String get subscriptionValid => _s('subscriptionValid');
  String subscriptionValidDetail(Object days) =>
      _s('subscriptionValidDetail').replaceAll('{days}', '$days');
  String get switchTheme => _s('switchTheme');
  String get totalCommission => _s('totalCommission');
  String get totalInvites => _s('totalInvites');
  String totalRecords(Object count) =>
      _s('totalRecords').replaceAll('{count}', '$count');
  String get transfer => _s('transfer');
  String get transferAmount => _s('transferAmount');
  String transferAmountExceeded(Object amount) =>
      _s('transferAmountExceeded').replaceAll('{amount}', '$amount');
  String transferFailed(Object error) =>
      _s('transferFailed').replaceAll('{error}', '$error');
  String get transferNote => _s('transferNote');
  String get transferSuccess => _s('transferSuccess');
  String transferSuccessMsg(Object amount) =>
      _s('transferSuccessMsg').replaceAll('{amount}', '$amount');
  String get transferToWallet => _s('transferToWallet');
  String get transferring => _s('transferring');
  String get userCenter => _s('userCenter');
  String get verificationCode => _s('verificationCode');
  String get verificationCode6Digits => _s('verificationCode6Digits');
  String get verificationCodeSent => _s('verificationCodeSent');
  String get verificationCodeSentCheckEmail =>
      _s('verificationCodeSentCheckEmail');
  String verificationCodeSentTo(Object email) =>
      _s('verificationCodeSentTo').replaceAll('{email}', '$email');
  String get viewHistory => _s('viewHistory');
  String get walletBalance => _s('walletBalance');
  String get walletDetails => _s('walletDetails');
  String get withdraw => _s('withdraw');
  String get withdrawCommission => _s('withdrawCommission');
  String get withdrawalAvailable => _s('withdrawalAvailable');
  String get xboard => _s('xboard');
  String get xboard24HourCustomerService => _s('xboard24HourCustomerService');
  String get xboardAfterPurchasingPlan => _s('xboardAfterPurchasingPlan');
  String get xboardBuyMoreTrafficOrUpgrade =>
      _s('xboardBuyMoreTrafficOrUpgrade');
  String get xboardConfirm => _s('xboardConfirm');
  String get xboardConfirmAction => _s('xboardConfirmAction');
  String get xboardConnectGlobalQualityNodes =>
      _s('xboardConnectGlobalQualityNodes');
  String get xboardDays => _s('xboardDays');
  String get xboardEmail => _s('xboardEmail');
  String get xboardEnjoyFastNetworkExperience =>
      _s('xboardEnjoyFastNetworkExperience');
  String get xboardExpiryTime => _s('xboardExpiryTime');
  String get xboardForgotPassword => _s('xboardForgotPassword');
  String get xboardGlobalNodes => _s('xboardGlobalNodes');
  String get xboardHandleLater => _s('xboardHandleLater');
  String get xboardHighSpeedNetwork => _s('xboardHighSpeedNetwork');
  String get xboardHome => _s('xboardHome');
  String get xboardInviteCode => _s('xboardInviteCode');
  String get xboardLogin => _s('xboardLogin');
  String get xboardLoginSuccess => _s('xboardLoginSuccess');
  String get xboardLoginToViewSubscription =>
      _s('xboardLoginToViewSubscription');
  String get xboardNoAvailablePlan => _s('xboardNoAvailablePlan');
  String get xboardNoAvailableSubscription =>
      _s('xboardNoAvailableSubscription');
  String get xboardNoSubscriptionInfo => _s('xboardNoSubscriptionInfo');
  String get xboardPassword => _s('xboardPassword');
  String get xboardProfessionalSupport => _s('xboardProfessionalSupport');
  String get xboardProtectNetworkPrivacy => _s('xboardProtectNetworkPrivacy');
  String get xboardPurchasePlan => _s('xboardPurchasePlan');
  String get xboardPurchaseSubscription => _s('xboardPurchaseSubscription');
  String get xboardPurchaseSubscriptionToUse =>
      _s('xboardPurchaseSubscriptionToUse');
  String get xboardPurchaseTraffic => _s('xboardPurchaseTraffic');
  String get xboardRefresh => _s('xboardRefresh');
  String get xboardRefreshStatus => _s('xboardRefreshStatus');
  String get xboardRegister => _s('xboardRegister');
  String get xboardRegisterSuccess => _s('xboardRegisterSuccess');
  String get xboardRememberPassword => _s('xboardRememberPassword');
  String get xboardRenewPlan => _s('xboardRenewPlan');
  String get xboardRenewToContinue => _s('xboardRenewToContinue');
  String xboardRunningTime(Object time) =>
      _s('xboardRunningTime').replaceAll('{time}', '$time');
  String get xboardSecureEncryption => _s('xboardSecureEncryption');
  String get xboardStartProxy => _s('xboardStartProxy');
  String get xboardStop => _s('xboardStop');
  String get xboardStopProxy => _s('xboardStopProxy');
  String get xboardSubscription => _s('xboardSubscription');
  String get xboardSubscriptionExpired => _s('xboardSubscriptionExpired');
  String get xboardSubscriptionHasExpired => _s('xboardSubscriptionHasExpired');
  String get xboardSubscriptionStatus => _s('xboardSubscriptionStatus');
  String get xboardSwitch => _s('xboardSwitch');
  String get xboardTokenExpiredContent => _s('xboardTokenExpiredContent');
  String get xboardTraffic => _s('xboardTraffic');
  String get xboardTrafficExhausted => _s('xboardTrafficExhausted');
  String get xboardTrafficUsedUp => _s('xboardTrafficUsedUp');
  String get xboardUpdateSubscription => _s('xboardUpdateSubscription');
  String get xboardUsed => _s('xboardUsed');
  String get xboardUsedTraffic => _s('xboardUsedTraffic');
  String get xboardValidityPeriod => _s('xboardValidityPeriod');
  String get years => _s('years');
  String get iosCore => _s('iosCore');
  String get iosTunnel => _s('iosTunnel');
  String get notReady => _s('notReady');
  String get ready => _s('ready');
  String get iosChannel => _s('iosChannel');
}

/// The panel's strings for the locale the app currently has loaded.
XBoardStrings get xboardL10n =>
    XBoardStrings.forLocale(Intl.getCurrentLocale());
