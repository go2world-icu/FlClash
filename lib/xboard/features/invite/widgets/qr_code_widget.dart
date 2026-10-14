import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/icons/icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const QrCodeWidget({
    super.key,
    required this.data,
    this.size = 200.0,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: ShapeDecoration(
          color: backgroundColor ?? Colors.white,
          shape: AppShape.all(12).copyWith(
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GlyphIcon(
                AppGlyphs.qrCode,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                appLocalizations.noInvitationData,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
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
        shape: AppShape.all(12).copyWith(
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: size,
        backgroundColor: backgroundColor ?? Colors.white,
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: foregroundColor ?? Colors.black,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: foregroundColor ?? Colors.black,
        ),
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      ),
    );
  }
}