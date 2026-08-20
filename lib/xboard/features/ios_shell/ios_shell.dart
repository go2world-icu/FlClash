/// XBoard iOS 外壳
///
/// 仅在 iOS 上使用的自包含界面模块：接管整个 App 界面，
/// 呈现为「订阅 / 账户」形态而非代理仪表盘。
///
/// 唯一对外入口是 [XBoardIosShell]；两个标签页实现为内部细节。
library;

export 'ios_shell_page.dart';
