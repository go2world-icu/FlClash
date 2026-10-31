import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/qr_code.dart';
import 'package:fl_clash/xboard/l10n/xboard_strings.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fl_clash/ui/shape.dart';

class QrCodeWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color? backgroundColor;

  const QrCodeWidget({
    super.key,
    required this.data,
    this.size = 200.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: ShapeDecoration(
          color: backgroundColor ?? Colors.white,
          shape: AppShape.all(
            12,
          ).copyWith(side: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GlyphIcon(AppGlyphs.qrCode, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                xboardL10n.noInvitationData,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: backgroundColor ?? Colors.white,
        shape: AppShape.all(
          12,
        ).copyWith(side: BorderSide(color: Colors.grey.shade300)),
      ),
      child: QrCodeView(data: data, size: size),
    );
  }
}
