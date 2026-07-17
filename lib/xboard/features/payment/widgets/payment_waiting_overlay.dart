import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_clash/common/common.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/l10n/l10n.dart';
import '../models/payment_step.dart';

// 鍒濆鍖栨枃浠剁骇鏃ュ織鍣?
final _logger = FileLogger('payment_waiting_overlay.dart');
class PaymentWaitingOverlay extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onPaymentSuccess;
  final String? tradeNo;
  final String? paymentUrl;
  const PaymentWaitingOverlay({
    super.key,
    this.onClose,
    this.onPaymentSuccess,
    this.tradeNo,
    this.paymentUrl,
  });
  @override
  ConsumerState<PaymentWaitingOverlay> createState() => _PaymentWaitingOverlayState();
}
class _PaymentWaitingOverlayState extends ConsumerState<PaymentWaitingOverlay>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  PaymentStep _currentStep = PaymentStep.cancelingOrders;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _paymentCheckTimer;
  String? _currentTradeNo;
  @override
  void initState() {
    super.initState();
    _currentTradeNo = widget.tradeNo;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _paymentCheckTimer?.cancel();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  void updateStep(PaymentStep step) {
    if (mounted) {
      setState(() {
        _currentStep = step;
      });
      if (step == PaymentStep.waitingPayment && _currentTradeNo != null) {
        _startPaymentStatusCheck();
      }
    }
  }
  void updateTradeNo(String tradeNo) {
    if (mounted) {
      setState(() {
        _currentTradeNo = tradeNo;
      });
    }
  }
  void updatePaymentUrl(String paymentUrl) {
    if (mounted) {
      setState(() {
      });
    }
  }
  void _startPaymentStatusCheck() {
    _logger.info('[PaymentWaiting] 寮€濮嬪畾鏃舵娴嬫敮浠樼姸鎬侊紝璁㈠崟鍙? $_currentTradeNo');
    _paymentCheckTimer?.cancel();
    
    // 绔嬪嵆鎵ц涓€娆℃鏌?
    _checkPaymentStatus();
    
    _paymentCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    if (!mounted || _currentTradeNo == null) {
      _paymentCheckTimer?.cancel();
      return;
    }

    try {
      _logger.info('[PaymentWaiting] ===== 寮€濮嬫娴嬫敮浠樼姸鎬?=====');
      _logger.info('[PaymentWaiting] 璁㈠崟鍙? $_currentTradeNo');
      
      // 浣跨敤 SDK 妫€鏌ヨ鍗曠姸鎬?
      final orderModels = await XBoardSDK.instance.order.getOrders();
      final orderData = orderModels.firstWhere(
        (o) => o.tradeNo == _currentTradeNo,
        orElse: () => const OrderModel(status: -1),
      );
      
      _logger.info('[PaymentWaiting] API 璋冪敤瀹屾垚锛岃鍗曠姸鎬? ${orderData.status}');
      
      if (orderData.status != -1) {
        // 妫€鏌ヨ鍗曠姸鎬?
        // 鐘舵€佸€? 0=寰呬粯娆? 1=寮€閫氫腑, 2=宸插彇娑? 3=宸插畬鎴? 4=宸叉姌鎶?
        if (orderData.status == 3) {
          // 鏀粯鎴愬姛锛岀珛鍗虫墽琛屾垚鍔熷洖璋?
          _logger.info('[PaymentWaiting] ===== 妫€娴嬪埌鏀粯鎴愬姛锛佺姸鎬? ${orderData.status} =====');
          _paymentCheckTimer?.cancel();
          if (mounted) {
            setState(() {
              _currentStep = PaymentStep.paymentSuccess;
            });
            _pulseController.stop();
            
            // 绔嬪嵆鎵ц鎴愬姛鍥炶皟
            if (widget.onPaymentSuccess != null) {
              widget.onPaymentSuccess?.call();
            }
          }
        } else if (orderData.status == 0 || orderData.status == 1) {
          // 浠嶅湪绛夊緟鏀粯 (0: 寰呬粯娆? 1: 寮€閫氫腑)
          _logger.info('[PaymentWaiting] 鏀粯浠嶅湪绛夊緟涓?(鐘舵€? ${orderData.status})...');
        } else {
          // 鍏朵粬鐘舵€佽涓哄け璐?(2: 宸插彇娑? 4: 宸叉姌鎶?
          _logger.info('[PaymentWaiting] 鏀粯瑙嗕负澶辫触/缁撴潫锛岀姸鎬? ${orderData.status}');
          _paymentCheckTimer?.cancel();
          if (mounted) {
            widget.onClose?.call();
          }
        }
      } else {
        _logger.info('[PaymentWaiting] 鑾峰彇璁㈠崟鐘舵€佸け璐ワ細璁㈠崟涓嶅瓨鍦?);
      }
    } catch (e) {
      _logger.info('[PaymentWaiting] 妫€娴嬫敮浠樼姸鎬佸紓甯? $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _logger.info('[PaymentWaiting] 搴旂敤鍥炲埌鍓嶅彴锛岀珛鍗虫娴嬫敮浠樼姸鎬?);
      if (_currentStep == PaymentStep.waitingPayment && _currentTradeNo != null) {
        _checkPaymentStatus();
      }
    }
  }
  String _getStepTitle(PaymentStep step) {
    switch (step) {
      case PaymentStep.cancelingOrders:
        return '娓呯悊鏃ц鍗?;
      case PaymentStep.createOrder:
        return AppLocalizations.of(context).xboardCreatingOrder;
      case PaymentStep.loadingPayment:
        return AppLocalizations.of(context).xboardLoadingPaymentPage;
      case PaymentStep.verifyPayment:
        return AppLocalizations.of(context).xboardPaymentMethodVerified;
      case PaymentStep.waitingPayment:
        return AppLocalizations.of(context).xboardWaitingPaymentCompletion;
      case PaymentStep.paymentSuccess:
        return AppLocalizations.of(context).xboardPaymentSuccess;
    }
  }
  String _getStepDescription(PaymentStep step) {
    switch (step) {
      case PaymentStep.cancelingOrders:
        return '姝ｅ湪娓呯悊涔嬪墠鐨勫緟鏀粯璁㈠崟...';
      case PaymentStep.createOrder:
        return AppLocalizations.of(context).xboardCreatingOrderPleaseWait;
      case PaymentStep.loadingPayment:
        return AppLocalizations.of(context).xboardPreparingPaymentPage;
      case PaymentStep.verifyPayment:
        return AppLocalizations.of(context).xboardPaymentMethodVerifiedPreparing;
      case PaymentStep.waitingPayment:
        return '鏀粯椤甸潰宸叉墦寮€锛屾敮浠橀摼鎺ュ凡澶嶅埗鍒板壀璐存澘銆傚鏋滄病鏈夎嚜鍔ㄨ烦杞紝璇锋墜鍔ㄧ矘璐村埌娴忚鍣ㄦ墦寮€銆?;
      case PaymentStep.paymentSuccess:
        return AppLocalizations.of(context).xboardCongratulationsSubscriptionActivated;
    }
  }
  Color _getStepColor(PaymentStep step) {
    switch (step) {
      case PaymentStep.cancelingOrders:
        return Colors.grey;
      case PaymentStep.createOrder:
        return Colors.orange;
      case PaymentStep.loadingPayment:
        return Colors.blue;
      case PaymentStep.verifyPayment:
        return Colors.green;
      case PaymentStep.waitingPayment:
        return Colors.purple;
      case PaymentStep.paymentSuccess:
        return Colors.green;
    }
  }
  IconData _getStepIcon(PaymentStep step) {
    switch (step) {
      case PaymentStep.cancelingOrders:
        return Icons.clear_all;
      case PaymentStep.createOrder:
        return Icons.receipt_long;
      case PaymentStep.loadingPayment:
        return Icons.payment;
      case PaymentStep.verifyPayment:
        return Icons.verified_user;
      case PaymentStep.waitingPayment:
        return Icons.access_time;
      case PaymentStep.paymentSuccess:
        return Icons.check_circle;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _getStepColor(_currentStep).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _getStepColor(_currentStep),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          _getStepIcon(_currentStep),
                          size: 40,
                          color: _getStepColor(_currentStep),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  _getStepTitle(_currentStep),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _getStepDescription(_currentStep),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_currentStep == PaymentStep.paymentSuccess)
                  Icon(
                    Icons.check_circle,
                    size: 48,
                    color: Colors.green,
                  )
                else
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStepColor(_currentStep),
                      ),
                    ),
                  ),
              ],
            ),
            actions: () {
              if (_currentStep == PaymentStep.paymentSuccess && widget.onPaymentSuccess != null) {
                return [
                  ElevatedButton(
                    onPressed: widget.onPaymentSuccess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(AppLocalizations.of(context).xboardConfirm),
                  ),
                ];
              } else if (_currentStep == PaymentStep.waitingPayment && widget.onClose != null) {
                return [
                  TextButton(
                    onPressed: widget.onClose,
                    child: Text(AppLocalizations.of(context).xboardHandleLater),
                  ),
                ];
              }
              return null;
            }(),
          ),
        ),
      ),
    );
  }
}
class PaymentWaitingManager {
  static OverlayEntry? _overlayEntry;
  static GlobalKey<_PaymentWaitingOverlayState>? _overlayKey;
  static VoidCallback? _onClose;
  static VoidCallback? _onPaymentSuccess;
  static void show(
    BuildContext context, {
    VoidCallback? onClose,
    VoidCallback? onPaymentSuccess,
    String? tradeNo,
  }) {
    _logger.debug('[PaymentWaitingManager.show] 鍑嗗鏄剧ず鏀粯绛夊緟寮圭獥');
    _logger.debug('[PaymentWaitingManager.show] onClose 鏄惁涓?null: ${onClose == null}');
    _logger.debug('[PaymentWaitingManager.show] onPaymentSuccess 鏄惁涓?null: ${onPaymentSuccess == null}');
    hide(); // 纭繚涔嬪墠鐨刼verlay琚竻闄?
    _onClose = onClose;
    _onPaymentSuccess = onPaymentSuccess;
    _logger.debug('[PaymentWaitingManager.show] 闈欐€佸彉閲忓凡璁剧疆锛宊onPaymentSuccess 鏄惁涓?null: ${_onPaymentSuccess == null}');
    _overlayKey = GlobalKey<_PaymentWaitingOverlayState>();
    _overlayEntry = OverlayEntry(
      builder: (context) => PaymentWaitingOverlay(
        key: _overlayKey,
        onClose: () {
          hide();
          _onClose?.call();
        },
        onPaymentSuccess: () {
          _logger.debug('[PaymentWaitingManager] 鏀跺埌鏀粯鎴愬姛閫氱煡锛屽噯澶囧鐞?);
          // 鍏堜繚瀛樺洖璋冿紝鍐嶉殣钘忓脊绐楋紙鍥犱负hide()浼氭竻绌哄洖璋冿級
          final callback = _onPaymentSuccess;
          _logger.debug('[PaymentWaitingManager] 淇濆瓨鐨勫洖璋冩槸鍚︿负 null: ${callback == null}');
          hide();
          _logger.debug('[PaymentWaitingManager] 寮圭獥宸查殣钘忥紝鍑嗗璋冪敤澶栭儴鍥炶皟');
          if (callback != null) {
            _logger.debug('[PaymentWaitingManager] 澶栭儴鍥炶皟瀛樺湪锛屽紑濮嬭皟鐢?);
            callback.call();
            _logger.debug('[PaymentWaitingManager] 澶栭儴鍥炶皟璋冪敤瀹屾垚');
          } else {
            _logger.debug('[PaymentWaitingManager] 璀﹀憡锛氬閮ㄥ洖璋冧负 null');
          }
        },
        tradeNo: tradeNo,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }
  static void updateStep(PaymentStep step) {
    _overlayKey?.currentState?.updateStep(step);
  }
  static void updateTradeNo(String tradeNo) {
    _overlayKey?.currentState?.updateTradeNo(tradeNo);
  }
  static void updatePaymentUrl(String paymentUrl) {
    _overlayKey?.currentState?.updatePaymentUrl(paymentUrl);
  }
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _overlayKey = null;
    _onClose = null;
    _onPaymentSuccess = null;
  }
}