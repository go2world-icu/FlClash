import 'package:material_ui/material_ui.dart';
import 'package:fl_clash/xboard/utils/xboard_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:fl_clash/xboard/features/invite/providers/invite_provider.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';

class TransferDialog extends ConsumerStatefulWidget {
  const TransferDialog({super.key});

  @override
  ConsumerState<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends ConsumerState<TransferDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool _isTransferring = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inviteState = ref.read(inviteProvider);
    final double maxAmount = inviteState.availableCommission; // 已经是元，不需要再除以100

    return AlertDialog(
      title: Text(xboardL10n.transferToWallet),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSuccess
                ? const GlyphIcon(
                    AppGlyphs.checkCircle,
                    size: 48,
                    color: Colors.green,
                    key: ValueKey('success'),
                  )
                : _isTransferring
                ? const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(key: ValueKey('loading')),
                  )
                : const GlyphIcon(
                    XBoardGlyphs.wallet,
                    size: 48,
                    color: Colors.blue,
                    key: ValueKey('wallet'),
                  ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSuccess
                ? Text(
                    xboardL10n.transferSuccess,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    key: const ValueKey('success-text'),
                  )
                : _isTransferring
                ? Text(
                    xboardL10n.transferring,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    key: const ValueKey('loading-text'),
                  )
                : Text(
                    xboardL10n.maxTransferable(
                      inviteState.availableCommission.toStringAsFixed(2),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    key: const ValueKey('balance-text'),
                  ),
          ),
          const SizedBox(height: 16),
          if (!_isTransferring && !_isSuccess) ...[
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: xboardL10n.transferAmount,
                hintText: xboardL10n.enterTransferAmount,
                border: const OutlineInputBorder(),
                suffixText: '¥',
                helperText: xboardL10n.maxTransferable(
                  maxAmount.toStringAsFixed(2),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              xboardL10n.transferNote,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      actions: [
        if (!_isTransferring && !_isSuccess) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(appLocalizations.cancel),
          ),
          ElevatedButton(
            onPressed: () => _performTransfer(maxAmount),
            child: Text(xboardL10n.confirmTransfer),
          ),
        ],
      ],
    );
  }

  Future<void> _performTransfer(double maxAmount) async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      if (mounted) {
        XBoardNotification.showError(xboardL10n.enterTransferAmountError);
      }
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      if (mounted) {
        XBoardNotification.showError(xboardL10n.invalidTransferAmount);
      }
      return;
    }

    if (amount > maxAmount) {
      if (mounted) {
        XBoardNotification.showError(
          xboardL10n.transferAmountExceeded(maxAmount.toStringAsFixed(2)),
        );
      }
      return;
    }

    setState(() {
      _isTransferring = true;
    });

    try {
      final result = await ref
          .read(inviteProvider.notifier)
          .transferCommission(amount);

      if (mounted) {
        setState(() {
          _isTransferring = false;
          _isSuccess = result;
        });

        if (result) {
          // 成功后显示动画，然后自动关闭
          await Future.delayed(const Duration(milliseconds: 1500));
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            // 关闭后显示提示
            Future.microtask(() {
              if (mounted) {
                XBoardNotification.showSuccess(
                  xboardL10n.transferSuccessMsg(amount.toStringAsFixed(2)),
                );
              }
            });
          }
        } else {
          XBoardNotification.showError(xboardL10n.transferFailed("划转失败"));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTransferring = false;
          _isSuccess = false;
        });
        XBoardNotification.showError(xboardL10n.transferFailed(e.toString()));
      }
    }
  }
}
