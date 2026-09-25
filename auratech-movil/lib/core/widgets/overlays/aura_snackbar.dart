import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../constants/app_colors.dart';
import '../../network/api_error.dart';

class AuraSnackbar {
  static void showError(BuildContext context,
      {required String message, String? errorCode}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AuraColors.redBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AuraColors.redBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.alertCircle,
                  color: AuraColors.redText, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: GoogleFonts.inter(
                          color: AuraColors.redText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    if (errorCode != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Código: $errorCode',
                        style: GoogleFonts.inter(
                            color:
                                AuraColors.redText.withOpacity(0.8),
                            fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context,
      {required String message}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AuraColors.greenBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AuraColors.greenBorder),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.checkCircle,
                  color: AuraColors.greenText, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                      color: AuraColors.greenText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showWarning(BuildContext context,
      {required String message}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AuraColors.amberBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AuraColors.amberBorder),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.alertTriangle,
                  color: AuraColors.amberText, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                      color: AuraColors.amberText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Parse and show API error automatically
  static void showApiError(
      BuildContext context, ApiResponseError error) {
    showError(
      context,
      message: error.displayMessage,
      errorCode: error.codigoError,
    );
  }
}
