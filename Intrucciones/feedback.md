import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../constants/app_colors.dart';

class AuraFeedback {
  static void showError(BuildContext context, {required String message, String? errorCode}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              const Icon(LucideIcons.alertCircle, color: AuraColors.redText, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: GoogleFonts.inter(color: AuraColors.redText, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    if (errorCode != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Código: $errorCode',
                        style: GoogleFonts.inter(color: AuraColors.redText.withOpacity(0.8), fontSize: 11),
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
}