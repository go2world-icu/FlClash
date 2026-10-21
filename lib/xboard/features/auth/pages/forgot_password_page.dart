import 'package:fl_clash/common/common.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:fl_clash/xboard/utils/xboard_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/features/shared/shared.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

enum ResetPasswordStep {
  sendCode, // 发送验证码步骤
  resetPassword, // 重置密码步骤
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  ResetPasswordStep _currentStep = ResetPasswordStep.sendCode;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 使用 SDK 发送验证码
      await XBoardSDK.instance.auth.sendEmailVerifyCode(_emailController.text);

      if (mounted) {
        setState(() {
          _currentStep = ResetPasswordStep.resetPassword;
        });
        XBoardNotification.showSuccess(xboardL10n.verificationCodeSent);
      }
    } catch (e) {
      if (mounted) {
        XBoardNotification.showError('${xboardL10n.sendCodeFailed}: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      XBoardNotification.showError(xboardL10n.passwordMismatch);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 使用 AuthRepository 重置密码
      // 使用 SDK 重置密码
      final success = await XBoardSDK.instance.auth.forgotPassword(
        _emailController.text,
        _codeController.text,
        _passwordController.text,
      );

      if (!success) {
        throw Exception('重置密码失败');
      }

      if (mounted) {
        XBoardNotification.showSuccess(xboardL10n.passwordResetSuccessful);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        XBoardNotification.showError('${xboardL10n.passwordResetFailed}: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goBackToSendCode() {
    setState(() {
      _currentStep = ResetPasswordStep.sendCode;
      _codeController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Widget _buildSendCodeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          xboardL10n.enterEmailForReset,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        XBInputField(
          controller: _emailController,
          labelText: xboardL10n.emailAddress,
          hintText: xboardL10n.pleaseEnterEmail,
          prefixIcon: XBoardGlyphs.email,
          keyboardType: TextInputType.emailAddress,
          enabled: !_isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return xboardL10n.pleaseEnterEmail;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return xboardL10n.pleaseEnterValidEmail;
            }
            return null;
          },
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: _isLoading
              ? ElevatedButton(
                  onPressed: null,
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : ElevatedButton(
                  onPressed: _sendVerificationCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: AppShape.all(12),
                  ),
                  child: Text(
                    xboardL10n.sendVerificationCode,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildResetPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          xboardL10n.verificationCodeSentTo(_emailController.text),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        XBInputField(
          controller: _codeController,
          labelText: xboardL10n.verificationCode,
          hintText: xboardL10n.pleaseEnterVerificationCode,
          prefixIcon: XBoardGlyphs.shieldCheck,
          keyboardType: TextInputType.number,
          enabled: !_isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return xboardL10n.pleaseEnterVerificationCode;
            }
            if (value.length < 4) {
              return xboardL10n.pleaseEnterValidVerificationCode;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        XBInputField(
          controller: _passwordController,
          labelText: xboardL10n.newPassword,
          hintText: xboardL10n.pleaseEnterNewPassword,
          prefixIcon: AppGlyphs.lock,
          obscureText: _obscurePassword,
          enabled: !_isLoading,
          suffixIcon: IconButton(
            tooltip: _obscurePassword
                ? AppLocalizations.of(context).hidePassword
                : AppLocalizations.of(context).showPassword,
            icon: GlyphIcon(
              _obscurePassword ? AppGlyphs.eye : AppGlyphs.eyeOff,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return xboardL10n.pleaseEnterNewPassword;
            }
            if (value.length < 6) {
              return xboardL10n.passwordMinLength;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        XBInputField(
          controller: _confirmPasswordController,
          labelText: xboardL10n.confirmNewPassword,
          hintText: xboardL10n.pleaseConfirmNewPassword,
          prefixIcon: AppGlyphs.lock,
          obscureText: _obscureConfirmPassword,
          enabled: !_isLoading,
          suffixIcon: IconButton(
            tooltip: _obscureConfirmPassword
                ? AppLocalizations.of(context).hidePassword
                : AppLocalizations.of(context).showPassword,
            icon: GlyphIcon(
              _obscureConfirmPassword ? AppGlyphs.eye : AppGlyphs.eyeOff,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return xboardL10n.pleaseConfirmNewPassword;
            }
            if (value != _passwordController.text) {
              return xboardL10n.passwordMismatch;
            }
            return null;
          },
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: _isLoading
              ? ElevatedButton(
                  onPressed: null,
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: AppShape.all(12),
                  ),
                  child: Text(
                    xboardL10n.resetPassword,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _isLoading ? null : _goBackToSendCode,
          child: Text(
            xboardL10n.resendVerificationCode,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                    tooltip: AppLocalizations.of(context).back,
                    onPressed: () {
                      if (_currentStep == ResetPasswordStep.resetPassword) {
                        _goBackToSendCode();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const GlyphIcon(AppGlyphs.arrowBack),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerLow,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _currentStep == ResetPasswordStep.sendCode
                        ? xboardL10n.resetPassword
                        : xboardL10n.setNewPassword,
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
                        if (_currentStep == ResetPasswordStep.sendCode)
                          _buildSendCodeStep()
                        else
                          _buildResetPasswordStep(),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              xboardL10n.rememberPassword,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                xboardL10n.backToLogin,
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
