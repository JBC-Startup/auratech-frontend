import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class MetricKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const MetricKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.backgroundColor = AuraColors.primaryLight,
    this.iconColor = AuraColors.primary,
    this.textColor = AuraColors.primary,
  });

  factory MetricKpiCard.available({required String value}) {
    return MetricKpiCard(
      title: 'Disponibles',
      value: value,
      icon: Icons.check_circle_outline,
      backgroundColor: AuraColors.greenBg,
      iconColor: AuraColors.greenText,
      textColor: AuraColors.greenText,
    );
  }

  factory MetricKpiCard.inProgress({required String value}) {
    return MetricKpiCard(
      title: 'En proceso',
      value: value,
      icon: Icons.access_time,
      backgroundColor: AuraColors.primaryLight,
      iconColor: AuraColors.primary,
      textColor: AuraColors.primary,
    );
  }

  factory MetricKpiCard.pending({required String value}) {
    return MetricKpiCard(
      title: 'Pendientes',
      value: value,
      icon: Icons.hourglass_empty,
      backgroundColor: AuraColors.amberBg,
      iconColor: AuraColors.amberText,
      textColor: AuraColors.amberText,
    );
  }

  factory MetricKpiCard.completed({required String value}) {
    return MetricKpiCard(
      title: 'Completados',
      value: value,
      icon: Icons.task_alt,
      backgroundColor: AuraColors.greenBg,
      iconColor: AuraColors.greenText,
      textColor: AuraColors.greenText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AuraColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AuraColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
