import 'package:fl_clash/common/dialog.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/xboard/core/core.dart';
import 'package:fl_clash/xboard/icons/xboard_glyphs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart' show AppShape;
import 'package:prism_ui/shape.dart';

import '../services/log_report_service.dart';

/// 日志上报行（内嵌在滚动内容中）
class LogUploadRow extends ConsumerStatefulWidget {
  const LogUploadRow({super.key});

  @override
  ConsumerState<LogUploadRow> createState() => _LogUploadRowState();
}

class _LogUploadRowState extends ConsumerState<LogUploadRow> {
  bool _isUploading = false;
  bool _hasUploaded = false;

  Color get _disabledColor => Theme.of(
    context,
  ).colorScheme.onSurfaceVariant.withValues(alpha: _hasUploaded ? 0.4 : 0.5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
        shape: AppShape.all(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '遇到问题？',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          GestureDetector(
            onTap: (_isUploading || _hasUploaded) ? null : _uploadLogs,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_hasUploaded)
                  GlyphIcon(XBoardGlyphs.bug, size: 14, color: _disabledColor),
                if (!_hasUploaded) const SizedBox(width: 4),
                Text(
                  _isUploading ? '上传中...' : (_hasUploaded ? '已上报' : '日志上报'),
                  style: TextStyle(
                    color: _disabledColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: (_isUploading || _hasUploaded)
                        ? null
                        : TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadLogs() async {
    if (_isUploading || _hasUploaded) return;
    final logs = ref.read(logsProvider).list;
    final upload = ref.read(logReportUploaderProvider);
    setState(() => _isUploading = true);

    try {
      final success = await upload(logs);

      if (!mounted) return;

      if (success) {
        _hasUploaded = true;
        _showSnackBar('日志上报成功 ✓');
      } else {
        _showSnackBar('日志上报失败');
      }
    } catch (e, stackTrace) {
      XBoardLogger.error('日志上报失败', e, stackTrace);
      if (!mounted) return;
      _showSnackBar('上报异常: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showSnackBar(String msg) {
    if (!mounted) return;
    dialogs.showBanner(msg);
  }
}
