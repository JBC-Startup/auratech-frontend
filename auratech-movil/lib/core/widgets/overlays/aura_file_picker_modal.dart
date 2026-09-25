import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../constants/app_colors.dart';
import '../../utils/image_compressor.dart';

class AuraFilePickerModal extends StatelessWidget {
  final Function(File file) onFilePicked;

  const AuraFilePickerModal({
    super.key,
    required this.onFilePicked,
  });

  static Future<void> show({
    required BuildContext context,
    required Function(File file) onFilePicked,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          AuraFilePickerModal(onFilePicked: onFilePicked),
    );
  }

  Future<void> _pickImage(
      BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final compressed = await ImageCompressor.compress(file);
      if (context.mounted) {
        Navigator.of(context).pop();
        onFilePicked(compressed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seleccionar imagen',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AuraColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'La imagen será comprimida automáticamente',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AuraColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                _PickerOption(
                  icon: LucideIcons.camera,
                  label: 'Tomar foto',
                  subtitle: 'Usar la cámara del dispositivo',
                  onTap: () =>
                      _pickImage(context, ImageSource.camera),
                ),
                const SizedBox(height: 8),
                _PickerOption(
                  icon: LucideIcons.image,
                  label: 'Galería',
                  subtitle: 'Seleccionar de la galería',
                  onTap: () =>
                      _pickImage(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AuraColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AuraColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(icon, color: AuraColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AuraColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AuraColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight,
                  size: 16, color: AuraColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
