
import 'package:fl_clash/xboard/services/services.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/initialization/initialization.dart';
import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'package:fl_clash/xboard/features/shared/shared.dart';
import 'package:fl_clash/xboard/config/xboard_config.dart';
import 'package:fl_clash/xboard/utils/xboard_notification.dart';
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberPassword = false;
  bool _isPasswordVisible = false;
  late XBoardStorageService _storageService;
  
  // 从配置文件加载的应用信息
  String _appTitle = 'XBoard';
  String _appWebsite = 'example.com';
  
  @override
  void initState() {
    super.initState();
    _storageService = ref.read(storageServiceProvider);
    _loadSavedCredentials();
    _loadAppInfo();

    // 远程配置要等初始化完成才落地，标题/官网必须在就绪后重读一次，
    // 否则界面一直显示本地 YAML 的兜底值。
    ref.listenManual(initializationProvider, (previous, next) {
      if (previous?.isReady != true && next.isReady) {
        _loadAppInfo();
      }
    });

    // ✅ 调用统一初始化服务
    _initializeXBoard();
  }
  
  /// 加载应用信息（标题和网站，本地YAML兜底，远程base覆盖）
  Future<void> _loadAppInfo() async {
    final title = XBoardConfig.appTitle;
    final website = XBoardConfig.appWebsite;
    if (mounted) {
      setState(() {
        _appTitle = title;
        _appWebsite = website;
      });
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  /// 冷启动重试间隔。首次失败多半是「刚启动还没连上网」，退避重试即可自愈。
  static const _initRetryDelays = [
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
    Duration(seconds: 15),
  ];

  /// 初始化 XBoard（统一入口）
  ///
  /// 必须能重试：iOS 上外壳就是 home，登录页在 t=0 挂载，
  /// 很容易撞上「连接尚未就绪」而初始化失败。失败后没有重试路径的话，
  /// 登录按钮会一直是灰的，远程配置（标题/官网）也永远不会落地。
  Future<void> _initializeXBoard() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var attempt = 0; attempt <= _initRetryDelays.length; attempt++) {
        if (!mounted) return;

        final initState = ref.read(initializationProvider);
        if (initState.isReady) return;

        // 别和另一个进行中的初始化抢（application.dart 启动时也会触发一次）
        if (!initState.isInitializing) {
          try {
            await ref.read(initializationProvider.notifier).initialize();
          } catch (_) {
            // 失败态由 UI 呈现，这里只负责退避重试
          }
        }

        if (!mounted) return;
        if (ref.read(initializationProvider).isReady) return;
        if (attempt == _initRetryDelays.length) return;

        await Future.delayed(_initRetryDelays[attempt]);
      }
    });
  }

  /// 手动重试（点击状态指示器）。顺便把失败原因显示出来 ——
  /// 否则界面上只有一个红点，完全无法定位是网络、域名还是 SDK 的问题。
  Future<void> _retryInitialization() async {
    final error = ref.read(initializationProvider).errorMessage;
    if (error != null && error.isNotEmpty) {
      XBoardNotification.showError(error);
    }
    try {
      await ref.read(initializationProvider.notifier).refresh();
    } catch (_) {
      // 失败态由 UI 呈现
    }
  }
  void refreshCredentials() {
    _loadSavedCredentials();
  }
  Future<void> _loadSavedCredentials() async {
    try {
      final savedEmail = await _storageService.getSavedEmail();
      final savedPassword = await _storageService.getSavedPassword();
      final rememberPassword = await _storageService.getRememberPassword();
      if (savedEmail != null && savedEmail.isNotEmpty) {
        _emailController.text = savedEmail;
      }
      if (savedPassword != null && savedPassword.isNotEmpty && rememberPassword) {
        _passwordController.text = savedPassword;
      }
      _rememberPassword = rememberPassword;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // 忽略加载凭据失败,继续正常流程
    }
  }
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final userNotifier = ref.read(xboardUserProvider.notifier);
      final success = await userNotifier.login(
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        if (success) {
          if (_rememberPassword) {
            await _storageService.saveCredentials(
              _emailController.text,
              _passwordController.text,
              true,
            );
          } else {
            await _storageService.saveCredentials(
              _emailController.text,
              '',
              false,
            );
          }
          if (mounted) {
            XBoardNotification.showSuccess(appLocalizations.xboardLoginSuccess);
            Future.delayed(const Duration(milliseconds: 500), () {
              // canPop 守卫：登录页也可能是根页面（iOS 外壳未登录态），
              // 此时 pop() 会弹掉 home 路由导致黑屏。
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          }
        } else {
          final userState = ref.read(xboardUserProvider);
          if (userState.errorMessage != null) {
            // 使用 FlClash 的原生 Toast 通知（自动消失）
            XBoardNotification.showError(userState.errorMessage!);
          }
        }
      }
    }
  }
  void _navigateToRegister() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
    _loadSavedCredentials();
    _initializeXBoard(); // 重新初始化
  }
  
  void _navigateToForgotPassword() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
    _initializeXBoard(); // 重新初始化
  }
    @override
    Widget build(BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;
      final initState = ref.watch(initializationProvider);
      final userState = ref.watch(xboardUserProvider);
  
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            const LanguageSelector(),
            const SizedBox(width: 8),
            // ✅ 显示初始化状态指示器
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: _buildInitializationIndicator(initState),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.surface.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.primary.withValues(alpha: 0.1),
                              ),
                              child: Icon(
                                Icons.vpn_key_outlined,
                                size: 48,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _appTitle,
                              style: textTheme.displaySmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _appWebsite,
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      XBInputField(
                        controller: _emailController,
                        labelText: appLocalizations.xboardEmail,
                        hintText: appLocalizations.xboardEmail,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalizations.xboardEmail;
                          }
                          if (!value.contains('@')) {
                            return appLocalizations.xboardEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      XBInputField(
                        controller: _passwordController,
                        labelText: appLocalizations.xboardPassword,
                        hintText: appLocalizations.xboardPassword,
                        prefixIcon: Icons.lock_outlined,
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalizations.xboardPassword;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberPassword,
                              onChanged: (value) {
                                setState(() {
                                  _rememberPassword = value ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _rememberPassword = !_rememberPassword;
                              });
                            },
                            child: Text(
                              appLocalizations.xboardRememberPassword,
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: initState.isReady && !userState.isLoading ? _login : null,
                          child: userState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(appLocalizations.xboardLogin),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _navigateToForgotPassword,
                            child: Text(
                              appLocalizations.xboardForgotPassword,
                            ),
                          ),
                          TextButton(
                            onPressed: _navigateToRegister,
                            child: Text(
                              appLocalizations.xboardRegister,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    /// 构建初始化状态指示器
    Widget _buildInitializationIndicator(InitializationState initState) {
      Color statusColor;
      IconData statusIcon;
      
      switch (initState.status) {
        case InitializationStatus.checkingDomain:
        case InitializationStatus.initializingSDK:
          statusColor = Colors.orange;
          statusIcon = Icons.sync;
          break;
        case InitializationStatus.ready:
          statusColor = Colors.green;
          statusIcon = Icons.check_circle;
          break;
        case InitializationStatus.failed:
          statusColor = Colors.red;
          statusIcon = Icons.error;
          break;
        case InitializationStatus.idle:
          statusColor = Colors.grey;
          statusIcon = Icons.dns;
          break;
      }
      
      final indicator = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          initState.isInitializing
              ? SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                )
              : Icon(
                  statusIcon,
                  size: 12,
                  color: statusColor,
                ),
        ],
      );

      // 失败态给一个手动重试入口，否则退避重试用尽后就是死路
      if (initState.status != InitializationStatus.failed) {
        return indicator;
      }
      return InkWell(
        onTap: _retryInitialization,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: indicator,
        ),
      );
    }
  }