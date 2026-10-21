import 'package:fl_clash/xboard/features/auth/auth.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fl_clash/xboard/utils/xboard_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/features/shared/shared.dart';
import 'package:fl_clash/xboard/services/services.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart' show ConfigModel;
import 'package:fl_clash/ui/shape.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _emailCodeController = TextEditingController();
  bool _isRegistering = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSendingEmailCode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _inviteCodeController.dispose();
    _emailCodeController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // 获取配置
    final configAsync = ref.read(configProvider);
    final config = configAsync.value;
    final isInviteForce = config?.isInviteForce ?? false;
    final isEmailVerify = config?.isEmailVerify ?? false;

    // 检查邮请码是否必填
    if (isInviteForce && _inviteCodeController.text.trim().isEmpty) {
      _showInviteCodeDialog();
      return;
    }

    // 检查邮箱验证码是否必填
    if (isEmailVerify && _emailCodeController.text.trim().isEmpty) {
      XBoardNotification.showError('请输入邮箱验证码');
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isRegistering = true;
      });
      try {
        // 使用 AuthRepository 注册
        // 使用 SDK 注册
        final success = await XBoardSDK.instance.auth.register(
          _emailController.text,
          _passwordController.text,
          inviteCode: _inviteCodeController.text.trim().isNotEmpty
              ? _inviteCodeController.text
              : null,
          emailCode:
              isEmailVerify && _emailCodeController.text.trim().isNotEmpty
              ? _emailCodeController.text
              : null,
        );

        if (!success) {
          throw Exception('注册失败');
        }

        // 注册成功
        if (mounted) {
          final storageService = ref.read(storageServiceProvider);
          await storageService.saveCredentials(
            _emailController.text,
            _passwordController.text,
            true, // 启用记住密码
          );
          if (mounted) {
            XBoardNotification.showSuccess(xboardL10n.xboardRegisterSuccess);
          }
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      } catch (e) {
        if (mounted) {
          // 提取详细的错误信息
          String errorMessage = '注册失败';

          final errorStr = e.toString();

          // 尝试提取具体的错误信息
          if (errorStr.contains('XBoardException')) {
            // 格式1: XBoardException(400): 具体错误信息
            if (errorStr.contains('): ')) {
              final parts = errorStr.split('): ');
              if (parts.length > 1) {
                errorMessage = parts.sublist(1).join('): ').trim();
              }
            }
            // 格式2: XBoardException: 具体错误信息
            else if (errorStr.contains('XBoardException: ')) {
              errorMessage = errorStr.split('XBoardException: ').last.trim();
            }
          } else {
            // 其他类型的错误，直接使用错误文本
            errorMessage = errorStr;
          }

          // 移除可能的 "Error: " 前缀
          if (errorMessage.startsWith('Error: ')) {
            errorMessage = errorMessage.substring(7);
          }

          // 500错误或通用错误提示：可能是邀请码问题
          if (errorMessage.contains('遇到了些问题') || errorMessage.contains('500')) {
            errorMessage = xboardL10n.inviteCodeIncorrect;
          }

          XBoardNotification.showError(errorMessage);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isRegistering = false;
          });
        }
      }
    }
  }

  Future<void> _sendEmailCode() async {
    if (_emailController.text.isEmpty) {
      XBoardNotification.showError(xboardL10n.pleaseEnterEmailAddress);
      return;
    }

    if (!_emailController.text.contains('@')) {
      XBoardNotification.showError(xboardL10n.pleaseEnterValidEmailAddress);
      return;
    }

    setState(() {
      _isSendingEmailCode = true;
    });

    try {
      // 使用 AuthRepository 发送验证码
      // 使用 SDK 发送验证码
      await XBoardSDK.instance.auth.sendEmailVerifyCode(_emailController.text);

      if (mounted) {
        XBoardNotification.showSuccess(
          xboardL10n.verificationCodeSentCheckEmail,
        );
      }
    } catch (e) {
      if (mounted) {
        XBoardNotification.showError(
          xboardL10n.sendVerificationCodeFailed(e.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingEmailCode = false;
        });
      }
    }
  }

  void _showInviteCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(xboardL10n.inviteCodeRequired),
          content: Text(xboardL10n.inviteCodeRequiredMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(xboardL10n.iUnderstand),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final configAsync = ref.watch(configProvider);

    // 处理异步加载状态
    return configAsync.when(
      loading: () => Scaffold(
        backgroundColor: colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _buildPage(context, colorScheme, null),
      data: (config) => _buildPage(context, colorScheme, config),
    );
  }

  Widget _buildPage(
    BuildContext context,
    ColorScheme colorScheme,
    ConfigModel? config,
  ) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: XBContainer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: appLocalizations.back,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const GlyphIcon(AppGlyphs.arrowBack),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerLow,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    xboardL10n.createAccount,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          xboardL10n.fillInfoToRegister,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 32),
                        XBInputField(
                          controller: _emailController,
                          labelText: xboardL10n.emailAddress,
                          hintText: xboardL10n.pleaseEnterYourEmailAddress,
                          prefixIcon: XBoardGlyphs.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return xboardL10n.pleaseEnterEmailAddress;
                            }
                            if (!value.contains('@')) {
                              return xboardL10n.pleaseEnterValidEmailAddress;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        XBInputField(
                          controller: _passwordController,
                          labelText: appLocalizations.password,
                          hintText: xboardL10n.pleaseEnterAtLeast8CharsPassword,
                          prefixIcon: AppGlyphs.lock,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            tooltip: _isPasswordVisible
                                ? appLocalizations.hidePassword
                                : appLocalizations.showPassword,
                            icon: GlyphIcon(
                              _isPasswordVisible
                                  ? AppGlyphs.eye
                                  : AppGlyphs.eyeOff,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return xboardL10n.pleaseEnterPassword;
                            }
                            if (value.length < 8) {
                              return xboardL10n.passwordMin8Chars;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        XBInputField(
                          controller: _confirmPasswordController,
                          labelText: xboardL10n.confirmNewPassword,
                          hintText: xboardL10n.pleaseReEnterPassword,
                          prefixIcon: AppGlyphs.lock,
                          obscureText: !_isConfirmPasswordVisible,
                          suffixIcon: IconButton(
                            tooltip: _isConfirmPasswordVisible
                                ? appLocalizations.hidePassword
                                : appLocalizations.showPassword,
                            icon: GlyphIcon(
                              _isConfirmPasswordVisible
                                  ? AppGlyphs.eye
                                  : AppGlyphs.eyeOff,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return xboardL10n.pleaseConfirmPassword;
                            }
                            if (value != _passwordController.text) {
                              return xboardL10n.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // 根据配置决定是否显示邮箱验证码字段
                        if (config?.isEmailVerify == true)
                          Column(
                            children: [
                              XBInputField(
                                controller: _emailCodeController,
                                labelText: xboardL10n.emailVerificationCode,
                                hintText:
                                    xboardL10n.pleaseEnterEmailVerificationCode,
                                prefixIcon: XBoardGlyphs.shieldCheck,
                                keyboardType: TextInputType.number,
                                suffixIcon: _isSendingEmailCode
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: _sendEmailCode,
                                        child: Text(
                                          xboardL10n.sendVerificationCode,
                                        ),
                                      ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return xboardL10n
                                        .pleaseEnterEmailVerificationCode;
                                  }
                                  if (value.length != 6) {
                                    return xboardL10n.verificationCode6Digits;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        // 邀请码：始终显示，根据配置改变标签（必填 vs 可选）
                        XBInputField(
                          controller: _inviteCodeController,
                          labelText: (config?.isInviteForce ?? false)
                              ? '${xboardL10n.xboardInviteCode} *'
                              : xboardL10n.inviteCodeOptional,
                          hintText: xboardL10n.pleaseEnterInviteCode,
                          prefixIcon: XBoardGlyphs.giftCard,
                          enabled: true,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: _isRegistering
                              ? ElevatedButton(
                                  onPressed: null,
                                  child: const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    shape: AppShape.all(12),
                                  ),
                                  child: Text(
                                    xboardL10n.registerAccount,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              xboardL10n.alreadyHaveAccount,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                xboardL10n.loginNow,
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
