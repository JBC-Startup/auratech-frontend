import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/aura_button.dart';
import '../../../core/widgets/inputs/aura_text_field.dart';
import '../../../core/widgets/overlays/aura_snackbar.dart';
import '../models/review_models.dart';
import '../providers/reviews_provider.dart';

class CreateReviewScreen extends StatefulWidget {
  final int idSolicitud;
  final String? tecnicoNombre;

  const CreateReviewScreen({
    super.key,
    required this.idSolicitud,
    this.tecnicoNombre,
  });

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  int _rating = 5;
  final TextEditingController _comentarioController = TextEditingController();

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final provider = Provider.of<ReviewsProvider>(context, listen: false);
    final error = await provider.createReview(
      CreateReviewRequest(
        idSolicitud: widget.idSolicitud,
        puntuacion: _rating,
        comentario: _comentarioController.text.trim().isEmpty
            ? null
            : _comentarioController.text.trim(),
      ),
    );

    if (mounted) {
      if (error != null) {
        AuraSnackbar.showError(
          context,
          message: error.displayMessage,
          errorCode: error.codigoError,
        );
      } else {
        AuraSnackbar.showSuccess(context, message: '¡Gracias por calificar el servicio!');
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.background,
      appBar: AppBar(
        title: Text(
          'Calificar Servicio',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AuraColors.amberBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.star,
                color: AuraColors.amberText,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '¿Cómo calificarías el trabajo?',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AuraColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              widget.tecnicoNombre != null
                  ? 'Realizado por ${widget.tecnicoNombre}'
                  : 'Tu opinión nos ayuda a mantener un estándar de calidad',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AuraColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return IconButton(
                  iconSize: 36,
                  icon: Icon(
                    starValue <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: starValue <= _rating ? AuraColors.amberText : AuraColors.border,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = starValue;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 24),
            AuraTextField(
              label: 'Comentario u opinión (Opcional)',
              hint: 'Describe cómo fue tu experiencia con el servicio recibido...',
              controller: _comentarioController,
              maxLines: 4,
              maxLength: 500,
            ),
            const SizedBox(height: 32),
            Consumer<ReviewsProvider>(
              builder: (context, provider, _) {
                return AuraButton(
                  label: 'Enviar Calificación',
                  isExpanded: true,
                  isLoading: provider.isSubmitting,
                  onPressed: _submitReview,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
