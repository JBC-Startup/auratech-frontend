import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

enum AuraButtonVariant { primary, outline, ghost, destructive }

class AuraButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AuraButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final double fontSize;

  const AuraButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AuraButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    final child = _buildChild();

    Widget button;
    switch (variant) {
      case AuraButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AuraColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFE2E8F0),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: child,
        );
        break;
      case AuraButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AuraColors.textSecondary,
            side: const BorderSide(color: AuraColors.border),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: child,
        );
        break;
      case AuraButtonVariant.ghost:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AuraColors.textSecondary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: child,
        );
        break;
      case AuraButtonVariant.destructive:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AuraColors.redText,
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFE2E8F0),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: child,
        );
        break;
    }

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    final textColor = variant == AuraButtonVariant.primary ||
            variant == AuraButtonVariant.destructive
        ? Colors.white
        : AuraColors.textSecondary;

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
                color: textColor),
          ),
        ],
      );
    }

    return Text(
      label,
      style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          color: textColor),
    );
  }
}
