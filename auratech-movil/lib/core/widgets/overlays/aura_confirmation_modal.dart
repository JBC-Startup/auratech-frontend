import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../constants/app_colors.dart';

enum AuraModalVariant { primary, warning, destructive }

class AuraConfirmationModal extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final AuraModalVariant variant;
  final VoidCallback onConfirm;

  const AuraConfirmationModal({
    super.key,
    required this.title,
    required this.description,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.variant = AuraModalVariant.primary,
    required this.onConfirm,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String description,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    AuraModalVariant variant = AuraModalVariant.primary,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => AuraConfirmationModal(
        title: title,
        description: description,
        confirmText: confirmText,
        cancelText: cancelText,
        variant: variant,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color confirmBg = AuraColors.primary;
    Color confirmTextCol = Colors.white;
    IconData icon = LucideIcons.helpCircle;
    Color iconCol = AuraColors.primary;
    Color iconBg = AuraColors.primaryLight;

    if (variant == AuraModalVariant.destructive) {
      confirmBg = AuraColors.redText;
      icon = LucideIcons.alertTriangle;
      iconCol = AuraColors.redText;
      iconBg = AuraColors.redBg;
    } else if (variant == AuraModalVariant.warning) {
      confirmBg = AuraColors.amberText;
      icon = LucideIcons.alertCircle;
      iconCol = AuraColors.amberText;
      iconBg = AuraColors.amberBg;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AuraColors.border, width: 1),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconCol, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AuraColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AuraColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AuraColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    cancelText,
                    style: GoogleFonts.inter(
                        color: AuraColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmBg,
                    foregroundColor: confirmTextCol,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    confirmText,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
