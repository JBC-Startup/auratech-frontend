import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class AuraBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final double? maxHeight;

  const AuraBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.maxHeight,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? subtitle,
    required Widget child,
    double? maxHeight,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AuraBottomSheet(
        title: title,
        subtitle: subtitle,
        maxHeight: maxHeight,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight:
            maxHeight ?? MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grab handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AuraColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (title != null || subtitle != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AuraColors.textPrimary,
                      ),
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AuraColors.textMuted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AuraColors.border),
                ],
              ),
            ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
