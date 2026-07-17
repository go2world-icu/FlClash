import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_clash/xboard/utils/xboard_notification.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart' show XBoardSDK, CouponModel;
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:fl_clash/xboard/features/payment/providers/xboard_payment_provider.dart';
import '../widgets/payment_waiting_overlay.dart';
import '../widgets/payment_method_selector_dialog.dart';
import '../widgets/plan_header_card.dart';
import '../widgets/period_selector.dart';
import '../widgets/coupon_input_section.dart';
import '../widgets/price_summary_card.dart';
import '../models/payment_step.dart';
import '../utils/price_calculator.dart';

// 鍒濆鍖栨枃浠剁骇鏃ュ織鍣?
final _logger = FileLogger('plan_purchase_page.dart');

/// 濂楅璐拱椤甸潰
class PlanPurchasePage extends ConsumerStatefulWidget {
  final DomainPlan plan;
  final bool embedded; // 鏄惁涓哄祵鍏ユā寮忥紙妗岄潰绔〉闈㈠唴鍒囨崲鏃朵娇鐢級
  final VoidCallback? onBack; // 杩斿洖鍥炶皟

  const PlanPurchasePage({
    super.key,
    required this.plan,
    this.embedded = false,
    this.onBack,
  });

  @override
  ConsumerState<PlanPurchasePage> createState() => _PlanPurchasePageState();
}

class _PlanPurchasePageState extends ConsumerState<PlanPurchasePage> {
  // 鍛ㄦ湡閫夋嫨
  String? _selectedPeriod;

  // 浼樻儬鍒哥浉鍏?
  final _couponController = TextEditingController();
  bool _isCouponValidating = false;
  bool? _isCouponValid;
  String? _couponErrorMessage;
  String? _couponCode;
  int? _couponType;
  int? _couponValue;
  double? _discountAmount;
  double? _finalPrice;

  // 鐢ㄦ埛浣欓
  double? _userBalance;
  bool _isLoadingBalance = false;

  @override
  void initState() {
    super.initState();
    // 纭繚 PaymentProvider 琚垵濮嬪寲锛屼互渚垮紑濮嬪姞杞芥敮浠樻柟寮?
    ref.read(xboardPaymentProvider);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final periods = _getAvailablePeriods(context);
      if (periods.isNotEmpty && _selectedPeriod == null) {  
        setState(() {
          _selectedPeriod = periods.first['period'];
        });
      }
      _loadUserBalance();
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  // ========== 鏁版嵁鍔犺浇 ==========

  Future<void> _loadUserBalance() async {
    setState(() => _isLoadingBalance = true);
    try {
      // 浣跨敤 xboardUserProvider 鑾峰彇鐢ㄦ埛淇℃伅
      final userInfo = ref.read(xboardUserProvider).userInfo;
      
      if (mounted) {
        setState(() => _userBalance = userInfo?.balanceInYuan);
      }
    } catch (e) {
      _logger.debug('[璐拱] 鍔犺浇鐢ㄦ埛浣欓澶辫触: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingBalance = false);
      }
    }
  }

  List<Map<String, dynamic>> _getAvailablePeriods(BuildContext context) {
    final List<Map<String, dynamic>> periods = [];
    final plan = widget.plan;
    final l10n = AppLocalizations.of(context);

    if (plan.monthlyPrice != null) {
      periods.add({
        'period': 'month_price',
        'label': l10n.xboardMonthlyPayment,
        'price': plan.monthlyPrice!,
        'description': l10n.xboardMonthlyRenewal,
      });
    }
    if (plan.quarterlyPrice != null) {
      periods.add({
        'period': 'quarter_price',
        'label': l10n.xboardQuarterlyPayment,
        'price': plan.quarterlyPrice!,
        'description': l10n.xboardThreeMonthCycle,
      });
    }
    if (plan.halfYearlyPrice != null) {
      periods.add({
        'period': 'half_year_price',
        'label': l10n.xboardHalfYearlyPayment,
        'price': plan.halfYearlyPrice!,
        'description': l10n.xboardSixMonthCycle,
      });
    }
    if (plan.yearlyPrice != null) {
      periods.add({
        'period': 'year_price',
        'label': l10n.xboardYearlyPayment,
        'price': plan.yearlyPrice!,
        'description': l10n.xboardTwelveMonthCycle,
      });
    }
    if (plan.twoYearPrice != null) {
      periods.add({
        'period': 'two_year_price',
        'label': l10n.xboardTwoYearPayment,
        'price': plan.twoYearPrice!,
        'description': l10n.xboardTwentyFourMonthCycle,
      });
    }
    if (plan.threeYearPrice != null) {
      periods.add({
        'period': 'three_year_price',
        'label': l10n.xboardThreeYearPayment,
        'price': plan.threeYearPrice!,
        'description': l10n.xboardThirtySixMonthCycle,
      });
    }
    if (plan.onetimePrice != null) {
      periods.add({
        'period': 'onetime_price',
        'label': l10n.xboardOneTimePayment,
        'price': plan.onetimePrice!,
        'description': l10n.xboardBuyoutPlan,
      });
    }

    return periods;
  }

  double _getCurrentPrice() {
    if (_selectedPeriod == null) return 0.0;
    final periods = _getAvailablePeriods(context);
    final selectedPeriod = periods.firstWhere(
      (period) => period['period'] == _selectedPeriod,
      orElse: () => {},
    );
    return selectedPeriod['price']?.toDouble() ?? 0.0;
  }

  // ========== 浼樻儬鍒搁獙璇?==========

  Future<void> _validateCoupon() async {
    if (_couponController.text.trim().isEmpty) {
      _clearCoupon();
      return;
    }

    setState(() {
      _isCouponValidating = true;
      _isCouponValid = null;
      _couponErrorMessage = null;
    });

    try {
      final couponCode = _couponController.text.trim();
      // TODO: 灏嗘潵娣诲姞鍒?PaymentRepository锛岀洰鍓嶄繚鐣欎娇鐢?SDK
      final couponData = await XBoardSDK.instance.order.checkCoupon(
        _couponController.text.trim(),
        widget.plan.id,
      );

      if (couponData != null && mounted) {
        _applyCoupon(couponCode, couponData);
      } else if (mounted) {
        _setCouponInvalid();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCouponValid = false;
          _couponErrorMessage = '${AppLocalizations.of(context).xboardValidationFailed}: ${e.toString()}';
          _clearCouponData();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isCouponValidating = false);
      }
    }
  }

  void _applyCoupon(String code, CouponModel couponData) {
    final currentPrice = _getCurrentPrice();
    final discountAmount = PriceCalculator.calculateDiscountAmount(
      currentPrice,
      couponData.type,
      couponData.value,
    );
    final finalPrice = currentPrice - discountAmount;

    setState(() {
      _isCouponValid = true;
      _couponCode = code;
      _couponType = couponData.type;
      _couponValue = couponData.value;
      _discountAmount = discountAmount;
      _finalPrice = finalPrice > 0 ? finalPrice : 0;
      _couponErrorMessage = null;
    });
  }

  void _setCouponInvalid() {
    setState(() {
      _isCouponValid = false;
      _couponErrorMessage = AppLocalizations.of(context).xboardInvalidOrExpiredCoupon;
      _clearCouponData();
    });
  }

  void _clearCoupon() {
    if (mounted) {
      setState(() {
        _isCouponValid = null;
        _couponErrorMessage = null;
        _clearCouponData();
      });
    }
  }

  void _clearCouponData() {
    _discountAmount = null;
    _finalPrice = null;
    _couponCode = null;
    _couponType = null;
    _couponValue = null;
  }

  void _recalculateDiscount() {
    if (_couponType == null || _couponValue == null) return;

    final currentPrice = _getCurrentPrice();
    final discountAmount = PriceCalculator.calculateDiscountAmount(
      currentPrice,
      _couponType,
      _couponValue,
    );

    setState(() {
      _discountAmount = discountAmount;
      _finalPrice = PriceCalculator.calculateFinalPrice(
        currentPrice,
        _couponType,
        _couponValue,
      );
    });
  }

  // ========== 璐拱娴佺▼ ==========

  Future<void> _proceedToPurchase() async {
    if (_selectedPeriod == null) {
      XBoardNotification.showError(AppLocalizations.of(context).xboardPleaseSelectPaymentPeriod);
      return;
    }

    try {
      String? tradeNo;
      _logger.debug('[璐拱] 寮€濮嬭喘涔版祦绋嬶紝濂楅ID: ${widget.plan.id}, 鍛ㄦ湡: $_selectedPeriod');

      // 鏄剧ず鏀粯绛夊緟椤甸潰
      if (mounted) {
        _showPaymentWaiting(null);
        PaymentWaitingManager.updateStep(PaymentStep.cancelingOrders);
      }

      // 鍒涘缓璁㈠崟
      _logger.debug('[璐拱] 鍒涘缓璁㈠崟');
      PaymentWaitingManager.updateStep(PaymentStep.createOrder);
      
      final paymentNotifier = ref.read(xboardPaymentProvider.notifier);
      tradeNo = await paymentNotifier.createOrder(
        planId: widget.plan.id,
        period: _selectedPeriod!,
        couponCode: _couponCode,
      );

      if (tradeNo == null) {
        final errorMessage = ref.read(userUIStateProvider).errorMessage;
        throw Exception('${AppLocalizations.of(context).xboardOrderCreationFailed}: $errorMessage');
      }

      _logger.debug('[璐拱] 璁㈠崟鍒涘缓鎴愬姛: $tradeNo');
      PaymentWaitingManager.updateTradeNo(tradeNo);

      // 璁＄畻瀹炰粯閲戦
      final displayFinalPrice = _finalPrice ?? _getCurrentPrice();
      final balanceToUse = _userBalance != null && _userBalance! > 0
          ? (_userBalance! > displayFinalPrice ? displayFinalPrice : _userBalance!)
          : 0.0;
      final actualPayAmount = displayFinalPrice - balanceToUse;

      _logger.debug('[璐拱] 瀹炰粯閲戦: $actualPayAmount (浼樻儬鍚庝环鏍? $displayFinalPrice, 浣欓鎶垫墸: $balanceToUse)');

      // 浣跨敤 xboardAvailablePaymentMethodsProvider 鑾峰彇鏀粯鏂瑰紡
      final paymentMethods = ref.read(xboardAvailablePaymentMethodsProvider);
      
      _logger.info('[璐拱] 鑾峰彇鍒扮殑鏀粯鏂瑰紡鏁伴噺: ${paymentMethods.length}');
      if (paymentMethods.isNotEmpty) {
        _logger.info('[璐拱] 鏀粯鏂瑰紡鍒楄〃:');
        for (var method in paymentMethods) {
          _logger.info('  - ${method.name} (id: ${method.id})');
        }
      } else {
        _logger.error('[璐拱] 鈿狅笍 鏀粯鏂瑰紡鍒楄〃涓虹┖锛?);
      }
      
      if (paymentMethods.isEmpty) {
        throw Exception('鏆傛棤鍙敤鐨勬敮浠樻柟寮?);
      }
      
      DomainPaymentMethod? selectedMethod;
      
      // 濡傛灉瀹炰粯閲戦涓?锛堜綑棰濆畬鍏ㄦ姷鎵ｏ級锛岃嚜鍔ㄩ€夋嫨绗竴涓敮浠樻柟寮忥紝璺宠繃鐢ㄦ埛閫夋嫨
      if (actualPayAmount <= 0) {
        _logger.debug('[璐拱] 瀹炰粯閲戦涓?锛岃嚜鍔ㄩ€夋嫨绗竴涓敮浠樻柟寮?);
        selectedMethod = paymentMethods.first;
        // 鏄剧ず鏀粯绛夊緟椤甸潰
        if (mounted) {
          _showPaymentWaiting(tradeNo);
        }
      } else {
        // 闇€瑕佸疄闄呮敮浠橈紝璁╃敤鎴烽€夋嫨鏀粯鏂瑰紡
        selectedMethod = await _selectPaymentMethod(paymentMethods, tradeNo);
        if (selectedMethod == null) return;
      }

      // 鎻愪氦鏀粯
      await _submitPayment(tradeNo, selectedMethod);
    } catch (e) {
      _logger.error('璐拱娴佺▼鍑洪敊: $e');
        if (mounted) {
        PaymentWaitingManager.hide();
        XBoardNotification.showError('鎿嶄綔澶辫触: ${e.toString()}');
      }
    }
  }

  void _showPaymentWaiting(String? tradeNo) {
          PaymentWaitingManager.show(
            context,
      onClose: () => Navigator.of(context).pop(),
      onPaymentSuccess: _handlePaymentSuccess,
      tradeNo: tradeNo,
    );
  }

  void _handlePaymentSuccess() {
    _logger.info('[鏀粯鎴愬姛] 澶勭悊鏀粯鎴愬姛鍥炶皟');
    try {
      final userProvider = ref.read(xboardUserProvider.notifier);
      userProvider.refreshSubscriptionInfoAfterPayment();
    } catch (e) {
      _logger.info('[鏀粯鎴愬姛] 鍒锋柊璁㈤槄淇℃伅澶辫触: $e');
    }

    if (mounted) {
      XBoardNotification.showSuccess(AppLocalizations.of(context).xboardPaymentSuccess);
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        try {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } catch (e) {
          _logger.info('[鏀粯鎴愬姛] 瀵艰埅澶辫触: $e');
        }
      }
    });
  }

  Future<DomainPaymentMethod?> _selectPaymentMethod(
    List<DomainPaymentMethod> methods,
    String tradeNo,
  ) async {
    if (methods.length == 1) {
      // 鍗曚竴鏀粯鏂瑰紡锛岀洿鎺ユ樉绀虹瓑寰呴〉闈㈠苟杩斿洖
      if (mounted) {
        _showPaymentWaiting(tradeNo);
      }
      return methods.first;
    }

    PaymentWaitingManager.hide();
    if (!mounted) return null;

    final selected = await PaymentMethodSelectorDialog.show(
      context,
      paymentMethods: methods,
    );

    if (selected == null) {
      _logger.debug('[鏀粯] 鐢ㄦ埛鍙栨秷閫夋嫨鏀粯鏂瑰紡');
      return null;
    }

    if (mounted) {
      _showPaymentWaiting(tradeNo);
    }

    return selected;
  }

  Future<void> _submitPayment(String tradeNo, DomainPaymentMethod method) async {
    _logger.debug('[鏀粯] 鎻愪氦鏀粯: $tradeNo, 鏂瑰紡: ${method.id}');
      PaymentWaitingManager.updateStep(PaymentStep.loadingPayment);
      PaymentWaitingManager.updateStep(PaymentStep.verifyPayment);

    final paymentNotifier = ref.read(xboardPaymentProvider.notifier);
      final paymentResult = await paymentNotifier.submitPayment(
        tradeNo: tradeNo,
      method: method.id.toString(),
      );
      
    if (paymentResult == null) {
      throw Exception('鏀粯澶辫触: 鏀粯璇锋眰杩斿洖绌虹粨鏋?);
    }
      
    if (!mounted) return;
        
    final paymentType = paymentResult['type'] as int? ?? 0;
    final paymentData = paymentResult['data'];
        
    _logger.debug('[鏀粯] type=$paymentType, data=$paymentData (${paymentData.runtimeType})');
        
    // type: -1 浣欓鏀粯鎴愬姛锛坉ata 鏄?bool锛?
    // type: 0 璺宠浆鏀粯锛坉ata 鏄?String锛?
    // type: 1 浜岀淮鐮佹敮浠橈紙data 鏄?String锛?
    if (paymentType == -1) {
      // 鍏嶈垂璁㈠崟/浣欓鏀粯锛宒ata 鏄?bool
      if (paymentData == true) {
        await _handleBalancePaymentSuccess();
      } else {
        throw Exception('鏀粯澶辫触: 浣欓鏀粯鏈垚鍔?(data=$paymentData)');
      }
    } else if (paymentData != null && paymentData is String && paymentData.isNotEmpty) {
      // 浠樿垂璁㈠崟锛宒ata 鏄敮浠楿RL锛圫tring锛?
      PaymentWaitingManager.updateStep(PaymentStep.waitingPayment);
      await _launchPaymentUrl(paymentData, tradeNo);
    } else {
      throw Exception('鏀粯澶辫触: 鏈幏鍙栧埌鏈夋晥鐨勬敮浠樻暟鎹?(type=$paymentType, data=$paymentData)');
    }
  }

  Future<void> _handleBalancePaymentSuccess() async {
    _logger.debug('[鏀粯] 浣欓鏀粯鎴愬姛');
          PaymentWaitingManager.hide();
          
          try {
            final userProvider = ref.read(xboardUserProvider.notifier);
            userProvider.refreshSubscriptionInfoAfterPayment();
          } catch (e) {
      _logger.debug('[浣欓鏀粯] 鍒锋柊璁㈤槄淇℃伅澶辫触: $e');
          }
          
          if (mounted) {
            XBoardNotification.showSuccess(AppLocalizations.of(context).xboardPaymentSuccess);
            
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                try {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } catch (e) {
            _logger.debug('[浣欓鏀粯] 瀵艰埅澶辫触: $e');
                }
              }
            });
    }
  }

  Future<void> _launchPaymentUrl(String url, String tradeNo) async {
    try {
      if (!mounted) return;

        await Clipboard.setData(ClipboardData(text: url));
        final uri = Uri.parse(url);

        if (!await canLaunchUrl(uri)) {
          throw Exception('鏃犳硶鎵撳紑鏀粯閾炬帴');
        }

        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          throw Exception('鏃犳硶鍚姩澶栭儴娴忚鍣?);
      }

      _logger.debug('[鏀粯] 鏀粯椤甸潰宸插湪娴忚鍣ㄤ腑鎵撳紑: $tradeNo');
    } catch (e) {
      if (mounted) {
        PaymentWaitingManager.hide();
        XBoardNotification.showError('鎵撳紑鏀粯椤甸潰澶辫触: ${e.toString()}');
      }
    }
  }

  // ========== UI 鏋勫缓 ==========

  @override
  Widget build(BuildContext context) {
    final periods = _getAvailablePeriods(context);
    final currentPrice = _getCurrentPrice();
    // 鐢ㄤ簬鍒ゆ柇骞冲彴绫诲瀷
    final isPlatformDesktop = Platform.isLinux || Platform.isWindows || Platform.isMacOS;

    final content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 700,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // 濂楅淇℃伅鍗＄墖
              PlanHeaderCard(plan: widget.plan),
              const SizedBox(height: 20),

              // 鍛ㄦ湡閫夋嫨鍣?
              PeriodSelector(
                periods: periods,
                selectedPeriod: _selectedPeriod,
                onPeriodSelected: (period) {
                          setState(() {
                    _selectedPeriod = period;
                    if (_couponCode != null) {
                      _recalculateDiscount();
                    }
                  });
                },
                couponType: _couponType,
                couponValue: _couponValue,
              ),
              const SizedBox(height: 20),

              // 浼樻儬鍒歌緭鍏?
              CouponInputSection(
                controller: _couponController,
                isValidating: _isCouponValidating,
                isValid: _isCouponValid,
                errorMessage: _couponErrorMessage,
                discountAmount: _discountAmount,
                onValidate: _validateCoupon,
                onChanged: _clearCoupon,
              ),
              const SizedBox(height: 20),

              // 浠锋牸姹囨€?
              if (_selectedPeriod != null)
                PriceSummaryCard(
                  originalPrice: currentPrice,
                  finalPrice: _finalPrice,
                  discountAmount: _discountAmount,
                  userBalance: _userBalance,
                ),
              const SizedBox(height: 20),

              // 纭璐拱鎸夐挳
            SizedBox(
              width: double.infinity,
                height: 54,
              child: Consumer(
                builder: (context, ref, child) {
                  final paymentState = ref.watch(userUIStateProvider);
                  return ElevatedButton(
                      onPressed: paymentState.isLoading ? null : _proceedToPurchase,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                        elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: paymentState.isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                                const SizedBox(width: 12),
                                Text(
                                  AppLocalizations.of(context).xboardProcessing,
                                  style: const TextStyle(fontSize: 16),
                                ),
                            ],
                          )
                        : Text(
                            AppLocalizations.of(context).xboardConfirmPurchase,
                            style: const TextStyle(
                                fontSize: 17,
                              fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                            ),
                          ),
                  );
                },
              ),
            ),
              const SizedBox(height: 16),
          ],
          ),
        ),
      ),
    );

    // 妗岄潰绔祵鍏ユā寮忥細鍙繑鍥炲唴瀹癸紙澶栧眰宸叉湁 Scaffold锛?
    if (widget.embedded) {
      return content;
    }

    // 绉诲姩绔叏灞忔垨鐙珛椤甸潰锛氬甫 AppBar 鐨?Scaffold
    return Scaffold(
      appBar: isPlatformDesktop ? null : AppBar(
        title: Text(AppLocalizations.of(context).xboardPurchaseSubscription),
      ),
      body: content,
    );
  }
} 

