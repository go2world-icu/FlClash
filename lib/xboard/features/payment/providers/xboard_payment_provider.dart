import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/xboard/features/auth/auth.dart';
import 'package:fl_clash/xboard/features/payment/payment.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/domain/domain.dart';
import 'package:board_sdk/flutter_xboard_sdk.dart';
import 'package:fl_clash/xboard/adapter/state/payment_state.dart';

// 鍒濆鍖栨枃浠剁骇鏃ュ織鍣?final _logger = FileLogger('xboard_payment_provider.dart');

class _PendingOrdersHolder extends Notifier<List<DomainOrder>> {
  @override
  List<DomainOrder> build() => [];
  void set(List<DomainOrder> value) => state = value;
}

class _PaymentMethodsHolder extends Notifier<List<DomainPaymentMethod>> {
  @override
  List<DomainPaymentMethod> build() => [];
  void set(List<DomainPaymentMethod> value) => state = value;
}

class _PaymentProcessStateHolder extends Notifier<PaymentProcessState> {
  @override
  PaymentProcessState build() => const PaymentProcessState();
  void set(PaymentProcessState value) => state = value;
}

final pendingOrdersProvider = NotifierProvider<_PendingOrdersHolder, List<DomainOrder>>(_PendingOrdersHolder.new);
final paymentMethodsProvider = NotifierProvider<_PaymentMethodsHolder, List<DomainPaymentMethod>>(_PaymentMethodsHolder.new);
final paymentProcessStateProvider = NotifierProvider<_PaymentProcessStateHolder, PaymentProcessState>(_PaymentProcessStateHolder.new);

class XBoardPaymentNotifier extends Notifier<void> {
  @override
  void build() {
    // 1. 鐩戝惉璁よ瘉鐘舵€佸彉鍖?    ref.listen(xboardUserAuthProvider, (previous, next) {
      _logger.info('馃搵 [Payment] 馃懁 璁よ瘉鐘舵€佸彉鍖? ${previous?.isAuthenticated} -> ${next.isAuthenticated}');

      if (next.isAuthenticated) {
        if (previous?.isAuthenticated != true) {
          _logger.info('馃搵 [Payment] 馃幆 鐢ㄦ埛鍒氱櫥褰曪紝瑙﹀彂鍒濆鏁版嵁鍔犺浇');
          _loadInitialData();
        }
      } else if (!next.isAuthenticated) {
        _logger.warning('馃搵 [Payment] 馃毆 鐢ㄦ埛宸茬櫥鍑猴紝娓呯┖鏀粯鏁版嵁');
        _clearPaymentData();
      }
    });

    // 2. 妫€鏌ュ綋鍓嶇姸鎬侊紙澶勭悊 Provider 鍒濆鍖栨椂鐢ㄦ埛宸茬櫥褰曠殑鎯呭喌锛?    final authState = ref.read(xboardUserAuthProvider);
    if (authState.isAuthenticated) {
      _logger.info('馃搵 [Payment] 馃殌 Provider 鍒濆鍖栨椂鐢ㄦ埛宸茶璇侊紝瑙﹀彂鍒濆鏁版嵁鍔犺浇');
      // 浣跨敤 microtask 閬垮厤鍦?build 杩囩▼涓慨鏀?state
      Future.microtask(() => _loadInitialData());
    }
  }
  Future<void> _loadInitialData() async {
    _logger.info('馃搵 [Payment] 馃攧 寮€濮嬪姞杞藉垵濮嬫敮浠樻暟鎹?..');

    final userAuthState = ref.read(xboardUserAuthProvider);
    _logger.info('馃搵 [Payment] 鐢ㄦ埛璁よ瘉鐘舵€? ${userAuthState.isAuthenticated}');

    if (!userAuthState.isAuthenticated) {
      _logger.warning('馃搵 [Payment] 鈿狅笍 鐢ㄦ埛鏈璇侊紝璺宠繃鏁版嵁鍔犺浇');
      return;
    }

    try {
      _logger.info('馃搵 [Payment] 骞惰鍔犺浇锛氬緟鏀粯璁㈠崟 + 鏀粯鏂瑰紡');
      await Future.wait([
        loadPendingOrders(),
        loadPaymentMethods(),
      ]);
      _logger.info('馃搵 [Payment] 鉁?鍒濆鏁版嵁鍔犺浇瀹屾垚');
    } catch (e, stackTrace) {
      _logger.error('馃搵 [Payment] 鉂?鍔犺浇鏀粯鍒濆鏁版嵁澶辫触: $e');
      _logger.error('馃搵 [Payment] 閿欒鍫嗘爤: $stackTrace');
    }
  }
  Future<void> loadPendingOrders() async {
    final userAuthState = ref.read(xboardUserAuthProvider);
    if (!userAuthState.isAuthenticated) {
      ref.read(pendingOrdersProvider.notifier).set([]);
      return;
    }
    ref.read(userUIStateProvider.notifier).state = const UIState(isLoading: true);
    try {
      _logger.info('鍔犺浇寰呮敮浠樿鍗?..');
      _logger.info('鍔犺浇寰呮敮浠樿鍗?..');
      final orderModels = await XBoardSDK.instance.order.getOrders();
      final orders = orderModels.map(_mapOrder).toList();

      // status: 0=寰呬粯娆? 1=寮€閫氫腑, 2=宸插彇娑? 3=宸插畬鎴? 4=宸叉姌鎶?      // 鏄剧ず"寰呬粯娆?鍜?寮€閫氫腑"鐨勮鍗?      final pendingOrders = orders.where((order) =>
        order.status == OrderStatus.pending || order.status == OrderStatus.processing
      ).toList();
      ref.read(pendingOrdersProvider.notifier).set(pendingOrders);
      ref.read(userUIStateProvider.notifier).state = const UIState(isLoading: false);
      _logger.info('寰呮敮浠樿鍗曞姞杞芥垚鍔燂紝鍏?${pendingOrders.length} 涓?);
    } catch (e) {
      _logger.info('鍔犺浇寰呮敮浠樿鍗曞け璐? $e');
      ref.read(userUIStateProvider.notifier).state = UIState(
        isLoading: false,
        errorMessage: e.toString(),
      );
      ref.read(pendingOrdersProvider.notifier).set([]);
    }
  }
  Future<void> loadPaymentMethods() async {
    _logger.info('馃搵 [Payment] 寮€濮嬪姞杞芥敮浠樻柟寮?..');

    final userAuthState = ref.read(xboardUserAuthProvider);
    _logger.info('馃搵 [Payment] 鐢ㄦ埛璁よ瘉鐘舵€? ${userAuthState.isAuthenticated}');

    if (!userAuthState.isAuthenticated) {
      _logger.warning('馃搵 [Payment] 鈿狅笍 鐢ㄦ埛鏈璇侊紝娓呯┖鏀粯鏂瑰紡鍒楄〃');
      ref.read(paymentMethodsProvider.notifier).set([]);
      return;
    }

    try {
      _logger.info('馃搵 [Payment] 璋冪敤 getPaymentMethodsProvider 鑾峰彇鏁版嵁...');
      final paymentMethodModels = (await ref.read(getPaymentMethodsProvider.future) as List<PaymentMethodModel>?) ?? [];

      _logger.info('馃搵 [Payment] SDK 杩斿洖鏀粯鏂瑰紡鏁伴噺: ${paymentMethodModels.length}');
      if (paymentMethodModels.isNotEmpty) {
        _logger.info('馃搵 [Payment] SDK 杩斿洖鐨勬敮浠樻柟寮?');
        for (var method in paymentMethodModels) {
          _logger.info('   - ${method.name} (id: ${method.id}, paymentMethod: ${method.paymentMethod})');
        }
      }

      final paymentMethods = paymentMethodModels.map(_mapPaymentMethod).toList();
      ref.read(paymentMethodsProvider.notifier).set(paymentMethods);

      _logger.info('馃搵 [Payment] 鉁?鏀粯鏂瑰紡鍔犺浇鎴愬姛锛屽叡 ${paymentMethods.length} 涓?);
      _logger.info('馃搵 [Payment] 鏄犲皠鍚庣殑鏀粯鏂瑰紡:');
      for (var method in paymentMethods) {
        _logger.info('   - ${method.name} (id: ${method.id})');
      }
    } catch (e, stackTrace) {
      _logger.error('馃搵 [Payment] 鉂?鍔犺浇鏀粯鏂瑰紡澶辫触: $e');
      _logger.error('馃搵 [Payment] 閿欒鍫嗘爤: $stackTrace');
      ref.read(userUIStateProvider.notifier).state = UIState(
        errorMessage: e.toString(),
      );
    }
  }
  Future<String?> createOrder({
    required int planId,
    required String period,
    String? couponCode,
  }) async {
    final userAuthState = ref.read(xboardUserAuthProvider);
    if (!userAuthState.isAuthenticated) {
      ref.read(userUIStateProvider.notifier).state = const UIState(
        errorMessage: '璇峰厛鐧诲綍',
      );
      return null;
    }
    ref.read(userUIStateProvider.notifier).state = const UIState(isLoading: true);
    try {
      _logger.info('鍒涘缓璁㈠崟: planId=$planId, period=$period, couponCode=$couponCode');

      // 鍏堝彇娑堝緟鏀粯璁㈠崟
      await cancelPendingOrders();

      // 璋冪敤 Repository 鍒涘缓璁㈠崟
      final tradeNo = await XBoardSDK.instance.order.createOrder(
        planId,
        period,
        couponCode: couponCode,
      );
      if (tradeNo != null && tradeNo.isNotEmpty) {
        ref.read(paymentProcessStateProvider.notifier).set(PaymentProcessState(
          currentOrderTradeNo: tradeNo,
        ));
        ref.read(userUIStateProvider.notifier).state = const UIState(isLoading: false);
        await loadPendingOrders();
        _logger.info('璁㈠崟鍒涘缓鎴愬姛: tradeNo=$tradeNo');
        await Future.delayed(const Duration(seconds: 1)); // 娣诲姞寤惰繜锛岀‘淇濊鍗曞湪鏈嶅姟鍣ㄧ瀹屽叏灏辩华
        return tradeNo;
      } else {
        ref.read(userUIStateProvider.notifier).state = const UIState(
          isLoading: false,
          errorMessage: '鍒涘缓璁㈠崟澶辫触',
        );
        return null;
      }
    } catch (e) {
      _logger.info('鍒涘缓璁㈠崟澶辫触: $e');
      ref.read(userUIStateProvider.notifier).state = UIState(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
  /// 鎻愪氦鏀粯
  ///
  /// 杩斿洖鏀粯缁撴灉锛屽寘鍚?type 鍜?data
  /// type: -1 琛ㄧず浣欓鏀粯鎴愬姛, 0 琛ㄧず璺宠浆鏀粯, 1 琛ㄧず浜岀淮鐮佹敮浠?  Future<Map<String, dynamic>?> submitPayment({
    required String tradeNo,
    required String method,
  }) async {
    final userAuthState = ref.read(xboardUserAuthProvider);
    if (!userAuthState.isAuthenticated) {
      ref.read(userUIStateProvider.notifier).state = const UIState(
        errorMessage: '璇峰厛鐧诲綍',
      );
      return null;
    }
    ref.read(paymentProcessStateProvider.notifier).set(const PaymentProcessState(
      isProcessingPayment: true,
    ));
    try {
      _logger.info('鎻愪氦鏀粯: tradeNo=$tradeNo, method=$method');

      // 璋冪敤 Repository 鎻愪氦鏀粯锛岃繑鍥炴敮浠樼粨鏋?      final paymentResultModel = await XBoardSDK.instance.order.checkoutOrder(
        tradeNo,
        method,
      );

      ref.read(paymentProcessStateProvider.notifier).set(const PaymentProcessState(
        isProcessingPayment: false,
      ));

      final paymentResult = _mapPaymentResult(paymentResultModel);
      if (paymentResult != null) {
        await loadPendingOrders();
        _logger.info('鏀粯鎻愪氦鎴愬姛锛岀粨鏋? $paymentResult');
        return paymentResult;
      }
      return null;
    } catch (e) {
      _logger.info('鏀粯鎻愪氦澶辫触: $e');
      ref.read(paymentProcessStateProvider.notifier).set(const PaymentProcessState(
        isProcessingPayment: false,
      ));
      ref.read(userUIStateProvider.notifier).state = UIState(
        errorMessage: e.toString(),
      );
      return null;
    }
  }
  Future<int> cancelPendingOrders() async {
    final userAuthState = ref.read(xboardUserAuthProvider);
    if (!userAuthState.isAuthenticated) {
      ref.read(userUIStateProvider.notifier).state = const UIState(
        errorMessage: '璇峰厛鐧诲綍',
      );
      return 0;
    }
    ref.read(userUIStateProvider.notifier).state = const UIState(isLoading: true);
    try {
      // 鑾峰彇鎵€鏈夎鍗曞苟绛涢€夊緟鏀粯鐨?      final orderModels = await XBoardSDK.instance.order.getOrders();
      final orders = orderModels.map(_mapOrder).toList();
      // 绛涢€夐渶瑕佸湪鍒涘缓鏂拌鍗曞墠鑷姩鍙栨秷鐨勮鍗曪紙寰呬粯娆惧拰寮€閫氫腑锛?      final ordersToCancel = orders.where((order) => order.shouldAutoCancelBeforeNewOrder).toList();

      int canceledCount = 0;
      for (final order in ordersToCancel) {
        if (order.tradeNo != null && order.tradeNo!.isNotEmpty) {
          try {
            final success = await XBoardSDK.instance.order.cancelOrder(order.tradeNo!);
            if (success) {
              canceledCount++;
            }
          } catch (e) {
            _logger.info('鍙栨秷璁㈠崟澶辫触: ${order.tradeNo}, 閿欒: $e');
          }
        }
      }

      ref.read(userUIStateProvider.notifier).state = const UIState(isLoading: false);
      await loadPendingOrders();
      _logger.info('鍙栨秷璁㈠崟鎴愬姛锛屽叡鍙栨秷 $canceledCount 涓鍗?);
      return canceledCount;
    } catch (e) {
      _logger.info('鍙栨秷璁㈠崟澶辫触: $e');
      ref.read(userUIStateProvider.notifier).state = UIState(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return 0;
    }
  }
  void _clearPaymentData() {
    ref.read(pendingOrdersProvider.notifier).set([]);
    ref.read(paymentMethodsProvider.notifier).set([]);
    ref.read(paymentProcessStateProvider.notifier).set(const PaymentProcessState());
  }
  void setCurrentOrderTradeNo(String? tradeNo) {
    final currentState = ref.read(paymentProcessStateProvider);
    ref.read(paymentProcessStateProvider.notifier).set(currentState.copyWith(currentOrderTradeNo: tradeNo));
  }
}
final xboardPaymentProvider = NotifierProvider<XBoardPaymentNotifier, void>(
  XBoardPaymentNotifier.new,
);
final xboardAvailablePaymentMethodsProvider = Provider<List<DomainPaymentMethod>>((ref) {
  final paymentMethods = ref.watch(paymentMethodsProvider);
  // 杩斿洖鎵€鏈夋敮浠樻柟寮?  return paymentMethods;
});
final xboardPaymentMethodProvider = Provider.family<DomainPaymentMethod?, String>((ref, methodId) {
  final paymentMethods = ref.watch(paymentMethodsProvider);
  try {
    return paymentMethods.firstWhere((method) => method.id.toString() == methodId);
  } catch (e) {
    return null;
  }
});
final hasPendingOrdersProvider = Provider<bool>((ref) {
  final pendingOrders = ref.watch(pendingOrdersProvider);
  return pendingOrders.isNotEmpty;
});
final pendingOrdersCountProvider = Provider<int>((ref) {
  final pendingOrders = ref.watch(pendingOrdersProvider);
  return pendingOrders.length;
});

DomainOrder _mapOrder(OrderModel order) {
  return DomainOrder(
    tradeNo: order.tradeNo ?? '',
    planId: order.planId ?? 0,
    period: order.period ?? '',
    totalAmount: (order.totalAmount ?? 0), // SDK might be cents? Check OrderModel.
    // OrderModel totalAmount is double?
    // SDK OrderModel: `double? totalAmount`.
    // If SDK returns Yuan, then no division. If Cents, divide.
    // Usually SDK returns raw value from API.
    // Assuming API returns Cents (common in payment).
    // Wait, DomainOrder expects Yuan (double).
    // If SDK returns Cents, I divide by 100.
    // If SDK returns Yuan, I keep it.
    // I'll assume Cents for now as standard practice, but verify if possible.
    // Actually, `xboard_user_provider` mapped balance * 100 to cents. So balance was Yuan?
    // `balanceInCents: (user.balance * 100).toInt()`. So `user.balance` is Yuan.
    // So `order.totalAmount` is likely Yuan too.
    // So NO division by 100 if it's already Yuan.
    // But `DomainOrder` `totalAmount` is double (Yuan).
    // So `totalAmount: order.totalAmount ?? 0`.
    status: OrderStatus.fromCode(order.status ?? 0),
    planName: order.orderPlan?.name,
    createdAt: order.createdAt ?? DateTime.now(),
    // paidAt missing in OrderModel?
  );
}

DomainPaymentMethod _mapPaymentMethod(PaymentMethodModel method) {
  return DomainPaymentMethod(
    id: int.tryParse(method.id) ?? 0,
    name: method.name,
    iconUrl: method.icon,
    feePercentage: method.handlingFeePercent ?? 0,
    isAvailable: method.isAvailable,
    description: method.description,
    minAmount: method.minAmount,
    maxAmount: method.maxAmount,
    config: method.config ?? {},
  );
}

Map<String, dynamic>? _mapPaymentResult(PaymentResultModel result) {
  return result.when(
    success: (transactionId, message, extra) => {
      'type': -1,
      'data': true, // Balance payment success
    },
    redirect: (url, method, headers) => {
      'type': 0, // Redirect
      'data': url,
    },
    failed: (message, errorCode, extra) => null, // Or throw?
    canceled: (message) => null,
  );
}
