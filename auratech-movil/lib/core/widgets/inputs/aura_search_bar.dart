import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../constants/app_colors.dart';

class AuraSearchBar extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AuraSearchBar({
    super.key,
    this.hint = 'Buscar...',
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  State<AuraSearchBar> createState() => _AuraSearchBarState();
}

class _AuraSearchBarState extends State<AuraSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AuraColors.border, width: 1),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: GoogleFonts.inter(
          fontSize: 13,
          color: AuraColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: AuraColors.textMuted,
          ),
          prefixIcon: const Icon(
            LucideIcons.search,
            size: 16,
            color: AuraColors.textMuted,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x,
                      size: 14, color: AuraColors.textMuted),
                  onPressed: () {
                    _controller.clear();
                    widget.onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}
