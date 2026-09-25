import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/aura_button.dart';
import '../../../core/widgets/inputs/aura_text_field.dart';
import '../../../core/widgets/overlays/aura_snackbar.dart';
import '../models/payment_models.dart';
import '../providers/payments_provider.dart';

class RegisterPaymentModal extends StatefulWidget {
  final int idSolicitud;

  const RegisterPaymentModal({super.key, required this.idSolicitud});

  static Future<void> show(BuildContext context, {required int idSolicitud}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RegisterPaymentModal(idSolicitud: idSolicitud),
    );
  }

  @override
  State<RegisterPaymentModal> createState() => _RegisterPaymentModalState();
}

class _RegisterPaymentModalState extends State<RegisterPaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  String _metodoSeleccionado = MetodosPago.efectivo;

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<PaymentsProvider>(context, listen: false);
    final error = await provider.registerPayment(
      widget.idSolicitud,
      CreatePagoRequest(
        monto: _montoController.text.trim(),
        metodoPago: _metodoSeleccionado,
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
        AuraSnackbar.showSuccess(context, message: 'Pago registrado para confirmación');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AuraColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Registrar Abono',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'El importe requiere validación de la contraparte.',
              style: GoogleFonts.inter(fontSize: 12, color: AuraColors.textMuted),
            ),
            const SizedBox(height: 16),
            AuraTextField(
              label: 'Monto (S/)',
              hint: '0.00',
              controller: _montoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: const Icon(LucideIcons.banknote, size: 16, color: AuraColors.textMuted),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Ingrese un monto';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Método de pago',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AuraColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MetodosPago.all.map((m) {
                final selected = _metodoSeleccionado == m;
                return ChoiceChip(
                  label: Text(MetodosPago.displayName(m)),
                  selected: selected,
                  selectedColor: AuraColors.primaryLight,
                  backgroundColor: AuraColors.surface,
                  side: BorderSide(color: selected ? AuraColors.primary : AuraColors.border),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? AuraColors.primary : AuraColors.textSecondary,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _metodoSeleccionado = m);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Consumer<PaymentsProvider>(
              builder: (context, provider, _) {
                return AuraButton(
                  label: 'Confirmar Registro',
                  isExpanded: true,
                  isLoading: provider.isSubmitting,
                  onPressed: _submit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
