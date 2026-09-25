import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/aura_button.dart';
import '../../../core/widgets/cards/aura_card.dart';
import '../../../core/widgets/inputs/aura_text_field.dart';
import '../../../core/widgets/overlays/aura_snackbar.dart';
import '../models/request_models.dart';
import '../providers/requests_provider.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _direccionController = TextEditingController();
  final _distritoController = TextEditingController();

  String _urgencia = 'MEDIA';
  String _modalidad = 'PRESENCIAL';
  final int _idTipoServicio = 1;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _direccionController.dispose();
    _distritoController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateSolicitudRequest(
      titulo: _tituloController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      idTipoServicio: _idTipoServicio,
      modalidad: _modalidad,
      urgencia: _urgencia,
      direccion: _modalidad == 'PRESENCIAL' ? _direccionController.text.trim() : null,
      ubigeoDistrito: _modalidad == 'PRESENCIAL' ? (_distritoController.text.trim().isNotEmpty ? _distritoController.text.trim() : '150101') : null,
    );

    final provider = context.read<RequestsProvider>();
    final error = await provider.createRequest(request);

    if (mounted) {
      if (error != null) {
        AuraSnackbar.showError(
          context,
          message: error.displayMessage,
          errorCode: error.codigoError,
        );
      } else {
        AuraSnackbar.showSuccess(context, message: 'Solicitud creada con éxito');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestsProvider>();

    return Scaffold(
      backgroundColor: AuraColors.background,
      appBar: AppBar(
        title: Text(
          'Nueva Solicitud',
          style: GoogleFonts.inter(
            color: AuraColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuraCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Información General', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    AuraTextField(
                      label: 'Título',
                      hint: 'Ej: Diagnóstico y reparación de router',
                      controller: _tituloController,
                      validator: (val) => val == null || val.trim().isEmpty ? 'Ingrese un título' : null,
                    ),
                    const SizedBox(height: 16),
                    AuraTextField(
                      label: 'Descripción',
                      hint: 'Detalla el problema o servicio que requieres...',
                      controller: _descripcionController,
                      maxLines: 4,
                      validator: (val) => val == null || val.trim().isEmpty ? 'Ingrese una descripción' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              AuraCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Urgencia', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: ['BAJA', 'MEDIA', 'ALTA'].map((u) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => setState(() => _urgencia = u),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _urgencia == u ? AuraColors.primaryLight : AuraColors.surface,
                                border: Border.all(
                                  color: _urgencia == u ? AuraColors.primary : AuraColors.border,
                                  width: _urgencia == u ? 1.5 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                u,
                                style: GoogleFonts.inter(
                                  color: _urgencia == u ? AuraColors.primary : AuraColors.textSecondary,
                                  fontWeight: _urgencia == u ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              AuraCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Modalidad', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: ['PRESENCIAL', 'REMOTO'].map((m) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => setState(() => _modalidad = m),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _modalidad == m ? AuraColors.primaryLight : AuraColors.surface,
                                border: Border.all(
                                  color: _modalidad == m ? AuraColors.primary : AuraColors.border,
                                  width: _modalidad == m ? 1.5 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                m,
                                style: GoogleFonts.inter(
                                  color: _modalidad == m ? AuraColors.primary : AuraColors.textSecondary,
                                  fontWeight: _modalidad == m ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                    if (_modalidad == 'PRESENCIAL') ...[
                      const SizedBox(height: 16),
                      AuraTextField(
                        label: 'Dirección exacta',
                        hint: 'Av. Las Begonias 450, Int 301',
                        controller: _direccionController,
                        validator: (val) => val == null || val.trim().isEmpty ? 'Dirección obligatoria en presencial' : null,
                      ),
                      const SizedBox(height: 16),
                      AuraTextField(
                        label: 'Ubigeo / Distrito',
                        hint: '150101 (Código ubigeo)',
                        controller: _distritoController,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ubigeo obligatorio en presencial';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AuraButton(
                label: 'Crear Solicitud',
                isLoading: provider.isSubmitting,
                isExpanded: true,
                onPressed: _submit,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
