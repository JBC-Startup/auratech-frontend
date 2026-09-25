import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

enum AuraBadgeVariant { green, blue, amber, red, neutral }

class AuraBadge extends StatelessWidget {
  final String label;
  final AuraBadgeVariant variant;
  final double fontSize;

  const AuraBadge({
    super.key,
    required this.label,
    this.variant = AuraBadgeVariant.neutral,
    this.fontSize = 11,
  });

  /// Maps API status strings to appropriate badge variants
  static AuraBadgeVariant variantFromStatus(String status) {
    switch (status.toUpperCase()) {
      case 'DISPONIBLE':
      case 'FINALIZADO':
      case 'VERIFICADO':
      case 'CONFIRMADO':
      case 'COMPLETADO':
        return AuraBadgeVariant.green;
      case 'EN_PROCESO':
      case 'ACEPTADO':
      case 'ACTIVO':
        return AuraBadgeVariant.blue;
      case 'PENDIENTE':
      case 'EN_REVISION':
      case 'PENDIENTE_VERIFICACION':
        return AuraBadgeVariant.amber;
      case 'RECHAZADO':
      case 'CANCELADO':
      case 'INACTIVO':
      case 'RETIRADA':
        return AuraBadgeVariant.red;
      default:
        return AuraBadgeVariant.neutral;
    }
  }

  /// Convenience constructor from API status
  factory AuraBadge.fromStatus(String status, {String? customLabel}) {
    return AuraBadge(
      label: customLabel ?? _formatStatus(status),
      variant: variantFromStatus(status),
    );
  }

  static String _formatStatus(String status) {
    return status
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((w) =>
            w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: colors.text,
        ),
      ),
    );
  }

  _BadgeColors _getColors() {
    switch (variant) {
      case AuraBadgeVariant.green:
        return _BadgeColors(
          bg: AuraColors.greenBg,
          border: AuraColors.greenBorder,
          text: AuraColors.greenText,
        );
      case AuraBadgeVariant.blue:
        return _BadgeColors(
          bg: AuraColors.primaryLight,
          border: AuraColors.primaryBorder,
          text: AuraColors.primaryText,
        );
      case AuraBadgeVariant.amber:
        return _BadgeColors(
          bg: AuraColors.amberBg,
          border: AuraColors.amberBorder,
          text: AuraColors.amberText,
        );
      case AuraBadgeVariant.red:
        return _BadgeColors(
          bg: AuraColors.redBg,
          border: AuraColors.redBorder,
          text: AuraColors.redText,
        );
      case AuraBadgeVariant.neutral:
        return _BadgeColors(
          bg: AuraColors.backgroundAlt,
          border: AuraColors.border,
          text: AuraColors.textSecondary,
        );
    }
  }
}

class _BadgeColors {
  final Color bg;
  final Color border;
  final Color text;

  _BadgeColors({required this.bg, required this.border, required this.text});
}
