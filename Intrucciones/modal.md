import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class AuraInputModal extends StatefulWidget {
  final String title;
  final String subtitle;
  final String placeholder;
  final String actionLabel;
  final int minChars;
  final int maxChars;
  final bool isDestructive;
  final Function(String value) onSubmit;

  const AuraInputModal({
    super.key,
    required this.title,
    required this.subtitle,
    required this.placeholder,
    required this.actionLabel,
    this.minChars = 1,
    this.maxChars = 2000,
    this.isDestructive = false,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String placeholder,
    required String actionLabel,
    int minChars = 1,
    int maxChars = 2000,
    bool isDestructive = false,
    required Function(String value) onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => AuraInputModal(
        title: title,
        subtitle: subtitle,
        placeholder: placeholder,
        actionLabel: actionLabel,
        minChars: minChars,
        maxChars: maxChars,
        isDestructive: isDestructive,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<AuraInputModal> createState() => _AuraInputModalState();
}

class _AuraInputModalState extends State<AuraInputModal> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validate);
  }

  void _validate() {
    final text = _controller.text.trim();
    final valid = text.length >= widget.minChars && text.length <= widget.maxChars;
    if (valid != _isValid) {
      setState(() => _isValid = valid);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AuraColors.border),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AuraColors.textPrimary)),
            const SizedBox(height: 6),
            Text(widget.subtitle, style: GoogleFonts.inter(fontSize: 13, color: AuraColors.textMuted)),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 4,
              maxLength: widget.maxChars,
              style: GoogleFonts.inter(fontSize: 13, color: AuraColors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: GoogleFonts.inter(fontSize: 13, color: AuraColors.textMuted),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AuraColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AuraColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AuraColors.primary, width: 1.5)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AuraColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Cerrar', style: GoogleFonts.inter(color: AuraColors.textSecondary, fontSize: 13)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isValid
                      ? () {
                          final value = _controller.text.trim();
                          Navigator.of(context).pop();
                          widget.onSubmit(value);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isDestructive ? AuraColors.redText : AuraColors.primary,
                    disabledBackgroundColor: const Color(0xFFE2E8F0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(widget.actionLabel, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}