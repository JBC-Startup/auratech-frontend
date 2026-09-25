import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/badges/aura_badge.dart';
import '../../../core/widgets/cards/aura_card.dart';
import '../models/request_models.dart';

class RequestCard extends StatelessWidget {
  final SolicitudResumen solicitud;
  final VoidCallback? onTap;

  const RequestCard({
    super.key,
    required this.solicitud,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AuraCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title + Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  solicitud.titulo,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AuraColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              AuraBadge.fromStatus(solicitud.estado),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            solicitud.descripcion,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AuraColors.textMuted,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Tags row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _InfoChip(
                icon: LucideIcons.layers,
                label: solicitud.nombreCategoria,
              ),
              _InfoChip(
                icon: solicitud.modalidad == 'PRESENCIAL'
                    ? LucideIcons.mapPin
                    : LucideIcons.monitor,
                label: solicitud.modalidad == 'PRESENCIAL'
                    ? 'Presencial'
                    : 'Remoto',
              ),
              _InfoChip(
                icon: LucideIcons.alertCircle,
                label: solicitud.urgencia,
                color: solicitud.urgencia == 'ALTA'
                    ? AuraColors.redText
                    : solicitud.urgencia == 'MEDIA'
                        ? AuraColors.amberText
                        : AuraColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Footer: Date + Type
          Row(
            children: [
              Icon(LucideIcons.calendar,
                  size: 12, color: AuraColors.textMuted),
              const SizedBox(width: 4),
              Text(
                _formatDate(solicitud.fechaCreacion),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AuraColors.textMuted,
                ),
              ),
              const Spacer(),
              Text(
                solicitud.nombreTipoServicio,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AuraColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AuraColors.textMuted;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AuraColors.backgroundAlt,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: chipColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: chipColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
