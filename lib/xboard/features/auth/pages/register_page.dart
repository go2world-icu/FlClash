import 'package:fl_clash/xboard/features/auth/auth.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:fl_clash/xboard/utils/xboard_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/features/shared/shared.dart';
import 'package:fl_clash/xboard/services/services.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart' show ConfigModel;
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
    // 鑾峰彇閰嶇疆
    final configAsync = ref.read(configProvider);
    final config = configAsync.value;
    final isInviteForce = config?.isInviteForce ?? false;
    final isEmailVerify = config?.isEmailVerify ?? false;
    
    // 妫€鏌ラ偖璇风爜鏄惁蹇呭～
    if (isInviteForce && _inviteCodeController.text.trim().isEmpty) {
      _showInviteCodeDialog();
      return;
    }
    
    // 妫€鏌ラ偖绠遍獙璇佺爜鏄惁蹇呭～
    if (isEmailVerify && _emailCodeController.text.trim().isEmpty) {
      XBoardNotification.showError('璇疯緭鍏ラ偖绠遍獙璇佺爜');
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isRegistering = true;
      });
      try {
        // 浣跨敤 AuthRepository 娉ㄥ唽
        // 浣跨敤 SDK 娉ㄥ唽
        final success = await XBoardSDK.instance.auth.register(
          _emailController.text,
          _passwordController.text,
          inviteCode: _inviteCodeController.text.trim().isNotEmpty 
              ? _inviteCodeController.text 
              : null,
          emailCode: isEmailVerify && _emailCodeController.text.trim().isNotEmpty
              ? _emailCodeController.text
              : null,
        );
        
        if (!success) {
          throw Exception('娉ㄥ唽澶辫触');
        }
        
        // 娉ㄥ唽鎴愬姛
        if (mounted) {
          final storageService = ref.read(storageServiceProvider);
          await storageService.saveCredentials(
            _emailController.text,
            _passwordController.text,
            true, // 鍚敤璁颁綇瀵嗙爜
          );
          if (mounted) {
            XBoardNotification.showSuccess(appLocalizations.xboardRegisterSuccess);
          }
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      } catch (e) {
        if (mounted) {
          // 鎻愬彇璇︾粏鐨勯敊璇俊鎭?
          String errorMessage = '娉ㄥ唽澶辫触';
          
          final errorStr = e.toString();
          
          // 灏濊瘯鎻愬彇鍏蜂綋鐨勯敊璇俊鎭?
          if (errorStr.contains('XBoardException')) {
            // 鏍煎紡1: XBoardException(400): 鍏蜂綋閿欒淇℃伅
            if (errorStr.contains('): ')) {
              final parts = errorStr.split('): ');
              if (parts.length > 1) {
                errorMessage = parts.sublist(1).join('): ').trim();
              }
            } 
            // 鏍煎紡2: XBoardException: 鍏蜂綋閿欒淇℃伅
            else if (errorStr.contains('XBoardException: ')) {
              errorMessage = errorStr.split('XBoardException: ').last.trim();
            }
          } else {
            // 鍏朵粬绫诲瀷鐨勯敊璇紝鐩存帴浣跨敤閿欒鏂囨湰
            errorMessage = errorStr;
          }
          
          // 绉婚櫎鍙兘鐨?"Error: " 鍓嶇紑
          if (errorMessage.startsWith('Error: ')) {
            errorMessage = errorMessage.substring(7);
          }
          
          // 500閿欒鎴栭€氱敤閿欒鎻愮ず锛氬彲鑳芥槸閭€璇风爜闂
          if (errorMessage.contains('閬囧埌浜嗕簺闂') || errorMessage.contains('500')) {
            errorMessage = appLocalizations.inviteCodeIncorrect;
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
      XBoardNotification.showError(appLocalizations.pleaseEnterEmailAddress);
      return;
    }

    if (!_emailController.text.contains('@')) {
      XBoardNotification.showError(appLocalizations.pleaseEnterValidEmailAddress);
      return;
    }

    setState(() {
      _isSendingEmailCode = true;
    });

    try {
      // 浣跨敤 AuthRepository 鍙戦€侀獙璇佺爜
      // 浣跨敤 SDK 鍙戦€侀獙璇佺爜
      await XBoardSDK.instance.auth.sendEmailVerifyCode(_emailController.text);

      if (mounted) {
        XBoardNotification.showSuccess(appLocalizations.verificationCodeSentCheckEmail);
      }
    } catch (e) {
      if (mounted) {
        XBoardNotification.showError(appLocalizations.sendVerificationCodeFailed(e.toString()));
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
          title: Text(appLocalizations.inviteCodeRequired),
          content: Text(appLocalizations.inviteCodeRequiredMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(appLocalizations.iUnderstand),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInviteCodeField(ConfigModel? config) {
    final colorScheme = Theme.of(context).colorScheme;
    final configAsync = ref.watch(configProvider);
    
    // 澶勭悊寮傛鍔犺浇鐘舵€?
    return configAsync.when(
      loading: () => const SizedBox.shrink(), // Or a placeholder
      error: (error, stack) => const SizedBox.shrink(), // Or an error message
      data: (configData) => XBInputField(
        controller: _inviteCodeController,
        labelText: (configData?.isInviteForce ?? false)
            ? '${appLocalizations.xboardInviteCode} *' 
            : appLocalizations.inviteCodeOptional,
        hintText: appLocalizations.pleaseEnterInviteCode,
        prefixIcon: Icons.card_giftcard_outlined,
        enabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final configAsync = ref.watch(configProvider);
    
    // 澶勭悊寮傛鍔犺浇鐘舵€?
    return configAsync.when(
      loading: () => Scaffold(
        backgroundColor: colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _buildPage(context, colorScheme, null),
      data: (config) => _buildPage(context, colorScheme, config),
    );
  }
  
  Widget _buildPage(BuildContext context, ColorScheme colorScheme, ConfigModel? config) {
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
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerLow,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    appLocalizations.createAccount,
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
                          appLocalizations.fillInfoToRegister,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),
                        XBInputField(
                          controller: _emailController,
                          labelText: appLocalizations.emailAddress,
                          hintText: appLocalizations.pleaseEnterYourEmailAddress,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appLocalizations.pleaseEnterEmailAddress;
                            }
                            if (!value.contains('@')) {
                              return appLocalizations.pleaseEnterValidEmailAddress;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        XBInputField(
                          controller: _passwordController,
                          labelText: appLocalizations.password,
                          hintText: appLocalizations.pleaseEnterAtLeast8CharsPassword,
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
                              return appLocalizations.pleaseEnterPassword;
                            }
                            if (value.length < 8) {
                              return appLocalizations.passwordMin8Chars;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        XBInputField(
                          controller: _confirmPasswordController,
                          labelText: appLocalizations.confirmNewPassword,
                          hintText: appLocalizations.pleaseReEnterPassword,
                          prefixIcon: Icons.lock_outlined,
                          obscureText: !_isConfirmPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appLocalizations.pleaseConfirmPassword;
                            }
                            if (value != _passwordController.text) {
                              return appLocalizations.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // 鏍规嵁閰嶇疆鍐冲畾鏄惁鏄剧ず閭楠岃瘉鐮佸瓧娈?
                        if (config?.isEmailVerify == true)
                          Column(
                            children: [
                                  XBInputField(
                                    controller: _emailCodeController,
                                    labelText: appLocalizations.emailVerificationCode,
                                    hintText: appLocalizations.pleaseEnterEmailVerificationCode,
                                    prefixIcon: Icons.verified_user_outlined,
                                    keyboardType: TextInputType.number,
                                    suffixIcon: _isSendingEmailCode
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : TextButton(
                                            onPressed: _sendEmailCode,
                                            child: Text(appLocalizations.sendVerificationCode),
                                          ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return appLocalizations.pleaseEnterEmailVerificationCode;
                                      }
                                      if (value.length != 6) {
                                        return appLocalizations.verificationCode6Digits;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                            ],
                          ),
                        // 閭€璇风爜锛氬缁堟樉绀猴紝鏍规嵁閰嶇疆鏀瑰彉鏍囩锛堝繀濉?vs 鍙€夛級
                        XBInputField(
                          controller: _inviteCodeController,
                          labelText: (config?.isInviteForce ?? false)
                              ? '${appLocalizations.xboardInviteCode} *' 
                              : appLocalizations.inviteCodeOptional,
                          hintText: appLocalizations.pleaseEnterInviteCode,
                          prefixIcon: Icons.card_giftcard_outlined,
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    appLocalizations.registerAccount,
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
                              appLocalizations.alreadyHaveAccount,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                appLocalizations.loginNow,
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